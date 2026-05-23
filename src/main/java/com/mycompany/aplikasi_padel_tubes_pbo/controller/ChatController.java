package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/chat")
public class ChatController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pesan = request.getParameter("pesan");

        try {

            Connection conn = Koneksi.getConnection();

            String sql = "INSERT INTO pesan(id_chat, pengirim_id, isi_pesan, status) VALUES (?, ?, ?, ?)";

            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setInt(1, 1);
            stmt.setInt(2, 1);
            stmt.setString(3, pesan);
            stmt.setString(4, "terkirim");

            stmt.executeUpdate();

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("view/chat.jsp");
    }
}