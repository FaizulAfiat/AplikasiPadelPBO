package com.mycompany.aplikasi_padel_tubes_pbo.controller.tournament;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import com.mycompany.aplikasi_padel_tubes_pbo.model.TournamentNews;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Controller for retrieving and viewing Tournament News.
 * 
 * @author Faizul Afiat
 */
@WebServlet(name = "TournamentNewsController", urlPatterns = {"/TournamentNewsController"})
public class TournamentNewsController extends HttpServlet {

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
        
        List<TournamentNews> tournamentList = new ArrayList<>();
        List<Map<String, Object>> courtList = new ArrayList<>();
        Set<Integer> registeredNewsIds = new HashSet<>();
        String userRole = "Regular";

        try (Connection conn = Koneksi.getConnection()) {
            // 1. Fetch latest user role to ensure accuracy
            String roleSql = "SELECT role FROM users WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(roleSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        userRole = rs.getString("role");
                        // Sync back to session role
                        session.setAttribute("role", userRole);
                    }
                }
            }

            // 2. Fetch all tournaments
            String newsSql = "SELECT tn.*, c.name AS court_name " +
                             "FROM tournament_news tn " +
                             "LEFT JOIN courts c ON tn.court_id = c.court_id " +
                             "ORDER BY tn.tournament_date DESC, tn.news_id DESC";
            try (PreparedStatement ps = conn.prepareStatement(newsSql)) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        TournamentNews tn = new TournamentNews();
                        tn.setId(rs.getInt("news_id"));
                        tn.setTitle(rs.getString("title"));
                        tn.setContent(rs.getString("content"));
                        tn.setImageUrl(rs.getString("image_url"));
                        tn.setCreatedAt(rs.getTimestamp("created_at"));
                        tn.setCourtId(rs.getInt("court_id"));
                        tn.setCourtName(rs.getString("court_name"));
                        tn.setTournamentDate(rs.getDate("tournament_date"));
                        tn.setMaxParticipants(rs.getInt("max_participants"));
                        tn.setCurrentParticipants(rs.getInt("current_participants"));
                        
                        tournamentList.add(tn);
                    }
                }
            }

            // 3. Fetch user registrations
            String regSql = "SELECT news_id FROM tournament_registrations WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(regSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        registeredNewsIds.add(rs.getInt("news_id"));
                    }
                }
            }

            // 4. Fetch all courts (for admin form)
            String courtsSql = "SELECT court_id, name FROM courts WHERE status = 'Available'";
            try (PreparedStatement ps = conn.prepareStatement(courtsSql)) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> court = new HashMap<>();
                        court.put("id", rs.getInt("court_id"));
                        court.put("name", rs.getString("name"));
                        courtList.add(court);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("tournaments", tournamentList);
        request.setAttribute("courts", courtList);
        request.setAttribute("registeredNewsIds", registeredNewsIds);
        request.setAttribute("role", userRole);

        request.getRequestDispatcher("view/tournament_news.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
