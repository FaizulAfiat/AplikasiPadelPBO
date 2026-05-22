package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MatchRecapController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String matchIdParam = request.getParameter("match_id");
        if (matchIdParam == null || matchIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/MatchSetupController");
            return;
        }

        int matchId = Integer.parseInt(matchIdParam.trim());
        String scoringStyle = "AMERICANO";
        int skorTim1 = 0;
        int skorTim2 = 0;
        List<String> team1Players = new ArrayList<>();
        List<String> team2Players = new ArrayList<>();

        try (Connection conn = Koneksi.getConnection()) {
            // 1. Fetch match info
            String matchSql = "SELECT scoring_style, skor_tim1, skor_tim2 FROM matches WHERE match_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(matchSql)) {
                ps.setInt(1, matchId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        scoringStyle = rs.getString("scoring_style");
                        skorTim1 = rs.getInt("skor_tim1");
                        skorTim2 = rs.getInt("skor_tim2");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/MatchSetupController");
                        return;
                    }
                }
            }

            String playersSql = "SELECT ps.tim, u.username, pr.fullname " +
                                "FROM player_scores ps " +
                                "LEFT JOIN users u ON ps.user_id = u.user_id " +
                                "LEFT JOIN profiles pr ON ps.user_id = pr.user_id " +
                                "WHERE ps.match_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(playersSql)) {
                ps.setInt(1, matchId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int tim = rs.getInt("tim");
                        String fullname = rs.getString("fullname");
                        String username = rs.getString("username");
                        String name = (fullname != null && !fullname.trim().isEmpty()) ? fullname : username;
                        if (name == null || name.trim().isEmpty()) {
                            name = "Guest";
                        }

                        if (tim == 1) {
                            team1Players.add(name);
                        } else {
                            team2Players.add(name);
                        }
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        String t1PlayersStr = team1Players.isEmpty() ? "Guest & Guest" : String.join(" & ", team1Players);
        String t2PlayersStr = team2Players.isEmpty() ? "Guest & Guest" : String.join(" & ", team2Players);

        String winnerAnnouncement = "DRAW MATCH!";
        if (skorTim1 > skorTim2) {
            winnerAnnouncement = "TEAM 1 WINS!";
        } else if (skorTim2 > skorTim1) {
            winnerAnnouncement = "TEAM 2 WINS!";
        }

        request.setAttribute("matchId", matchId);
        request.setAttribute("scoringStyle", scoringStyle);
        request.setAttribute("skorTim1", skorTim1);
        request.setAttribute("skorTim2", skorTim2);
        request.setAttribute("team1Players", t1PlayersStr);
        request.setAttribute("team2Players", t2PlayersStr);
        request.setAttribute("winner", winnerAnnouncement);

        request.getRequestDispatcher("view/scoring/recap.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
