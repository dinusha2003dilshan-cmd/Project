package com.smartboys.servlet;

import com.smartboys.dao.CategoryDAO;
import com.smartboys.dao.ProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("")
public class HomeServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("featuredProducts", productDAO.getFeaturedProducts(8));
        req.setAttribute("categories", categoryDAO.getAllCategories());
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
