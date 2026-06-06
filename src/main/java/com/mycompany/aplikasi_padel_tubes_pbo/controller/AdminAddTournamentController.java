package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Controller for Admin to add a new tournament.
 * Access control is enforced to verify Admin authorization.
 * 
 * @author Faizul Afiat
 */
@WebServlet(name = "AdminAddTournamentController", urlPatterns = {"/AdminAddTournamentController"})
public class AdminAddTournamentController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        // Authorization check
        if (role == null || !role.equalsIgnoreCase("Admin")) {
            response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=unauthorized");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String courtIdParam = request.getParameter("court_id");
        String dateParam = request.getParameter("tournament_date");
        String maxParam = request.getParameter("max_participants");
        String imageUrl = request.getParameter("image_url");

        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            imageUrl = "img/padel.jpg"; // Default banner
        }

        if (title == null || title.trim().isEmpty() ||
            content == null || content.trim().isEmpty() ||
            courtIdParam == null || courtIdParam.trim().isEmpty() ||
            dateParam == null || dateParam.trim().isEmpty() ||
            maxParam == null || maxParam.trim().isEmpty()) {
            
            response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=missing_fields");
            return;
        }

        try {
            int courtId = Integer.parseInt(courtIdParam);
            Date tournamentDate = Date.valueOf(dateParam); // parses YYYY-MM-DD
            int maxParticipants = Integer.parseInt(maxParam);

            try (Connection conn = Koneksi.getConnection()) {
                String insertSql = "INSERT INTO tournament_news (title, content, court_id, image_url, tournament_date, max_participants, current_participants) VALUES (?, ?, ?, ?, ?, ?, 0)";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setString(1, title);
                    ps.setString(2, content);
                    ps.setInt(3, courtId);
                    ps.setString(4, imageUrl);
                    ps.setDate(5, tournamentDate);
                    ps.setInt(6, maxParticipants);
                    
                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=create_success");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=create_failed");
                    }
                }
            }
        } catch (IllegalArgumentException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=error");
        }
    }
}
