package com.algorythm.dao;

import com.algorythm.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for User operations
 */
public class UserDAO extends BaseDAO {

    /**
     * Create a new user
     */
    public Long createUser(User user) throws SQLException {
        String sql = "INSERT INTO users (username, email, password_hash, full_name, date_of_birth, " +
                    "gender, profile_picture_url, subscription_type, is_verified, is_active) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        return executeInsert(sql, 
            user.getUsername(),
            user.getEmail(),
            user.getPasswordHash(),
            user.getFullName(),
            user.getDateOfBirth(),
            user.getGender(),
            user.getProfilePictureUrl(),
            user.getSubscriptionType() != null ? user.getSubscriptionType() : "Free",
            user.isVerified(),
            user.isActive()
        );
    }

    /**
     * Find user by ID
     */
    public User findById(Long userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, userId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Find user by email
     */
    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Find user by username
     */
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Update user information
     */
    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET username = ?, email = ?, full_name = ?, " +
                    "date_of_birth = ?, gender = ?, profile_picture_url = ?, " +
                    "subscription_type = ?, is_verified = ?, is_active = ? " +
                    "WHERE user_id = ?";
        
        int rowsAffected = executeUpdate(sql,
            user.getUsername(),
            user.getEmail(),
            user.getFullName(),
            user.getDateOfBirth(),
            user.getGender(),
            user.getProfilePictureUrl(),
            user.getSubscriptionType(),
            user.isVerified(),
            user.isActive(),
            user.getUserId()
        );
        
        return rowsAffected > 0;
    }

    /**
     * Update last login timestamp
     */
    public boolean updateLastLogin(Long userId) throws SQLException {
        String sql = "UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE user_id = ?";
        return executeUpdate(sql, userId) > 0;
    }

    /**
     * Delete user
     */
    public boolean deleteUser(Long userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        return executeUpdate(sql, userId) > 0;
    }

    /**
     * Get all users with pagination
     */
    public List<User> findAll(int limit, int offset) throws SQLException {
        String sql = "SELECT * FROM users ORDER BY created_at DESC LIMIT ? OFFSET ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<User> users = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            return users;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Get users by subscription type
     */
    public List<User> findBySubscriptionType(String subscriptionType) throws SQLException {
        String sql = "SELECT * FROM users WHERE subscription_type = ? AND is_active = TRUE";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<User> users = new ArrayList<>();
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, subscriptionType);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            return users;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Count total users
     */
    public int countUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Map ResultSet to User object
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getLong("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setFullName(rs.getString("full_name"));
        
        Date dob = rs.getDate("date_of_birth");
        if (dob != null) {
            user.setDateOfBirth(dob.toLocalDate());
        }
        
        user.setGender(rs.getString("gender"));
        user.setProfilePictureUrl(rs.getString("profile_picture_url"));
        user.setSubscriptionType(rs.getString("subscription_type"));
        user.setVerified(rs.getBoolean("is_verified"));
        user.setActive(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        user.setLastLogin(rs.getTimestamp("last_login"));
        
        return user;
    }
}
