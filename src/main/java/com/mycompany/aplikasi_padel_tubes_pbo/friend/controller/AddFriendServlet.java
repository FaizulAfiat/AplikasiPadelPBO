/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.friend.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class AddFriendServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId
                = (Integer) request.getSession()
                        .getAttribute("user_id");

        int friendId
                = Integer.parseInt(
                        request.getParameter("friendId")
                );

        try {

            Connection conn = Koneksi.getConnection();

            String sql
                    = "INSERT INTO friendships "
                    + "(user_id, friend_id, status) "
                    + "VALUES (?, ?, 'PENDING')";

            PreparedStatement ps
                    = conn.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setInt(2, friendId);

            ps.executeUpdate();

            response.sendRedirect(
                    request.getContextPath()
                    + "/view/searchfriend.jsp"
            );

        } catch (Exception e) {

            e.printStackTrace();

        }

    }

}
