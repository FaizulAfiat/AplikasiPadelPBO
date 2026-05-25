package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import com.mycompany.aplikasi_padel_tubes_pbo.model.MusicRequest;
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
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MusicRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String user = (String) session.getAttribute("user");
        Integer userId = (Integer) session.getAttribute("user_id");
        String role = (String) session.getAttribute("role");

        if (user == null || userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html");
            return;
        }

        String action = request.getParameter("action");

        // 1. Handling Premium Upgrade Request (Simulated)
        if ("upgrade".equalsIgnoreCase(action)) {
            try (Connection conn = Koneksi.getConnection()) {
                String sqlUpdate = "UPDATE users SET role = 'Premium' WHERE user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }
                // Update session
                session.setAttribute("role", "Premium");
                response.sendRedirect(request.getContextPath() + "/MusicRequest?status=upgraded");
                return;
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/MusicRequest?status=error");
                return;
            }
        }

        // 2. Handling Admin Actions (Approve/Reject/Delete)
        if (action != null && ("played".equalsIgnoreCase(action) || "reject".equalsIgnoreCase(action) || "delete".equalsIgnoreCase(action))) {
            if (role == null || !role.equalsIgnoreCase("Admin")) {
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=unauthorized");
                return;
            }
            
            String idParam = request.getParameter("id");
            if (idParam != null) {
                int reqId = Integer.parseInt(idParam);
                try (Connection conn = Koneksi.getConnection()) {
                    if ("played".equalsIgnoreCase(action)) {
                        String sql = "UPDATE music_requests SET status = 'Played' WHERE request_id = ?";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, reqId);
                            ps.executeUpdate();
                        }
                    } else if ("reject".equalsIgnoreCase(action)) {
                        String sql = "UPDATE music_requests SET status = 'Rejected' WHERE request_id = ?";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, reqId);
                            ps.executeUpdate();
                        }
                    } else if ("delete".equalsIgnoreCase(action)) {
                        String sql = "DELETE FROM music_requests WHERE request_id = ?";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, reqId);
                            ps.executeUpdate();
                        }
                    }
                    
                    // Redirect back to admin dashboard if they came from there
                    String referer = request.getHeader("referer");
                    if (referer != null && referer.contains("AdminController")) {
                        response.sendRedirect(request.getContextPath() + "/AdminController?status=music_updated");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/MusicRequest?status=music_updated");
                    }
                    return;
                } catch (SQLException e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/MusicRequest?status=error");
                    return;
                }
            }
        }

        // 3. Normal View Loading
        List<Map<String, Object>> courts = new ArrayList<>();
        List<MusicRequest> musicRequests = new ArrayList<>();

        try (Connection conn = Koneksi.getConnection()) {
            // Get courts
            String sqlCourts = "SELECT court_id, name FROM courts ORDER BY name ASC";
            try (PreparedStatement ps = conn.prepareStatement(sqlCourts);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> court = new HashMap<>();
                    court.put("id", rs.getInt("court_id"));
                    court.put("name", rs.getString("name"));
                    courts.add(court);
                }
            }

            // Get recent music requests
            String sqlRequests = "SELECT r.*, u.username, c.name AS court_name "
                    + "FROM music_requests r "
                    + "JOIN users u ON r.user_id = u.user_id "
                    + "LEFT JOIN courts c ON r.court_id = c.court_id "
                    + "ORDER BY r.requested_at DESC LIMIT 50";
            try (PreparedStatement ps = conn.prepareStatement(sqlRequests);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MusicRequest req = new MusicRequest();
                    req.setRequestId(rs.getInt("request_id"));
                    req.setUserId(rs.getInt("user_id"));
                    req.setUsername(rs.getString("username"));
                    
                    int cId = rs.getInt("court_id");
                    if (rs.wasNull()) {
                        req.setCourtId(null);
                    } else {
                        req.setCourtId(cId);
                    }
                    
                    req.setCourtName(rs.getString("court_name"));
                    req.setTrackName(rs.getString("track_name"));
                    req.setArtist(rs.getString("artist"));
                    req.setPlatform(rs.getString("platform"));
                    req.setTrackUrl(rs.getString("track_url"));
                    req.setStatus(rs.getString("status"));
                    req.setRequestedAt(rs.getTimestamp("requested_at"));
                    
                    musicRequests.add(req);
                }
            }

            request.setAttribute("courts", courts);
            request.setAttribute("musicRequests", musicRequests);
            request.getRequestDispatcher("view/music_request.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp?status=error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String user = (String) session.getAttribute("user");
        Integer userId = (Integer) session.getAttribute("user_id");
        String role = (String) session.getAttribute("role");

        if (user == null || userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html");
            return;
        }

        // Restrict track request submission to premium users (and admins)
        if (role == null || (!role.equalsIgnoreCase("Premium") && !role.equalsIgnoreCase("Admin"))) {
            response.sendRedirect(request.getContextPath() + "/MusicRequest?status=unauthorized");
            return;
        }

        String courtIdStr = request.getParameter("courtId");
        String trackName = request.getParameter("trackName");
        String artist = request.getParameter("artist");
        String platform = request.getParameter("platform");
        String trackUrl = request.getParameter("trackUrl");

        if (trackName == null || trackName.trim().isEmpty() || artist == null || artist.trim().isEmpty() || platform == null) {
            response.sendRedirect(request.getContextPath() + "/MusicRequest?status=validation_error");
            return;
        }

        try (Connection conn = Koneksi.getConnection()) {
            String sqlInsert = "INSERT INTO music_requests (user_id, court_id, track_name, artist, platform, track_url, status) "
                    + "VALUES (?, ?, ?, ?, ?, ?, 'Pending')";
            try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                ps.setInt(1, userId);
                if (courtIdStr == null || courtIdStr.trim().isEmpty()) {
                    ps.setNull(2, Types.INTEGER);
                } else {
                    ps.setInt(2, Integer.parseInt(courtIdStr));
                }
                ps.setString(3, trackName.trim());
                ps.setString(4, artist.trim());
                ps.setString(5, platform);
                
                if (trackUrl == null || trackUrl.trim().isEmpty()) {
                    ps.setNull(6, Types.VARCHAR);
                } else {
                    ps.setString(6, trackUrl.trim());
                }
                
                ps.executeUpdate();
            }
            response.sendRedirect(request.getContextPath() + "/MusicRequest?status=success");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MusicRequest?status=error");
        }
    }
}
