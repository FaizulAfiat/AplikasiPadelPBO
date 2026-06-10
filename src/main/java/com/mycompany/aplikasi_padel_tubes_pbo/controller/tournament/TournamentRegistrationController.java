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

/**
 * Controller for registering users to padel tournaments.
 * Demonstrates MVC pattern and Transaction handling in DB.
 * 
 * @author Faizul Afiat
 */
@WebServlet(name = "TournamentRegistrationController", urlPatterns = {"/TournamentRegistrationController"})
public class TournamentRegistrationController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("user_id");
        String role = (String) session.getAttribute("role");

        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html");
            return;
        }

        int userId = (Integer) userIdObj;
        String newsIdParam = request.getParameter("news_id");

        if (newsIdParam == null || newsIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=invalid_tournament");
            return;
        }

        try {
            int newsId = Integer.parseInt(newsIdParam);

            try (Connection conn = Koneksi.getConnection()) {
                // 1. Fetch tournament details and build our OOP object
                TournamentNews tn = null;
                String fetchSql = "SELECT * FROM tournament_news WHERE news_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(fetchSql)) {
                    ps.setInt(1, newsId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            tn = new TournamentNews();
                            tn.setId(rs.getInt("news_id"));
                            tn.setTitle(rs.getString("title"));
                            tn.setContent(rs.getString("content"));
                            tn.setTournamentDate(rs.getDate("tournament_date"));
                            tn.setMaxParticipants(rs.getInt("max_participants"));
                            tn.setCurrentParticipants(rs.getInt("current_participants"));
                        }
                    }
                }

                if (tn == null) {
                    response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=not_found");
                    return;
                }

                // 2. Check if user is already registered (database level constraint check)
                String checkSql = "SELECT COUNT(*) FROM tournament_registrations WHERE news_id = ? AND user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                    ps.setInt(1, newsId);
                    ps.setInt(2, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=already_registered");
                            return;
                        }
                    }
                }

                // 3. Evaluate OOP Business Rules
                if (!tn.canRegister(role)) {
                    if (!"Premium".equalsIgnoreCase(role) && !"Admin".equalsIgnoreCase(role)) {
                        response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=premium_only");
                    } else if (tn.isFull()) {
                        response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=tournament_full");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=registration_closed");
                    }
                    return;
                }

                // 4. Perform database transaction (registration & quota update)
                conn.setAutoCommit(false);
                try {
                    // a. Insert registration record
                    String insertSql = "INSERT INTO tournament_registrations (news_id, user_id) VALUES (?, ?)";
                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                        insertPs.setInt(1, newsId);
                        insertPs.setInt(2, userId);
                        insertPs.executeUpdate();
                    }

                    // b. Increment participant count
                    String updateSql = "UPDATE tournament_news SET current_participants = current_participants + 1 WHERE news_id = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setInt(1, newsId);
                        updatePs.executeUpdate();
                    }

                    conn.commit();
                    response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=registration_success");
                } catch (SQLException ex) {
                    conn.rollback();
                    ex.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=registration_error");
                } finally {
                    conn.setAutoCommit(true);
                }

            }
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=error");
        }
    }
}
