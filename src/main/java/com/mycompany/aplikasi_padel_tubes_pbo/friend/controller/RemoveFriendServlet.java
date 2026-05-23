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

public class RemoveFriendServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int friendshipId
                = Integer.parseInt(
                        request.getParameter("friendshipId")
                );

        try {

            Connection conn = Koneksi.getConnection();

            String sql
                    = "DELETE FROM friendships "
                    + "WHERE friendship_id=?";

            PreparedStatement ps
                    = conn.prepareStatement(sql);

            ps.setInt(1, friendshipId);

            ps.executeUpdate();

            response.sendRedirect(
                    request.getContextPath()
                    + "/viewFriends"
            );

        } catch (Exception e) {

            e.printStackTrace();

        }

    }

}
