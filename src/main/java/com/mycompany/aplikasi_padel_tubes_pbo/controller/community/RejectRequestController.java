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

@WebServlet(name = "RejectRequestController", urlPatterns = {"/RejectRequestController"})
public class RejectRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user_id") == null) {
            response.sendRedirect("view/Login.html");
            return;
        }

        String clubIdStr = request.getParameter("club_id");
        String reqIdStr = request.getParameter("request_id");

        if (clubIdStr == null || reqIdStr == null) {
            response.sendRedirect("MySquadController");
            return;
        }

        int clubId = Integer.parseInt(clubIdStr);
        int reqId = Integer.parseInt(reqIdStr);

        try (Connection conn = Koneksi.getConnection()) {
            String deleteSql = "DELETE FROM club_request WHERE request_id = ?";
            PreparedStatement deletePs = conn.prepareStatement(deleteSql);
            deletePs.setInt(1, reqId);
            deletePs.executeUpdate();

            response.sendRedirect("ClubDetailController?id=" + clubId);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("ClubDetailController?id=" + clubId);
        }
    }
}

