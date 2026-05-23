<%-- 
    Document   : searchfriend
    Created on : 23 May 2026, 21.47.09
    Author     : Pongo
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Integer userId
            = (Integer) session.getAttribute("user_id");

    if (userId == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/view/Login.html"
        );

        return;
    }

    Connection conn = Koneksi.getConnection();

    String sql
            = "SELECT f.friendship_id, "
            + "u.user_id, "
            + "u.username, "
            + "f.status, "
            + "f.user_id AS sender_id, "
            + "f.friend_id AS receiver_id "
            + "FROM friendships f "
            + "JOIN users u "
            + "ON ( "
            + "   (u.user_id = f.friend_id AND f.user_id = ?) "
            + "   OR "
            + "   (u.user_id = f.user_id AND f.friend_id = ?) "
            + ")";

    PreparedStatement ps
            = conn.prepareStatement(sql);

    ps.setInt(1, userId);
    ps.setInt(2, userId);

    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>

    <head>

        <title>Friend List</title>

        <script src="https://cdn.tailwindcss.com"></script>

    </head>

    <body class="bg-gray-100 min-h-screen p-10">

        <div class="max-w-6xl mx-auto bg-white p-10 rounded-3xl shadow-xl">

            <h1 class="text-5xl font-black uppercase mb-10">

                FRIEND LIST

            </h1>

            <!-- SEARCH FRIEND -->

            <form action="${pageContext.request.contextPath}/searchFriend"
                  method="GET"
                  class="flex gap-4 mb-10">

                <input
                    type="text"
                    name="keyword"
                    placeholder="Cari username..."
                    class="border p-4 rounded-lg w-full">

                <button
                    type="submit"
                    class="bg-black text-white px-6 rounded-lg">

                    Search

                </button>

            </form>

            <!-- TABLE -->

            <div class="overflow-x-auto">

                <table class="w-full border-collapse">

                    <thead>

                        <tr class="bg-black text-white">

                            <th class="p-4 text-left">User ID</th>

                            <th class="p-4 text-left">Username</th>

                            <th class="p-4 text-left">Status</th>

                            <th class="p-4 text-left">Action</th>

                        </tr>

                    </thead>

                    <tbody>

                        <%
                            boolean adaTeman = false;

                            while (rs.next()) {

                                adaTeman = true;

                                int senderId
                                        = rs.getInt("sender_id");

                                int receiverId
                                        = rs.getInt("receiver_id");

                                String status
                                        = rs.getString("status");

                                boolean isReceiver
                                        = receiverId == userId;
                        %>

                        <tr class="border-b hover:bg-gray-100">

                            <td class="p-4">

                                <%= rs.getInt("user_id")%>

                            </td>

                            <td class="p-4">

                                <%= rs.getString("username")%>

                            </td>

                            <td class="p-4">

                                <%= status%>

                            </td>

                            <td class="p-4 flex gap-2">

                                <% if ("PENDING".equals(status)
                                            && isReceiver) {%>

                                <!-- ACCEPT -->

                                <form action="${pageContext.request.contextPath}/acceptFriend"
                                      method="POST">

                                    <input type="hidden"
                                           name="friendshipId"
                                           value="<%= rs.getInt("friendship_id")%>">

                                    <button
                                        class="bg-green-500 text-white px-4 py-2 rounded">

                                        Accept

                                    </button>

                                </form>

                                <% }%>

                                <!-- REMOVE -->

                                <form action="${pageContext.request.contextPath}/removeFriend"
                                      method="POST">

                                    <input type="hidden"
                                           name="friendshipId"
                                           value="<%= rs.getInt("friendship_id")%>">

                                    <button
                                        class="bg-red-500 text-white px-4 py-2 rounded">

                                        Remove

                                    </button>

                                </form>

                                <!-- TRACK HEALTH -->

                                <a href="${pageContext.request.contextPath}/view/friendHealth.jsp?friendId=<%= rs.getInt("user_id")%>"
                                   class="bg-blue-500 text-white px-4 py-2 rounded">

                                    Track Health

                                </a>

                            </td>

                        </tr>

                        <%
                            }

                            if (!adaTeman) {
                        %>

                        <tr>

                            <td colspan="4"
                                class="text-center p-10 text-gray-500">

                                Belum ada teman.

                            </td>

                        </tr>

                        <%
                            }
                        %>

                    </tbody>

                </table>

            </div>

            <!-- BUTTON -->

            <div class="flex gap-4 mt-10">

                <a href="${pageContext.request.contextPath}/searchFriend"
                   class="bg-blue-600 text-white px-6 py-3 rounded-lg font-bold">

                    Search Friend

                </a>

                <a href="${pageContext.request.contextPath}/index.jsp"
                   class="bg-black text-white px-6 py-3 rounded-lg font-bold">

                    Back

                </a>

            </div>

        </div>

    </body>

</html>