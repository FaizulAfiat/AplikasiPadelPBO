<%-- 
    Document   : healthhistory
    Created on : 23 May 2026, 20.32.52
    Author     : Pongo
--%>

<%-- 
    Document   : healthhistory
    Created on : 23 May 2026
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%

    /*
    =========================================
    AMBIL USER ID DARI SESSION LOGIN
    =========================================
     */
    Integer userId
            = (Integer) session.getAttribute("user_id");

    /*
    =========================================
    JIKA BELUM LOGIN
    =========================================
     */
    if (userId == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/view/Login.html"
        );

        return;
    }

    /*
    =========================================
    QUERY HISTORY BERDASARKAN USER LOGIN
    =========================================
     */
    Connection conn = Koneksi.getConnection();

    String sql
            = "SELECT * FROM health_metrics "
            + "WHERE user_id = ? "
            + "ORDER BY record_date DESC";

    PreparedStatement ps
            = conn.prepareStatement(sql);

    ps.setInt(1, userId);

    ResultSet rs = ps.executeQuery();

%>

<!DOCTYPE html>
<html>

    <head>

        <title>Health History</title>

        <script src="https://cdn.tailwindcss.com"></script>

    </head>

    <body class="bg-gray-100 min-h-screen p-10">

        <div class="max-w-5xl mx-auto bg-white rounded-3xl shadow-xl p-10">

            <h1 class="text-5xl font-black uppercase mb-10">

                HEALTH HISTORY

            </h1>

            <div class="overflow-x-auto">

                <table class="w-full border-collapse">

                    <thead>

                        <tr class="bg-black text-white">

                            <th class="p-4 text-left">
                                Date
                            </th>

                            <th class="p-4 text-left">
                                Heart Rate
                            </th>

                            <th class="p-4 text-left">
                                BMI
                            </th>

                            <th class="p-4 text-left">
                                Steps
                            </th>

                            <th class="p-4 text-left">
                                Calories
                            </th>

                        </tr>

                    </thead>

                    <tbody>

                        <%                            boolean adaData = false;

                            while (rs.next()) {

                                adaData = true;

                        %>

                        <tr class="border-b hover:bg-gray-100">

                            <td class="p-4">

                                <%= rs.getDate("record_date")%>

                            </td>

                            <td class="p-4">

                                <%= rs.getInt("resting_heart_rate")%>

                            </td>

                            <td class="p-4">

                                <%= rs.getFloat("bmi")%>

                            </td>

                            <td class="p-4">

                                <%= rs.getInt("total_steps")%>

                            </td>

                            <td class="p-4">

                                <%= rs.getInt("calories_daily")%>

                            </td>

                        </tr>

                        <% } %>

                        <% if (!adaData) { %>

                        <tr>

                            <td colspan="5"
                                class="text-center p-8 text-gray-500 font-semibold">

                                Belum ada data health.

                            </td>

                        </tr>

                        <% }%>

                    </tbody>

                </table>

            </div>

            <a href="<%= request.getContextPath()%>/index.jsp"
               class="inline-block mt-8 bg-black text-white px-6 py-3 rounded-lg font-bold hover:bg-gray-800 transition">

                Back to Dashboard

            </a>

        </div>

    </body>

</html>