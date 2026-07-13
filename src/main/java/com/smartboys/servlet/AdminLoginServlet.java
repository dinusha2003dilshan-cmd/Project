package com.smartboys.servlet;

import com.smartboys.dao.AdminDAO;
import com.smartboys.model.Admin;
import com.smartboys.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/admin/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        Admin admin = adminDAO.getByEmail(email);
        if (admin == null || !PasswordUtil.verify(password, admin.getPasswordHash())) {
            req.setAttribute("error", "Invalid administrator credentials.");
            req.getRequestDispatcher("/admin/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("adminId", admin.getAdminId());
        session.setAttribute("adminName", admin.getFullName());
        session.setAttribute("adminRole", admin.getRole());

        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}
