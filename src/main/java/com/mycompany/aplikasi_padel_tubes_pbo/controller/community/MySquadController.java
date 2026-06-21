package com.mycompany.aplikasi_padel_tubes_pbo.controller.community;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi; 
import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "MySquadController", urlPatterns = {"/MySquadController"})
public class MySquadController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // PENTING: Sesuaikan dengan nama session saat user login
        Object userObj = session.getAttribute("user_id"); 

        if (userObj == null) {
            response.sendRedirect("view/Login.html");
            return;
        }

        int userId = Integer.parseInt(userObj.toString());
        List<Map<String, Object>> listMySquad = new ArrayList<>();

        try (Connection conn = Koneksi.getConnection()) {
            // INNER JOIN untuk mencari klub yang diikuti user
            String sql = "SELECT c.club_id, c.name, c.description, c.status " +
                         "FROM club c " +
                         "JOIN club_member cm ON c.club_id = cm.club_id " +
                         "WHERE cm.user_id = ? " +
                         "ORDER BY c.club_id DESC";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> club = new HashMap<>();
                club.put("club_id", rs.getInt("club_id"));
                club.put("name", rs.getString("name"));
                club.put("description", rs.getString("description"));
                club.put("status", rs.getString("status"));
                listMySquad.add(club);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Kirim data listMySquad ke halaman JSP
        request.setAttribute("listMySquad", listMySquad);
        request.getRequestDispatcher("view/Mysquad.jsp").forward(request, response);
    }
}
