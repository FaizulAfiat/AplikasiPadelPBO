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

@WebServlet(name = "LeaveController", urlPatterns = {"/LeaveController"})
public class LeaveController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user_id");

        if (userObj == null) {
            response.sendRedirect("view/Login.html");
            return;
        }

        String clubIdStr = request.getParameter("club_id");
        
        if (clubIdStr == null || clubIdStr.trim().isEmpty()) {
            response.sendRedirect("MySquadController?status=error");
            return;
        }

        int userId;
        int clubId;
        
        try {
            userId = Integer.parseInt(userObj.toString());
            clubId = Integer.parseInt(clubIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("MySquadController?status=error");
            return;
        }

        try (Connection conn = Koneksi.getConnection()) {
            String deleteSql = "DELETE FROM club_member WHERE club_id = ? AND user_id = ?";
            PreparedStatement deletePs = conn.prepareStatement(deleteSql);
            deletePs.setInt(1, clubId);
            deletePs.setInt(2, userId);
            int affectedRows = deletePs.executeUpdate();
            
            if (affectedRows > 0) {
                response.sendRedirect("MySquadController?status=leave_success");
            } else {
                response.sendRedirect("MySquadController?status=not_member");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("MySquadController?status=error_db");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

