package com.mycompany.aplikasi_padel_tubes_pbo.controller.booking;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import com.mycompany.aplikasi_padel_tubes_pbo.model.Lapangan;
import java.io.IOException;
import jakarta.servlet.ServletException;
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

public class BookingController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html");
            return;
        }

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

        List<Lapangan> listLapangan = new ArrayList<>();
        List<LocalTime> bookedSlots = new ArrayList<>();

        try (Connection conn = Koneksi.getConnection()) {
            // Load all available courts from database
            String courtSql = "SELECT * FROM courts WHERE status = 'Available'";
            try (PreparedStatement courtPs = conn.prepareStatement(courtSql);
                 ResultSet courtRs = courtPs.executeQuery()) {
                while (courtRs.next()) {
                    listLapangan.add(new Lapangan(
                        courtRs.getInt("court_id"),
                        courtRs.getString("name"),
                        courtRs.getInt("price_per_hour"),
                        courtRs.getString("status")
                    ));
                }
            }

            // Determine active courtId
            String courtId = request.getParameter("court_id");
            if (courtId == null && !listLapangan.isEmpty()) {
                courtId = String.valueOf(listLapangan.get(0).getCourtId());
            } else if (courtId == null) {
                courtId = "1";
            }

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

            boolean isToday = selectedDate.equals(today);
            int currentHour = java.time.LocalTime.now().getHour();

            // Generate Slot (06:00 - 22:00)
            List<Map<String, Object>> timeSlots = new ArrayList<>();
            for (int h = 6; h < 22; h++) {
                LocalTime slotTime = LocalTime.of(h, 0);
                Map<String, Object> slot = new HashMap<>();
                slot.put("time", slotTime);
                
                boolean available = !bookedSlots.contains(slotTime);
                if (isToday && h <= currentHour) {
                    available = false;
                }
                
                slot.put("isAvailable", available);
                timeSlots.add(slot);
            }

            int pricePerHour = 250000;
            for (Lapangan l : listLapangan) {
                if (String.valueOf(l.getCourtId()).equals(courtId)) {
                    pricePerHour = l.getPricePerHour();
                    break;
                }
            }

            request.setAttribute("courtId", courtId);
            request.setAttribute("date", date);
            request.setAttribute("timeSlots", timeSlots);
            request.setAttribute("listLapangan", listLapangan);
            request.setAttribute("pricePerHour", pricePerHour);
            request.setAttribute("isToday", isToday);
            request.setAttribute("currentHour", currentHour);
            request.getRequestDispatcher("view/booking.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("BookingController?date=" + date + "&status=error");
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

            try (Connection conn = Koneksi.getConnection()) {
                // Fetch dynamic court price per hour from database
                String courtPriceSql = "SELECT price_per_hour FROM courts WHERE court_id = ?";
                try (PreparedStatement cpPs = conn.prepareStatement(courtPriceSql)) {
                    cpPs.setInt(1, courtId);
                    try (ResultSet cpRs = cpPs.executeQuery()) {
                        if (cpRs.next()) {
                            pricePerHour = cpRs.getInt("price_per_hour");
                        }
                    }
                }

                int totalPrice = (int) (hours * pricePerHour);

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
                PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);

                ps.setInt(1, userId);
                ps.setInt(2, courtId);
                ps.setString(3, matchDate);
                ps.setString(4, startTimeStr);
                ps.setString(5, endTimeStr);
                ps.setInt(6, totalPrice);
                ps.setString(7, "Pending");

                int rowInserted = ps.executeUpdate();
                if (rowInserted > 0) {
                    int bookingId = -1;
                    try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            bookingId = generatedKeys.getInt(1);
                        }
                    }
                    if (bookingId != -1) {
                        response.sendRedirect(request.getContextPath() + "/PaymentController?booking_id=" + bookingId);
                    } else {
                        response.sendRedirect("BookingController?date=" + matchDate + "&status=error");
                    }
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
