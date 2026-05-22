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
        String date = request.getParameter("date");

        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.LocalDate selectedDate = today;
        try {
            if (date != null && !date.trim().isEmpty()) {
                selectedDate = java.time.LocalDate.parse(date);
                if (selectedDate.isBefore(today)) {
                    selectedDate = today;
                }
            }
        } catch (Exception e) {
            selectedDate = today;
        }
        date = selectedDate.toString();

        List<String> bookedSlotsA = new ArrayList<>();
        List<String> bookedSlotsB = new ArrayList<>();

        try (Connection conn = Koneksi.getConnection()) {
            String sql = "SELECT court_id, start_time, end_time FROM bookings WHERE match_date = ? AND status != 'Cancelled'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, date);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int cId = rs.getInt("court_id");
                LocalTime start = rs.getTime("start_time").toLocalTime();
                LocalTime end = rs.getTime("end_time").toLocalTime();

                LocalTime temp = start;
                while (temp.isBefore(end)) {
                    String timeStr = String.format("%02d:00", temp.getHour());
                    if (cId == 1) {
                        bookedSlotsA.add(timeStr);
                    } else if (cId == 2) {
                        bookedSlotsB.add(timeStr);
                    }
                    temp = temp.plusHours(1);
                }
            }

            boolean isToday = selectedDate.equals(today);
            int currentHour = java.time.LocalTime.now().getHour();

            request.setAttribute("isToday", isToday);
            request.setAttribute("currentHour", currentHour);
            request.setAttribute("bookedSlotsA", bookedSlotsA);
            request.setAttribute("bookedSlotsB", bookedSlotsB);
            request.setAttribute("match_date", date);

            request.getRequestDispatcher("view/booking.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?status=error");
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

        // Server-side validation for date and past times
        java.time.LocalDate today = java.time.LocalDate.now();
        try {
            java.time.LocalDate bookDate = java.time.LocalDate.parse(matchDate);
            if (bookDate.isBefore(today)) {
                response.sendRedirect("BookingController?date=" + matchDate + "&status=invalid_date");
                return;
            }
            if (bookDate.equals(today)) {
                LocalTime nowTime = LocalTime.now();
                LocalTime start = LocalTime.parse(startTimeStr);
                if (start.getHour() <= nowTime.getHour()) {
                    response.sendRedirect("BookingController?date=" + matchDate + "&status=past_time");
                    return;
                }
            }
        } catch (Exception e) {
            response.sendRedirect("BookingController?status=invalid_date");
            return;
        }

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
                // strict overlapping interval check: S1 < E2 and S2 < E1
                String checkSql = "SELECT COUNT(*) FROM bookings " +
                                  "WHERE court_id = ? " +
                                  "AND match_date = ? " +
                                  "AND status != 'Cancelled' " +
                                  "AND start_time < ? " +
                                  "AND end_time > ?";
                PreparedStatement checkPs = conn.prepareStatement(checkSql);
                checkPs.setInt(1, courtId);
                checkPs.setString(2, matchDate);
                checkPs.setString(3, endTimeStr);
                checkPs.setString(4, startTimeStr);
                ResultSet rs = checkPs.executeQuery();

                if (rs.next() && rs.getInt(1) > 0) {
                    response.sendRedirect("BookingController?date=" + matchDate + "&status=already_booked");
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
                    response.sendRedirect("ProfileController?status=success");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("BookingController?date=" + matchDate + "&status=error");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("BookingController?date=" + matchDate + "&status=invalid_time");
        }
    }
}
