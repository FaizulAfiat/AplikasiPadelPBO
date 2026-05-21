/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Faizul Afiat
 */
public class BookingController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courtId = request.getParameter("court_id");
        String date = request.getParameter("date");

        if (courtId == null) {
            courtId = "1";
        }
        if (date == null) {
            date = java.time.LocalDate.now().toString();
        }

        List<LocalTime> bookedSlots = new ArrayList<>();

        try (Connection conn = Koneksi.getConnection()) {
            String sql = "SELECT start_time, end_time FROM bookings WHERE court_id = ? AND match_date = ? AND status != 'Cancelled'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, courtId);
            ps.setString(2, date);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                LocalTime start = rs.getTime("start_time").toLocalTime();
                LocalTime end = rs.getTime("end_time").toLocalTime();

                LocalTime temp = start;
                while (temp.isBefore(end)) {
                    bookedSlots.add(temp);
                    temp = temp.plusHours(1);
                }
            }

            // Generate Slot (06:00 - 22:00)
            List<Map<String, Object>> timeSlots = new ArrayList<>();
            for (int h = 6; h < 22; h++) {
                LocalTime slotTime = LocalTime.of(h, 0);
                Map<String, Object> slot = new HashMap<>();
                slot.put("time", slotTime);
                slot.put("isAvailable", !bookedSlots.contains(slotTime));
                timeSlots.add(slot);
            }

            request.setAttribute("timeSlots", timeSlots);
            request.getRequestDispatcher("view/booking.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Object userObj = session.getAttribute("user_id");
        String matchDate = request.getParameter("match_date");
        String startTimeStr = request.getParameter("start_time");
        String endTimeStr = request.getParameter("end_time");
        int courtId = Integer.parseInt(request.getParameter("court_id"));

        if (userObj == null) {
            response.sendRedirect("view/Login.html");
            return;
        }
        Integer userId = (Integer) userObj;

        try {
            LocalTime start = LocalTime.parse(startTimeStr);
            LocalTime end = LocalTime.parse(endTimeStr);

            long minutes = Duration.between(start, end).toMinutes();

            if (minutes < 0) {
                minutes += 24 * 60;
            }

            double hours = minutes / 60.0;
            int pricePerHour = 250000;
            int totalPrice = (int) (hours * pricePerHour);

            try (Connection conn = Koneksi.getConnection()) {
                String checkSql = "SELECT COUNT(*) FROM bookings WHERE court_id = ? AND match_date = ? AND start_time = ? AND status != 'Cancelled'";
                PreparedStatement checkPs = conn.prepareStatement(checkSql);
                checkPs.setInt(1, courtId);
                checkPs.setString(2, matchDate);
                checkPs.setString(3, startTimeStr);
                ResultSet rs = checkPs.executeQuery();

                if (rs.next() && rs.getInt(1) > 0) {
                    response.sendRedirect("view/booking.jsp?status=already_booked");
                    return;
                }

                String sql = "INSERT INTO bookings (user_id, court_id, match_date, start_time, end_time, total_price, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);

                ps.setInt(1, userId);
                ps.setInt(2, courtId);
                ps.setString(3, matchDate);
                ps.setString(4, startTimeStr);
                ps.setString(5, endTimeStr);
                ps.setInt(6, totalPrice);
                ps.setString(7, "Pending");

                int rowInserted = ps.executeUpdate();
                if (rowInserted > 0) {
                    response.sendRedirect("index.jsp?status=success");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("view/booking.jsp?status=error");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("view/booking.jsp?status=invalid_time");
        }
    }
}
