package com.mycompany.aplikasi_padel_tubes_pbo.controller.chat;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ChatController extends HttpServlet {

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

        // 1. Handle friendUserId redirection: check/create one-on-one chat room
        String friendUserIdStr = request.getParameter("friendUserId");
        if (friendUserIdStr != null && !friendUserIdStr.trim().isEmpty()) {
            try {
                int friendUserId = Integer.parseInt(friendUserIdStr);
                if (friendUserId != userId) {
                    int idChat = -1;
                    try (Connection conn = Koneksi.getConnection()) {
                        // Look for an existing 1-on-1 chat
                        String findChatSql = "SELECT c.id_chat FROM chats c " +
                                             "JOIN chat_participants cp1 ON c.id_chat = cp1.id_chat " +
                                             "JOIN chat_participants cp2 ON c.id_chat = cp2.id_chat " +
                                             "WHERE c.is_group = 0 AND cp1.user_id = ? AND cp2.user_id = ?";
                        try (PreparedStatement ps = conn.prepareStatement(findChatSql)) {
                            ps.setInt(1, userId);
                            ps.setInt(2, friendUserId);
                            try (ResultSet rs = ps.executeQuery()) {
                                if (rs.next()) {
                                    idChat = rs.getInt("id_chat");
                                }
                            }
                        }

                        // Create if it does not exist
                        if (idChat == -1) {
                            conn.setAutoCommit(false);
                            try {
                                String insertChatSql = "INSERT INTO chats (is_group, nama_grup) VALUES (0, NULL)";
                                try (PreparedStatement ps = conn.prepareStatement(insertChatSql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                                    ps.executeUpdate();
                                    try (ResultSet rs = ps.getGeneratedKeys()) {
                                        if (rs.next()) {
                                            idChat = rs.getInt(1);
                                        }
                                    }
                                }

                                if (idChat != -1) {
                                    String insertParticipantSql = "INSERT INTO chat_participants (id_chat, user_id) VALUES (?, ?)";
                                    try (PreparedStatement ps = conn.prepareStatement(insertParticipantSql)) {
                                        ps.setInt(1, idChat);
                                        ps.setInt(2, userId);
                                        ps.executeUpdate();

                                        ps.setInt(1, idChat);
                                        ps.setInt(2, friendUserId);
                                        ps.executeUpdate();
                                    }
                                }
                                conn.commit();
                            } catch (SQLException ex) {
                                conn.rollback();
                                throw ex;
                            } finally {
                                conn.setAutoCommit(true);
                            }
                        }
                    }

                    if (idChat != -1) {
                        response.sendRedirect(request.getContextPath() + "/chat?idChat=" + idChat);
                        return;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 2. Fetch all chat rooms for the sidebar
        List<Map<String, Object>> chatRooms = new ArrayList<>();
        try (Connection conn = Koneksi.getConnection()) {
            String roomsSql = "SELECT c.id_chat, c.is_group, c.nama_grup, " +
                              "       other_u.user_id AS other_user_id, other_u.username AS other_username, " +
                              "       other_p.fullname AS other_fullname, other_p.gender AS other_gender, " +
                              "       lm.isi_pesan AS last_message, lm.waktu_kirim AS last_message_time, " +
                              "       lm.pengirim_id AS last_message_sender_id, " +
                              "       (SELECT COUNT(*) FROM pesan p_unread " +
                              "        WHERE p_unread.id_chat = c.id_chat AND p_unread.pengirim_id != ? AND p_unread.status = 'terkirim') AS unread_count " +
                              "FROM chats c " +
                              "JOIN chat_participants cp_me ON c.id_chat = cp_me.id_chat AND cp_me.user_id = ? " +
                              "LEFT JOIN chat_participants cp_other ON c.id_chat = cp_other.id_chat AND cp_other.user_id != ? " +
                              "LEFT JOIN users other_u ON cp_other.user_id = other_u.user_id " +
                              "LEFT JOIN profiles other_p ON cp_other.user_id = other_p.user_id " +
                              "LEFT JOIN (" +
                              "    SELECT p1.id_chat, p1.isi_pesan, p1.waktu_kirim, p1.pengirim_id " +
                              "    FROM pesan p1 " +
                              "    WHERE p1.id_pesan = (" +
                              "        SELECT MAX(p2.id_pesan) FROM pesan p2 WHERE p2.id_chat = p1.id_chat" +
                              "    )" +
                              ") lm ON c.id_chat = lm.id_chat " +
                              "ORDER BY COALESCE(lm.waktu_kirim, c.created_at) DESC";

            try (PreparedStatement ps = conn.prepareStatement(roomsSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, userId);
                ps.setInt(3, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> room = new HashMap<>();
                        room.put("id_chat", rs.getInt("id_chat"));
                        room.put("is_group", rs.getInt("is_group"));
                        room.put("nama_grup", rs.getString("nama_grup"));
                        room.put("other_user_id", rs.getInt("other_user_id"));
                        room.put("other_username", rs.getString("other_username"));
                        room.put("other_fullname", rs.getString("other_fullname"));
                        room.put("other_gender", rs.getString("other_gender"));
                        room.put("last_message", rs.getString("last_message"));
                        room.put("last_message_time", rs.getTimestamp("last_message_time"));
                        room.put("last_message_sender_id", rs.getInt("last_message_sender_id"));
                        room.put("unread_count", rs.getInt("unread_count"));
                        chatRooms.add(room);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        request.setAttribute("chatRooms", chatRooms);

        // 3. Fetch messages for active chat room
        String idChatStr = request.getParameter("idChat");
        Integer selectedIdChat = null;
        if (idChatStr != null && !idChatStr.trim().isEmpty()) {
            try {
                int idChat = Integer.parseInt(idChatStr);
                boolean isParticipant = false;

                try (Connection conn = Koneksi.getConnection()) {
                    String verifySql = "SELECT 1 FROM chat_participants WHERE id_chat = ? AND user_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(verifySql)) {
                        ps.setInt(1, idChat);
                        ps.setInt(2, userId);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                isParticipant = true;
                            }
                        }
                    }

                    if (isParticipant) {
                        selectedIdChat = idChat;

                        // Mark messages from other user in this chat as read
                        String markReadSql = "UPDATE pesan SET status = 'dibaca' WHERE id_chat = ? AND pengirim_id != ? AND status = 'terkirim'";
                        try (PreparedStatement ps = conn.prepareStatement(markReadSql)) {
                            ps.setInt(1, idChat);
                            ps.setInt(2, userId);
                            ps.executeUpdate();
                        }

                        // Fetch active partner details
                        Map<String, Object> partner = new HashMap<>();
                        String partnerSql = "SELECT u.user_id, u.username, p.fullname, p.gender " +
                                            "FROM chat_participants cp " +
                                            "JOIN users u ON cp.user_id = u.user_id " +
                                            "LEFT JOIN profiles p ON u.user_id = p.user_id " +
                                            "WHERE cp.id_chat = ? AND cp.user_id != ?";
                        try (PreparedStatement ps = conn.prepareStatement(partnerSql)) {
                            ps.setInt(1, idChat);
                            ps.setInt(2, userId);
                            try (ResultSet rs = ps.executeQuery()) {
                                if (rs.next()) {
                                    partner.put("user_id", rs.getInt("user_id"));
                                    partner.put("username", rs.getString("username"));
                                    partner.put("fullname", rs.getString("fullname"));
                                    partner.put("gender", rs.getString("gender"));
                                }
                            }
                        }
                        request.setAttribute("activeChatPartner", partner);

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
                        request.setAttribute("chatMessages", chatMessages);
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            } catch (NumberFormatException e) {
                // Ignore
            }
        }

        request.setAttribute("selectedIdChat", selectedIdChat);
        request.getRequestDispatcher("/view/chat.jsp").forward(request, response);
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
        String idChatStr = request.getParameter("idChat");
        String pesan = request.getParameter("pesan");

        if (idChatStr != null && !idChatStr.trim().isEmpty() && pesan != null && !pesan.trim().isEmpty()) {
            try {
                int idChat = Integer.parseInt(idChatStr);

                try (Connection conn = Koneksi.getConnection()) {
                    // Verify membership
                    boolean isParticipant = false;
                    String verifySql = "SELECT 1 FROM chat_participants WHERE id_chat = ? AND user_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(verifySql)) {
                        ps.setInt(1, idChat);
                        ps.setInt(2, userId);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                isParticipant = true;
                            }
                        }
                    }

                    if (isParticipant) {
                        String sql = "INSERT INTO pesan (id_chat, pengirim_id, isi_pesan, status) VALUES (?, ?, ?, 'terkirim')";
                        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                            stmt.setInt(1, idChat);
                            stmt.setInt(2, userId);
                            stmt.setString(3, pesan);
                            stmt.executeUpdate();
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }

                response.sendRedirect(request.getContextPath() + "/chat?idChat=" + idChat);
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/chat");
    }
}