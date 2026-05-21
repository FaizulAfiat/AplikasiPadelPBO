/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class SaveScoreController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("booking_id"));
        String scoringStyle = request.getParameter("scoring_style");
        int skorTim1 = Integer.parseInt(request.getParameter("skor_tim1"));
        int skorTim2 = Integer.parseInt(request.getParameter("skor_tim2"));

        String p1_val = request.getParameter("p1_tim1");
        String p2_val = request.getParameter("p2_tim1");
        String p3_val = request.getParameter("p1_tim2");
        String p4_val = request.getParameter("p2_tim2");

// 2. Ambil status guest langsung sebagai String dari request parameter
        String isGuestP1 = request.getParameter("is_guest_p1");
        String isGuestP2 = request.getParameter("is_guest_p2");
        String isGuestP3 = request.getParameter("is_guest_p3");
        String isGuestP4 = request.getParameter("is_guest_p4");

// ─── TRANSAKSI DATABASE ───
        Connection conn = null;
        try {
            conn = Koneksi.getConnection();
            conn.setAutoCommit(false);

            // [BAGIAN INSERT MATCHES TETAP SAMA SEPERTI SEBELUMNYA]
            String sqlMatch = "INSERT INTO matches (booking_id, scoring_style, skor_tim1, skor_tim2, status_selesai) VALUES (?, ?, ?, ?, TRUE)";
            PreparedStatement psMatch = conn.prepareStatement(sqlMatch, PreparedStatement.RETURN_GENERATED_KEYS);
            psMatch.setInt(1, bookingId);
            psMatch.setString(2, scoringStyle);
            psMatch.setInt(3, skorTim1);
            psMatch.setInt(4, skorTim2);
            psMatch.executeUpdate();

            int generatedMatchId = 0;
            try (ResultSet rsKeys = psMatch.getGeneratedKeys()) {
                if (rsKeys.next()) {
                    generatedMatchId = rsKeys.getInt(1);
                }
            }

            // ─── PERBAIKAN TOTAL DI SINI (LOGIKA BATCH INSERT) ───
            String sqlPlayerScore = "INSERT INTO player_scores (match_id, user_id, tim, poin_didapat) VALUES (?, ?, ?, ?)";
            PreparedStatement psPlayer = conn.prepareStatement(sqlPlayerScore);

            // Kita bikin matriks String biasa agar tidak pusing dengan casting Boolean object
            String[][] playersData = {
                {p1_val, isGuestP1, "1", String.valueOf(skorTim1)}, // Player A
                {p2_val, isGuestP2, "1", String.valueOf(skorTim1)}, // Player B
                {p3_val, isGuestP3, "2", String.valueOf(skorTim2)}, // Player C
                {p4_val, isGuestP4, "2", String.valueOf(skorTim2)} // Player D
            };

            for (String[] pData : playersData) {
                String rawValue = pData[0];
                String guestStatusStr = pData[1];
                int teamNum = Integer.parseInt(pData[2]);
                int pointWon = Integer.parseInt(pData[3]);

                psPlayer.setInt(1, generatedMatchId);

                // Cek dengan equalsIgnoreCase("true") untuk memastikan string dari HTML dibaca benar oleh Java
                if (guestStatusStr != null && guestStatusStr.equalsIgnoreCase("true")) {
                    // Jaminan mutu: Kalau statusnya guest, langsung set NULL ke database, JANGAN PARSING ANGKA!
                    psPlayer.setNull(2, java.sql.Types.INTEGER);
                } else {
                    // Kalau bukan guest, pastikan datanya emang gak kosong baru di-parse ke Integer ID
                    if (rawValue != null && !rawValue.trim().isEmpty()) {
                        psPlayer.setInt(2, Integer.parseInt(rawValue.trim()));
                    } else {
                        psPlayer.setNull(2, java.sql.Types.INTEGER);
                    }
                }

                psPlayer.setInt(3, teamNum);
                psPlayer.setInt(4, pointWon);
                psPlayer.addBatch();
            }

            // Eksekusi massal
            psPlayer.executeBatch();
            conn.commit();

            response.sendRedirect("MatchSetupController?success=match_saved");

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            response.sendRedirect("MatchSetupController?error=save_failed");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
