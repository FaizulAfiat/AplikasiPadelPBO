/*
 * Controller untuk Achievement System
 * @author Muhammad Alfian
 */
package com.mycompany.aplikasi_padel_tubes_pbo.controller.achievement;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import com.mycompany.aplikasi_padel_tubes_pbo.model.UserAchievement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AchievementController", urlPatterns = {"/AchievementController"})
public class AchievementController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Cek apakah user sudah login
        Object userIdObj = session.getAttribute("user_id");
        if (userIdObj == null) {
            response.sendRedirect("view/Login.html");
            return;
        }

        int userId = Integer.parseInt(userIdObj.toString());
        List<UserAchievement> userAchievements = new ArrayList<>();
        List<Map<String, Object>> allAchievements = new ArrayList<>();
        int totalBookings = 0;
        int totalCommunities = 0;
        int totalProducts = 0;
        String premiumStatus = "Regular";

        try (Connection conn = Koneksi.getConnection()) {
            // 1. Ambil semua achievement yang sudah di-unlock user
            String userAchSql = "SELECT ua.user_achievement_id, ua.user_id, ua.achievement_id, "
                    + "ua.unlocked_at, a.name, a.icon, a.badge_color, a.description "
                    + "FROM user_achievements ua "
                    + "JOIN achievements a ON ua.achievement_id = a.achievement_id "
                    + "WHERE ua.user_id = ? ORDER BY ua.unlocked_at DESC";
            
            PreparedStatement userAchPs = conn.prepareStatement(userAchSql);
            userAchPs.setInt(1, userId);
            ResultSet userAchRs = userAchPs.executeQuery();
            
            while (userAchRs.next()) {
                UserAchievement ua = new UserAchievement(
                    userAchRs.getInt("user_achievement_id"),
                    userAchRs.getInt("user_id"),
                    userAchRs.getInt("achievement_id"),
                    userAchRs.getTimestamp("unlocked_at"),
                    userAchRs.getString("name"),
                    userAchRs.getString("icon"),
                    userAchRs.getString("badge_color"),
                    userAchRs.getString("description")
                );
                userAchievements.add(ua);
            }
            userAchPs.close();

            // 2. Hitung total bookings user
            String bookingSql = "SELECT COUNT(*) as total FROM bookings WHERE user_id = ?";
            PreparedStatement bookingPs = conn.prepareStatement(bookingSql);
            bookingPs.setInt(1, userId);
            ResultSet bookingRs = bookingPs.executeQuery();
            if (bookingRs.next()) {
                totalBookings = bookingRs.getInt("total");
            }
            bookingPs.close();

            // 3. Hitung total komunitas yang di-join user
            String communitySql = "SELECT COUNT(*) as total FROM club_member WHERE user_id = ?";
            PreparedStatement communityPs = conn.prepareStatement(communitySql);
            communityPs.setInt(1, userId);
            ResultSet communityRs = communityPs.executeQuery();
            if (communityRs.next()) {
                totalCommunities = communityRs.getInt("total");
            }
            communityPs.close();

            // 4. Cek role user (untuk premium status)
            String roleSql = "SELECT role FROM users WHERE user_id = ?";
            PreparedStatement rolePs = conn.prepareStatement(roleSql);
            rolePs.setInt(1, userId);
            ResultSet roleRs = rolePs.executeQuery();
            if (roleRs.next()) {
                premiumStatus = roleRs.getString("role");
            }
            rolePs.close();

            // 5. Cek apakah ada pembelian produk
            String productSql = "SELECT COUNT(DISTINCT product_id) as total FROM (" +
                    "SELECT product_id FROM products LIMIT 100) as temp";
            PreparedStatement productPs = conn.prepareStatement(productSql);
            ResultSet productRs = productPs.executeQuery();
            if (productRs.next()) {
                totalProducts = productRs.getInt("total");
            }
            productPs.close();

            // 6. Ambil semua achievement definitions
            String allAchSql = "SELECT achievement_id, name, description, icon, badge_color, milestone_type, milestone_value FROM achievements";
            PreparedStatement allAchPs = conn.prepareStatement(allAchSql);
            ResultSet allAchRs = allAchPs.executeQuery();
            
            while (allAchRs.next()) {
                int achId = allAchRs.getInt("achievement_id");
                Map<String, Object> ach = new HashMap<>();
                ach.put("achievement_id", achId);
                ach.put("name", allAchRs.getString("name"));
                ach.put("description", allAchRs.getString("description"));
                ach.put("icon", allAchRs.getString("icon"));
                ach.put("badge_color", allAchRs.getString("badge_color"));
                ach.put("milestone_type", allAchRs.getString("milestone_type"));
                ach.put("milestone_value", allAchRs.getInt("milestone_value"));
                
                // Cek apakah user sudah unlock achievement ini
                boolean isUnlocked = userAchievements.stream()
                        .anyMatch(ua -> ua.getAchievementId() == achId);
                ach.put("is_unlocked", isUnlocked);
                
                allAchievements.add(ach);
            }
            allAchPs.close();

            // 7. Check dan unlock achievement otomatis
            checkAndUnlockAchievements(conn, userId, totalBookings, totalCommunities, premiumStatus, allAchievements);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Pass data ke JSP
        request.setAttribute("userAchievements", userAchievements);
        request.setAttribute("allAchievements", allAchievements);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalCommunities", totalCommunities);
        request.setAttribute("premiumStatus", premiumStatus);

        request.getRequestDispatcher("view/achievement.jsp").forward(request, response);
    }

    /**
     * Method untuk check dan unlock achievement berdasarkan milestone secara dinamis
     */
    private void checkAndUnlockAchievements(Connection conn, int userId, 
            int totalBookings, int totalCommunities, String premiumStatus, List<Map<String, Object>> allAchievements) {
        try {
            int communityCreated = checkCommunityCreated(conn, userId);

            for (Map<String, Object> ach : allAchievements) {
                int achId = (int) ach.get("achievement_id");
                String type = (String) ach.get("milestone_type");
                int value = (int) ach.get("milestone_value");
                boolean isUnlocked = (boolean) ach.get("is_unlocked");

                // Jika sudah unlock, skip
                if (isUnlocked) continue;

                boolean shouldUnlock = false;

                if ("booking".equals(type) && totalBookings >= value) {
                    shouldUnlock = true;
                } else if ("community".equals(type) && totalCommunities >= value) {
                    shouldUnlock = true;
                } else if ("community_created".equals(type) && communityCreated >= value) {
                    shouldUnlock = true;
                } else if ("premium".equals(type) && "Premium".equals(premiumStatus)) {
                    shouldUnlock = true;
                }

                if (shouldUnlock) {
                    unlockAchievement(conn, userId, achId);
                    ach.put("is_unlocked", true); // update map in memory
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Method untuk unlock achievement (insert ke tabel user_achievements)
     */
    private void unlockAchievement(Connection conn, int userId, int achievementId) throws SQLException {
        // Cek dulu apakah achievement sudah di-unlock
        String checkSql = "SELECT * FROM user_achievements WHERE user_id = ? AND achievement_id = ?";
        PreparedStatement checkPs = conn.prepareStatement(checkSql);
        checkPs.setInt(1, userId);
        checkPs.setInt(2, achievementId);
        ResultSet rs = checkPs.executeQuery();

        if (!rs.next()) {
            // Belum di-unlock, jadi di-insert
            String insertSql = "INSERT INTO user_achievements (user_id, achievement_id, unlocked_at) VALUES (?, ?, ?)";
            PreparedStatement insertPs = conn.prepareStatement(insertSql);
            insertPs.setInt(1, userId);
            insertPs.setInt(2, achievementId);
            insertPs.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            insertPs.executeUpdate();
            insertPs.close();
        }
        checkPs.close();
    }

    /**
     * Method untuk check berapa banyak komunitas yang dibuat user
     */
    private int checkCommunityCreated(Connection conn, int userId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM club WHERE created_by = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        
        int count = 0;
        if (rs.next()) {
            count = rs.getInt("total");
        }
        ps.close();
        return count;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tidak ada POST untuk achievement (read-only)
    }
}

