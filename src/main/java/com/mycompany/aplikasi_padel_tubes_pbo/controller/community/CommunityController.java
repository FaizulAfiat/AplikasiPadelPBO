/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.controller.community;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author ALFIAN
 */
public class CommunityController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null && session.getAttribute("user_id") == null) {
            response.sendRedirect("view/Login.html");
            return;
        }

        List<Map<String, Object>> listClub = new ArrayList<>();

        try (Connection conn = Koneksi.getConnection()) {
            String sql = "SELECT club_id, name, description, status, type FROM club ORDER BY club_id DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> club = new HashMap<>();
                club.put("club_id", rs.getInt("club_id"));
                club.put("name", rs.getString("name"));
                club.put("description", rs.getString("description"));
                club.put("status", rs.getString("status"));
                club.put("type", rs.getString("type"));
                
                listClub.add(club);
            }

            request.setAttribute("listClub", listClub);
            request.getRequestDispatcher("view/community.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("listClub", listClub);
            request.getRequestDispatcher("view/community.jsp").forward(request, response);
        }
    
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Timestamp currenttime = new Timestamp(System.currentTimeMillis());
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user_id");

        if (userObj == null) {
            response.sendRedirect("view/Login.html");
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String type = request.getParameter("type");
        if (type == null || type.trim().isEmpty()) {
            type = "PUBLIC";
        }
        

        if (name == null || name.trim().isEmpty() || description == null || description.trim().isEmpty()) {
            response.sendRedirect("CommunityController?status=empty_field");
            return;
        }

        try (Connection conn = Koneksi.getConnection()) {
            String checkSql = "SELECT COUNT(*) FROM club WHERE name = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, name);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                response.sendRedirect("CommunityController?status=already_exists");
                return;
            }

            // 1. Tambah kolom 'created_by' dan 'type'
            String sql = "INSERT INTO club (name, description, created_at, created_by, type) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);

            ps.setString(1, name);
            ps.setString(2, description);
            ps.setTimestamp(3, currenttime);

            // 2. MASUKIN BARIS INI (Ini jawabannya)
            // Kita ambil userId dari userObj yang sudah kamu buat di baris 66
            int userId = Integer.parseInt(userObj.toString());
            ps.setInt(4, userId);
            ps.setString(5, type);
            //gimana caranya ini ngerekam user_id yang lagi buat community baru
            

            int rowInserted = ps.executeUpdate();
            if (rowInserted > 0) {
                // Get generated club_id and insert into club_member
                ResultSet rsKeys = ps.getGeneratedKeys();
                if (rsKeys.next()) {
                    int newClubId = rsKeys.getInt(1);
                    String memberSql = "INSERT INTO club_member (club_id, user_id) VALUES (?, ?)";
                    try (PreparedStatement memberPs = conn.prepareStatement(memberSql)) {
                        memberPs.setInt(1, newClubId);
                        memberPs.setInt(2, userId);
                        memberPs.executeUpdate();
                    }
                }
                response.sendRedirect("CommunityController?status=success");
            } else {
                response.sendRedirect("CommunityController?status=failed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("CommunityController?status=error");
        }
    
    }
}

