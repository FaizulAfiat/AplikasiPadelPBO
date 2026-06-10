package com.mycompany.aplikasi_padel_tubes_pbo.controller.chat;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SearchFriendController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer currentUserId = (Integer) session.getAttribute("user_id");

        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html");
            return;
        }

        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        keyword = keyword.trim();

        List<Map<String, Object>> searchResults = new ArrayList<>();

        if (!keyword.isEmpty()) {
            String sql = "SELECT u.user_id, u.username, u.email, " +
                         "       f.friendship_id, f.user_id AS sender_id, f.friend_id AS receiver_id, f.status " +
                         "FROM users u " +
                         "LEFT JOIN friendships f ON ( " +
                         "    (f.user_id = ? AND f.friend_id = u.user_id) OR " +
                         "    (f.friend_id = ? AND f.user_id = u.user_id) " +
                         ") " +
                         "WHERE u.username LIKE ? AND u.user_id != ? AND u.role != 'Admin' " +
                         "ORDER BY u.username ASC";

            try (Connection conn = Koneksi.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                
                ps.setInt(1, currentUserId);
                ps.setInt(2, currentUserId);
                ps.setString(3, "%" + keyword + "%");
                ps.setInt(4, currentUserId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> user = new HashMap<>();
                        user.put("userId", rs.getInt("user_id"));
                        user.put("username", rs.getString("username"));
                        user.put("email", rs.getString("email"));
                        
                        int friendshipId = rs.getInt("friendship_id");
                        if (rs.wasNull()) {
                            user.put("friendshipId", null);
                            user.put("status", "NONE");
                        } else {
                            user.put("friendshipId", friendshipId);
                            user.put("senderId", rs.getInt("sender_id"));
                            user.put("receiverId", rs.getInt("receiver_id"));
                            user.put("status", rs.getString("status"));
                        }
                        searchResults.add(user);
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("searchResults", searchResults);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("view/searchfriend.jsp").forward(request, response);
    }
}
