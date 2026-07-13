package com.smartboys.servlet;

import com.smartboys.dao.WishlistDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {

    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Integer customerId = (Integer) req.getSession().getAttribute("customerId");
        if (customerId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String productIdParam = req.getParameter("productId");
        if (action != null && productIdParam != null) {
            int productId = Integer.parseInt(productIdParam);
            if ("add".equals(action)) wishlistDAO.add(customerId, productId);
            else if ("remove".equals(action)) wishlistDAO.remove(customerId, productId);
        }

        req.setAttribute("wishlist", wishlistDAO.getWishlist(customerId));
        req.getRequestDispatcher("/wishlist.jsp").forward(req, resp);
    }
}
