/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.friend.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SearchFriendServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Integer userId
                    = (Integer) request.getSession()
                            .getAttribute("user_id");

            if (userId == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/view/Login.html"
                );

                return;
            }

            String keyword = request.getParameter("keyword");

            Connection conn = Koneksi.getConnection();

            String sql
                    = "SELECT user_id, username "
                    + "FROM users "
                    + "WHERE username LIKE ? "
                    + "AND user_id != ?";

            PreparedStatement ps
                    = conn.prepareStatement(sql);

            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, userId);

            ResultSet rs = ps.executeQuery();

            ArrayList<String[]> users
                    = new ArrayList<>();

            while (rs.next()) {

                String[] data = {
                    rs.getString("user_id"),
                    rs.getString("username")
                };

                users.add(data);
            }

            request.setAttribute("users", users);

            request.getRequestDispatcher(
                    "/view/searchfriend.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                    "<h1>Error Search Friend</h1>"
                    + "<pre>" + e.getMessage() + "</pre>"
            );
        }
    }
}
