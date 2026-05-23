/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        try (Connection conn = Koneksi.getConnection()) {

            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, pass);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                int userId = rs.getInt("user_id");
                String username = rs.getString("username");
                String role = rs.getString("role");

                request.getSession().setAttribute("user_id", userId);
                request.getSession().setAttribute("user", username);
                request.getSession().setAttribute("role", role);

                if ("Admin".equalsIgnoreCase(role)) {

                    response.sendRedirect(
                            request.getContextPath() + "/AdminController"
                    );

                } else {

                    response.sendRedirect(
                            request.getContextPath() + "/index.jsp"
                    );
                }

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/view/Login.html?error=1"
                );

            }

        } catch (SQLException e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/view/Login.html?error=db"
            );
        }
    }
}
