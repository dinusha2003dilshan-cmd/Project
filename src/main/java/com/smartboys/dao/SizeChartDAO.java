package com.smartboys.dao;

import java.sql.*;

public class SizeChartDAO {

    /**
     * Core logic of the Smart Size Assistant: given a child's age, height and weight,
     * find the best-matching size_label from the reference size chart.
     * Scoring: rows fully matching all three criteria win; otherwise the closest
     * match by age is used as a fallback so a recommendation is always produced.
     */
    public String recommendSize(int age, int heightCm, int weightKg) {
        String exactSql = "SELECT size_label FROM size_chart WHERE ? BETWEEN min_age AND max_age " +
                "AND ? BETWEEN min_height AND max_height AND ? BETWEEN min_weight AND max_weight " +
                "LIMIT 1";
        String fallbackSql = "SELECT size_label FROM size_chart ORDER BY ABS(((min_age+max_age)/2) - ?) LIMIT 1";

        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(exactSql)) {
                ps.setInt(1, age);
                ps.setInt(2, heightCm);
                ps.setInt(3, weightKg);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getString("size_label");
                }
            }
            try (PreparedStatement ps = con.prepareStatement(fallbackSql)) {
                ps.setInt(1, age);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getString("size_label");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error recommending size", e);
        }
        return "N/A";
    }
}
