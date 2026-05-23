<%-- 
    Document   : friendHealth
    Created on : 23 May 2026, 22.55.51
    Author     : Pongo
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int friendId
            = Integer.parseInt(
                    request.getParameter("friendId")
            );

    Connection conn = Koneksi.getConnection();

    String sql
            = "SELECT * FROM health_metrics "
            + "WHERE user_id=? "
            + "ORDER BY record_date DESC";

    PreparedStatement ps
            = conn.prepareStatement(sql);

    ps.setInt(1, friendId);

    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
    <head>

        <title>Friend Health</title>

        <script src="https://cdn.tailwindcss.com"></script>

    </head>

    <body class="bg-gray-100 min-h-screen p-10">

        <div class="max-w-5xl mx-auto bg-white p-10 rounded-3xl shadow-xl">

            <h1 class="text-5xl font-black uppercase mb-10">

                Friend Health

            </h1>

            <table class="w-full border-collapse">

                <thead>

                    <tr class="bg-black text-white">

                        <th class="p-4 text-left">Date</th>
                        <th class="p-4 text-left">Heart Rate</th>
                        <th class="p-4 text-left">BMI</th>
                        <th class="p-4 text-left">Steps</th>
                        <th class="p-4 text-left">Calories</th>

                    </tr>

                </thead>

                <tbody>

                    <% while (rs.next()) {%>

                    <tr class="border-b">

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

                    <% }%>

                </tbody>

            </table>

            <a href="${pageContext.request.contextPath}/viewFriends"
               class="inline-block mt-8 bg-black text-white px-6 py-3 rounded-lg">

                Back

            </a>

        </div>

    </body>
</html>