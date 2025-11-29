package com.algorythm.servlet;

import com.algorythm.model.User;
import com.algorythm.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet for handling user-related requests
 */
@WebServlet(urlPatterns = {"/user/register", "/user/login", "/user/profile", "/user/logout"})
public class UserServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(UserServlet.class);
    private UserService userService;

    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserService();
        logger.info("UserServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        try {
            switch (path) {
                case "/user/profile":
                    showProfile(request, response);
                    break;
                case "/user/logout":
                    logout(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            logger.error("Database error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        try {
            switch (path) {
                case "/user/register":
                    register(request, response);
                    break;
                case "/user/login":
                    login(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            logger.error("Database error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }

    /**
     * Handle user registration
     */
    private void register(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (username == null || email == null || password == null || 
            username.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing required fields\"}");
            return;
        }

        try {
            Long userId = userService.registerUser(username, email, password);
            response.setStatus(HttpServletResponse.SC_CREATED);
            response.setContentType("application/json");
            response.getWriter().write("{\"userId\": " + userId + ", \"message\": \"User registered successfully\"}");
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    /**
     * Handle user login
     */
    private void login(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing email or password\"}");
            return;
        }

        try {
            User user = userService.authenticateUser(email, password);
            
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("subscriptionType", user.getSubscriptionType());

            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("application/json");
            response.getWriter().write(String.format(
                "{\"userId\": %d, \"username\": \"%s\", \"email\": \"%s\", \"subscriptionType\": \"%s\", \"message\": \"Login successful\"}",
                user.getUserId(), user.getUsername(), user.getEmail(), user.getSubscriptionType()
            ));
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    /**
     * Show user profile
     */
    private void showProfile(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Not authenticated\"}");
            return;
        }

        Long userId = (Long) session.getAttribute("userId");
        User user = userService.getUserById(userId);

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"error\": \"User not found\"}");
            return;
        }

        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/json");
        response.getWriter().write(String.format(
            "{\"userId\": %d, \"username\": \"%s\", \"email\": \"%s\", \"fullName\": \"%s\", " +
            "\"subscriptionType\": \"%s\", \"isVerified\": %b, \"isActive\": %b}",
            user.getUserId(), user.getUsername(), user.getEmail(), 
            user.getFullName() != null ? user.getFullName() : "",
            user.getSubscriptionType(), user.isVerified(), user.isActive()
        ));
    }

    /**
     * Handle user logout
     */
    private void logout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            session.invalidate();
        }

        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/json");
        response.getWriter().write("{\"message\": \"Logged out successfully\"}");
    }
}
