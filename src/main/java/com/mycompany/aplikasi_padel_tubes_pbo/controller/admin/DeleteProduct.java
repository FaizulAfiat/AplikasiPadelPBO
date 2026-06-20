package com.mycompany.aplikasi_padel_tubes_pbo.controller.admin;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Servlet untuk menangani penghapusan produk.
 * @author Faizul Afiat
 */
public class DeleteProduct extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equalsIgnoreCase("Admin")) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html?error=unauthorized");
            return;
        }
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                try (Connection conn = Koneksi.getConnection()) {
                    String sql = "DELETE FROM products WHERE product_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, id);
                        int rowsDeleted = ps.executeUpdate();
                        if (rowsDeleted > 0) {
                            response.sendRedirect(request.getContextPath() + "/ManageProducts?success=delete");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/ManageProducts?error=notfound");
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/ManageProducts?error=delete");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/ManageProducts?error=invalidid");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/ManageProducts?error=missingid");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
