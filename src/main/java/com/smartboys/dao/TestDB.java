package com.smartboys.dao;

import java.sql.Connection;
import java.sql.SQLException;

public class TestDB {
    public static void main(String[] args) {
        try {
            System.out.println("Testing DB Connection...");
            Connection con = DBConnection.getConnection();
            System.out.println("Connection SUCCESS!");
            con.close();
        } catch (Exception e) {
            System.out.println("Connection FAILED!");
            e.printStackTrace();
        }
    }
}
