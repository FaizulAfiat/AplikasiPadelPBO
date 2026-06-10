package com.mycompany.aplikasi_padel_tubes_pbo.controller.api;

import com.google.gson.Gson;
import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ProfileApiController extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("user_id");

        if (userIdObj == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized. Please login first.\"}");
            return;
        }

        int userId = (Integer) userIdObj;
        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing action parameter.\"}");
            return;
        }

        try {
            if ("updatePassword".equalsIgnoreCase(action)) {
                handleUpdatePassword(request, response, userId);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid action parameter.\"}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        }
    }

    private void handleUpdatePassword(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        if (oldPassword == null || oldPassword.trim().isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing oldPassword or newPassword parameter.\"}");
            return;
        }

        try (Connection conn = Koneksi.getConnection()) {
            // Fetch current password
            String currentPassword = null;
            String selectSql = "SELECT password FROM users WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        currentPassword = rs.getString("password");
                    }
                }
            }

            if (currentPassword == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"User account not found.\"}");
                return;
            }

            // Compare passwords
            if (!currentPassword.equals(oldPassword)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Incorrect current password.\"}");
                return;
            }

            // Update to new password
            String updateSql = "UPDATE users SET password = ? WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, newPassword);
                ps.setInt(2, userId);
                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated > 0) {
                    response.getWriter().write("{\"success\": true}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"error\": \"Failed to update password.\"}");
                }
            }
        }
    }
}
