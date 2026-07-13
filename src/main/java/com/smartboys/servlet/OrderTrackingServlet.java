package com.smartboys.servlet;

import com.smartboys.dao.OrderDAO;
import com.smartboys.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/** Live Order Tracking Portal: Processing -> Shipped -> Delivered. */
@WebServlet("/orderTracking")
public class OrderTrackingServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Integer customerId = (Integer) req.getSession().getAttribute("customerId");
        if (customerId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String orderIdParam = req.getParameter("orderId");
        if (orderIdParam != null) {
            Order order = orderDAO.getOrderById(Integer.parseInt(orderIdParam));
            if (order != null && order.getCustomerId() == customerId) {
                req.setAttribute("order", order);
                req.setAttribute("items", orderDAO.getOrderItems(order.getOrderId()));
            }
        }
        req.setAttribute("myOrders", orderDAO.getOrdersByCustomer(customerId));
        req.getRequestDispatcher("/orderTracking.jsp").forward(req, resp);
    }
}
