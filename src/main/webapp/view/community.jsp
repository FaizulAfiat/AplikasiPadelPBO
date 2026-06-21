<%--
Document   : community
Created on : 11 May 2026, 13.04.17
Author     : ALFIAN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Community - PadelApp</title>
<script src="https://cdn.tailwindcss.com"></script>
<style>
.border-grid { border-color: #e5e5e5; }
.brutalist-shadow { box-shadow: 8px 8px 0px 0px rgba(0,0,0,1); }
.slot-in-range {
    background-color: #22d3ee !important;
    border-color: #0891b2 !important;
    color: #000 !important;
}
.slot-start, .slot-end {
    background-color: #000 !important;
    color: #fff !important;
    border-color: #000 !important;
}
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
        <a href="index.jsp" class="text-xs font-bold uppercase tracking-widest hover:underline">← Back to Dashboard</a>
        <span class="mx-4 text-gray-300">/</span>
        <span class="text-xs font-bold uppercase tracking-widest text-blue-400">Community</span>
    </div>
    <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4">
        <a href="AchievementController" class="text-[10px] font-bold uppercase tracking-widest hover:text-blue-500">Achievements</a>
        <span class="text-[10px] font-bold uppercase tracking-widest border-l border-grid pl-4">
            <%= session.getAttribute("user")%>
        </span>
        <div class="p-2 border-2 border-black bg-white">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
            </svg>
        </div>
    </div>
</header>

<main class="flex flex-col md:flex-row flex-1">
    <div class="w-full md:w-1/3 p-8 md:p-12 border-b md:border-b-0 md:border-r border-grid bg-white">
        <span class="text-xs font-bold uppercase block mb-4 opacity-50">04 / Community Interaction</span>
        <h2 class="text-5xl md:text-7xl font-black leading-none uppercase mb-8 tracking-tighter">
            The <span class="text-blue-400">Community.</span>
        </h2>
        <p class="text-gray-500 uppercase font-bold text-xs leading-relaxed italic mb-10">
            Cari grup tanding, kumpul komunitas, atau buat klub padel Anda sendiri sekarang juga.
        </p>

        <a href="CreateCommunityController" class="inline-block w-full text-center bg-black text-white px-8 py-5 font-black uppercase tracking-widest text-sm hover:bg-blue-400 hover:text-black transition-all brutalist-shadow">
            Create New Community +
        </a>

        <a href="MySquadController" class="inline-block w-full text-center bg-white text-black border-4 border-black mt-4 px-8 py-5 font-black uppercase tracking-widest text-sm hover:bg-blue-400 transition-all shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
            View My Club →
        </a>
    </div>

    <div class="flex-1 p-8 md:p-12 bg-gray-50">
        <div class="flex justify-between items-end border-b-2 border-black pb-4 mb-8">
            <label class="text-xs font-bold uppercase opacity-50">Nearby Communities</label>
            <span class="text-[10px] font-black uppercase tracking-tighter">Sorted by: Newest</span>
        </div>

        <%-- Status feedback --%>
        <% String status = request.getParameter("status");
           if ("success".equals(status)) { %>
        <div class="mb-6 bg-lime-400 border-4 border-black px-6 py-4 font-black uppercase text-sm shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
            ✓ Community berhasil dibuat!
        </div>
        <% } else if ("already_exists".equals(status)) { %>
        <div class="mb-6 bg-red-100 border-4 border-red-500 px-6 py-4 font-black uppercase text-sm text-red-700">
            ⚠ Nama klub sudah digunakan!
        </div>
        <% } else if ("empty_field".equals(status)) { %>
        <div class="mb-6 bg-red-100 border-4 border-red-500 px-6 py-4 font-black uppercase text-sm text-red-700">
            ⚠ Nama dan deskripsi wajib diisi!
        </div>
        <% } else if ("joined_success".equals(status)) { %>
        <div class="mb-6 bg-lime-400 border-4 border-black px-6 py-4 font-black uppercase text-sm shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
            ✓ Berhasil bergabung dengan squad!
        </div>
        <% } else if ("already_joined".equals(status)) { %>
        <div class="mb-6 bg-yellow-300 border-4 border-black px-6 py-4 font-black uppercase text-sm shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
            ⚠ Kamu sudah bergabung dengan squad ini!
        </div>
        <% } else if ("error_db".equals(status) || "error".equals(status)) { %>
        <div class="mb-6 bg-red-100 border-4 border-red-500 px-6 py-4 font-black uppercase text-sm text-red-700">
            ⚠ Terjadi kesalahan sistem. Silakan coba lagi!
        </div>
        <% } else if ("already_requested".equals(status)) { %>
        <div class="mb-6 bg-yellow-300 border-4 border-black px-6 py-4 font-black uppercase text-sm shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
            ⚠ Permintaan bergabung masih menunggu persetujuan Admin!
        </div>
        <% } else if ("request_sent".equals(status)) { %>
        <div class="mb-6 bg-blue-300 border-4 border-black px-6 py-4 font-black uppercase text-sm shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
            ✓ Permintaan bergabung terkirim! Menunggu persetujuan Admin.
        </div>
        <% } %>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <c:forEach var="club" items="${listClub}">
            <div class="bg-white border-2 border-black p-6 flex flex-col justify-between brutalist-shadow hover:translate-x-1 hover:translate-y-1 hover:shadow-none transition-all">
                <div>
                    <div class="flex justify-between items-start mb-4">
                        <h3 class="text-2xl font-black uppercase tracking-tighter leading-none">${club.name}</h3>
                        <div class="flex gap-2">
                            <span class="${club.type == 'PRIVATE' ? 'bg-red-500 text-white' : 'bg-lime-400 text-black'} text-[10px] font-black px-2 py-1 border border-black uppercase">${club.type}</span>
                            <span class="bg-blue-400 text-[10px] font-black px-2 py-1 border border-black uppercase">${club.status}</span>
                        </div>
                    </div>
                    <p class="text-xs font-bold text-gray-500 uppercase mb-6 leading-relaxed">
                        ${club.description}
                    </p>
                </div>
                <div class="flex gap-2">
                    <button onclick="showDetail('${club.club_id}')" class="flex-1 text-center bg-black text-white py-3 font-bold uppercase text-[10px] tracking-widest hover:bg-blue-400 hover:text-black transition-colors cursor-pointer border-2 border-black">
                        View Detail
                    </button>
                    <a href="JoinController?club_id=${club.club_id}" class="flex-1 text-center border-2 border-black py-3 font-bold uppercase text-[10px] tracking-widest hover:bg-black hover:text-white transition-all">
                        Join Squad →
                    </a>
                </div>
            </div>
            </c:forEach>

            <c:if test="${empty listClub}">
            <div class="col-span-full border-2 border-dashed border-gray-300 p-12 text-center">
                <p class="text-xs font-bold uppercase opacity-30 italic">No communities found. Be the first to create one!</p>
            </div>
            </c:if>
        </div>
    </div>
</main>

<footer class="p-6 border-t border-grid bg-white">
    <p class="text-[10px] font-bold uppercase opacity-50 tracking-widest">© 2026 PadelApp Ecosystem - Project Tugas Besar PBO</p>
</footer>

<div id="modalDetail" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
    <div class="bg-white border-4 border-black w-full max-w-2xl shadow-[12px_12px_0px_0px_rgba(0,0,0,1)] relative">
        <button onclick="hideModal()" class="absolute -top-4 -right-4 bg-red-500 text-white border-4 border-black w-12 h-12 flex items-center justify-center font-black text-xl hover:bg-black transition-colors cursor-pointer">X</button>
        <div class="p-8">
            <div class="border-b-4 border-black pb-4 mb-6">
                <span id="mCreator" class="text-[10px] font-black uppercase text-blue-600 tracking-widest bg-blue-100 border border-black px-2 py-1"></span>
                <h2 id="mTitle" class="text-4xl md:text-5xl font-black uppercase tracking-tighter mt-2"></h2>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                <div class="space-y-6">
                    <div>
                        <h4 class="text-xs font-black uppercase opacity-40 mb-2 underline decoration-2 underline-offset-4">About Squad</h4>
                        <p id="mDesc" class="font-bold text-sm leading-relaxed uppercase"></p>
                    </div>
                    
                    <div class="border-2 border-black p-4 bg-white shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] mt-2">
                        <h4 class="text-[10px] font-black uppercase mb-3 bg-black text-white px-2 py-1 inline-block">Recent Match History</h4>
                        <div class="flex flex-col gap-2">
                            <div class="flex justify-between items-center text-xs font-bold border-b border-gray-200 pb-2">
                                <span>VS <span class="opacity-50">Smashers Club</span></span> <span class="bg-lime-400 border border-black px-2 py-1 shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]">WIN (6-4, 6-2)</span>
                            </div>
                            <div class="flex justify-between items-center text-xs font-bold pb-1 pt-1">
                                <span>VS <span class="opacity-50">Net Ninjas</span></span> <span class="bg-red-400 text-white border border-black px-2 py-1 shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]">LOSS (3-6, 5-7)</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="bg-gray-100 border-2 border-black p-4 h-full shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
                    <h4 class="text-xs font-black uppercase mb-4 flex items-center gap-2 border-b-2 border-black pb-2">
                        <div class="w-2 h-2 bg-lime-400 border border-black rounded-full"></div>
                        Squad Members
                    </h4>
                    <ul id="mMembers" class="text-sm font-bold space-y-2 uppercase max-h-80 overflow-y-auto pr-2"></ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function showDetail(clubId) {
    const modal = document.getElementById('modalDetail');
    const listMembers = document.getElementById('mMembers');

    document.getElementById('mTitle').innerText = "LOADING...";
    document.getElementById('mDesc').innerText = "Mohon tunggu sebentar...";
    document.getElementById('mCreator').innerText = "FETCHING DATA...";
    listMembers.innerHTML = "<li class='animate-pulse'>Menarik data...</li>";

    modal.classList.remove('hidden');

    fetch('ClubDetailController?format=json&id=' + clubId)
    .then(response => response.json())
    .then(data => {
        if (data.error) {
            alert("Error mengambil data!");
            return;
        }
        document.getElementById('mTitle').innerText = data.name;
        document.getElementById('mDesc').innerText = data.desc;
        document.getElementById('mCreator').innerText = "FOUNDED BY " + data.creator;

        listMembers.innerHTML = "";
        if (data.members.length === 0) {
            listMembers.innerHTML = "<li class='opacity-40 italic'>No members yet. Be the first!</li>";
        } else {
            data.members.forEach(member => {
                listMembers.innerHTML += '<li class="border-b border-black/10 pb-1">→ ' + member + '</li>';
            });
        }
    })
    .catch(error => {
        console.error('Error:', error);
        document.getElementById('mTitle').innerText = "ERROR";
    });
}

function hideModal() {
    document.getElementById('modalDetail').classList.add('hidden');
}
</script>
</body>
</html>