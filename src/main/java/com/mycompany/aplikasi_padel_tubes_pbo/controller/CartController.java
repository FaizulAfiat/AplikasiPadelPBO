package com.mycompany.aplikasi_padel_tubes_pbo.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import com.mycompany.aplikasi_padel_tubes_pbo.model.Product;
import com.mycompany.aplikasi_padel_tubes_pbo.model.CartItem;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET request redirects back to the Shop page
        response.sendRedirect(request.getContextPath() + "/ShopController");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("user_id");

        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/ShopController?status=not_logged_in");
            return;
        }

        int userId = (Integer) userIdObj;
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/ShopController");
            return;
        }

        // Initialize cart in session if it doesn't exist
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        try {
            switch (action) {
                case "add":
                    addToCart(request, response, cart);
                    break;
                case "update":
                    updateCartQuantity(request, response, cart);
                    break;
                case "remove":
                    removeFromCart(request, response, cart);
                    break;
                case "clear":
                    clearCart(request, response, session);
                    break;
                case "checkout":
                    checkoutCart(request, response, userId, cart, session);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/ShopController");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ShopController?status=db_error");
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response, List<CartItem> cart)
            throws ServletException, IOException, SQLException {
        String productIdStr = request.getParameter("productId");
        if (productIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/ShopController?status=error");
            return;
        }

        int productId = Integer.parseInt(productIdStr);

        // Fetch product info from DB to ensure validity and current stock
        try (Connection conn = Koneksi.getConnection()) {
            String sql = "SELECT * FROM products WHERE product_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Product product = new Product();
                        product.setId(rs.getInt("product_id"));
                        product.setName(rs.getString("name"));
                        product.setCategory(rs.getString("category"));
                        product.setType(rs.getString("type"));
                        product.setPrice(rs.getInt("price"));
                        product.setStock(rs.getInt("stock"));
                        product.setImage(rs.getString("image"));

                        if (product.getStock() <= 0) {
                            response.sendRedirect(request.getContextPath() + "/ShopController?status=out_of_stock");
                            return;
                        }

                        // Check if item already in cart
                        CartItem existingItem = null;
                        for (CartItem item : cart) {
                            if (item.getProduct().getId() == productId) {
                                existingItem = item;
                                break;
                            }
                        }

                        if (existingItem != null) {
                            // Check if quantity + 1 exceeds stock
                            if (existingItem.getQuantity() + 1 > product.getStock()) {
                                response.sendRedirect(request.getContextPath() + "/ShopController?status=max_stock_exceeded");
                                return;
                            }
                            existingItem.setQuantity(existingItem.getQuantity() + 1);
                        } else {
                            cart.add(new CartItem(product, 1));
                        }

                        response.sendRedirect(request.getContextPath() + "/ShopController?status=cart_add_success");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/ShopController?status=product_not_found");
                    }
                }
            }
        }
    }

    private void updateCartQuantity(HttpServletRequest request, HttpServletResponse response, List<CartItem> cart)
            throws ServletException, IOException {
        String productIdStr = request.getParameter("productId");
        String changeStr = request.getParameter("change"); // e.g. "1" or "-1"

        if (productIdStr == null || changeStr == null) {
            response.sendRedirect(request.getContextPath() + "/ShopController?cartOpen=true");
            return;
        }

        int productId = Integer.parseInt(productIdStr);
        int change = Integer.parseInt(changeStr);

        CartItem targetItem = null;
        for (CartItem item : cart) {
            if (item.getProduct().getId() == productId) {
                targetItem = item;
                break;
            }
        }

        if (targetItem != null) {
            int newQty = targetItem.getQuantity() + change;
            if (newQty <= 0) {
                cart.remove(targetItem);
            } else {
                // Check stock
                try (Connection conn = Koneksi.getConnection()) {
                    String sql = "SELECT stock FROM products WHERE product_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, productId);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                int currentStock = rs.getInt("stock");
                                if (newQty > currentStock) {
                                    response.sendRedirect(request.getContextPath() + "/ShopController?status=max_stock_exceeded&cartOpen=true");
                                    return;
                                }
                                targetItem.setQuantity(newQty);
                            }
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/ShopController?cartOpen=true");
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, List<CartItem> cart)
            throws ServletException, IOException {
        String productIdStr = request.getParameter("productId");
        if (productIdStr != null) {
            int productId = Integer.parseInt(productIdStr);
            cart.removeIf(item -> item.getProduct().getId() == productId);
        }
        response.sendRedirect(request.getContextPath() + "/ShopController?cartOpen=true");
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        session.removeAttribute("cart");
        response.sendRedirect(request.getContextPath() + "/ShopController?cartOpen=true");
    }

    private void checkoutCart(HttpServletRequest request, HttpServletResponse response, int userId, List<CartItem> cart, HttpSession session)
            throws ServletException, IOException, SQLException {
        if (cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ShopController?status=cart_empty");
            return;
        }

        try (Connection conn = Koneksi.getConnection()) {
            // Start transaction
            conn.setAutoCommit(false);
            try {
                for (CartItem item : cart) {
                    // 1. Verify fresh stock from database
                    String checkStockSql = "SELECT stock FROM products WHERE product_id = ? FOR UPDATE";
                    int freshStock = 0;
                    try (PreparedStatement ps = conn.prepareStatement(checkStockSql)) {
                        ps.setInt(1, item.getProduct().getId());
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                freshStock = rs.getInt("stock");
                            } else {
                                throw new SQLException("Product ID " + item.getProduct().getId() + " not found.");
                            }
                        }
                    }

                    if (item.getQuantity() > freshStock) {
                        conn.rollback();
                        response.sendRedirect(request.getContextPath() + "/ShopController?status=insufficient_stock_for_checkout");
                        return;
                    }

                    // 2. Decrement stock
                    String updateStockSql = "UPDATE products SET stock = stock - ? WHERE product_id = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateStockSql)) {
                        updatePs.setInt(1, item.getQuantity());
                        updatePs.setInt(2, item.getProduct().getId());
                        updatePs.executeUpdate();
                    }

                    // 3. Create transaction record
                    // Note: total_amount = price * quantity
                    int subtotal = item.getProduct().getPrice() * item.getQuantity();
                    String insertTxSql = "INSERT INTO transaction (user_id, product_id, quantity, type, transaction_date, total_amount, status) VALUES (?, ?, ?, ?, CURRENT_DATE(), ?, 'Completed')";
                    try (PreparedStatement insertPs = conn.prepareStatement(insertTxSql)) {
                        insertPs.setInt(1, userId);
                        insertPs.setInt(2, item.getProduct().getId());
                        insertPs.setInt(3, item.getQuantity());
                        insertPs.setString(4, item.getProduct().getType());
                        insertPs.setInt(5, subtotal);
                        insertPs.executeUpdate();
                    }
                }

                // If everything goes well, commit transaction
                conn.commit();
                // Clear cart
                session.removeAttribute("cart");
                response.sendRedirect(request.getContextPath() + "/ShopController?status=success");

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
}
