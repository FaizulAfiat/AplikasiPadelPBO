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
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Controller for upgrading user role to Premium.
 * Used to demonstrate premium features and unlock views instantly.
 * 
 * @author Faizul Afiat
 */
@WebServlet(name = "UpgradePremiumController", urlPatterns = {"/UpgradePremiumController"})
public class UpgradePremiumController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("user_id");

        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html");
            return;
        }

        int userId = (Integer) userIdObj;

        try (Connection conn = Koneksi.getConnection()) {
            String updateSql = "UPDATE users SET role = 'Premium' WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, userId);
                int result = ps.executeUpdate();
                
                if (result > 0) {
                    session.setAttribute("role", "Premium");
                    response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=upgrade_success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=upgrade_failed");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/TournamentNewsController?status=error");
        }
    }
}
