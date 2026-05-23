<%-- 
    Document   : searchfriend
    Created on : 23 May 2026, 22.49.44
    Author     : Pongo
--%>

<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    ArrayList<String[]> users
            = (ArrayList<String[]>) request.getAttribute("users");
%>

<!DOCTYPE html>
<html>

    <head>

        <title>Search Friend</title>

        <script src="https://cdn.tailwindcss.com"></script>

    </head>

    <body class="bg-gray-100 min-h-screen p-10">

        <div class="max-w-5xl mx-auto bg-white p-10 rounded-3xl shadow-xl">

            <h1 class="text-5xl font-black uppercase mb-10">

                SEARCH FRIEND

            </h1>

            <table class="w-full border-collapse">

                <thead>

                    <tr class="bg-black text-white">

                        <th class="p-4 text-left">User ID</th>

                        <th class="p-4 text-left">Username</th>

                        <th class="p-4 text-left">Action</th>

                    </tr>

                </thead>

                <tbody>

                    <%
                        if (users != null && !users.isEmpty()) {

                            for (String[] user : users) {
                    %>

                    <tr class="border-b">

                        <td class="p-4">

                            <%= user[0]%>

                        </td>

                        <td class="p-4">

                            <%= user[1]%>

                        </td>

                        <td class="p-4">

                            <form action="${pageContext.request.contextPath}/addFriend"
                                  method="POST">

                                <input type="hidden"
                                       name="friendId"
                                       value="<%= user[0]%>">

                                <button
                                    type="submit"
                                    class="bg-blue-500 text-white px-4 py-2 rounded">

                                    Add Friend

                                </button>

                            </form>

                        </td>

                    </tr>

                    <%
                        }

                    } else {
                    %>

                    <tr>

                        <td colspan="3"
                            class="text-center p-10 text-gray-500">

                            User tidak ditemukan.

                        </td>

                    </tr>

                    <%
                        }
                    %>

                </tbody>

            </table>

            <a href="${pageContext.request.contextPath}/viewFriends"
               class="inline-block mt-8 bg-black text-white px-6 py-3 rounded-lg font-bold">

                Back

            </a>

        </div>

    </body>

</html>