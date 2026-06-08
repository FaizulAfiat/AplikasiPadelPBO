package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import com.mycompany.aplikasi_padel_tubes_pbo.model.MusicRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/MusicController")
public class MusicController extends HttpServlet {

    private static final int REGULAR_LIMIT = 3;

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
        String userRole = (String) session.getAttribute("role");
        if (userRole == null) {
            userRole = "Regular";
        }

        List<MusicRequest> activeQueue = new ArrayList<>();
        List<MusicRequest> recentlyPlayed = new ArrayList<>();
        int activeCount = 0;

        try (Connection conn = Koneksi.getConnection()) {
            // 1. Get active requests (Pending, Playing)
            String activeSql = "SELECT mr.*, u.username, u.role FROM music_requests mr " +
                               "JOIN users u ON mr.user_id = u.user_id " +
                               "WHERE mr.status IN ('Pending', 'Playing') " +
                               "ORDER BY CASE mr.status WHEN 'Playing' THEN 1 WHEN 'Pending' THEN 2 END, mr.requested_at ASC";
            try (PreparedStatement ps = conn.prepareStatement(activeSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MusicRequest mr = new MusicRequest();
                    mr.setRequestId(rs.getInt("request_id"));
                    mr.setUserId(rs.getInt("user_id"));
                    mr.setSongTitle(rs.getString("song_title"));
                    mr.setArtist(rs.getString("artist"));
                    mr.setStatus(rs.getString("status"));
                    mr.setRequestedAt(rs.getTimestamp("requested_at"));
                    mr.setStartedAt(rs.getTimestamp("started_at"));
                    mr.setUsername(rs.getString("username"));
                    mr.setUserRole(rs.getString("role"));
                    activeQueue.add(mr);
                }
            }

            // 2. Get recently played requests (Played, Cancelled) - limit to 10
            String historySql = "SELECT mr.*, u.username, u.role FROM music_requests mr " +
                                "JOIN users u ON mr.user_id = u.user_id " +
                                "WHERE mr.status IN ('Played', 'Cancelled') " +
                                "ORDER BY COALESCE(mr.played_at, mr.requested_at) DESC LIMIT 10";
            try (PreparedStatement ps = conn.prepareStatement(historySql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MusicRequest mr = new MusicRequest();
                    mr.setRequestId(rs.getInt("request_id"));
                    mr.setUserId(rs.getInt("user_id"));
                    mr.setSongTitle(rs.getString("song_title"));
                    mr.setArtist(rs.getString("artist"));
                    mr.setStatus(rs.getString("status"));
                    mr.setRequestedAt(rs.getTimestamp("requested_at"));
                    mr.setPlayedAt(rs.getTimestamp("played_at"));
                    mr.setUsername(rs.getString("username"));
                    mr.setUserRole(rs.getString("role"));
                    recentlyPlayed.add(mr);
                }
            }

            // 3. Count active requests (Pending, Playing) for the logged-in user
            String countSql = "SELECT COUNT(*) FROM music_requests WHERE user_id = ? AND status IN ('Pending', 'Playing')";
            try (PreparedStatement ps = conn.prepareStatement(countSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        activeCount = rs.getInt(1);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("activeQueue", activeQueue);
        request.setAttribute("recentlyPlayed", recentlyPlayed);
        request.setAttribute("activeCount", activeCount);
        request.setAttribute("limit", REGULAR_LIMIT);
        request.setAttribute("role", userRole);

        request.getRequestDispatcher("view/music.jsp").forward(request, response);
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
        String userRole = (String) session.getAttribute("role");
        if (userRole == null) {
            userRole = "Regular";
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/MusicController");
            return;
        }

        try (Connection conn = Koneksi.getConnection()) {
            if ("add".equalsIgnoreCase(action)) {
                String songTitle = request.getParameter("song_title");
                String artist = request.getParameter("artist");

                if (songTitle == null || songTitle.trim().isEmpty() || artist == null || artist.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/MusicController?status=invalid_input");
                    return;
                }

                // If user is Regular, check request limit
                if ("Regular".equalsIgnoreCase(userRole)) {
                    String countSql = "SELECT COUNT(*) FROM music_requests WHERE user_id = ? AND status IN ('Pending', 'Playing')";
                    int activeCount = 0;
                    try (PreparedStatement ps = conn.prepareStatement(countSql)) {
                        ps.setInt(1, userId);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                activeCount = rs.getInt(1);
                            }
                        }
                    }

                    if (activeCount >= REGULAR_LIMIT) {
                        response.sendRedirect(request.getContextPath() + "/MusicController?status=limit_reached");
                        return;
                    }
                }

                // Insert new request
                String insertSql = "INSERT INTO music_requests (user_id, song_title, artist, status) VALUES (?, ?, ?, 'Pending')";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, userId);
                    ps.setString(2, songTitle.trim());
                    ps.setString(3, artist.trim());
                    ps.executeUpdate();
                }

                response.sendRedirect(request.getContextPath() + "/MusicController?status=success");

            } else if ("updateStatus".equalsIgnoreCase(action)) {
                // Admin only check
                if (!"Admin".equalsIgnoreCase(userRole)) {
                    response.sendRedirect(request.getContextPath() + "/MusicController?status=unauthorized");
                    return;
                }

                String requestIdParam = request.getParameter("request_id");
                String newStatus = request.getParameter("status");

                if (requestIdParam != null && newStatus != null) {
                    int requestId = Integer.parseInt(requestIdParam);
                    String updateSql;
                    if ("Playing".equalsIgnoreCase(newStatus)) {
                        // Catat waktu mulai diputar (digunakan oleh scheduler auto-complete)
                        updateSql = "UPDATE music_requests SET status = ?, started_at = NOW() WHERE request_id = ?";
                    } else if ("Played".equalsIgnoreCase(newStatus)) {
                        // Catat waktu selesai diputar
                        updateSql = "UPDATE music_requests SET status = ?, played_at = NOW() WHERE request_id = ?";
                    } else {
                        updateSql = "UPDATE music_requests SET status = ? WHERE request_id = ?";
                    }
                    try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                        ps.setString(1, newStatus);
                        ps.setInt(2, requestId);
                        ps.executeUpdate();
                    }
                }
                response.sendRedirect(request.getContextPath() + "/MusicController?status=updated");

            } else if ("delete".equalsIgnoreCase(action)) {
                String requestIdParam = request.getParameter("request_id");
                if (requestIdParam != null) {
                    int requestId = Integer.parseInt(requestIdParam);

                    // Check if owner or admin
                    boolean isAuthorized = false;
                    if ("Admin".equalsIgnoreCase(userRole)) {
                        isAuthorized = true;
                    } else {
                        String ownerSql = "SELECT user_id FROM music_requests WHERE request_id = ?";
                        try (PreparedStatement ps = conn.prepareStatement(ownerSql)) {
                            ps.setInt(1, requestId);
                            try (ResultSet rs = ps.executeQuery()) {
                                if (rs.next()) {
                                    int ownerId = rs.getInt("user_id");
                                    if (ownerId == userId) {
                                        isAuthorized = true;
                                    }
                                }
                            }
                        }
                    }

                    if (isAuthorized) {
                        // Mark as Cancelled rather than delete entirely, so it goes to history log.
                        // Or we can delete it entirely. User request says "music yang sudah di request akan masuk kedalam queue".
                        // Let's set it to 'Cancelled' so users can see they cancelled it.
                        String cancelSql = "UPDATE music_requests SET status = 'Cancelled' WHERE request_id = ?";
                        try (PreparedStatement ps = conn.prepareStatement(cancelSql)) {
                            ps.setInt(1, requestId);
                            ps.executeUpdate();
                        }
                        response.sendRedirect(request.getContextPath() + "/MusicController?status=cancelled");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/MusicController?status=unauthorized");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/MusicController");
                }
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MusicController?status=error");
        }
    }
}
