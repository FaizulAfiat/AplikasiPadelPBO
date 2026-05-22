package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
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
 * Servlet untuk menangani pembaruan data produk.
 * @author Faizul Afiat
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 15
)
public class EditProduct extends HttpServlet {

    private final String UPLOAD_DIRECTORY = "C:/Users/Faizul Afiat/Documents/Kuliah/Semester 4/Pemrograman Berorientasi Objek/Reguler/Tubes/Aplikasi_Padel_Tubes_PBO/src/main/webapp/assets/images";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("ManageProducts");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String type = request.getParameter("type");
            int price = Integer.parseInt(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String description = request.getParameter("description");
            double rating = Double.parseDouble(request.getParameter("rating"));
            String oldImage = request.getParameter("oldImage");

            Part filePart = request.getPart("image");
            String fileName = filePart.getSubmittedFileName();

            String finalImageName = oldImage;
            if (fileName != null && !fileName.trim().isEmpty()) {
                filePart.write(UPLOAD_DIRECTORY + File.separator + fileName);
                finalImageName = fileName;
            }

            try (Connection conn = Koneksi.getConnection()) {
                String sql = "UPDATE products SET name = ?, category = ?, type = ?, price = ?, stock = ?, image = ?, description = ?, rating = ? WHERE product_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, name);
                    ps.setString(2, category);
                    ps.setString(3, type);
                    ps.setInt(4, price);
                    ps.setInt(5, stock);
                    ps.setString(6, finalImageName);
                    ps.setString(7, description);
                    ps.setDouble(8, rating);
                    ps.setInt(9, id);

                    ps.executeUpdate();
                    response.sendRedirect("ManageProducts?success=edit");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ManageProducts?error=edit");
        }
    }
}
