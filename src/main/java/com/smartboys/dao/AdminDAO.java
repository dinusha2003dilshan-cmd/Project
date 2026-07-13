package com.smartboys.dao;

import com.smartboys.model.Admin;

import java.sql.*;

public class AdminDAO {

    public Admin getByEmail(String email) {
        String sql = "SELECT * FROM admins WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin a = new Admin();
                    a.setAdminId(rs.getInt("admin_id"));
                    a.setFullName(rs.getString("full_name"));
                    a.setEmail(rs.getString("email"));
                    a.setPasswordHash(rs.getString("password_hash"));
                    a.setRole(rs.getString("role"));
                    return a;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching admin", e);
        }
        return null;
    }
}
