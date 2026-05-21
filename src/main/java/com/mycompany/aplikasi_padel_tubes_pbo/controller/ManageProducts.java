/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Faizul Afiat
 */
public class ManageProducts extends HttpServlet {

        protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map<String, Object>> productList = new ArrayList<>();
        try (Connection conn = Koneksi.getConnection()) {
            String sql = "SELECT * FROM products ORDER BY product_id DESC";
            ResultSet rs = conn.createStatement().executeQuery(sql);
            
            while (rs.next()) {
                Map<String, Object> p = new HashMap<>();
                p.put("image", rs.getString("image"));
                p.put("id", rs.getInt("product_id"));
                p.put("name", rs.getString("name"));
                p.put("category", rs.getString("category"));
                p.put("price", rs.getInt("price"));
                p.put("stock", rs.getInt("stock"));
                productList.add(p);
            }
            request.setAttribute("productList", productList);
            request.getRequestDispatcher("view/admin/admin_products.jsp").forward(request, response);
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
   }
}
