package com.smartboys.servlet;

import com.smartboys.dao.ProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/** Automated Inventory Alerts screen — highlights SKUs below their low-stock threshold. */
@WebServlet("/admin/inventory")
public class AdminInventoryServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("lowStockProducts", productDAO.getLowStockProducts());
        req.getRequestDispatcher("/admin/inventory.jsp").forward(req, resp);
    }
}
