package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class InvoiceController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("user_id");

        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html");
            return;
        }

        int userId = (Integer) userIdObj;
        String bookingIdParam = request.getParameter("booking_id");

        if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ProfileController");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);

            try (Connection conn = Koneksi.getConnection()) {
                String sql = "SELECT b.booking_id, b.user_id, b.match_date, b.start_time, b.end_time, b.total_price, b.status, " +
                             "c.name AS court_name, u.username, u.email, p.fullname " +
                             "FROM bookings b " +
                             "JOIN courts c ON b.court_id = c.court_id " +
                             "JOIN users u ON b.user_id = u.user_id " +
                             "LEFT JOIN profiles p ON u.user_id = p.user_id " +
                             "WHERE b.booking_id = ?";

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, bookingId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            int bookingUserId = rs.getInt("user_id");

                            // Validasi keamanan: Pastikan invoice milik user yang login
                            if (bookingUserId != userId) {
                                response.sendRedirect(request.getContextPath() + "/ProfileController?status=unauthorized");
                                return;
                            }

                            String status = rs.getString("status");
                            
                            // Jika masih pending/belum bayar, arahkan kembali ke halaman pembayaran
                            if ("Pending".equalsIgnoreCase(status)) {
                                response.sendRedirect(request.getContextPath() + "/PaymentController?booking_id=" + bookingId);
                                return;
                            }

                            // Bungkus data booking & user
                            Map<String, Object> invoiceData = new HashMap<>();
                            invoiceData.put("id", rs.getInt("booking_id"));
                            invoiceData.put("court", rs.getString("court_name"));
                            invoiceData.put("date", rs.getDate("match_date"));
                            invoiceData.put("start", rs.getTime("start_time"));
                            invoiceData.put("end", rs.getTime("end_time"));
                            invoiceData.put("total", rs.getInt("total_price"));
                            invoiceData.put("status", status);
                            invoiceData.put("username", rs.getString("username"));
                            invoiceData.put("email", rs.getString("email"));
                            
                            String fullname = rs.getString("fullname");
                            invoiceData.put("fullname", (fullname != null && !fullname.trim().isEmpty()) ? fullname : rs.getString("username"));

                            // Generate formatted booking/transaction time
                            String bookingTime = new java.text.SimpleDateFormat("dd MMM yyyy, HH:mm").format(new java.util.Date());
                            invoiceData.put("bookingTime", bookingTime);

                            request.setAttribute("invoice", invoiceData);
                            request.getRequestDispatcher("view/invoice.jsp").forward(request, response);
                        } else {
                            response.sendRedirect(request.getContextPath() + "/ProfileController?status=not_found");
                        }
                    }
                }
            }
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ProfileController?status=error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
