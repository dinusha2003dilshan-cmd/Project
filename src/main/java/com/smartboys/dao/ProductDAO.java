package com.smartboys.dao;

import com.smartboys.model.Product;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    private static final String BASE_SELECT =
        "SELECT p.*, c.category_name FROM products p " +
        "JOIN categories c ON p.category_id = c.category_id ";

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        p.setProductName(rs.getString("product_name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setColor(rs.getString("color"));
        p.setSizeLabel(rs.getString("size_label"));
        p.setMinAge(rs.getInt("min_age"));
        p.setMaxAge(rs.getInt("max_age"));
        p.setStockQty(rs.getInt("stock_qty"));
        p.setLowStockLimit(rs.getInt("low_stock_limit"));
        p.setImagePath(rs.getString("image_path"));
        p.setActive(rs.getBoolean("is_active"));
        return p;
    }

    /** Filter-driven product listing used by the storefront's Advanced Filtering Engine. */
    public List<Product> searchProducts(Integer categoryId, BigDecimal minPrice, BigDecimal maxPrice,
                                         String color, Integer age, String keyword) {
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE p.is_active = 1 ");
        List<Object> params = new ArrayList<>();

        if (categoryId != null) { sql.append("AND p.category_id = ? "); params.add(categoryId); }
        if (minPrice != null)   { sql.append("AND p.price >= ? "); params.add(minPrice); }
        if (maxPrice != null)   { sql.append("AND p.price <= ? "); params.add(maxPrice); }
        if (color != null && !color.isBlank()) { sql.append("AND p.color = ? "); params.add(color); }
        if (age != null)        { sql.append("AND ? BETWEEN p.min_age AND p.max_age "); params.add(age); }
        if (keyword != null && !keyword.isBlank()) {
            sql.append("AND p.product_name LIKE ? "); params.add("%" + keyword + "%");
        }
        sql.append("ORDER BY p.created_at DESC");

        List<Product> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error searching products", e);
        }
        return list;
    }

    public Product getProductById(int productId) {
        String sql = BASE_SELECT + "WHERE p.product_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching product", e);
        }
        return null;
    }

    public List<Product> getFeaturedProducts(int limit) {
        String sql = BASE_SELECT + "WHERE p.is_active = 1 ORDER BY p.created_at DESC LIMIT ?";
        List<Product> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching featured products", e);
        }
        return list;
    }

    /** Products matching a recommended size label — used to back the Smart Size Assistant results. */
    public List<Product> getProductsBySize(String sizeLabel) {
        String sql = BASE_SELECT + "WHERE p.is_active = 1 AND p.size_label = ?";
        List<Product> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, sizeLabel);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching products by size", e);
        }
        return list;
    }

    public List<Product> getLowStockProducts() {
        String sql = BASE_SELECT + "WHERE p.stock_qty <= p.low_stock_limit ORDER BY p.stock_qty ASC";
        List<Product> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching low-stock products", e);
        }
        return list;
    }

    public List<Product> getAllProductsForAdmin() {
        String sql = BASE_SELECT + "ORDER BY p.product_id DESC";
        List<Product> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching products", e);
        }
        return list;
    }

    public boolean addProduct(Product p) {
        String sql = "INSERT INTO products (category_id, product_name, description, price, color, " +
                "size_label, min_age, max_age, stock_qty, low_stock_limit, image_path, is_active) " +
                "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getProductName());
            ps.setString(3, p.getDescription());
            ps.setBigDecimal(4, p.getPrice());
            ps.setString(5, p.getColor());
            ps.setString(6, p.getSizeLabel());
            ps.setInt(7, p.getMinAge());
            ps.setInt(8, p.getMaxAge());
            ps.setInt(9, p.getStockQty());
            ps.setInt(10, p.getLowStockLimit());
            ps.setString(11, p.getImagePath());
            ps.setBoolean(12, p.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error adding product", e);
        }
    }

    public boolean updateProduct(Product p) {
        String sql = "UPDATE products SET category_id=?, product_name=?, description=?, price=?, color=?, " +
                "size_label=?, min_age=?, max_age=?, stock_qty=?, low_stock_limit=?, image_path=?, is_active=? " +
                "WHERE product_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getProductName());
            ps.setString(3, p.getDescription());
            ps.setBigDecimal(4, p.getPrice());
            ps.setString(5, p.getColor());
            ps.setString(6, p.getSizeLabel());
            ps.setInt(7, p.getMinAge());
            ps.setInt(8, p.getMaxAge());
            ps.setInt(9, p.getStockQty());
            ps.setInt(10, p.getLowStockLimit());
            ps.setString(11, p.getImagePath());
            ps.setBoolean(12, p.isActive());
            ps.setInt(13, p.getProductId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating product", e);
        }
    }

    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting product", e);
        }
    }

    /** Atomically decreases stock during checkout; returns false if not enough stock (prevents overselling). */
    public boolean decrementStock(Connection con, int productId, int qty) throws SQLException {
        String sql = "UPDATE products SET stock_qty = stock_qty - ? WHERE product_id = ? AND stock_qty >= ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, qty);
            ps.setInt(2, productId);
            ps.setInt(3, qty);
            return ps.executeUpdate() > 0;
        }
    }
}
