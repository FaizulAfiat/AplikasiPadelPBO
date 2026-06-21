/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.controller.community;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet(name = "JoinController", urlPatterns = {"/JoinController"})
public class JoinController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Cek apakah user sudah login (ambil dari Session)
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user_id");

        if (userObj == null) {
            response.sendRedirect("view/Login.html");
            return;
        }

        // 2. Tangkap ID Club yang dikirim dari tombol (parameter URL)
        String clubIdStr = request.getParameter("club_id");
        
        if (clubIdStr == null || clubIdStr.trim().isEmpty()) {
            response.sendRedirect("CommunityController?status=error");
            return;
        }

        // Ubah bentuk ID menjadi integer (angka)
        int userId = Integer.parseInt(userObj.toString());
        int clubId = Integer.parseInt(clubIdStr);

        try (Connection conn = Koneksi.getConnection()) {
            // 3. CEK DULU TIPE KLUB
            String clubSql = "SELECT type FROM club WHERE club_id = ?";
            PreparedStatement psClub = conn.prepareStatement(clubSql);
            psClub.setInt(1, clubId);
            ResultSet rsClub = psClub.executeQuery();
            
            if (!rsClub.next()) {
                response.sendRedirect("CommunityController?status=error");
                return;
            }
            
            String clubType = rsClub.getString("type");

            // 4. CEK APAKAH SUDAH JOIN ATAU PENDING
            String checkSql = "SELECT * FROM club_member WHERE club_id = ? AND user_id = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, clubId);
            checkPs.setInt(2, userId);
            ResultSet rs = checkPs.executeQuery();

            String checkReqSql = "SELECT * FROM club_request WHERE club_id = ? AND user_id = ?";
            PreparedStatement checkReqPs = conn.prepareStatement(checkReqSql);
            checkReqPs.setInt(1, clubId);
            checkReqPs.setInt(2, userId);
            ResultSet rsReq = checkReqPs.executeQuery();

            if (rs.next()) {
                response.sendRedirect("CommunityController?status=already_joined");
            } else if (rsReq.next()) {
                response.sendRedirect("CommunityController?status=already_requested");
            } else {
                if ("PRIVATE".equalsIgnoreCase(clubType)) {
                    String insertSql = "INSERT INTO club_request (club_id, user_id) VALUES (?, ?)";
                    PreparedStatement insertPs = conn.prepareStatement(insertSql);
                    insertPs.setInt(1, clubId);
                    insertPs.setInt(2, userId);
                    insertPs.executeUpdate();
                    response.sendRedirect("CommunityController?status=request_sent");
                } else {
                    String insertSql = "INSERT INTO club_member (club_id, user_id) VALUES (?, ?)";
                    PreparedStatement insertPs = conn.prepareStatement(insertSql);
                    insertPs.setInt(1, clubId);
                    insertPs.setInt(2, userId);
                    insertPs.executeUpdate();
                    response.sendRedirect("CommunityController?status=joined_success");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("CommunityController?status=error_db");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kita pakai doGet karena pengirimannya lewat link <a>
    }
}


