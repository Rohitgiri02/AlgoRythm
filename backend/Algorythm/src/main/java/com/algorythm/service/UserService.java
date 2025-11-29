package com.algorythm.service;

import com.algorythm.dao.UserDAO;
import com.algorythm.model.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.Base64;
import java.util.List;

/**
 * Service layer for User-related business logic
 */
public class UserService {
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);
    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    /**
     * Register a new user
     */
    public Long registerUser(String username, String email, String password) throws SQLException {
        // Check if user already exists
        if (userDAO.findByEmail(email) != null) {
            throw new IllegalArgumentException("Email already registered");
        }
        
        if (userDAO.findByUsername(username) != null) {
            throw new IllegalArgumentException("Username already taken");
        }

        // Create new user
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(hashPassword(password));
        user.setSubscriptionType("Free");
        user.setVerified(false);
        user.setActive(true);

        Long userId = userDAO.createUser(user);
        logger.info("New user registered: {}", username);
        return userId;
    }

    /**
     * Authenticate user
     */
    public User authenticateUser(String email, String password) throws SQLException {
        User user = userDAO.findByEmail(email);
        
        if (user == null) {
            throw new IllegalArgumentException("Invalid email or password");
        }

        String hashedPassword = hashPassword(password);
        if (!hashedPassword.equals(user.getPasswordHash())) {
            throw new IllegalArgumentException("Invalid email or password");
        }

        if (!user.isActive()) {
            throw new IllegalArgumentException("Account is deactivated");
        }

        // Update last login
        userDAO.updateLastLogin(user.getUserId());
        logger.info("User authenticated: {}", email);
        
        return user;
    }

    /**
     * Get user by ID
     */
    public User getUserById(Long userId) throws SQLException {
        return userDAO.findById(userId);
    }

    /**
     * Update user profile
     */
    public boolean updateUserProfile(User user) throws SQLException {
        boolean success = userDAO.updateUser(user);
        if (success) {
            logger.info("User profile updated: {}", user.getUserId());
        }
        return success;
    }

    /**
     * Upgrade user subscription
     */
    public boolean upgradeSubscription(Long userId, String subscriptionType) throws SQLException {
        User user = userDAO.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found");
        }

        user.setSubscriptionType(subscriptionType);
        boolean success = userDAO.updateUser(user);
        
        if (success) {
            logger.info("User {} upgraded to {} subscription", userId, subscriptionType);
        }
        
        return success;
    }

    /**
     * Get all users with pagination
     */
    public List<User> getAllUsers(int page, int pageSize) throws SQLException {
        int offset = (page - 1) * pageSize;
        return userDAO.findAll(pageSize, offset);
    }

    /**
     * Get users by subscription type
     */
    public List<User> getUsersBySubscription(String subscriptionType) throws SQLException {
        return userDAO.findBySubscriptionType(subscriptionType);
    }

    /**
     * Delete user account
     */
    public boolean deleteUser(Long userId) throws SQLException {
        boolean success = userDAO.deleteUser(userId);
        if (success) {
            logger.info("User deleted: {}", userId);
        }
        return success;
    }

    /**
     * Get total user count
     */
    public int getTotalUserCount() throws SQLException {
        return userDAO.countUsers();
    }

    /**
     * Hash password using SHA-256
     */
    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException e) {
            logger.error("Error hashing password", e);
            throw new RuntimeException("Password hashing failed", e);
        }
    }
}
