package com.mycompany.aplikasi_padel_tubes_pbo.controller.api;

import com.google.gson.Gson;
import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuthApiController extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing action parameter.\"}");
            return;
        }

        try {
            switch (action) {
                case "login":
                    handleLogin(request, response);
                    break;
                case "register":
                    handleRegister(request, response);
                    break;
                case "logout":
                    handleLogout(request, response);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Invalid action parameter.\"}");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Email and password are required.\"}");
            return;
        }

        try (Connection conn = Koneksi.getConnection()) {
            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email.trim());
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        HttpSession session = request.getSession();
                        String username = rs.getString("username");
                        int userId = rs.getInt("user_id");
                        String role = rs.getString("role");

                        session.setAttribute("user", username);
                        session.setAttribute("user_id", userId);
                        session.setAttribute("role", role);

                        Map<String, Object> userMap = new HashMap<>();
                        userMap.put("userId", userId);
                        userMap.put("username", username);
                        userMap.put("role", role);
                        userMap.put("email", rs.getString("email"));

                        Map<String, Object> apiResponse = new HashMap<>();
                        apiResponse.put("success", true);
                        apiResponse.put("user", userMap);

                        response.getWriter().write(gson.toJson(apiResponse));
                    } else {
                        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                        response.getWriter().write("{\"error\": \"Invalid email or password.\"}");
                    }
                }
            }
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String username = request.getParameter("username");
        String fullname = request.getParameter("fullname");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
            fullname == null || fullname.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"All registration fields are required.\"}");
            return;
        }

        Timestamp currentTime = new Timestamp(System.currentTimeMillis());

        try (Connection conn = Koneksi.getConnection()) {
            // Check if username or email already exists
            String checkSql = "SELECT 1 FROM users WHERE username = ? OR email = ?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, username.trim());
                checkPs.setString(2, email.trim());
                try (ResultSet checkRs = checkPs.executeQuery()) {
                    if (checkRs.next()) {
                        response.setStatus(HttpServletResponse.SC_CONFLICT);
                        response.getWriter().write("{\"error\": \"Username or Email already registered.\"}");
                        return;
                    }
                }
            }

            conn.setAutoCommit(false);
            try {
                String sql = "INSERT INTO users (username, email, password, created_at) VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, username.trim());
                    ps.setString(2, email.trim());
                    ps.setString(3, password);
                    ps.setTimestamp(4, currentTime);

                    int result = ps.executeUpdate();
                    if (result > 0) {
                        int userId = -1;
                        try (ResultSet rs = ps.getGeneratedKeys()) {
                            if (rs.next()) {
                                userId = rs.getInt(1);
                            }
                        }

                        if (userId != -1) {
                            String profileSql = "INSERT INTO profiles (user_id, fullname, username, gender) VALUES (?, ?, ?, ?)";
                            try (PreparedStatement profilePs = conn.prepareStatement(profileSql)) {
                                profilePs.setInt(1, userId);
                                profilePs.setString(2, fullname.trim());
                                profilePs.setString(3, username.trim());
                                profilePs.setString(4, gender);
                                profilePs.executeUpdate();
                            }
                        }

                        conn.commit();
                        response.getWriter().write("{\"success\": true}");
                    } else {
                        conn.rollback();
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        response.getWriter().write("{\"error\": \"Failed to create user account.\"}");
                    }
                }
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.getWriter().write("{\"success\": true}");
    }
}
