package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import com.mycompany.aplikasi_padel_tubes_pbo.model.Rental;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminRentalController", urlPatterns = {"/AdminRentalController"})
public class AdminRentalController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !role.equalsIgnoreCase("Admin")) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html?error=unauthorized");
            return;
        }

        try (Connection conn = Koneksi.getConnection()) {
            // 1. Auto-update Overdue rentals
            String updateOverdueSql = "UPDATE rentals SET status = 'Overdue' WHERE status = 'Active' AND due_date < CURRENT_DATE()";
            try (PreparedStatement psUpdate = conn.prepareStatement(updateOverdueSql)) {
                psUpdate.executeUpdate();
            }

            // 2. Filter & Search Query Building
            String statusFilter = request.getParameter("status");
            String searchQuery = request.getParameter("search");

            StringBuilder sqlBuilder = new StringBuilder(
                "SELECT r.rental_id, r.transaction_id, r.user_id, r.product_id, r.quantity, r.rental_date, r.due_date, r.return_date, r.status, " +
                "u.username, p.name AS product_name, p.category, p.image " +
                "FROM rentals r " +
                "JOIN users u ON r.user_id = u.user_id " +
                "JOIN products p ON r.product_id = p.product_id " +
                "WHERE 1=1 "
            );

            List<Object> params = new ArrayList<>();

            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("All")) {
                sqlBuilder.append("AND r.status = ? ");
                params.add(statusFilter);
            }

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                sqlBuilder.append("AND (u.username LIKE ? OR p.name LIKE ? OR p.category LIKE ?) ");
                String likePattern = "%" + searchQuery.trim() + "%";
                params.add(likePattern);
                params.add(likePattern);
                params.add(likePattern);
            }

            sqlBuilder.append("ORDER BY r.rental_id DESC");

            List<Rental> rentalsList = new ArrayList<>();
            try (PreparedStatement psSelect = conn.prepareStatement(sqlBuilder.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    psSelect.setObject(i + 1, params.get(i));
                }

                try (ResultSet rs = psSelect.executeQuery()) {
                    while (rs.next()) {
                        Rental rental = new Rental();
                        rental.setRentalId(rs.getInt("rental_id"));
                        rental.setTransactionId(rs.getInt("transaction_id"));
                        rental.setUserId(rs.getInt("user_id"));
                        rental.setProductId(rs.getInt("product_id"));
                        rental.setQuantity(rs.getInt("quantity"));
                        rental.setRentalDate(rs.getDate("rental_date"));
                        rental.setDueDate(rs.getDate("due_date"));
                        rental.setReturnDate(rs.getDate("return_date"));
                        rental.setStatus(rs.getString("status"));
                        rental.setUsername(rs.getString("username"));
                        rental.setProductName(rs.getString("product_name"));
                        rental.setCategory(rs.getString("category"));
                        rental.setImage(rs.getString("image"));
                        rentalsList.add(rental);
                    }
                }
            }

            // Fetch summary stats
            int activeCount = 0;
            int overdueCount = 0;
            int returnedCount = 0;

            String statsSql = "SELECT status, COUNT(*) AS count FROM rentals GROUP BY status";
            try (PreparedStatement psStats = conn.prepareStatement(statsSql);
                 ResultSet rsStats = psStats.executeQuery()) {
                while (rsStats.next()) {
                    String status = rsStats.getString("status");
                    int count = rsStats.getInt("count");
                    if ("Active".equalsIgnoreCase(status)) {
                        activeCount = count;
                    } else if ("Overdue".equalsIgnoreCase(status)) {
                        overdueCount = count;
                    } else if ("Returned".equalsIgnoreCase(status)) {
                        returnedCount = count;
                    }
                }
            }

            request.setAttribute("rentalsList", rentalsList);
            request.setAttribute("activeCount", activeCount);
            request.setAttribute("overdueCount", overdueCount);
            request.setAttribute("returnedCount", returnedCount);
            request.setAttribute("currentStatus", statusFilter != null ? statusFilter : "All");
            request.setAttribute("currentSearch", searchQuery != null ? searchQuery : "");

            request.getRequestDispatcher("view/admin/admin_rentals.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/AdminController?error=db");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !role.equalsIgnoreCase("Admin")) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        if ("return".equalsIgnoreCase(action)) {
            String rentalIdStr = request.getParameter("rentalId");
            if (rentalIdStr == null || rentalIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/AdminRentalController?status=error");
                return;
            }

            int rentalId = Integer.parseInt(rentalIdStr);

            try (Connection conn = Koneksi.getConnection()) {
                conn.setAutoCommit(false);
                try {
                    // 1. Get product_id, quantity, and status from the rental record
                    int productId = -1;
                    int quantity = 0;
                    String status = "";

                    String selectRentalSql = "SELECT product_id, quantity, status FROM rentals WHERE rental_id = ? FOR UPDATE";
                    try (PreparedStatement psSelect = conn.prepareStatement(selectRentalSql)) {
                        psSelect.setInt(1, rentalId);
                        try (ResultSet rs = psSelect.executeQuery()) {
                            if (rs.next()) {
                                productId = rs.getInt("product_id");
                                quantity = rs.getInt("quantity");
                                status = rs.getString("status");
                            }
                        }
                    }

                    if (productId == -1) {
                        conn.rollback();
                        response.sendRedirect(request.getContextPath() + "/AdminRentalController?status=not_found");
                        return;
                    }

                    if ("Returned".equalsIgnoreCase(status)) {
                        conn.rollback();
                        response.sendRedirect(request.getContextPath() + "/AdminRentalController?status=already_returned");
                        return;
                    }

                    // 2. Update status and return_date in rentals
                    String updateRentalSql = "UPDATE rentals SET status = 'Returned', return_date = CURRENT_DATE() WHERE rental_id = ?";
                    try (PreparedStatement psUpdate = conn.prepareStatement(updateRentalSql)) {
                        psUpdate.setInt(1, rentalId);
                        psUpdate.executeUpdate();
                    }

                    // 3. Restore product stock
                    String restoreStockSql = "UPDATE products SET stock = stock + ? WHERE product_id = ?";
                    try (PreparedStatement psRestore = conn.prepareStatement(restoreStockSql)) {
                        psRestore.setInt(1, quantity);
                        psRestore.setInt(2, productId);
                        psRestore.executeUpdate();
                    }

                    conn.commit();
                    response.sendRedirect(request.getContextPath() + "/AdminRentalController?status=success_return");
                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                } finally {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/AdminRentalController?status=db_error");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminRentalController");
        }
    }
}
