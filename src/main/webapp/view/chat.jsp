<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/view/Login.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Padel Community Chat</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Outfit:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #fcfcfc;
        }

        ::-webkit-scrollbar {
            width: 6px;
        }

        ::-webkit-scrollbar-thumb {
            background: #cfcfcf;
            border-radius: 10px;
        }
    </style>
</head>

<body class="bg-[#f3f3f3] overflow-hidden text-black antialiased">

<div class="flex h-screen w-full">

    <!-- SIDEBAR -->
    <div class="w-[360px] bg-white border-r-4 border-black flex flex-col z-10">

        <!-- LOGO -->
        <div class="p-6 border-b-4 border-black bg-white">
            <h1 class="text-4xl font-black leading-none uppercase italic tracking-tighter">
                <span>PADEL</span><span class="text-blue-400">APP</span>
            </h1>
            <p class="text-[9px] font-black text-gray-400 tracking-[0.2em] uppercase mt-2">
                COMMUNITY CHAT
            </p>
        </div>

        <!-- BACK BUTTON -->
        <div class="p-5 border-b border-gray-150">
            <a href="${pageContext.request.contextPath}/index.jsp" class="block">
                <button class="w-full bg-black text-white py-3.5 rounded-2xl font-black uppercase text-xs tracking-wider border-2 border-black shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-0.5 hover:translate-y-0.5 transition-all">
                    ← Back To Dashboard
                </button>
            </a>
        </div>

        <!-- TITLE & SEARCH -->
        <div class="px-5 pt-4 space-y-4">
            <h2 class="text-4xl font-black uppercase italic tracking-tight">
                Pesan
            </h2>
            <input
                id="search-input"
                type="text"
                placeholder="Cari percakapan..."
                class="w-full bg-[#f5f5f5] border-2 border-black rounded-xl px-4 py-3 text-sm font-semibold outline-none focus:bg-white shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] transition-all"
            >
        </div>

        <!-- FILTER -->
        <div class="flex gap-2 px-5 mt-4">
            <button data-filter="all" class="filter-btn bg-[#B6FF2D] text-black border-2 border-black px-4 py-2 rounded-xl text-xs font-black uppercase transition-all shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]">
                Semua
            </button>
            <button data-filter="group" class="filter-btn bg-[#f3f3f3] text-gray-600 border-2 border-transparent px-4 py-2 rounded-xl text-xs font-bold uppercase transition-all">
                Grup
            </button>
            <button data-filter="unread" class="filter-btn bg-[#f3f3f3] text-gray-600 border-2 border-transparent px-4 py-2 rounded-xl text-xs font-bold uppercase transition-all">
                Belum Dibaca
            </button>
        </div>

        <!-- CHAT LIST -->
        <div class="flex-1 overflow-y-auto p-5 space-y-3 mt-2">
            <c:choose>
                <c:when test="${empty chatRooms}">
                    <div class="text-center py-10">
                        <p class="text-xs text-gray-400 font-bold uppercase tracking-wider italic">Tidak ada chat aktif</p>
                        <a href="${pageContext.request.contextPath}/Profile" class="mt-4 inline-block text-[10px] font-black uppercase text-blue-500 hover:underline">
                            Cari Teman →
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="room" items="${chatRooms}">
                        <c:set var="partnerName" value="${not empty room.other_fullname ? room.other_fullname : room.other_username}" />
                        <a href="${pageContext.request.contextPath}/chat?idChat=${room.id_chat}" 
                           class="chat-room-item block" 
                           data-name="${partnerName}"
                           data-group="${room.is_group == 1}"
                           data-unread="${room.unread_count}">
                            <div class="p-4 rounded-3xl transition-all flex items-center gap-4 ${room.id_chat == selectedIdChat ? 'bg-[#f7f7f7] border-2 border-black shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]' : 'bg-white hover:bg-gray-50 border border-gray-200'}">
                                <!-- Avatar Initial -->
                                <div class="w-12 h-12 rounded-full bg-black text-white flex items-center justify-center font-black text-base shrink-0 border-2 border-black shadow-sm">
                                    <c:out value="${empty partnerName ? '?' : partnerName.substring(0,1).toUpperCase()}" />
                                </div>

                                <div class="flex-1 min-w-0">
                                    <div class="flex justify-between items-center gap-2">
                                        <h3 class="font-black text-base truncate text-black">
                                            <c:out value="${partnerName}" />
                                        </h3>
                                        <span class="text-[10px] font-bold text-gray-400 shrink-0 uppercase">
                                            <c:if test="${not empty room.last_message_time}">
                                                <fmt:formatDate value="${room.last_message_time}" pattern="HH:mm" />
                                            </c:if>
                                        </span>
                                    </div>
                                    <div class="flex justify-between items-center mt-1">
                                        <p class="text-xs truncate ${room.unread_count > 0 ? 'text-black font-black' : 'text-gray-400 font-semibold'}">
                                            <c:choose>
                                                <c:when test="${not empty room.last_message}">
                                                    <c:out value="${room.last_message}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="italic text-gray-300">Belum ada pesan</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <c:if test="${room.unread_count > 0}">
                                            <span class="bg-[#B6FF2D] text-black text-[9px] font-black w-5 h-5 rounded-full flex items-center justify-center border-2 border-black shadow-sm shrink-0">
                                                ${room.unread_count}
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- CHAT AREA -->
    <div class="flex-1 flex flex-col bg-[#f5f5f5]">
        <c:choose>
            <c:when test="${not empty selectedIdChat}">
                <!-- HEADER -->
                <div class="bg-white border-b-4 border-black px-10 py-5 flex items-center justify-between z-0">
                    <div class="flex items-center">
                        <c:set var="partnerName" value="${not empty activeChatPartner.fullname ? activeChatPartner.fullname : activeChatPartner.username}" />
                        <div class="w-14 h-14 rounded-full bg-black text-white flex items-center justify-center font-black text-xl border-4 border-black shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] shrink-0">
                            <c:out value="${empty partnerName ? '?' : partnerName.substring(0,1).toUpperCase()}" />
                        </div>
                        <div class="ml-5 text-left">
                            <h2 class="text-2xl font-black uppercase tracking-tight">
                                <c:out value="${partnerName}" />
                            </h2>
                            <p class="text-gray-400 font-bold uppercase text-[9px] tracking-widest flex items-center gap-1.5 mt-0.5">
                                <span class="w-2 h-2 bg-[#B6FF2D] rounded-full border border-black animate-pulse"></span> ONLINE
                            </p>
                        </div>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/Profile?viewUserId=${activeChatPartner.user_id}" class="text-xs font-black uppercase tracking-wider text-black border-2 border-black bg-white hover:bg-gray-50 px-4 py-2 rounded-xl shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-0.5 hover:translate-y-0.5 transition-all">
                            View Profile
                        </a>
                    </div>
                </div>

                <!-- CHAT CONTENT -->
                <div id="chat-container" class="flex-1 overflow-y-auto px-10 py-8 space-y-6">
                    <c:choose>
                        <c:when test="${empty chatMessages}">
                            <div class="flex flex-col items-center justify-center h-full text-center p-10">
                                <span class="text-4xl">👋</span>
                                <h3 class="font-black uppercase tracking-tight text-lg mt-4">Katakan Halo!</h3>
                                <p class="text-gray-400 font-bold text-xs uppercase tracking-wider mt-1">Belum ada pesan dalam obrolan ini.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="msg" items="${chatMessages}">
                                <c:choose>
                                    <c:when test="${msg.pengirim_id == sessionScope.user_id}">
                                        <!-- MESSAGE RIGHT -->
                                        <div class="flex justify-end">
                                            <div class="bg-[#B6FF2D] border-2 border-black rounded-3xl rounded-tr-none px-6 py-4 max-w-[500px] shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] text-left">
                                                <p class="text-sm font-semibold text-black leading-relaxed break-words">
                                                    <c:out value="${msg.isi_pesan}" />
                                                </p>
                                                <div class="flex items-center justify-end gap-1.5 mt-2">
                                                    <span class="text-[9px] font-black uppercase text-black/60">
                                                        <fmt:formatDate value="${msg.waktu_kirim}" pattern="HH:mm" />
                                                    </span>
                                                    <span>
                                                        <c:choose>
                                                            <c:when test="${msg.status == 'dibaca'}">
                                                                <span class="text-blue-700 font-black text-[9px] uppercase tracking-tighter" title="Read">✓✓</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-zinc-500 font-black text-[9px] uppercase" title="Sent">✓</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- MESSAGE LEFT -->
                                        <div class="flex items-end gap-3 justify-start">
                                            <div class="w-9 h-9 rounded-full bg-black text-white flex items-center justify-center font-black text-xs border-2 border-black shadow-sm shrink-0">
                                                <c:set var="senderName" value="${not empty msg.pengirim_fullname ? msg.pengirim_fullname : msg.pengirim_username}" />
                                                <c:out value="${empty senderName ? '?' : senderName.substring(0,1).toUpperCase()}" />
                                            </div>
                                            <div class="bg-white border-2 border-black rounded-3xl rounded-tl-none px-6 py-4 max-w-[450px] shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] text-left">
                                                <p class="text-sm font-semibold text-black leading-relaxed break-words">
                                                    <c:out value="${msg.isi_pesan}" />
                                                </p>
                                                <span class="text-[9px] font-black uppercase text-gray-400 block mt-2">
                                                    <fmt:formatDate value="${msg.waktu_kirim}" pattern="HH:mm" />
                                                </span>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- INPUT FORM -->
                <div class="bg-white border-t-4 border-black p-5">
                    <form action="${pageContext.request.contextPath}/chat" method="POST" class="flex items-center gap-4">
                        <input type="hidden" name="idChat" value="${selectedIdChat}">
                        <input
                            type="text"
                            name="pesan"
                            required
                            autocomplete="off"
                            placeholder="Tulis pesan..."
                            class="flex-1 bg-[#f5f5f5] border-2 border-black rounded-2xl px-6 py-4 outline-none text-base font-semibold shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] focus:bg-white focus:translate-y-0.5 focus:shadow-none transition-all"
                        >
                        <button
                            type="submit"
                            class="bg-[#6EA8FF] text-black border-2 border-black px-8 py-4 rounded-2xl font-black uppercase tracking-wider hover:bg-blue-300 transition-all shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] active:translate-x-0.5 active:translate-y-0.5 active:shadow-none"
                        >
                            Kirim
                        </button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <!-- EMPTY STATE -->
                <div class="flex-1 flex flex-col justify-center items-center p-10 bg-[#f5f5f5]">
                    <div class="max-w-md text-center space-y-6">
                        <div class="inline-block p-6 bg-pink-400 border-4 border-black rounded-3xl shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
                            <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="none" viewBox="0 0 24 24" stroke="black" stroke-width="2.5">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M8 10h8M8 14h5m-9 6l2.3-2.3A2 2 0 0 1 7.7 17H19a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h1" />
                            </svg>
                        </div>
                        <h2 class="text-4xl font-black uppercase italic tracking-tight text-black">
                            Start Chatting
                        </h2>
                        <p class="text-gray-500 font-bold leading-relaxed text-sm">
                            Pilih teman dari daftar percakapan di sebelah kiri untuk mulai mengobrol, atau hubungkan pertemanan baru dan kirim pesan langsung dari halaman profil mereka.
                        </p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<script>
    // 1. Auto scroll to bottom
    const chatContainer = document.getElementById('chat-container');
    if (chatContainer) {
        chatContainer.scrollTop = chatContainer.scrollHeight;
    }

    // 2. Search filter
    const searchInput = document.getElementById('search-input');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const keyword = this.value.toLowerCase().trim();
            const items = document.querySelectorAll('.chat-room-item');
            items.forEach(item => {
                const name = item.getAttribute('data-name').toLowerCase();
                if (name.includes(keyword)) {
                    item.style.display = '';
                } else {
                    item.style.display = 'none';
                }
            });
        });
    }

    // 3. Category filters
    const filterButtons = document.querySelectorAll('.filter-btn');
    filterButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            filterButtons.forEach(b => {
                b.classList.remove('bg-[#B6FF2D]', 'text-black', 'font-black', 'shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]');
                b.classList.add('bg-[#f3f3f3]', 'text-gray-600', 'border-transparent');
            });
            this.classList.remove('bg-[#f3f3f3]', 'text-gray-600', 'border-transparent');
            this.classList.add('bg-[#B6FF2D]', 'text-black', 'font-black', 'border-black', 'shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]');
            
            const filterType = this.getAttribute('data-filter');
            const items = document.querySelectorAll('.chat-room-item');
            items.forEach(item => {
                const isGroup = item.getAttribute('data-group') === 'true';
                const unreadCount = parseInt(item.getAttribute('data-unread') || '0', 10);
                
                if (filterType === 'all') {
                    item.style.display = '';
                } else if (filterType === 'group') {
                    if (isGroup) {
                        item.style.display = '';
                    } else {
                        item.style.display = 'none';
                    }
                } else if (filterType === 'unread') {
                    if (unreadCount > 0) {
                        item.style.display = '';
                    } else {
                        item.style.display = 'none';
                    }
                }
            });
        });
    });
</script>

</body>
</html>