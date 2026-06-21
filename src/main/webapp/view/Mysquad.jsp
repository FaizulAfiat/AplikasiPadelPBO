<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Squads - PadelApp</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            .border-grid { border-color: #e5e5e5; }
            .brutalist-shadow-sm { box-shadow: 4px 4px 0px 0px rgba(0,0,0,1); }
        </style>
    </head>
    <body class="bg-white text-black min-h-screen flex flex-col">

        <header class="flex border-b border-grid bg-white sticky top-0 z-50">
            <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
                <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">
                    Padel<span class="text-blue-400">App</span>
                </h1>
            </div>
            <div class="flex-1 border-r border-grid hidden md:flex items-center px-8">
                <a href="CommunityController" class="text-xs font-bold uppercase tracking-widest hover:underline">← Back to Community</a>
                <span class="mx-4 text-gray-300">/</span>
                <span class="text-xs font-bold uppercase tracking-widest text-blue-400">My Squads</span>
            </div>
            <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4">
                <a href="AchievementController" class="text-[10px] font-bold uppercase tracking-widest hover:text-blue-500">Achievements</a>
                <span class="text-[10px] font-bold uppercase tracking-widest border-l border-grid pl-4">
                    <%= (session.getAttribute("user") != null) ? session.getAttribute("user") : "PLAYER" %>
                </span>
            </div>
        </header>

        <main class="flex flex-col md:flex-row flex-1">
            <div class="w-full md:w-1/3 p-8 md:p-12 border-b md:border-b-0 md:border-r border-grid bg-white">
                <span class="text-xs font-bold uppercase block mb-4 opacity-50">05 / Personalized Groups</span>
                <h2 class="text-5xl md:text-7xl font-black leading-none uppercase mb-8 tracking-tighter">
                    My <span class="text-blue-400">Squads.</span>
                </h2>
                <a href="CommunityController" class="inline-block w-full text-center bg-black text-white px-8 py-5 font-black uppercase tracking-widest text-sm hover:bg-blue-400 hover:text-black transition-all brutalist-shadow-sm">
                    Find More Communities
                </a>
            </div>

            <div class="flex-1 p-8 md:p-12 bg-gray-50">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                    <%
                        Object dataAttr = request.getAttribute("listMySquad");
                        if (dataAttr != null) {
                            java.util.List<java.util.Map<String, Object>> listSquads = (java.util.List<java.util.Map<String, Object>>) dataAttr;
                            if (!listSquads.isEmpty()) {
                                for (java.util.Map<String, Object> clubItem : listSquads) {
                    %>
                        <div class="bg-white border-2 border-black p-6 flex flex-col justify-between brutalist-shadow-sm hover:translate-x-1 hover:translate-y-1 hover:shadow-none transition-all">
                            <div>
                                <h3 class="text-2xl font-black uppercase tracking-tighter mb-2"><%= clubItem.get("name") %></h3>
                                <p class="text-xs font-bold text-gray-500 uppercase mb-6"><%= clubItem.get("description") %></p>
                            </div>
                            <div class="flex gap-2">
                                <a href="ClubDetailController?id=<%= clubItem.get("club_id") %>" class="flex-1 text-center bg-black text-white py-3 font-bold uppercase text-[10px] border-2 border-black hover:bg-blue-400 transition-colors block leading-[normal] flex items-center justify-center">View Detail</a>
                                <button onclick="showLeaveModal('<%= clubItem.get("club_id") %>', '<%= clubItem.get("name").toString().replace("'", "\\'") %>')" class="flex-1 text-center border-2 border-black py-3 font-bold uppercase text-[10px] hover:bg-red-500 hover:text-white transition-all cursor-pointer">Leave X</button>
                            </div>
                        </div>
                    <% 
                                }
                            } else { 
                    %>
                        <div class="col-span-full border-2 border-dashed border-gray-300 p-12 text-center text-gray-400">
                            <p class="text-xs font-bold uppercase italic">Anda belum bergabung dengan komunitas manapun.</p>
                        </div>
                    <% 
                            }
                        }
                    %>
                </div>
            </div>
        </main>

        <div id="modalLeave" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
            <div class="bg-white border-4 border-black w-full max-w-md shadow-[12px_12px_0px_0px_rgba(0,0,0,1)] p-8">
                <h2 class="text-3xl font-black uppercase tracking-tighter mb-4 text-red-500">Leave Squad?</h2>
                <p class="font-bold text-sm mb-8 uppercase text-gray-600">Are you sure you want to leave <span id="leaveClubName" class="text-black font-black bg-yellow-200 px-1 border border-black"></span>? You will lose access to team updates and tournaments.</p>
                <div class="flex gap-4">
                    <button onclick="hideLeaveModal()" class="flex-1 border-2 border-black py-3 font-black uppercase text-xs hover:bg-gray-100 transition-colors">Cancel</button>
                    <a id="confirmLeaveBtn" href="#" class="flex-1 bg-red-500 text-white border-2 border-black py-3 font-black uppercase text-xs text-center hover:bg-black transition-colors shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">Yes, Leave</a>
                </div>
            </div>
        </div>

        <script>
        function showLeaveModal(clubId, clubName) {
            document.getElementById('leaveClubName').innerText = clubName;
            document.getElementById('confirmLeaveBtn').href = 'LeaveController?club_id=' + clubId;
            document.getElementById('modalLeave').classList.remove('hidden');
        }

        function hideLeaveModal() {
            document.getElementById('modalLeave').classList.add('hidden');
        }
        function hideModal() {
            document.getElementById('modalDetail').classList.add('hidden');
        }
        </script>
    </body>
</html>