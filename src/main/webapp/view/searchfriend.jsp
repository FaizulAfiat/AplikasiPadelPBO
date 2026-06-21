<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/view/Login.html");
        return;
    }
    String uname = (String) session.getAttribute("user");
    String initial = (uname != null && !uname.isEmpty()) ? uname.substring(0, 1).toUpperCase() : "?";
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Friends - PadelApp</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .border-grid {
            border-color: #e5e5e5;
        }
        body {
            font-family: 'Inter', sans-serif;
            background-color: #fcfcfc;
        }
    </style>
</head>
<body class="bg-[#FCFCFC] text-black min-h-screen flex flex-col antialiased">
    <!-- Header -->
    <header class="flex border-b border-grid bg-white sticky top-0 z-50">
        <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
            <span class="text-[10px] font-bold uppercase block opacity-50 md:text-xs">01 / Padel Management</span>
            <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">Padel<span class="text-blue-400">App</span></h1>
        </div>

        <div class="flex-1 border-r border-grid hidden md:flex items-center px-8 bg-white">
            <a href="${pageContext.request.contextPath}/index.jsp" class="text-xs font-bold uppercase tracking-widest hover:underline flex items-center gap-1">
                ← Back to Dashboard
            </a>
        </div>

        <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4 md:gap-6 bg-white">
            <div class="flex items-center gap-2 group cursor-pointer" onclick="window.location.href='${pageContext.request.contextPath}/Profile'">
                <div class="w-8 h-8 rounded-full bg-black text-white flex items-center justify-center font-bold uppercase text-xs shadow-sm">
                    <%= initial %>
                </div>
                <span class="hidden lg:inline text-[10px] font-bold uppercase tracking-widest text-zinc-600">
                    @<%= uname %>
                </span>
            </div>
        </div>
    </header>

    <main class="flex flex-col md:flex-row flex-1">
        <!-- Left Panel -->
        <aside class="w-full md:w-1/3 p-8 border-b md:border-b-0 md:border-r border-grid bg-white">
            <span class="text-xs font-bold uppercase block mb-2 tracking-widest text-gray-400">02 / Search</span>
            <h2 class="text-4xl font-black leading-none uppercase mb-8 tracking-tighter">Find Friends</h2>
            
            <form action="${pageContext.request.contextPath}/SearchFriendController" method="GET" class="space-y-4">
                <div class="border-b-2 border-black pb-2">
                    <label class="text-[10px] font-bold uppercase opacity-50 block mb-2">Username</label>
                    <input type="text" name="keyword" value="${keyword}" placeholder="Type username..." class="w-full bg-transparent text-xl font-black outline-none placeholder:text-gray-300 uppercase" required>
                </div>
                <button type="submit" class="w-full bg-black text-white py-4 rounded-xl font-black uppercase text-xs tracking-wider hover:bg-zinc-800 transition-colors shadow-sm active:scale-[0.98]">
                    Search Users
                </button>
            </form>
        </aside>

        <!-- Right Panel (Search Results) -->
        <div class="flex-1 p-8 bg-[#FCFCFC]">
            <h3 class="text-lg font-bold uppercase tracking-tight flex items-center gap-2 mb-6">
                <span class="w-2.5 h-2.5 bg-blue-500 rounded-full"></span>
                Search Results for "${keyword}"
            </h3>

            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:choose>
                    <c:when test="${empty searchResults}">
                        <div class="col-span-full py-16 text-center text-gray-400 font-bold uppercase tracking-widest bg-white border border-grid rounded-3xl shadow-sm">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-12 h-12 mx-auto mb-3 opacity-30">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M18 18.72a9.094 9.094 0 0 0 3.741-.479 3 3 0 0 0-4.682-2.72m.94 3.198.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058 2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477m.94-3.197a5.971 5.971 0 0 0-.94-3.197M15 6.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Z" />
                            </svg>
                            No users found matching your search.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="res" items="${searchResults}">
                            <!-- User Card -->
                            <div class="border border-grid rounded-2xl p-6 bg-white shadow-sm flex flex-col justify-between hover:shadow-md transition-all duration-300 transform hover:-translate-y-1">
                                <div>
                                    <div class="w-12 h-12 bg-black text-white rounded-full flex items-center justify-center font-bold uppercase text-lg mb-4">
                                        <c:out value="${res.username.substring(0,1).toUpperCase()}" />
                                    </div>
                                    <h4 class="font-black text-lg uppercase tracking-tight text-black">@${res.username}</h4>
                                    <p class="text-xs text-gray-500 font-medium truncate mb-6">${res.email}</p>
                                </div>

                                <div class="pt-4 border-t border-gray-100 flex items-center justify-between">
                                    <c:choose>
                                        <c:when test="${res.status eq 'NONE'}">
                                            <!-- Add Friend Form -->
                                            <form action="${pageContext.request.contextPath}/FriendActionController" method="POST" class="w-full">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="friendId" value="${res.userId}">
                                                <input type="hidden" name="keyword" value="${keyword}">
                                                <button type="submit" class="w-full bg-blue-400 text-black border border-black hover:bg-cyan-300 font-bold uppercase text-[10px] tracking-wider py-2.5 rounded-xl transition-all shadow-sm">
                                                    Add Friend +
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:when test="${res.status eq 'PENDING'}">
                                            <c:choose>
                                                <c:when test="${res.senderId eq user_id}">
                                                    <!-- Request Sent Badge -->
                                                    <span class="w-full text-center py-2.5 border border-gray-200 bg-gray-50 text-gray-400 rounded-xl font-bold uppercase text-[10px] tracking-wider cursor-not-allowed">
                                                        Request Sent
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Incoming Request Actions -->
                                                    <div class="flex gap-2 w-full">
                                                        <form action="${pageContext.request.contextPath}/FriendActionController" method="POST" class="flex-1">
                                                            <input type="hidden" name="action" value="accept">
                                                            <input type="hidden" name="friendshipId" value="${res.friendshipId}">
                                                            <input type="hidden" name="keyword" value="${keyword}">
                                                            <button type="submit" class="w-full bg-black text-white hover:bg-zinc-800 font-bold uppercase text-[10px] tracking-wider py-2.5 rounded-xl transition-all">
                                                                Accept
                                                            </button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/FriendActionController" method="POST" class="flex-1">
                                                            <input type="hidden" name="action" value="reject">
                                                            <input type="hidden" name="friendshipId" value="${res.friendshipId}">
                                                            <input type="hidden" name="keyword" value="${keyword}">
                                                            <button type="submit" class="w-full bg-white text-gray-500 hover:text-red-500 border border-gray-200 hover:border-red-200 font-bold uppercase text-[10px] tracking-wider py-2.5 rounded-xl transition-all">
                                                                Reject
                                                            </button>
                                                        </form>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:when test="${res.status eq 'ACCEPTED'}">
                                            <!-- Friend Badge and Unfriend Action -->
                                            <div class="flex flex-col gap-2 w-full">
                                                <span class="w-full text-center py-2 bg-green-50 text-green-700 border border-green-200 rounded-xl font-black uppercase text-[10px] tracking-wider">
                                                    ✓ Friends
                                                </span>
                                                <form action="${pageContext.request.contextPath}/FriendActionController" method="POST" class="w-full">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="friendshipId" value="${res.friendshipId}">
                                                    <input type="hidden" name="keyword" value="${keyword}">
                                                    <button type="submit" onclick="return confirm('Apakah Anda yakin ingin menghapus pertemanan ini?');" class="w-full text-center text-red-500 hover:text-red-700 font-bold uppercase text-[9px] tracking-widest transition-colors mt-1">
                                                        Unfriend
                                                    </button>
                                                </form>
                                            </div>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</body>
</html>
