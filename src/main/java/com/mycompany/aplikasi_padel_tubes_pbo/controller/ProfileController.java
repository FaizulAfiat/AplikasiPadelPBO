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

        try (Connection conn = Koneksi.getConnection()) {
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

            // 3. Fetch Match History
            String matchSql = "SELECT ps_self.match_id, m.scoring_style, m.skor_tim1, m.skor_tim2, ps_self.tim AS user_team, " +
                              "       ps_all.user_id AS player_user_id, ps_all.tim AS player_team, " +
                              "       u.username AS player_username, pr.fullname AS player_fullname " +
                              "FROM player_scores ps_self " +
                              "JOIN matches m ON ps_self.match_id = m.match_id " +
                              "JOIN player_scores ps_all ON m.match_id = ps_all.match_id " +
                              "LEFT JOIN users u ON ps_all.user_id = u.user_id " +
                              "LEFT JOIN profiles pr ON ps_all.user_id = pr.user_id " +
                              "WHERE ps_self.user_id = ? " +
                              "ORDER BY m.match_id DESC";

            java.util.Map<Integer, java.util.Map<String, Object>> matchMap = new java.util.LinkedHashMap<>();
            try (PreparedStatement ps = conn.prepareStatement(matchSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int matchId = rs.getInt("match_id");
                        java.util.Map<String, Object> matchData = matchMap.get(matchId);
                        if (matchData == null) {
                            matchData = new HashMap<>();
                            matchData.put("id", matchId);
                            matchData.put("mode", rs.getString("scoring_style"));

                            int skorTim1 = rs.getInt("skor_tim1");
                            int skorTim2 = rs.getInt("skor_tim2");
                            int userTeam = rs.getInt("user_team");

                            int userScore = (userTeam == 1) ? skorTim1 : skorTim2;
                            int oppScore = (userTeam == 1) ? skorTim2 : skorTim1;

                            matchData.put("score", userScore + " - " + oppScore);

                            String outcome = "DRAW";
                            if (userScore > oppScore) {
                                outcome = "WIN";
                            } else if (userScore < oppScore) {
                                outcome = "LOSE";
                            }
                            matchData.put("outcome", outcome);

                            matchData.put("partnerList", new ArrayList<String>());
                            matchData.put("opponentList", new ArrayList<String>());
                            matchData.put("userTeam", userTeam);

                            matchMap.put(matchId, matchData);
                        }

                        int userTeam = (Integer) matchData.get("userTeam");
                        int playerTeam = rs.getInt("player_team");
                        Integer playerUserId = rs.getObject("player_user_id") != null ? rs.getInt("player_user_id") : null;

                        String fullname = rs.getString("player_fullname");
                        String username = rs.getString("player_username");
                        String name = (fullname != null && !fullname.trim().isEmpty()) ? fullname : username;
                        if (name == null || name.trim().isEmpty()) {
                            name = "Guest";
                        }

                        if (playerTeam == userTeam) {
                            if (playerUserId != null && playerUserId == userId) {
                                // It's self, skip
                            } else {
                                ((List<String>) matchData.get("partnerList")).add(name);
                            }
                        } else {
                            ((List<String>) matchData.get("opponentList")).add(name);
                        }
                    }
                }
            }

            List<Map<String, Object>> matchHistory = new ArrayList<>();
            for (Map<String, Object> matchData : matchMap.values()) {
                List<String> partnerList = (List<String>) matchData.get("partnerList");
                List<String> opponentList = (List<String>) matchData.get("opponentList");

                String partner = partnerList.isEmpty() ? "Guest" : String.join(" & ", partnerList);
                String opponents = opponentList.isEmpty() ? "Guest" : String.join(" & ", opponentList);

                matchData.put("partner", partner);
                matchData.put("opponents", opponents);

                matchHistory.add(matchData);
            }
            request.setAttribute("matchHistory", matchHistory);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("bookingHistory", bookingHistory);
        request.setAttribute("transactionHistory", transactionHistory);

        request.getRequestDispatcher("view/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
