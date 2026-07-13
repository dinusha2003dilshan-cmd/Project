package com.smartboys.servlet;

import com.smartboys.dao.OrderDAO;
import com.smartboys.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/** Order pipeline management for Shop Managers / Warehouse Staff: Processing -> Shipped -> Delivered. */
@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        String idParam = req.getParameter("id");

        if ("view".equals(action) && idParam != null) {
            Order order = orderDAO.getOrderById(Integer.parseInt(idParam));
            req.setAttribute("order", order);
            req.setAttribute("items", orderDAO.getOrderItems(order.getOrderId()));
            req.getRequestDispatcher("/admin/orderDetail.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("orders", orderDAO.getAllOrders());
        req.getRequestDispatcher("/admin/orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int orderId = Integer.parseInt(req.getParameter("orderId"));
        String status = req.getParameter("status");
        orderDAO.updateStatus(orderId, status);
        resp.sendRedirect(req.getContextPath() + "/admin/orders?action=view&id=" + orderId);
    }
}
