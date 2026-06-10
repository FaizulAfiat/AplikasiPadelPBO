package com.mycompany.aplikasi_padel_tubes_pbo.controller.api;

import com.google.gson.Gson;
import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class BookingApiController extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized. Please login first.\"}");
            return;
        }

        String courtIdStr = request.getParameter("courtId");
        String dateStr = request.getParameter("date");

        // Parse date (default to today)
        LocalDate today = LocalDate.now();
        LocalDate selectedDate = today;
        try {
            if (dateStr != null && !dateStr.trim().isEmpty()) {
                selectedDate = LocalDate.parse(dateStr);
                if (selectedDate.isBefore(today)) {
                    selectedDate = today;
                }
            }
        } catch (Exception e) {
            selectedDate = today;
        }
        String date = selectedDate.toString();

        List<LocalTime> bookedSlots = new ArrayList<>();

        try (Connection conn = Koneksi.getConnection()) {
            // Determine active courtId (default to first available court if courtId is invalid or missing)
            int courtId = -1;
            if (courtIdStr != null && !courtIdStr.trim().isEmpty()) {
                try {
                    courtId = Integer.parseInt(courtIdStr);
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }

            if (courtId == -1) {
                String firstCourtSql = "SELECT court_id FROM courts WHERE status = 'Available' LIMIT 1";
                try (PreparedStatement ps = conn.prepareStatement(firstCourtSql);
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        courtId = rs.getInt("court_id");
                    } else {
                        courtId = 1; // absolute fallback
                    }
                }
            }

            // Retrieve existing non-cancelled bookings
            String sql = "SELECT start_time, end_time FROM bookings WHERE court_id = ? AND match_date = ? AND status != 'Cancelled'";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, courtId);
                ps.setString(2, date);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        LocalTime start = rs.getTime("start_time").toLocalTime();
                        LocalTime end = rs.getTime("end_time").toLocalTime();

                        LocalTime temp = start;
                        while (temp.isBefore(end)) {
                            bookedSlots.add(temp);
                            temp = temp.plusHours(1);
                        }
                    }
                }
            }

            boolean isToday = selectedDate.equals(today);
            int currentHour = LocalTime.now().getHour();

            // Generate Slot (06:00 - 22:00)
            List<Map<String, Object>> timeSlots = new ArrayList<>();
            for (int h = 6; h < 22; h++) {
                LocalTime slotTime = LocalTime.of(h, 0);
                Map<String, Object> slot = new HashMap<>();
                
                // Format time as readable "HH:00"
                slot.put("time", String.format("%02d:00", h));
                
                boolean available = !bookedSlots.contains(slotTime);
                if (isToday && h <= currentHour) {
                    available = false;
                }
                
                slot.put("isAvailable", available);
                timeSlots.add(slot);
            }

            Map<String, Object> jsonResponse = new HashMap<>();
            jsonResponse.put("courtId", courtId);
            jsonResponse.put("date", date);
            jsonResponse.put("timeSlots", timeSlots);

            response.getWriter().write(gson.toJson(jsonResponse));

        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        }
    }
}
