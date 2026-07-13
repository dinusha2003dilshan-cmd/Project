package com.smartboys.servlet;

import com.smartboys.dao.CustomerDAO;
import com.smartboys.model.Customer;
import com.smartboys.util.PasswordUtil;
import com.smartboys.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        if (!ValidationUtil.isNotBlank(fullName) || !ValidationUtil.isValidEmail(email)
                || !ValidationUtil.isNotBlank(password) || password.length() < 6) {
            req.setAttribute("error", "Please fill all fields correctly (password min 6 characters).");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (customerDAO.emailExists(email)) {
            req.setAttribute("error", "An account with this email already exists.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        Customer c = new Customer();
        c.setFullName(fullName);
        c.setEmail(email);
        c.setPasswordHash(PasswordUtil.hash(password));
        c.setPhone(phone);
        c.setAddress(address);
        customerDAO.register(c);

        req.setAttribute("success", "Registration successful! Please log in.");
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}
