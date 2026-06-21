package com.mycompany.aplikasi_padel_tubes_pbo.controller.community;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ApproveRequestController", urlPatterns = {"/ApproveRequestController"})
public class ApproveRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user_id") == null) {
            response.sendRedirect("view/Login.html");
            return;
        }

        String clubIdStr = request.getParameter("club_id");
        String userIdStr = request.getParameter("user_id");
        String reqIdStr = request.getParameter("request_id");

        if (clubIdStr == null || userIdStr == null || reqIdStr == null) {
            response.sendRedirect("MySquadController");
            return;
        }

        int clubId = Integer.parseInt(clubIdStr);
        int reqUserId = Integer.parseInt(userIdStr);
        int reqId = Integer.parseInt(reqIdStr);

        try (Connection conn = Koneksi.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Insert into club_member
                String insertSql = "INSERT INTO club_member (club_id, user_id) VALUES (?, ?)";
                PreparedStatement insertPs = conn.prepareStatement(insertSql);
                insertPs.setInt(1, clubId);
                insertPs.setInt(2, reqUserId);
                insertPs.executeUpdate();

                // 2. Delete from club_request
                String deleteSql = "DELETE FROM club_request WHERE request_id = ?";
                PreparedStatement deletePs = conn.prepareStatement(deleteSql);
                deletePs.setInt(1, reqId);
                deletePs.executeUpdate();

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
            response.sendRedirect("ClubDetailController?id=" + clubId);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("ClubDetailController?id=" + clubId);
        }
    }
}

