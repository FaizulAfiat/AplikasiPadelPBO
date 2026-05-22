package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("user_id");

        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html");
            return;
        }

        int userId = (Integer) userIdObj;
        List<Map<String, Object>> bookingHistory = new ArrayList<>();
        List<Map<String, Object>> transactionHistory = new ArrayList<>();

        String username = "";
        String email = "";
        String role = "";
        String fullname = "";
        String gender = "";

        try (Connection conn = Koneksi.getConnection()) {
            // 0. Fetch User Details
            String userSql = "SELECT u.username, u.email, u.role, p.fullname, p.gender " +
                             "FROM users u " +
                             "LEFT JOIN profiles p ON u.user_id = p.user_id " +
                             "WHERE u.user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(userSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        username = rs.getString("username");
                        email = rs.getString("email");
                        role = rs.getString("role");
                        fullname = rs.getString("fullname");
                        gender = rs.getString("gender");
                    }
                }
            }

            // Check if profile exists in profiles table
            boolean profileExists = false;
            String checkSql = "SELECT COUNT(*) FROM profiles WHERE user_id = ?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setInt(1, userId);
                try (ResultSet checkRs = checkPs.executeQuery()) {
                    if (checkRs.next() && checkRs.getInt(1) > 0) {
                        profileExists = true;
                    }
                }
            }

            if (!profileExists) {
                // Insert default profile row for this user
                String insertSql = "INSERT INTO profiles (user_id, fullname, username, gender) VALUES (?, ?, ?, ?)";
                try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    insertPs.setInt(1, userId);
                    insertPs.setString(2, username);
                    insertPs.setString(3, username);
                    insertPs.setString(4, "L");
                    insertPs.executeUpdate();
                }
                fullname = username;
                gender = "L";
            }

            if (fullname == null) fullname = "";
            if (gender == null) gender = "";

            // 1. Fetch Court Bookings
            String bookingsSql = "SELECT b.booking_id, c.name AS court_name, b.match_date, b.start_time, b.end_time, b.total_price, b.status " +
                                 "FROM bookings b " +
                                 "JOIN courts c ON b.court_id = c.court_id " +
                                 "WHERE b.user_id = ? " +
                                 "ORDER BY b.match_date DESC, b.start_time DESC";
            
            try (PreparedStatement ps = conn.prepareStatement(bookingsSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> booking = new HashMap<>();
                        booking.put("id", rs.getInt("booking_id"));
                        booking.put("court", rs.getString("court_name"));
                        booking.put("date", rs.getDate("match_date"));
                        booking.put("start", rs.getTime("start_time"));
                        booking.put("end", rs.getTime("end_time"));
                        booking.put("total", rs.getInt("total_price"));
                        booking.put("status", rs.getString("status"));
                        bookingHistory.add(booking);
                    }
                }
            }

            // 2. Fetch Product Transactions (Purchases and Rentals)
            String transactionsSql = "SELECT t.transaction_id, p.name AS product_name, p.category, t.quantity, t.type, t.transaction_date, t.total_amount, t.status " +
                                     "FROM transaction t " +
                                     "JOIN products p ON t.product_id = p.product_id " +
                                     "WHERE t.user_id = ? " +
                                     "ORDER BY t.transaction_date DESC, t.transaction_id DESC";
            
            try (PreparedStatement ps = conn.prepareStatement(transactionsSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> tx = new HashMap<>();
                        tx.put("id", rs.getInt("transaction_id"));
                        tx.put("productName", rs.getString("product_name"));
                        tx.put("category", rs.getString("category"));
                        tx.put("quantity", rs.getInt("quantity"));
                        tx.put("type", rs.getString("type"));
                        tx.put("date", rs.getDate("transaction_date"));
                        tx.put("total", rs.getInt("total_amount"));
                        tx.put("status", rs.getString("status"));
                        transactionHistory.add(tx);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("role", role);
        request.setAttribute("fullname", fullname);
        request.setAttribute("gender", gender);
        request.setAttribute("bookingHistory", bookingHistory);
        request.setAttribute("transactionHistory", transactionHistory);

        request.getRequestDispatcher("view/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("user_id");

        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html");
            return;
        }

        int userId = (Integer) userIdObj;
        String username = (String) session.getAttribute("user");
        String fullname = request.getParameter("fullname");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = Koneksi.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Update Users table (email and optional password)
                if (password != null && !password.trim().isEmpty()) {
                    String updateUsersSql = "UPDATE users SET email = ?, password = ? WHERE user_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(updateUsersSql)) {
                        ps.setString(1, email);
                        ps.setString(2, password);
                        ps.setInt(3, userId);
                        ps.executeUpdate();
                    }
                } else {
                    String updateUsersSql = "UPDATE users SET email = ? WHERE user_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(updateUsersSql)) {
                        ps.setString(1, email);
                        ps.setInt(2, userId);
                        ps.executeUpdate();
                    }
                }

                // 2. Check if Profile exists
                boolean profileExists = false;
                String checkProfileSql = "SELECT COUNT(*) FROM profiles WHERE user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(checkProfileSql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            profileExists = true;
                        }
                    }
                }

                // 3. Update or Insert Profile
                if (profileExists) {
                    String updateProfileSql = "UPDATE profiles SET fullname = ?, gender = ? WHERE user_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(updateProfileSql)) {
                        ps.setString(1, fullname);
                        ps.setString(2, gender);
                        ps.setInt(3, userId);
                        ps.executeUpdate();
                    }
                } else {
                    String insertProfileSql = "INSERT INTO profiles (user_id, fullname, username, gender) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement ps = conn.prepareStatement(insertProfileSql)) {
                        ps.setInt(1, userId);
                        ps.setString(2, fullname);
                        ps.setString(3, username);
                        ps.setString(4, gender);
                        ps.executeUpdate();
                    }
                }

                conn.commit();
                response.sendRedirect(request.getContextPath() + "/Profile?status=profile_updated");
            } catch (SQLException ex) {
                conn.rollback();
                ex.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/Profile?status=error");
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Profile?status=error");
        }
    }
}
