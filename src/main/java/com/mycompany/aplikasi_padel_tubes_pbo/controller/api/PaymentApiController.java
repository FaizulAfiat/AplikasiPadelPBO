package com.mycompany.aplikasi_padel_tubes_pbo.controller.api;

import com.google.gson.Gson;
import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PaymentApiController extends HttpServlet {

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
        String bookingIdParam = request.getParameter("booking_id");

        if (action == null || !"confirm".equalsIgnoreCase(action) || bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid or missing parameters. action=confirm and booking_id are required.\"}");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);

            try (Connection conn = Koneksi.getConnection()) {
                // Verify owner and status
                String verifySql = "SELECT user_id, status FROM bookings WHERE booking_id = ?";
                try (PreparedStatement verifyPs = conn.prepareStatement(verifySql)) {
                    verifyPs.setInt(1, bookingId);
                    try (ResultSet rs = verifyPs.executeQuery()) {
                        if (rs.next()) {
                            int bookingUserId = rs.getInt("user_id");
                            String status = rs.getString("status");

                            if (bookingUserId != userId) {
                                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                                response.getWriter().write("{\"error\": \"Access denied. This booking does not belong to you.\"}");
                                return;
                            }

                            if (!"Pending".equalsIgnoreCase(status)) {
                                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                                response.getWriter().write("{\"error\": \"Invalid status. This booking is already " + status + ".\"}");
                                return;
                            }
                        } else {
                            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                            response.getWriter().write("{\"error\": \"Booking not found.\"}");
                            return;
                        }
                    }
                }

                // Update to Confirmed
                String updateSql = "UPDATE bookings SET status = 'Confirmed' WHERE booking_id = ?";
                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setInt(1, bookingId);
                    int updated = updatePs.executeUpdate();

                    if (updated > 0) {
                        Map<String, Object> apiResponse = new HashMap<>();
                        apiResponse.put("success", true);
                        apiResponse.put("bookingId", bookingId);
                        apiResponse.put("status", "Confirmed");
                        response.getWriter().write(gson.toJson(apiResponse));
                    } else {
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        response.getWriter().write("{\"error\": \"Failed to update booking status.\"}");
                    }
                }
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid booking ID format.\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        }
    }
}
