package com.smartboys.dao;

import com.smartboys.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    public boolean add(int customerId, int productId) {
        String sql = "INSERT IGNORE INTO wishlist (customer_id, product_id) VALUES (?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error adding to wishlist", e);
        }
    }

    public boolean remove(int customerId, int productId) {
        String sql = "DELETE FROM wishlist WHERE customer_id = ? AND product_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error removing from wishlist", e);
        }
    }

    public List<Product> getWishlist(int customerId) {
        String sql = "SELECT p.*, c.category_name FROM wishlist w " +
                "JOIN products p ON w.product_id = p.product_id " +
                "JOIN categories c ON p.category_id = c.category_id " +
                "WHERE w.customer_id = ? ORDER BY w.added_at DESC";
        List<Product> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setCategoryName(rs.getString("category_name"));
                    p.setProductName(rs.getString("product_name"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setColor(rs.getString("color"));
                    p.setSizeLabel(rs.getString("size_label"));
                    p.setImagePath(rs.getString("image_path"));
                    p.setStockQty(rs.getInt("stock_qty"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching wishlist", e);
        }
        return list;
    }
}
