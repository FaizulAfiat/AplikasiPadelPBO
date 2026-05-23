/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.friend.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class FriendListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer userId
                = (Integer) session.getAttribute("user_id");

        if (userId == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/view/Login.html");

            return;
        }

        ArrayList<String[]> friendList
                = new ArrayList<>();

        try {

            Connection conn = Koneksi.getConnection();

            String sql
                    = "SELECT u.user_id, u.username, f.status "
                    + "FROM friendships f "
                    + "JOIN users u "
                    + "ON u.user_id = f.friend_id "
                    + "WHERE f.user_id = ?";

            PreparedStatement ps
                    = conn.prepareStatement(sql);

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                String[] data = new String[3];

                data[0]
                        = rs.getString("user_id");

                data[1]
                        = rs.getString("username");

                data[2]
                        = rs.getString("status");

                friendList.add(data);
            }

            request.setAttribute(
                    "friendList",
                    friendList);

            request.getRequestDispatcher(
                    "/view/friendlist.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                    "ERROR: " + e.getMessage());
        }
    }
}
