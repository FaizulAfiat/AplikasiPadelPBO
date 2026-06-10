package com.mycompany.aplikasi_padel_tubes_pbo.controller.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
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

public class ChatApiController extends HttpServlet {

    // Use GsonBuilder to format timestamps in ISO-8601 or readable format
    private final Gson gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd HH:mm:ss")
            .create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("user_id");

        if (userIdObj == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized. Please login first.\"}");
            return;
        }

        int userId = (Integer) userIdObj;
        String idChatStr = request.getParameter("idChat");

        if (idChatStr == null || idChatStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing idChat parameter.\"}");
            return;
        }

        try {
            int idChat = Integer.parseInt(idChatStr);

            try (Connection conn = Koneksi.getConnection()) {
                // Verify if the current user is a participant of the chat
                if (!isChatParticipant(conn, idChat, userId)) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.getWriter().write("{\"error\": \"You are not a participant in this chat.\"}");
                    return;
                }

                // Mark other participant messages in this chat as read
                String markReadSql = "UPDATE pesan SET status = 'dibaca' WHERE id_chat = ? AND pengirim_id != ? AND status = 'terkirim'";
                try (PreparedStatement ps = conn.prepareStatement(markReadSql)) {
                    ps.setInt(1, idChat);
                    ps.setInt(2, userId);
                    ps.executeUpdate();
                }

                // Fetch chat messages
                List<Map<String, Object>> chatMessages = new ArrayList<>();
                String msgsSql = "SELECT p.id_pesan, p.pengirim_id, p.isi_pesan, p.waktu_kirim, p.status, " +
                                 "       u.username AS pengirim_username, pr.fullname AS pengirim_fullname " +
                                 "FROM pesan p " +
                                 "JOIN users u ON p.pengirim_id = u.user_id " +
                                 "LEFT JOIN profiles pr ON p.pengirim_id = pr.user_id " +
                                 "WHERE p.id_chat = ? " +
                                 "ORDER BY p.waktu_kirim ASC, p.id_pesan ASC";

                try (PreparedStatement ps = conn.prepareStatement(msgsSql)) {
                    ps.setInt(1, idChat);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, Object> msg = new HashMap<>();
                            msg.put("id_pesan", rs.getInt("id_pesan"));
                            msg.put("pengirim_id", rs.getInt("pengirim_id"));
                            msg.put("isi_pesan", rs.getString("isi_pesan"));
                            msg.put("waktu_kirim", rs.getTimestamp("waktu_kirim"));
                            msg.put("status", rs.getString("status"));
                            msg.put("pengirim_username", rs.getString("pengirim_username"));
                            msg.put("pengirim_fullname", rs.getString("pengirim_fullname"));
                            chatMessages.add(msg);
                        }
                    }
                }

                response.getWriter().write(gson.toJson(chatMessages));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid idChat parameter format.\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("user_id");

        if (userIdObj == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized. Please login first.\"}");
            return;
        }

        int userId = (Integer) userIdObj;
        String idChatStr = request.getParameter("idChat");
        String pesan = request.getParameter("pesan");

        if (idChatStr == null || idChatStr.trim().isEmpty() || pesan == null || pesan.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing idChat or pesan parameter.\"}");
            return;
        }

        try {
            int idChat = Integer.parseInt(idChatStr);

            try (Connection conn = Koneksi.getConnection()) {
                // Verify participation
                if (!isChatParticipant(conn, idChat, userId)) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.getWriter().write("{\"error\": \"You are not a participant in this chat.\"}");
                    return;
                }

                // Insert dynamic message
                String sql = "INSERT INTO pesan (id_chat, pengirim_id, isi_pesan, status) VALUES (?, ?, ?, 'terkirim')";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, idChat);
                    stmt.setInt(2, userId);
                    stmt.setString(3, pesan);
                    stmt.executeUpdate();
                }

                response.getWriter().write("{\"success\": true}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid idChat parameter format.\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        }
    }

    private boolean isChatParticipant(Connection conn, int idChat, int userId) throws SQLException {
        String verifySql = "SELECT 1 FROM chat_participants WHERE id_chat = ? AND user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(verifySql)) {
            ps.setInt(1, idChat);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
