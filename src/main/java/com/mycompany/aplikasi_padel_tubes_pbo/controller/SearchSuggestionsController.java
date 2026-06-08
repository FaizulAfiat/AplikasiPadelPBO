package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SearchSuggestionsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer currentUserId = (Integer) session.getAttribute("user_id");

        if (currentUserId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        keyword = keyword.trim();

        List<String> suggestions = new ArrayList<>();

        if (!keyword.isEmpty()) {
            String sql = "SELECT username FROM users WHERE username LIKE ? AND user_id != ? AND role != 'Admin' LIMIT 5";
            try (Connection conn = Koneksi.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, "%" + keyword + "%");
                ps.setInt(2, currentUserId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        suggestions.add(rs.getString("username"));
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Format JSON manually: ["user1", "user2"]
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < suggestions.size(); i++) {
            String escaped = suggestions.get(i).replace("\"", "\\\"");
            json.append("\"").append(escaped).append("\"");
            if (i < suggestions.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());
    }
}
