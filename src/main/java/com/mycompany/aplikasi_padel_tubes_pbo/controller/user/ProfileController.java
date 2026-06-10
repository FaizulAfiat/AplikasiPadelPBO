package com.mycompany.aplikasi_padel_tubes_pbo.controller.user;

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
        int targetUserId = userId;
        boolean viewingSelf = true;
        
        String viewUserIdStr = request.getParameter("viewUserId");
        if (viewUserIdStr != null && !viewUserIdStr.trim().isEmpty()) {
            try {
                int viewUserId = Integer.parseInt(viewUserIdStr);
                targetUserId = viewUserId;
                viewingSelf = (targetUserId == userId);
            } catch (NumberFormatException e) {
                // Ignore and fall back to viewing self
            }
        }
        request.setAttribute("viewingSelf", viewingSelf);
        
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
                ps.setInt(1, targetUserId);
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
                checkPs.setInt(1, targetUserId);
                try (ResultSet checkRs = checkPs.executeQuery()) {
                    if (checkRs.next() && checkRs.getInt(1) > 0) {
                        profileExists = true;
                    }
                }
            }

            if (!profileExists && viewingSelf) {
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

            if (fullname == null || fullname.trim().isEmpty()) fullname = username;
            if (gender == null || gender.trim().isEmpty()) gender = "L";

            // 2. Fetch Product Transactions (Purchases and Rentals)
            if (viewingSelf) {
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
                ps.setInt(1, targetUserId);
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

                        String playerFullname = rs.getString("player_fullname");
                        String playerUsername = rs.getString("player_username");
                        String name = (playerFullname != null && !playerFullname.trim().isEmpty()) ? playerFullname : playerUsername;
                        if (name == null || name.trim().isEmpty()) {
                            name = "Guest";
                        }

                        if (playerTeam == userTeam) {
                            if (playerUserId != null && playerUserId == targetUserId) {
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

            List<Map<String, Object>> activeRentals = new ArrayList<>();
            if (viewingSelf) {
                // 4. Auto-update Overdue rentals for current user
                String updateOverdueSql = "UPDATE rentals SET status = 'Overdue' WHERE user_id = ? AND status = 'Active' AND due_date < CURRENT_DATE()";
                try (PreparedStatement psUpdate = conn.prepareStatement(updateOverdueSql)) {
                    psUpdate.setInt(1, userId);
                    psUpdate.executeUpdate();
                }

                // 5. Fetch Active Product Rentals for current user
                String activeRentalsSql = "SELECT r.rental_id, p.name AS product_name, p.category, r.quantity, r.rental_date, r.due_date, r.status, p.image, " +
                                          "c.name AS court_name, b.start_time, b.end_time " +
                                          "FROM rentals r " +
                                          "JOIN products p ON r.product_id = p.product_id " +
                                          "LEFT JOIN bookings b ON r.booking_id = b.booking_id " +
                                          "LEFT JOIN courts c ON b.court_id = c.court_id " +
                                          "WHERE r.user_id = ? AND r.status != 'Returned' " +
                                          "ORDER BY r.rental_id DESC";
                try (PreparedStatement ps = conn.prepareStatement(activeRentalsSql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, Object> rental = new HashMap<>();
                            rental.put("id", rs.getInt("rental_id"));
                            rental.put("productName", rs.getString("product_name"));
                            rental.put("category", rs.getString("category"));
                            rental.put("quantity", rs.getInt("quantity"));
                            rental.put("rentalDate", rs.getDate("rental_date"));
                            rental.put("dueDate", rs.getDate("due_date"));
                            rental.put("status", rs.getString("status"));
                            rental.put("image", rs.getString("image"));
                            rental.put("courtName", rs.getString("court_name"));
                            rental.put("bookingStart", rs.getTime("start_time"));
                            rental.put("bookingEnd", rs.getTime("end_time"));
                            
                            // Calculate remaining days (due_date - current_date)
                            java.sql.Date dueDate = rs.getDate("due_date");
                            long diffMs = dueDate.getTime() - System.currentTimeMillis();
                            long diffDays = diffMs / (1000 * 60 * 60 * 24);
                            rental.put("remainingDays", diffDays);
                            
                            activeRentals.add(rental);
                        }
                    }
                }
            }
            request.setAttribute("activeRentals", activeRentals);

            // 6. Fetch Following & Followers Count
            int followingCount = 0;
            int followersCount = 0;
            String followingSql = "SELECT COUNT(*) FROM friendships WHERE (user_id = ? AND status IN ('ACCEPTED', 'PENDING')) OR (friend_id = ? AND status = 'ACCEPTED')";
            try (PreparedStatement ps = conn.prepareStatement(followingSql)) {
                ps.setInt(1, targetUserId);
                ps.setInt(2, targetUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        followingCount = rs.getInt(1);
                    }
                }
            }
            String followersSql = "SELECT COUNT(*) FROM friendships WHERE (friend_id = ? AND status IN ('ACCEPTED', 'PENDING')) OR (user_id = ? AND status = 'ACCEPTED')";
            try (PreparedStatement ps = conn.prepareStatement(followersSql)) {
                ps.setInt(1, targetUserId);
                ps.setInt(2, targetUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        followersCount = rs.getInt(1);
                    }
                }
            }
            request.setAttribute("followingCount", followingCount);
            request.setAttribute("followersCount", followersCount);

            // 7. Fetch Pending Friend Requests (Inbox)
            List<Map<String, Object>> pendingRequests = new ArrayList<>();
            if (viewingSelf) {
                String pendingSql = "SELECT f.friendship_id, u.username AS sender_username " +
                                    "FROM friendships f " +
                                    "JOIN users u ON f.user_id = u.user_id " +
                                    "WHERE f.friend_id = ? AND f.status = 'PENDING'";
                try (PreparedStatement ps = conn.prepareStatement(pendingSql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, Object> reqMap = new HashMap<>();
                            reqMap.put("friendshipId", rs.getInt("friendship_id"));
                            reqMap.put("senderUsername", rs.getString("sender_username"));
                            pendingRequests.add(reqMap);
                        }
                    }
                }
            }
            request.setAttribute("pendingRequests", pendingRequests);

            // 8. Fetch Accepted Friends
            List<Map<String, Object>> friendsList = new ArrayList<>();
            if (viewingSelf) {
                String friendsSql = "SELECT f.friendship_id, u.user_id, u.username, u.email, p.fullname, p.gender " +
                                    "FROM friendships f " +
                                    "JOIN users u ON (f.friend_id = u.user_id OR f.user_id = u.user_id) " +
                                    "LEFT JOIN profiles p ON u.user_id = p.user_id " +
                                    "WHERE (f.user_id = ? OR f.friend_id = ?) AND f.status = 'ACCEPTED' AND u.user_id != ?";
                try (PreparedStatement ps = conn.prepareStatement(friendsSql)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, userId);
                    ps.setInt(3, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, Object> friendMap = new HashMap<>();
                            friendMap.put("friendshipId", rs.getInt("friendship_id"));
                            friendMap.put("userId", rs.getInt("user_id"));
                            friendMap.put("username", rs.getString("username"));
                            friendMap.put("email", rs.getString("email"));
                            friendMap.put("fullname", rs.getString("fullname"));
                            friendMap.put("gender", rs.getString("gender"));
                            friendsList.add(friendMap);
                        }
                    }
                }
            }
            request.setAttribute("friends", friendsList);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("role", role);
        request.setAttribute("fullname", fullname);
        request.setAttribute("gender", gender);
        request.setAttribute("transactionHistory", transactionHistory);
        request.setAttribute("targetUserId", targetUserId);

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
