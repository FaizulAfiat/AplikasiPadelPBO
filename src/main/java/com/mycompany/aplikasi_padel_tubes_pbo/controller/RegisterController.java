/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

/**
 *
 * @author Faizul Afiat
 */
public class RegisterController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RegisterController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Timestamp currentTime = new Timestamp(System.currentTimeMillis());
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        try (Connection conn = Koneksi.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String sql = "INSERT INTO users (username, email, password, created_at) VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, username);
                    ps.setString(2, email);
                    ps.setString(3, pass);
                    ps.setTimestamp(4, currentTime);

                    int result = ps.executeUpdate();

                    if (result > 0) {
                        int userId = -1;
                        try (java.sql.ResultSet rs = ps.getGeneratedKeys()) {
                            if (rs.next()) {
                                userId = rs.getInt(1);
                            }
                        }

                        if (userId != -1) {
                            String profileSql = "INSERT INTO profiles (user_id, fullname, username, gender) VALUES (?, ?, ?, ?)";
                            try (PreparedStatement profilePs = conn.prepareStatement(profileSql)) {
                                profilePs.setInt(1, userId);
                                profilePs.setString(2, username);
                                profilePs.setString(3, username);
                                profilePs.setString(4, "L");
                                profilePs.executeUpdate();
                            }
                        }

                        conn.commit();
                        response.getWriter().println("<script>"
                                + "alert('Registrasi Berhasil! Silakan Login.');"
                                + "window.location='Login.html';"
                                + "</script>");
                    } else {
                        conn.rollback();
                        response.getWriter().println("Gagal Registrasi: Gagal menyimpan data user.");
                    }
                }
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Gagal Registrasi: " + e.getMessage());
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
