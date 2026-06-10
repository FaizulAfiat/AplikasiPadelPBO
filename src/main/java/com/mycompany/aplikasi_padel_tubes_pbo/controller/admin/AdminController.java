/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.controller.admin;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Faizul Afiat
 */
public class AdminController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !role.equalsIgnoreCase("Admin")) {
            response.sendRedirect("view/Login.html?error=unauthorized");
            return;
        }

        try (Connection conn = Koneksi.getConnection()) {
            String sqlRevenue = "SELECT SUM(total_price) FROM bookings";
            PreparedStatement ps1 = conn.prepareStatement(sqlRevenue);
            ResultSet rs1 = ps1.executeQuery();
            int totalRevenue = 0;
            if (rs1.next()) {
                totalRevenue = rs1.getInt(1);
            }

            String sqlProducts = "SELECT COUNT(*) FROM products";
            PreparedStatement ps2 = conn.prepareStatement(sqlProducts);
            ResultSet rs2 = ps2.executeQuery();
            int totalProducts = 0;
            if (rs2.next()) {
                totalProducts = rs2.getInt(1);
            }

            String sqlBookings = "SELECT COUNT(*) FROM bookings";
            PreparedStatement ps3 = conn.prepareStatement(sqlBookings);
            ResultSet rs3 = ps3.executeQuery();
            int totalBookings = 0;
            if (rs3.next()) {
                totalBookings = rs3.getInt(1);
            }

            String sqlList = "SELECT b.booking_id, u.username, c.name as court_name, b.match_date, b.start_time, b.end_time, b.total_price, b.status "
                    + "FROM bookings b "
                    + "JOIN users u ON b.user_id = u.user_id "
                    + "JOIN courts c ON b.court_id = c.court_id "
                    + "ORDER BY b.booking_id DESC";
            PreparedStatement ps = conn.prepareStatement(sqlList);
            ResultSet rs = ps.executeQuery();

            List<Map<String, Object>> bookingList = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("booking_id"));
                map.put("username", rs.getString("username"));
                map.put("court", rs.getString("court_name"));
                map.put("date", rs.getDate("match_date"));
                map.put("start", rs.getTime("start_time"));
                map.put("end", rs.getTime("end_time"));
                map.put("total", rs.getInt("total_price"));
                map.put("status", rs.getString("status"));
                bookingList.add(map);
            }

            request.setAttribute("revenue", totalRevenue);
            request.setAttribute("productCount", totalProducts);
            request.setAttribute("bookingCount", totalBookings);
            request.setAttribute("bookingList", bookingList);

            request.getRequestDispatcher("view/admin/admin_dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
