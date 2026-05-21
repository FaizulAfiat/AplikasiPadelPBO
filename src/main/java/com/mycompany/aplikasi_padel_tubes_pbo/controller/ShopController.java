/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import com.mycompany.aplikasi_padel_tubes_pbo.model.Product;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Faizul Afiat
 */
public class ShopController extends HttpServlet {

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
            out.println("<title>Servlet ShopController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ShopController at " + request.getContextPath() + "</h1>");
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
        List<Product> productList = new ArrayList<>();
        
        try (Connection conn = Koneksi.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM products");
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
                        
            request.setAttribute("productList", productList);
            request.getRequestDispatcher("view/store_rent.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
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
        jakarta.servlet.http.HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("user_id");
        
        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/ShopController?status=not_logged_in");
            return;
        }
        
        int userId = (Integer) userIdObj;
        String productIdStr = request.getParameter("productId");
        String action = request.getParameter("action"); // 'buy' or 'rent'
        
        if (productIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/ShopController?status=error");
            return;
        }
        
        int productId;
        try {
            productId = Integer.parseInt(productIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ShopController?status=error");
            return;
        }
        
        try (Connection conn = Koneksi.getConnection()) {
            // Cek detail produk dan stoknya
            String productSql = "SELECT price, stock, type FROM products WHERE product_id = ?";
            try (PreparedStatement productPs = conn.prepareStatement(productSql)) {
                productPs.setInt(1, productId);
                try (ResultSet rs = productPs.executeQuery()) {
                    if (!rs.next()) {
                        response.sendRedirect(request.getContextPath() + "/ShopController?status=product_not_found");
                        return;
                    }
                    
                    int price = rs.getInt("price");
                    int stock = rs.getInt("stock");
                    String type = rs.getString("type");
                    
                    // Validasi kecocokan aksi dengan tipe produk
                    if (("buy".equals(action) && !"Sale".equals(type)) || ("rent".equals(action) && !"Rent".equals(type))) {
                        response.sendRedirect(request.getContextPath() + "/ShopController?status=invalid_action");
                        return;
                    }
                    
                    if (stock <= 0) {
                        response.sendRedirect(request.getContextPath() + "/ShopController?status=out_of_stock");
                        return;
                    }
                    
                    // Proses checkout di dalam sebuah database transaction
                    conn.setAutoCommit(false);
                    try {
                        // 1. Kurangi stok produk sebesar 1
                        String updateStockSql = "UPDATE products SET stock = stock - 1 WHERE product_id = ?";
                        try (PreparedStatement updatePs = conn.prepareStatement(updateStockSql)) {
                            updatePs.setInt(1, productId);
                            updatePs.executeUpdate();
                        }
                        
                        // 2. Tambah record transaksi baru
                        String insertTxSql = "INSERT INTO transaction (user_id, product_id, quantity, type, transaction_date, total_amount, status) VALUES (?, ?, 1, ?, CURRENT_DATE(), ?, 'Completed')";
                        try (PreparedStatement insertPs = conn.prepareStatement(insertTxSql)) {
                            insertPs.setInt(1, userId);
                            insertPs.setInt(2, productId);
                            insertPs.setString(3, type);
                            insertPs.setInt(4, price);
                            insertPs.executeUpdate();
                        }
                        
                        conn.commit();
                        response.sendRedirect(request.getContextPath() + "/ShopController?status=success");
                    } catch (SQLException ex) {
                        conn.rollback();
                        throw ex;
                    } finally {
                        conn.setAutoCommit(true);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ShopController?status=db_error");
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
