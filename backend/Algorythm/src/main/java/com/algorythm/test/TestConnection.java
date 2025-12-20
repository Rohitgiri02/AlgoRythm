package com.algorythm.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestConnection {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://db.xbvvbkjkrragpxbypvax.supabase.co:5432/postgres";
        String username = "postgres";
        String password = "Rohitgiri123@";
        
        System.out.println("=== Testing Supabase PostgreSQL Connection ===");
        System.out.println("URL: " + url);
        System.out.println("Username: " + username);
        System.out.println();
        
        try {
            // Load PostgreSQL driver
            Class.forName("org.postgresql.Driver");
            System.out.println("✓ PostgreSQL driver loaded");
            
            // Attempt connection
            System.out.println("Attempting to connect...");
            Connection conn = DriverManager.getConnection(url, username, password);
            System.out.println("✓ Connection successful!");
            
            // Test query
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT version(), current_database(), current_user");
            
            if (rs.next()) {
                System.out.println("\n=== Database Information ===");
                System.out.println("PostgreSQL Version: " + rs.getString(1));
                System.out.println("Current Database: " + rs.getString(2));
                System.out.println("Current User: " + rs.getString(3));
            }
            
            // Check if users table exists
            ResultSet tables = conn.getMetaData().getTables(null, null, "users", null);
            if (tables.next()) {
                System.out.println("\n✓ 'users' table exists");
            } else {
                System.out.println("\n⚠ 'users' table does NOT exist - you need to run schema.sql");
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
            System.out.println("\n✓ Connection test completed successfully!");
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ PostgreSQL driver not found!");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("❌ Connection failed!");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
