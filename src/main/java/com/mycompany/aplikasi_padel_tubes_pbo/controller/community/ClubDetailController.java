package com.mycompany.aplikasi_padel_tubes_pbo.controller.community;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "ClubDetailController", urlPatterns = {"/ClubDetailController"})
public class ClubDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String clubIdStr = request.getParameter("id");
        int clubId = Integer.parseInt(clubIdStr);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try (Connection conn = Koneksi.getConnection()) {
            String sqlClub = "SELECT c.*, u.username AS creator_name " +
                             "FROM club c LEFT JOIN users u ON c.created_by = u.user_id " +
                             "WHERE c.club_id = ?";
            PreparedStatement psClub = conn.prepareStatement(sqlClub);
            psClub.setInt(1, clubId);
            ResultSet rsClub = psClub.executeQuery();

            if (!rsClub.next()) {
                if ("json".equals(request.getParameter("format"))) {
                    out.print("{\"error\":true}");
                } else {
                    response.sendRedirect("CommunityController?status=error");
                }
                return;
            }

            String name    = rsClub.getString("name");
            String desc    = rsClub.getString("description");
            String creator = rsClub.getString("creator_name");
            if (creator == null) creator = "Unknown";
            String status  = rsClub.getString("status");

            String sqlMember = "SELECT u.username FROM users u " +
                               "JOIN club_member cm ON u.user_id = cm.user_id " +
                               "WHERE cm.club_id = ?";
            PreparedStatement psMember = conn.prepareStatement(sqlMember);
            psMember.setInt(1, clubId);
            ResultSet rsMember = psMember.executeQuery();

            if ("json".equals(request.getParameter("format"))) {
                StringBuilder members = new StringBuilder("[");
                boolean first = true;
                while (rsMember.next()) {
                    if (!first) members.append(",");
                    members.append("\"")
                           .append(rsMember.getString("username").replace("\"", "\\\""))
                           .append("\"");
                    first = false;
                }
                members.append("]");

                out.print("{" +
                    "\"name\":\""    + name.replace("\"", "\\\"")    + "\"," +
                    "\"desc\":\""    + desc.replace("\"", "\\\"")    + "\"," +
                    "\"creator\":\"" + creator + "\"," +
                    "\"members\":"   + members +
                "}");
            } else {
                java.util.Map<String, Object> clubMap = new java.util.HashMap<>();
                clubMap.put("club_id", clubId);
                clubMap.put("name", name);
                clubMap.put("description", desc);
                clubMap.put("creator", creator);
                clubMap.put("status", status != null ? status : "ACTIVE");
                // Mocked extra fields for club_detail.jsp
                clubMap.put("next_match", "Sat, 24 Jun - Padel Court 1");
                clubMap.put("contact", creator);
                clubMap.put("quota", "Unlimited");

                java.util.List<String> memberList = new java.util.ArrayList<>();
                while (rsMember.next()) {
                    memberList.add(rsMember.getString("username"));
                }

                int createdBy = rsClub.getInt("created_by");
                int currentUserId = Integer.parseInt(session.getAttribute("user_id").toString());
                boolean isAdmin = (createdBy == currentUserId);
                clubMap.put("isAdmin", isAdmin);

                if (isAdmin) {
                    String reqSql = "SELECT r.request_id, r.user_id, u.username FROM club_request r JOIN users u ON r.user_id = u.user_id WHERE r.club_id = ?";
                    PreparedStatement reqPs = conn.prepareStatement(reqSql);
                    reqPs.setInt(1, clubId);
                    ResultSet reqRs = reqPs.executeQuery();
                    java.util.List<java.util.Map<String, Object>> pendingRequests = new java.util.ArrayList<>();
                    while (reqRs.next()) {
                        java.util.Map<String, Object> req = new java.util.HashMap<>();
                        req.put("request_id", reqRs.getInt("request_id"));
                        req.put("user_id", reqRs.getInt("user_id"));
                        req.put("username", reqRs.getString("username"));
                        pendingRequests.add(req);
                    }
                    request.setAttribute("pendingRequests", pendingRequests);
                }

                request.setAttribute("clubData", clubMap);
                request.setAttribute("members", memberList);
                request.getRequestDispatcher("view/club_detail.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            if ("json".equals(request.getParameter("format"))) {
                out.print("{\"error\":true, \"msg\":\"" + e.getMessage() + "\"}");
            } else {
                response.sendRedirect("CommunityController?status=error");
            }
        }
    }
}

