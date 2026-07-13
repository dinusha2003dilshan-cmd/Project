package com.smartboys.servlet;

import com.smartboys.dao.OrderDAO;
import com.smartboys.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private static final BigDecimal SHIPPING_FEE = new BigDecimal("350.00");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (req.getSession().getAttribute("customerId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=checkout");
            return;
        }
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");
        if (customerId == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=checkout");
            return;
        }

        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String address = req.getParameter("address");
        String paymentMethod = req.getParameter("paymentMethod");
        List<CartItem> items = new ArrayList<>(cart.values());

        int orderId = orderDAO.placeOrder(customerId, address, paymentMethod, items, SHIPPING_FEE);

        if (orderId == -1) {
            req.setAttribute("error", "Sorry, one or more items just went out of stock. Please review your cart.");
            req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
            return;
        }

        cart.clear();
        resp.sendRedirect(req.getContextPath() + "/orderTracking?orderId=" + orderId);
    }
}
