<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<% if (session.getAttribute("user") == null) { response.sendRedirect(request.getContextPath() + "/view/Login.html"); } %>
<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Music Request Queue - PadelApp</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .border-grid {
            border-color: #e5e5e5;
        }
        body {
            font-family: 'Inter', sans-serif;
        }
        .no-scrollbar::-webkit-scrollbar {
            display: none;
        }
        .no-scrollbar {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }
        @keyframes shrink {
            from { width: 100%; }
            to   { width: 0%; }
        }
        .song-progress-bar {
            animation-name: shrink;
            animation-timing-function: linear;
            animation-fill-mode: forwards;
        }
    </style>
</head>

<body class="bg-[#f9fafb] text-black min-h-screen flex flex-col">
    <!-- HEADER -->
    <header class="flex border-b border-grid bg-white sticky top-0 z-50">
        <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
            <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">Padel<span class="text-blue-400">App</span></h1>
        </div>
        <div class="flex-1 border-r border-grid hidden md:flex items-center px-8">
            <a href="${pageContext.request.contextPath}/index.jsp" class="text-xs font-bold uppercase tracking-widest hover:underline">
                ← Back to Dashboard
            </a>
        </div>
        <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4">
            <span class="text-[10px] font-bold uppercase tracking-widest bg-gray-100 px-3 py-1.5 border border-black rounded-lg">
                <%= session.getAttribute("user") %> (${role})
            </span>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
            </svg>
        </div>
    </header>

    <!-- MAIN BODY -->
    <main class="flex flex-col md:flex-row flex-1">
        <!-- LEFT PANEL: Info & Request Form -->
        <div class="w-full md:w-1/3 p-8 md:p-12 border-b md:border-b-0 md:border-r border-grid bg-white flex flex-col justify-between">
            <div>
                <span class="text-xs font-bold uppercase block mb-4 opacity-50">05 / DJ Request</span>
                <h2 class="text-5xl md:text-6xl font-black leading-none uppercase mb-6 tracking-tighter">
                    Request Your Beats
                </h2>
                <p class="text-gray-500 text-sm leading-relaxed mb-8">
                    Isi antrean musik di lapangan Padel kami! Berbagi lagu favoritmu agar permainan semakin seru dan berenergi.
                </p>

                <!-- LIMIT BADGE/INDICATOR -->
                <div class="mb-8 border-2 border-black p-4 rounded-xl shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] bg-[#f3f4f6]">
                    <span class="text-[10px] font-bold uppercase opacity-50 block mb-1">Status Kuota Request</span>
                    <c:choose>
                        <c:when test="${role eq 'Premium' || role eq 'Admin'}">
                            <div class="flex items-center gap-2">
                                <span class="text-purple-600 font-extrabold uppercase text-lg flex items-center gap-1 animate-pulse">
                                    Premium Unlimited 🌟
                                </span>
                            </div>
                            <span class="text-[11px] text-gray-500 font-semibold block mt-1">Anda memiliki akses tak terbatas untuk request musik!</span>
                        </c:when>
                        <c:otherwise>
                            <div class="flex justify-between items-center">
                                <span class="text-xl font-black">${activeCount} / ${limit}</span>
                                <span class="text-[10px] font-bold uppercase px-2 py-1 bg-blue-100 text-blue-800 rounded border border-blue-300">Regular Account</span>
                            </div>
                            <!-- progress bar -->
                            <div class="w-full bg-gray-300 h-3 border border-black rounded-full mt-2 overflow-hidden">
                                <div class="bg-blue-400 h-full border-r border-black" style="width: ${(activeCount / limit) * 100}%"></div>
                            </div>
                            <span class="text-[11px] text-gray-500 font-medium block mt-1.5">Max 3 request aktif. Upgrade ke Premium untuk request sepuasnya!</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- REQUEST FORM -->
                <form action="${pageContext.request.contextPath}/MusicController" method="POST" class="space-y-6">
                    <input type="hidden" name="action" value="add">

                    <div class="border-b-2 border-black pb-2">
                        <label for="song_title" class="text-xs font-bold uppercase opacity-50 block mb-1">Judul Lagu</label>
                        <input type="text" id="song_title" name="song_title" placeholder="Contoh: Dynamite" class="w-full bg-transparent text-xl font-black outline-none placeholder-gray-300" required>
                    </div>

                    <div class="border-b-2 border-black pb-2">
                        <label for="artist" class="text-xs font-bold uppercase opacity-50 block mb-1">Penyanyi / Artis</label>
                        <input type="text" id="artist" name="artist" placeholder="Contoh: BTS" class="w-full bg-transparent text-xl font-black outline-none placeholder-gray-300" required>
                    </div>

                    <div class="grid grid-cols-2 gap-4 pb-2 border-b-2 border-black">
                        <div>
                            <label for="duration_minutes" class="text-xs font-bold uppercase opacity-50 block mb-1">Durasi (Menit)</label>
                            <input type="number" id="duration_minutes" name="duration_minutes" min="0" max="20" value="4" class="w-full bg-transparent text-xl font-black outline-none" required>
                        </div>
                        <div>
                            <label for="duration_seconds" class="text-xs font-bold uppercase opacity-50 block mb-1">Durasi (Detik)</label>
                            <input type="number" id="duration_seconds" name="duration_seconds" min="0" max="59" value="0" class="w-full bg-transparent text-xl font-black outline-none" required>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${role eq 'Regular' && activeCount >= limit}">
                            <button type="button" disabled class="w-full bg-gray-300 text-gray-500 px-8 py-4 font-black uppercase tracking-widest text-sm border-2 border-black cursor-not-allowed shadow-[4px_4px_0px_0px_rgba(0,0,0,0.5)]">
                                Limit Tercapai 🚫
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="submit" class="w-full bg-black text-white hover:bg-[#B6FF2D] hover:text-black px-8 py-4 font-black uppercase tracking-widest text-sm border-2 border-black transition-all shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] hover:translate-x-[2px] hover:translate-y-[2px] hover:shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
                                Request Song 🎵
                            </button>
                        </c:otherwise>
                    </c:choose>
                </form>
            </div>

            <!-- Dashboard Back Link for Mobile -->
            <div class="mt-8 md:hidden">
                <a href="${pageContext.request.contextPath}/index.jsp" class="text-xs font-bold uppercase tracking-widest text-blue-500 hover:underline">
                    ← Back to Dashboard
                </a>
            </div>
        </div>

        <!-- RIGHT PANEL: Queue list & Recently Played -->
        <div class="flex-1 p-8 md:p-12 bg-white md:overflow-y-auto flex flex-col gap-10">
            <!-- TOAST MESSAGES -->
            <c:if test="${not empty param.status}">
                <div id="status-toast" class="border-4 border-black p-5 rounded-2xl font-black uppercase italic shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between
                    <c:choose>
                        <c:when test="${param.status eq 'success'}">bg-emerald-400</c:when>
                        <c:when test="${param.status eq 'limit_reached'}">bg-amber-400</c:when>
                        <c:when test="${param.status eq 'invalid_input' || param.status eq 'unauthorized' || param.status eq 'error'}">bg-rose-400</c:when>
                        <c:otherwise>bg-cyan-400</c:otherwise>
                    </c:choose>">
                    <div class="flex items-center gap-3">
                        <c:choose>
                            <c:when test="${param.status eq 'success'}">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" class="shrink-0">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                </svg>
                                <span>Request musik berhasil ditambahkan ke antrean! 🎵</span>
                            </c:when>
                            <c:when test="${param.status eq 'limit_reached'}">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" class="shrink-0">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                </svg>
                                <span>Batas kuota tercapai! Regular user maksimal memiliki 3 request aktif. 🚫</span>
                            </c:when>
                            <c:when test="${param.status eq 'invalid_input'}">
                                <span>Gagal: Mohon isi judul lagu dan artis dengan lengkap!</span>
                            </c:when>
                            <c:when test="${param.status eq 'unauthorized'}">
                                <span>Gagal: Anda tidak memiliki otoritas untuk tindakan ini.</span>
                            </c:when>
                            <c:when test="${param.status eq 'cancelled'}">
                                <span>Request musik berhasil dibatalkan.</span>
                            </c:when>
                            <c:when test="${param.status eq 'history_deleted'}">
                                <span>Riwayat request musik berhasil dihapus secara permanen.</span>
                            </c:when>
                            <c:when test="${param.status eq 'updated'}">
                                <span>Status antrean musik berhasil diperbarui!</span>
                            </c:when>
                            <c:otherwise>
                                <span>Operasi berhasil diproses.</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <button onclick="document.getElementById('status-toast').remove()" class="hover:opacity-70 transition-opacity ml-4">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                    </button>
                </div>
            </c:if>

            <!-- QUEUE SECTION -->
            <div>
                <div class="flex items-center gap-3 mb-6">
                    <span class="w-3 h-3 bg-red-500 rounded-full animate-ping"></span>
                    <h3 class="text-2xl font-black uppercase tracking-tight">Active Queue / Antrean Aktif</h3>
                </div>

                <c:choose>
                    <c:when test="${empty activeQueue}">
                        <div class="border-2 border-dashed border-gray-300 rounded-2xl p-12 text-center">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 mx-auto text-gray-300 mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3" />
                            </svg>
                            <p class="font-bold text-gray-400 uppercase tracking-wider text-sm">Belum ada request aktif. Jadilah yang pertama request musik!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <c:forEach var="mr" items="${activeQueue}">
                                <!-- Queue Card -->
                                <div class="border-2 border-black rounded-2xl p-6 bg-white shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] transition-transform duration-300 hover:-translate-y-1 relative overflow-hidden flex flex-col justify-between min-h-[170px]">
                                    <!-- Now Playing overlay color line -->
                                    <c:if test="${mr.status eq 'Playing'}">
                                        <div class="absolute top-0 left-0 right-0 h-2 bg-gray-200 overflow-hidden">
                                            <div class="song-progress-bar h-full bg-[#B6FF2D]"
                                                 data-started="${mr.startedAt.time}"
                                                 data-duration="${mr.durationSeconds * 1000}">
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Top Card Details -->
                                    <div>
                                        <div class="flex justify-between items-start gap-4 mb-2">
                                            <span class="text-xs font-bold text-gray-500 uppercase tracking-widest">
                                                Requested by ${mr.username}
                                                <span class="ml-1 px-1.5 py-0.5 text-[9px] font-black rounded border
                                                    <c:choose>
                                                        <c:when test="${mr.userRole eq 'Premium'}">bg-purple-100 text-purple-700 border-purple-300</c:when>
                                                        <c:when test="${mr.userRole eq 'Admin'}">bg-red-100 text-red-700 border-red-300</c:when>
                                                        <c:otherwise>bg-blue-100 text-blue-700 border-blue-300</c:otherwise>
                                                    </c:choose>">
                                                    ${mr.userRole}
                                                </span>
                                            </span>

                                            <!-- Status badge -->
                                            <c:choose>
                                                <c:when test="${mr.status eq 'Playing'}">
                                                    <span class="flex items-center gap-1.5 text-[9px] font-black px-2.5 py-1 bg-[#B6FF2D] text-black border border-black rounded-full uppercase tracking-wider animate-pulse">
                                                        <span class="w-1.5 h-1.5 bg-black rounded-full animate-ping"></span>
                                                        Now Playing
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-[9px] font-black px-2.5 py-1 bg-yellow-100 text-yellow-800 border border-yellow-300 rounded-full uppercase tracking-wider">
                                                        Waiting
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <h4 class="text-2xl font-black uppercase tracking-tight leading-none mb-1 break-words">${mr.songTitle}</h4>
                                        <p class="text-sm font-extrabold text-gray-500 break-words mb-2">by ${mr.artist}</p>
                                        <!-- Countdown Timer (hanya tampil untuk status Playing) -->
                                        <c:if test="${mr.status eq 'Playing' && mr.startedAt != null}">
                                            <div class="flex items-center gap-1.5 mb-2">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                                                    <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                                                </svg>
                                                <span class="countdown-timer text-[11px] font-black text-gray-500 uppercase tracking-wider"
                                                      data-started="${mr.startedAt.time}"
                                                      data-duration="${mr.durationSeconds}">--:--</span>
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- Bottom Card Actions -->
                                    <div class="flex justify-between items-center pt-2 border-t border-gray-100">
                                        <span class="text-[10px] text-gray-400 font-bold uppercase">
                                            <fmt:formatDate value="${mr.requestedAt}" pattern="HH:mm"/>
                                        </span>

                                        <div class="flex items-center gap-2">
                                            <!-- ADMIN CONTROLS -->
                                            <c:if test="${role eq 'Admin'}">
                                                <c:choose>
                                                    <c:when test="${mr.status eq 'Pending'}">
                                                        <form action="${pageContext.request.contextPath}/MusicController" method="POST" class="inline">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="request_id" value="${mr.requestId}">
                                                            <input type="hidden" name="status" value="Playing">
                                                            <button type="submit" class="bg-black hover:bg-[#B6FF2D] hover:text-black text-white px-3 py-1.5 rounded-lg border border-black text-[10px] font-black uppercase tracking-wider transition-colors">
                                                                Play ▶
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${mr.status eq 'Playing'}">
                                                        <form action="${pageContext.request.contextPath}/MusicController" method="POST" class="inline">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="request_id" value="${mr.requestId}">
                                                            <input type="hidden" name="status" value="Played">
                                                            <button type="submit" class="bg-black hover:bg-cyan-400 hover:text-black text-white px-3 py-1.5 rounded-lg border border-black text-[10px] font-black uppercase tracking-wider transition-colors">
                                                                Done ✓
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                </c:choose>
                                            </c:if>

                                            <!-- USER CANCEL/DELETE (If requester or Admin) -->
                                            <c:if test="${role eq 'Admin' || sessionScope.user_id == mr.userId}">
                                                <form action="${pageContext.request.contextPath}/MusicController" method="POST" class="inline">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="request_id" value="${mr.requestId}">
                                                    <button type="submit" class="hover:bg-red-600 hover:text-white text-red-600 px-3 py-1.5 rounded-lg border border-red-300 hover:border-red-600 text-[10px] font-black uppercase tracking-wider transition-colors" onclick="return confirm('Batalkan request musik ini?')">
                                                        Cancel
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- HISTORY / RECENTLY PLAYED SECTION -->
            <div class="mt-8 border-t-2 border-black pt-8">
                <h3 class="text-2xl font-black uppercase tracking-tight mb-6">Recently Played & History</h3>
                <c:choose>
                    <c:when test="${empty recentlyPlayed}">
                        <p class="text-sm font-semibold text-gray-400 uppercase tracking-wider">Belum ada riwayat lagu yang diputar.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="overflow-x-auto">
                            <table class="w-full border-2 border-black text-left">
                                <thead>
                                    <tr class="bg-gray-100 border-b-2 border-black">
                                        <th class="p-3 text-xs font-black uppercase tracking-wider">Lagu</th>
                                        <th class="p-3 text-xs font-black uppercase tracking-wider">Artis</th>
                                        <th class="p-3 text-xs font-black uppercase tracking-wider">Oleh</th>
                                        <th class="p-3 text-xs font-black uppercase tracking-wider">Status</th>
                                        <th class="p-3 text-xs font-black uppercase tracking-wider text-right">Waktu Diputar</th>
                                        <th class="p-3 text-xs font-black uppercase tracking-wider text-center">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="h" items="${recentlyPlayed}">
                                        <tr class="border-b border-black hover:bg-gray-50 transition-colors">
                                            <td class="p-3 font-bold break-all">${h.songTitle}</td>
                                            <td class="p-3 text-gray-500 font-semibold break-all">${h.artist}</td>
                                            <td class="p-3 text-xs font-bold text-gray-600">${h.username}</td>
                                            <td class="p-3 text-[10px] font-extrabold uppercase">
                                                <span class="px-2.5 py-0.5 rounded-full border
                                                    <c:choose>
                                                        <c:when test="${h.status eq 'Played'}">bg-green-50 text-green-700 border-green-300</c:when>
                                                        <c:otherwise>bg-gray-100 text-gray-600 border-gray-300</c:otherwise>
                                                    </c:choose>">
                                                    ${h.status}
                                                </span>
                                            </td>
                                            <td class="p-3 text-xs text-gray-400 font-bold text-right">
                                                <c:choose>
                                                    <c:when test="${h.status eq 'Played' && h.playedAt != null}">
                                                        <span class="block text-green-600"><fmt:formatDate value="${h.playedAt}" pattern="dd MMM, HH:mm"/></span>
                                                        <span class="text-[9px] text-gray-300">req: <fmt:formatDate value="${h.requestedAt}" pattern="HH:mm"/></span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatDate value="${h.requestedAt}" pattern="dd MMM, HH:mm"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="p-3 text-center">
                                                <c:if test="${role eq 'Admin' || sessionScope.user_id == h.userId}">
                                                    <form action="${pageContext.request.contextPath}/MusicController" method="POST" class="inline">
                                                        <input type="hidden" name="action" value="deleteHistory">
                                                        <input type="hidden" name="request_id" value="${h.requestId}">
                                                        <button type="submit" class="hover:bg-red-600 hover:text-white text-red-600 px-2.5 py-1 rounded border border-red-300 hover:border-red-600 text-[10px] font-black uppercase tracking-wider transition-colors" onclick="return confirm('Hapus lagu ini dari riwayat secara permanen?')">
                                                            Hapus
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <script>
        // =============================================
        // COUNTDOWN TIMER untuk card "Now Playing"
        // =============================================
        const SONG_DURATION_SEC = 240; // harus sama dengan MusicAutoPlayedScheduler.java
        const AUTO_REFRESH_INTERVAL_MS = 30000; // auto-refresh setiap 30 detik

        function updateCountdowns() {
            const timers = document.querySelectorAll('.countdown-timer');
            timers.forEach(el => {
                const startedMs = parseInt(el.dataset.started, 10);
                const durationSec = parseInt(el.dataset.duration, 10);
                const now = Date.now();
                const elapsedSec = Math.floor((now - startedMs) / 1000);
                const remainingSec = Math.max(0, durationSec - elapsedSec);

                const mm = String(Math.floor(remainingSec / 60)).padStart(2, '0');
                const ss = String(remainingSec % 60).padStart(2, '0');

                if (remainingSec <= 0) {
                    el.textContent = 'Selesai ✓';
                    el.classList.add('text-green-600');
                } else if (remainingSec <= 30) {
                    el.textContent = mm + ':' + ss + ' tersisa';
                    el.classList.add('text-red-500');
                    el.classList.remove('text-gray-500');
                } else {
                    el.textContent = mm + ':' + ss + ' tersisa';
                    el.classList.remove('text-red-500');
                    el.classList.add('text-gray-500');
                }
            });

            // Update progress bars
            const bars = document.querySelectorAll('.song-progress-bar');
            bars.forEach(bar => {
                const startedMs = parseInt(bar.dataset.started, 10);
                const durationMs = parseInt(bar.dataset.duration, 10);
                const now = Date.now();
                const elapsed = now - startedMs;
                const pct = Math.max(0, Math.min(100, 100 - (elapsed / durationMs * 100)));
                bar.style.width = pct + '%';
                // Set animasi dari sisa ke 0
                const remainingMs = Math.max(0, durationMs - elapsed);
                bar.style.transition = 'width ' + (remainingMs / 1000) + 's linear';
                bar.style.width = '0%';
            });
        }

        // Jalankan segera dan update setiap detik
        updateCountdowns();
        setInterval(updateCountdowns, 1000);

        // =============================================
        // AUTO-REFRESH halaman setiap 30 detik
        // (hanya jika tidak ada lagu yg sedang Playing,
        //  atau jika ada Playing agar history terupdate)
        // =============================================
        let refreshTimer = setTimeout(function() {
            // Jangan refresh jika user sedang mengetik di form
            const songInput = document.getElementById('song_title');
            const artistInput = document.getElementById('artist');
            if ((songInput && songInput.value.trim() !== '') ||
                (artistInput && artistInput.value.trim() !== '')) {
                // Tunda refresh 30 detik lagi jika user sedang isi form
                refreshTimer = setTimeout(arguments.callee, AUTO_REFRESH_INTERVAL_MS);
                return;
            }
            window.location.reload();
        }, AUTO_REFRESH_INTERVAL_MS);

        // Batalkan auto-refresh jika user klik tombol submit
        document.querySelectorAll('form').forEach(f => {
            f.addEventListener('submit', () => clearTimeout(refreshTimer));
        });
    </script>
</body>

</html>
