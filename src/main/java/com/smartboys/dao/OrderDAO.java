package com.smartboys.dao;

import com.smartboys.model.CartItem;
import com.smartboys.model.Order;
import com.smartboys.model.OrderItem;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private final ProductDAO productDAO = new ProductDAO();

    /**
     * Creates an order + its line items and decrements stock, all within one transaction.
     * Returns the generated order_id, or -1 if any item did not have enough stock
     * (whole transaction is rolled back so the DB never goes inconsistent).
     */
    public int placeOrder(int customerId, String shippingAddress, String paymentMethod,
                           List<CartItem> cartItems, BigDecimal shippingFee) {
        String orderSql = "INSERT INTO orders (customer_id, status, shipping_address, subtotal, " +
                "shipping_fee, total_amount, payment_method) VALUES (?,?,?,?,?,?,?)";
        String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, line_total) " +
                "VALUES (?,?,?,?,?)";

        BigDecimal subtotal = BigDecimal.ZERO;
        for (CartItem ci : cartItems) subtotal = subtotal.add(ci.getLineTotal());
        BigDecimal total = subtotal.add(shippingFee);

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Verify & reserve stock first
            for (CartItem ci : cartItems) {
                boolean ok = productDAO.decrementStock(con, ci.getProductId(), ci.getQuantity());
                if (!ok) {
                    con.rollback();
                    return -1; // insufficient stock
                }
            }

            int orderId;
            try (PreparedStatement ps = con.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, customerId);
                ps.setString(2, "PROCESSING");
                ps.setString(3, shippingAddress);
                ps.setBigDecimal(4, subtotal);
                ps.setBigDecimal(5, shippingFee);
                ps.setBigDecimal(6, total);
                ps.setString(7, paymentMethod);
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    keys.next();
                    orderId = keys.getInt(1);
                }
            }

            try (PreparedStatement ps = con.prepareStatement(itemSql)) {
                for (CartItem ci : cartItems) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, ci.getProductId());
                    ps.setInt(3, ci.getQuantity());
                    ps.setBigDecimal(4, ci.getUnitPrice());
                    ps.setBigDecimal(5, ci.getLineTotal());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            con.commit();
            return orderId;
        } catch (SQLException e) {
            try { if (con != null) con.rollback(); } catch (SQLException ignored) {}
            throw new RuntimeException("Error placing order", e);
        } finally {
            try { if (con != null) { con.setAutoCommit(true); con.close(); } } catch (SQLException ignored) {}
        }
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, c.full_name AS customer_name FROM orders o " +
                "JOIN customers c ON o.customer_id = c.customer_id WHERE o.order_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapOrder(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching order", e);
        }
        return null;
    }

    public List<Order> getOrdersByCustomer(int customerId) {
        String sql = "SELECT o.*, c.full_name AS customer_name FROM orders o " +
                "JOIN customers c ON o.customer_id = c.customer_id " +
                "WHERE o.customer_id = ? ORDER BY o.order_date DESC";
        List<Order> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching customer orders", e);
        }
        return list;
    }

    public List<Order> getAllOrders() {
        String sql = "SELECT o.*, c.full_name AS customer_name FROM orders o " +
                "JOIN customers c ON o.customer_id = c.customer_id ORDER BY o.order_date DESC";
        List<Order> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapOrder(rs));
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching orders", e);
        }
        return list;
    }

    public List<OrderItem> getOrderItems(int orderId) {
        String sql = "SELECT oi.*, p.product_name FROM order_items oi " +
                "JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = ?";
        List<OrderItem> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem oi = new OrderItem();
                    oi.setOrderItemId(rs.getInt("order_item_id"));
                    oi.setOrderId(rs.getInt("order_id"));
                    oi.setProductId(rs.getInt("product_id"));
                    oi.setProductName(rs.getString("product_name"));
                    oi.setQuantity(rs.getInt("quantity"));
                    oi.setUnitPrice(rs.getBigDecimal("unit_price"));
                    oi.setLineTotal(rs.getBigDecimal("line_total"));
                    list.add(oi);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching order items", e);
        }
        return list;
    }

    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating order status", e);
        }
    }

    /** Aggregated revenue figures for the admin Sales Dashboard. */
    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount),0) AS total FROM orders WHERE status != 'CANCELLED'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getBigDecimal("total");
        } catch (SQLException e) {
            throw new RuntimeException("Error computing revenue", e);
        }
        return BigDecimal.ZERO;
    }

    public int getOrderCount() {
        String sql = "SELECT COUNT(*) AS cnt FROM orders";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("cnt");
        } catch (SQLException e) {
            throw new RuntimeException("Error counting orders", e);
        }
        return 0;
    }

    /** Revenue grouped by day for the last N days — feeds the dashboard bar/line chart. */
    public List<Object[]> getDailyRevenue(int days) {
        String sql = "SELECT DATE(order_date) AS d, SUM(total_amount) AS total FROM orders " +
                "WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL ? DAY) AND status != 'CANCELLED' " +
                "GROUP BY DATE(order_date) ORDER BY d";
        List<Object[]> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, days);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(new Object[]{rs.getDate("d"), rs.getBigDecimal("total")});
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error computing daily revenue", e);
        }
        return list;
    }

    /** Revenue share by category — feeds the dashboard pie chart. */
    public List<Object[]> getRevenueByCategory() {
        String sql = "SELECT c.category_name, SUM(oi.line_total) AS total FROM order_items oi " +
                "JOIN products p ON oi.product_id = p.product_id " +
                "JOIN categories c ON p.category_id = c.category_id " +
                "JOIN orders o ON oi.order_id = o.order_id " +
                "WHERE o.status != 'CANCELLED' GROUP BY c.category_name";
        List<Object[]> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(new Object[]{rs.getString("category_name"), rs.getBigDecimal("total")});
        } catch (SQLException e) {
            throw new RuntimeException("Error computing category revenue", e);
        }
        return list;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setCustomerId(rs.getInt("customer_id"));
        o.setCustomerName(rs.getString("customer_name"));
        o.setOrderDate(rs.getTimestamp("order_date"));
        o.setStatus(rs.getString("status"));
        o.setShippingAddress(rs.getString("shipping_address"));
        o.setSubtotal(rs.getBigDecimal("subtotal"));
        o.setShippingFee(rs.getBigDecimal("shipping_fee"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setPaymentMethod(rs.getString("payment_method"));
        return o;
    }
}
