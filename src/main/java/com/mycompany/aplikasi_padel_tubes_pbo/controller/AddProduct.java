/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author Faizul Afiat
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 15
)
public class AddProduct extends HttpServlet {

    private final String UPLOAD_DIRECTORY = "C:/Users/Faizul Afiat/Documents/Kuliah/Semester 4/Pemrograman Berorientasi Objek/Reguler/Tubes/Aplikasi_Padel_Tubes_PBO/src/main/webapp/assets/images";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String type = request.getParameter("type");
        int price = Integer.parseInt(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String description = request.getParameter("description");
        
        double rating = 4.5;
        String ratingStr = request.getParameter("rating");
        if (ratingStr != null && !ratingStr.trim().isEmpty()) {
            try {
                rating = Double.parseDouble(ratingStr);
            } catch (NumberFormatException e) {
                // Gunakan default 4.5 jika gagal memparsing rating
            }
        }

        Part filePart = request.getPart("image");
        String fileName = filePart.getSubmittedFileName();

        if (fileName != null && !fileName.isEmpty()) {
            filePart.write(UPLOAD_DIRECTORY + File.separator + fileName);
        }
        
        try (Connection conn = Koneksi.getConnection()) {
            String sql = "INSERT INTO products (name, category, type, price, stock, image, description, rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, category);
            ps.setString(3, type);
            ps.setInt(4, price);
            ps.setInt(5, stock);
            ps.setString(6, fileName);
            ps.setString(7, description);
            ps.setDouble(8, rating);

            ps.executeUpdate();
            response.sendRedirect("ManageProducts?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ManageProducts?error=1");
        }
    }
}
