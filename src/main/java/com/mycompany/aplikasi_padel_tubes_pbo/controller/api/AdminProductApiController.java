package com.mycompany.aplikasi_padel_tubes_pbo.controller.api;

import com.google.gson.Gson;
import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import com.mycompany.aplikasi_padel_tubes_pbo.model.Product;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 15     // 15MB
)
public class AdminProductApiController extends HttpServlet {

    private final Gson gson = new Gson();

    private String getUploadDirectory(HttpServletRequest request) {
        String uploadDir = request.getServletContext().getRealPath("/assets/images");
        if (uploadDir == null) {
            // Absolute fallback path matching workspace structure
            uploadDir = "C:/Users/Faizul Afiat/Documents/Kuliah/Semester 4/Pemrograman Berorientasi Objek/Reguler/Tubes/GitHub/AplikasiPadelPBO/src/main/webapp/assets/images";
        }
        File uploadDirFile = new File(uploadDir);
        if (!uploadDirFile.exists()) {
            uploadDirFile.mkdirs();
        }
        return uploadDir;
    }

    private boolean checkAdminAuthorization(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        if (role == null || !"Admin".equalsIgnoreCase(role)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\": \"Access denied. Admin role required.\"}");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (!checkAdminAuthorization(request, response)) {
            return;
        }

        try (Connection conn = Koneksi.getConnection()) {
            List<Product> productList = new ArrayList<>();
            String sql = "SELECT * FROM products";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setCategory(rs.getString("category"));
                    p.setType(rs.getString("type"));
                    p.setPrice(rs.getInt("price"));
                    p.setStock(rs.getInt("stock"));
                    p.setImage(rs.getString("image"));
                    p.setDescription(rs.getString("description"));
                    p.setRating(rs.getDouble("rating"));
                    productList.add(p);
                }
            }
            response.getWriter().write(gson.toJson(productList));
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (!checkAdminAuthorization(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing action parameter.\"}");
            return;
        }

        try {
            switch (action) {
                case "add":
                    addProduct(request, response);
                    break;
                case "edit":
                    editProduct(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Invalid action parameter.\"}");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String type = request.getParameter("type");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        String description = request.getParameter("description");
        String ratingStr = request.getParameter("rating");

        if (name == null || category == null || type == null || priceStr == null || stockStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing required fields.\"}");
            return;
        }

        int price = Integer.parseInt(priceStr);
        int stock = Integer.parseInt(stockStr);
        double rating = 4.5;
        if (ratingStr != null && !ratingStr.trim().isEmpty()) {
            try {
                rating = Double.parseDouble(ratingStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }

        Part filePart = request.getPart("image");
        String fileName = (filePart != null) ? filePart.getSubmittedFileName() : null;

        if (fileName != null && !fileName.trim().isEmpty()) {
            filePart.write(getUploadDirectory(request) + File.separator + fileName);
        }

        try (Connection conn = Koneksi.getConnection()) {
            String sql = "INSERT INTO products (name, category, type, price, stock, image, description, rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, category);
                ps.setString(3, type);
                ps.setInt(4, price);
                ps.setInt(5, stock);
                ps.setString(6, fileName);
                ps.setString(7, description);
                ps.setDouble(8, rating);
                ps.executeUpdate();
            }
        }
        response.getWriter().write("{\"success\": true}");
    }

    private void editProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String type = request.getParameter("type");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        String description = request.getParameter("description");
        String ratingStr = request.getParameter("rating");
        String oldImage = request.getParameter("oldImage");

        if (idStr == null || name == null || category == null || type == null || priceStr == null || stockStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing required fields.\"}");
            return;
        }

        int id = Integer.parseInt(idStr);
        int price = Integer.parseInt(priceStr);
        int stock = Integer.parseInt(stockStr);
        double rating = Double.parseDouble(ratingStr);

        Part filePart = request.getPart("image");
        String fileName = (filePart != null) ? filePart.getSubmittedFileName() : null;

        String finalImageName = oldImage;
        if (fileName != null && !fileName.trim().isEmpty()) {
            filePart.write(getUploadDirectory(request) + File.separator + fileName);
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
            }
        }
        response.getWriter().write("{\"success\": true}");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing product ID.\"}");
            return;
        }

        int id = Integer.parseInt(idStr);

        try (Connection conn = Koneksi.getConnection()) {
            String sql = "DELETE FROM products WHERE product_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                int rowsDeleted = ps.executeUpdate();
                if (rowsDeleted > 0) {
                    response.getWriter().write("{\"success\": true}");
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{\"error\": \"Product not found.\"}");
                }
            }
        }
    }
}
