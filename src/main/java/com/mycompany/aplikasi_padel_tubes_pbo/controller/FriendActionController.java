package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class FriendActionController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer currentUserId = (Integer) session.getAttribute("user_id");

        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html");
            return;
        }

        String action = request.getParameter("action");
        String redirectTarget = request.getParameter("redirect");
        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }

        try (Connection conn = Koneksi.getConnection()) {
            if ("add".equalsIgnoreCase(action)) {
                String friendIdStr = request.getParameter("friendId");
                if (friendIdStr != null) {
                    int friendId = Integer.parseInt(friendIdStr);
                    String sql = "INSERT INTO friendships (user_id, friend_id, status) VALUES (?, ?, 'PENDING')";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, currentUserId);
                        ps.setInt(2, friendId);
                        ps.executeUpdate();
                    }
                }
            } else if ("accept".equalsIgnoreCase(action)) {
                String friendshipIdStr = request.getParameter("friendshipId");
                if (friendshipIdStr != null) {
                    int friendshipId = Integer.parseInt(friendshipIdStr);
                    String sql = "UPDATE friendships SET status = 'ACCEPTED' WHERE friendship_id = ? AND friend_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, friendshipId);
                        ps.setInt(2, currentUserId);
                        ps.executeUpdate();
                    }
                }
            } else if ("reject".equalsIgnoreCase(action)) {
                String friendshipIdStr = request.getParameter("friendshipId");
                if (friendshipIdStr != null) {
                    int friendshipId = Integer.parseInt(friendshipIdStr);
                    String sql = "DELETE FROM friendships WHERE friendship_id = ? AND friend_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, friendshipId);
                        ps.setInt(2, currentUserId);
                        ps.executeUpdate();
                    }
                }
            } else if ("remove".equalsIgnoreCase(action)) {
                String friendshipIdStr = request.getParameter("friendshipId");
                if (friendshipIdStr != null) {
                    int friendshipId = Integer.parseInt(friendshipIdStr);
                    String sql = "DELETE FROM friendships WHERE friendship_id = ? AND (user_id = ? OR friend_id = ?)";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, friendshipId);
                        ps.setInt(2, currentUserId);
                        ps.setInt(3, currentUserId);
                        ps.executeUpdate();
                    }
                }
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        }

        // Determine where to redirect
        if ("profile".equalsIgnoreCase(redirectTarget)) {
            response.sendRedirect(request.getContextPath() + "/Profile");
        } else {
            response.sendRedirect(request.getContextPath() + "/SearchFriendController?keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8"));
        }
    }
}
