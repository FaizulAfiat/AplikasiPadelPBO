<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/view/Login.html");
        return;
    }
    String uname = (String) session.getAttribute("user");
    String initial = (uname != null && !uname.isEmpty()) ? uname.substring(0, 1).toUpperCase() : "?";
    String userRole = (String) session.getAttribute("role");
    boolean isPremium = "Premium".equalsIgnoreCase(userRole) || "Admin".equalsIgnoreCase(userRole);
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PadelJukebox - Request Musik</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Outfit:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #fcfcfc;
        }
        .border-grid {
            border-color: #e5e5e5;
        }
        /* Vinyl Rotation Animation */
        @keyframes rotate-vinyl {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        .animate-vinyl {
            animation: rotate-vinyl 8s linear infinite;
        }
        .paused-vinyl {
            animation-play-state: paused;
        }
        /* Equalizer Animation */
        .eq-bar {
            width: 4px;
            background-color: #000;
            animation: bounce-eq 0.8s ease-in-out infinite alternate;
        }
        @keyframes bounce-eq {
            0% { height: 4px; }
            100% { height: 28px; }
        }
        /* Staggered EQ delays */
        .eq-bar:nth-child(2) { animation-delay: 0.15s; }
        .eq-bar:nth-child(3) { animation-delay: 0.3s; }
        .eq-bar:nth-child(4) { animation-delay: 0.05s; }
        .eq-bar:nth-child(5) { animation-delay: 0.25s; }
        .eq-bar:nth-child(6) { animation-delay: 0.1s; }
        
        .no-scrollbar::-webkit-scrollbar {
            display: none;
        }
        .no-scrollbar {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }
    </style>
</head>
<body class="bg-[#FCFCFC] text-black min-h-screen flex flex-col antialiased">
    
    <!-- Navigation Header -->
    <header class="flex border-b border-grid bg-white sticky top-0 z-50">
        <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
            <span class="text-[10px] font-bold uppercase block opacity-50 md:text-xs">01 / Premium Feature</span>
            <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">
                Padel<span class="text-blue-400">Jukebox</span>
            </h1>
        </div>
        <div class="flex-1 border-r border-grid hidden md:flex items-center px-8 bg-white">
            <c:choose>
                <c:when test="${role eq 'Admin'}">
                    <a href="${pageContext.request.contextPath}/AdminController"
                        class="text-xs font-bold uppercase tracking-widest hover:underline flex items-center gap-1">
                        ← Back to Admin Dashboard
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/index.jsp"
                        class="text-xs font-bold uppercase tracking-widest hover:underline flex items-center gap-1">
                        ← Back to Dashboard
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4 md:gap-6 bg-white">
            <div class="flex items-center gap-2">
                <div class="w-8 h-8 rounded-full bg-black text-white flex items-center justify-center font-bold uppercase text-xs shadow-sm">
                    <%= initial %>
                </div>
                <span class="hidden lg:inline text-[10px] font-bold uppercase tracking-widest text-zinc-600">
                    @<%= uname %>
                </span>
                <span class="px-2 py-0.5 bg-purple-100 text-purple-800 text-[8px] font-bold uppercase tracking-wide rounded border border-purple-200">
                    <%= userRole %>
                </span>
            </div>
        </div>
    </header>

    <!-- Main Container -->
    <main class="flex-1 flex flex-col p-6 md:p-12 max-w-7xl mx-auto w-full">
        
        <!-- Alerts Block -->
        <c:if test="${not empty param.status}">
            <c:choose>
                <c:when test="${param.status eq 'success'}">
                    <div id="alert-box" class="mb-8 border-4 border-black p-5 rounded-2xl bg-emerald-400 font-black uppercase italic shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between">
                        <span>Lagu berhasil direquest ke antrean!</span>
                        <button onclick="document.getElementById('alert-box').remove()" class="font-bold">X</button>
                    </div>
                </c:when>
                <c:when test="${param.status eq 'upgraded'}">
                    <div id="alert-box" class="mb-8 border-4 border-black p-5 rounded-2xl bg-purple-400 font-black uppercase italic shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between">
                        <span>Selamat! Akun Anda berhasil di-upgrade ke PREMIUM. Nikmati kontrol Jukebox!</span>
                        <button onclick="document.getElementById('alert-box').remove()" class="font-bold">X</button>
                    </div>
                </c:when>
                <c:when test="${param.status eq 'music_updated'}">
                    <div id="alert-box" class="mb-8 border-4 border-black p-5 rounded-2xl bg-cyan-400 font-black uppercase italic shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between">
                        <span>Status antrean lagu berhasil diperbarui!</span>
                        <button onclick="document.getElementById('alert-box').remove()" class="font-bold">X</button>
                    </div>
                </c:when>
                <c:when test="${param.status eq 'error'}">
                    <div id="alert-box" class="mb-8 border-4 border-black p-5 rounded-2xl bg-rose-400 font-black uppercase italic shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between">
                        <span>Terjadi kesalahan saat memproses data. Coba lagi.</span>
                        <button onclick="document.getElementById('alert-box').remove()" class="font-bold">X</button>
                    </div>
                </c:when>
            </c:choose>
        </c:if>

        <% if (!isPremium) { %>
            <!-- PREMIUM UPGRADE GATE -->
            <div class="flex-1 flex items-center justify-center py-12">
                <div class="w-full max-w-2xl bg-white border-4 border-black p-8 md:p-12 rounded-[2.5rem] shadow-[12px_12px_0px_0px_rgba(0,0,0,1)] text-center relative overflow-hidden group">
                    <div class="absolute -top-12 -left-12 w-32 h-32 bg-purple-400/20 rounded-full blur-2xl group-hover:scale-125 transition-transform duration-500"></div>
                    <div class="absolute -bottom-12 -right-12 w-32 h-32 bg-blue-400/20 rounded-full blur-2xl group-hover:scale-125 transition-transform duration-500"></div>
                    
                    <div class="w-24 h-24 bg-purple-600 border-4 border-black rounded-3xl mx-auto flex items-center justify-center shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] mb-8 transform -rotate-6 group-hover:rotate-0 transition-transform">
                        <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
                            <path d="M9 18V5l12-2v13"></path>
                            <circle cx="6" cy="18" r="3"></circle>
                            <circle cx="18" cy="16" r="3"></circle>
                        </svg>
                    </div>

                    <h2 class="text-4xl md:text-5xl font-black uppercase italic tracking-tighter mb-4">
                        UNLEASH THE BEAT ON COURT
                    </h2>
                    <p class="text-gray-500 font-medium text-sm md:text-base mb-8 max-w-md mx-auto leading-relaxed">
                        PadelJukebox hanya tersedia untuk member <strong>Premium</strong>. Atur lagu favoritmu, pacu adrenalin permainan, dan request langsung dari lapangan!
                    </p>

                    <!-- Benefits list -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 text-left mb-10 border-t border-b border-grid py-8">
                        <div>
                            <div class="font-bold text-xs uppercase text-purple-600 mb-1 flex items-center gap-1.5">
                                <span class="w-2 h-2 bg-purple-600 rounded-full"></span> 01 / Full Control
                            </div>
                            <p class="text-xs text-gray-500 font-semibold leading-relaxed">Request lagu dari platform streaming favoritmu.</p>
                        </div>
                        <div>
                            <div class="font-bold text-xs uppercase text-blue-600 mb-1 flex items-center gap-1.5">
                                <span class="w-2 h-2 bg-blue-600 rounded-full"></span> 02 / Real-time Queue
                            </div>
                            <p class="text-xs text-gray-500 font-semibold leading-relaxed">Dengarkan lagumu diputar langsung di sound system lapangan.</p>
                        </div>
                        <div>
                            <div class="font-bold text-xs uppercase text-emerald-600 mb-1 flex items-center gap-1.5">
                                <span class="w-2 h-2 bg-emerald-600 rounded-full"></span> 03 / Premium Badge
                            </div>
                            <p class="text-xs text-gray-500 font-semibold leading-relaxed">Dapatkan keuntungan eksklusif di aplikasi PadelApp.</p>
                        </div>
                    </div>

                    <!-- Upgrade Action -->
                    <a href="${pageContext.request.contextPath}/MusicRequest?action=upgrade" 
                       class="inline-block w-full sm:w-auto bg-yellow-400 text-black border-4 border-black px-12 py-4 rounded-2xl font-black uppercase text-sm tracking-wider hover:bg-black hover:text-yellow-400 transition-all shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] hover:translate-x-1 hover:translate-y-1 hover:shadow-none">
                        Upgrade to Premium Now →
                    </a>
                </div>
            </div>
        <% } else { %>
            <!-- PREMIUM JUKEBOX INTERFACE -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-12">
                
                <!-- Left Column: Request Form -->
                <div class="lg:col-span-6 space-y-8">
                    <div class="bg-white border-4 border-black p-8 rounded-[2.5rem] shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
                        <span class="text-[10px] font-black uppercase tracking-wider text-purple-600 block mb-2">Jukebox Jumper</span>
                        <h2 class="text-3xl font-black uppercase italic tracking-tighter mb-6">Request Your Workout Anthem</h2>
                        
                        <form action="${pageContext.request.contextPath}/MusicRequest" method="POST" id="requestForm" class="space-y-6">
                            
                            <!-- Court Selector -->
                            <div>
                                <label for="courtId" class="block text-[10px] font-black uppercase tracking-widest text-zinc-500 mb-2">Pilih Lapangan Bermain</label>
                                <select name="courtId" id="courtId" onchange="filterQueue()" class="w-full bg-gray-50 border-2 border-black p-3.5 rounded-xl font-bold text-sm focus:outline-none focus:ring-2 focus:ring-purple-600">
                                    <option value="">-- Putar di Seluruh Lapangan (Venue-wide) --</option>
                                    <c:forEach var="c" items="${courts}">
                                        <option value="${c.id}">${c.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Platform Selector -->
                            <div>
                                <span class="block text-[10px] font-black uppercase tracking-widest text-zinc-500 mb-2">Pilih Platform Musik</span>
                                <div class="grid grid-cols-2 gap-4">
                                    <button type="button" id="spotify-btn" onclick="selectPlatform('Spotify')" class="border-2 border-black p-4 rounded-xl flex items-center justify-center gap-2 font-black uppercase text-xs tracking-wider transition-all bg-emerald-500 text-white shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
                                        <svg class="w-5 h-5 fill-current" viewBox="0 0 24 24">
                                            <path d="M12 0C5.373 0 0 5.373 0 12s5.373 12 12 12 12-5.373 12-12S18.627 0 12 0zm5.485 17.305c-.215.354-.675.466-1.028.249-2.856-1.745-6.452-2.14-10.686-1.173-.404.092-.812-.162-.905-.566-.092-.404.162-.812.566-.905 4.636-1.059 8.601-.605 11.8 1.35.354.215.466.675.249 1.028zm1.465-3.262c-.271.442-.851.587-1.293.316-3.27-2.008-8.257-2.593-12.126-1.417-.497.151-1.02-.132-1.171-.629-.151-.497.132-1.02.629-1.171 4.417-1.34 9.907-.696 13.645 1.6 1.6.442.271.851.587 1.293.316zm.126-3.412C15.222 8.32 8.878 8.11 5.21 9.224c-.58.175-1.19-.157-1.365-.737-.175-.58.157-1.19.737-1.365 4.225-1.282 11.236-1.042 15.688 1.6 1.6.522.187 1.195-.316 1.365-.737.18-.58.175-1.19-.157-1.365z"/>
                                        </svg>
                                        Spotify
                                    </button>
                                    <button type="button" id="apple-btn" onclick="selectPlatform('Apple Music')" class="border-2 border-black p-4 rounded-xl flex items-center justify-center gap-2 font-black uppercase text-xs tracking-wider transition-all bg-white text-black hover:bg-zinc-50 border-zinc-200">
                                        <svg class="w-5 h-5 fill-current text-rose-500" viewBox="0 0 24 24">
                                            <path d="M12.2 21c-1-.2-1.7-.8-2.6-1.7-1-.9-2-1.8-3.1-2.6h-.2c-1.1.1-2.1-.4-2.7-1.3-.7-1-1-2.2-.8-3.4.1-1.1.6-2.1 1.4-2.8 1.1-.9 2.5-1.3 3.9-1h.2c1 .6 2 1.3 2.9 2h.2c1-.9 2-1.8 3.1-2.5h.3c1.4-.2 2.7.2 3.7 1.1.8.7 1.3 1.7 1.4 2.8.2 1.2-.1 2.4-.8 3.4-.6.9-1.6 1.4-2.7 1.3h-.2c-1.1.8-2.1 1.7-3.1 2.6-.9.9-1.6 1.5-2.6 1.7v.4zm-.2-11c-.5 0-1 .4-1 1s.4 1 1 1 1-.4 1-1-.5-1-1-1z"/>
                                        </svg>
                                        Apple Music
                                    </button>
                                </div>
                                <input type="hidden" name="platform" id="platform-val" value="Spotify">
                            </div>

                            <!-- Track Search / Input -->
                            <div class="relative">
                                <label for="trackSearch" class="block text-[10px] font-black uppercase tracking-widest text-zinc-500 mb-2">Cari Lagu / Tulis Nama Lagu</label>
                                <input type="text" id="trackSearch" autocomplete="off" oninput="showMockSearch()" placeholder="Ketik nama lagu atau artis (misal: Levitating, Stronger)..." class="w-full bg-gray-50 border-2 border-black p-3.5 rounded-xl font-bold text-sm focus:outline-none focus:ring-2 focus:ring-purple-600">
                                
                                <!-- Mock Search Dropdown Results -->
                                <div id="search-results" class="absolute left-0 right-0 mt-2 bg-white border-2 border-black rounded-xl max-h-60 overflow-y-auto hidden z-20 shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] divide-y divide-gray-100">
                                    <!-- Results dynamically generated -->
                                </div>
                            </div>

                            <!-- Auto-filled Forms -->
                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label for="trackName" class="block text-[10px] font-black uppercase tracking-widest text-zinc-500 mb-2">Judul Lagu</label>
                                    <input type="text" name="trackName" id="trackName" required placeholder="Judul lagu..." class="w-full bg-white border-2 border-zinc-200 p-3 rounded-xl font-bold text-sm focus:outline-none focus:ring-2 focus:ring-purple-600">
                                </div>
                                <div>
                                    <label for="artist" class="block text-[10px] font-black uppercase tracking-widest text-zinc-500 mb-2">Artis / Band</label>
                                    <input type="text" name="artist" id="artist" required placeholder="Nama penyanyi..." class="w-full bg-white border-2 border-zinc-200 p-3 rounded-xl font-bold text-sm focus:outline-none focus:ring-2 focus:ring-purple-600">
                                </div>
                            </div>

                            <!-- Track Link -->
                            <div>
                                <label for="trackUrl" class="block text-[10px] font-black uppercase tracking-widest text-zinc-500 mb-2">Link Lagu (Opsional)</label>
                                <input type="url" name="trackUrl" id="trackUrl" placeholder="https://open.spotify.com/track/..." class="w-full bg-gray-50 border-2 border-black p-3.5 rounded-xl font-bold text-sm focus:outline-none focus:ring-2 focus:ring-purple-600">
                                <span class="text-[9px] text-gray-400 font-semibold block mt-1">Anda juga dapat menyalin tautan lagu dari aplikasi Spotify / Apple Music.</span>
                            </div>

                            <!-- Submit -->
                            <button type="submit" class="w-full bg-purple-600 text-white border-4 border-black py-4 rounded-xl font-black uppercase text-xs tracking-widest hover:bg-black hover:text-purple-400 transition-all shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] hover:translate-x-0.5 hover:translate-y-0.5 hover:shadow-none">
                                Kirim Request Lagu →
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Right Column: Player & Queue -->
                <div class="lg:col-span-6 space-y-8">
                    
                    <!-- NOW PLAYING PLAYER -->
                    <div class="bg-black text-white p-8 rounded-[2.5rem] border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] flex flex-col md:flex-row items-center gap-8 relative overflow-hidden group">
                        
                        <!-- Rotating Record -->
                        <div class="relative shrink-0 select-none">
                            <div class="w-32 h-32 rounded-full bg-zinc-900 border-4 border-zinc-800 flex items-center justify-center animate-vinyl shadow-inner" id="vinyl-disc">
                                <!-- Record center label -->
                                <div class="w-10 h-10 rounded-full bg-purple-600 border border-black flex items-center justify-center">
                                    <div class="w-2.5 h-2.5 rounded-full bg-black"></div>
                                </div>
                            </div>
                            <!-- Player needle arm -->
                            <div class="absolute -top-1 right-2 w-8 h-16 origin-top transform rotate-12 transition-transform duration-500" id="player-needle">
                                <svg width="30" height="60" viewBox="0 0 30 60" fill="none">
                                    <path d="M5 5h10l5 30-5 15h-5" stroke="#9ca3af" stroke-width="3" stroke-linecap="round"/>
                                    <circle cx="5" cy="5" r="4" fill="#6b7280"/>
                                </svg>
                            </div>
                        </div>

                        <!-- Track Details -->
                        <div class="flex-1 text-center md:text-left space-y-4 z-10 w-full">
                            <div>
                                <span class="text-[9px] font-black uppercase tracking-wider text-purple-400 bg-purple-400/10 px-2 py-0.5 rounded border border-purple-500/20">NOW PLAYING</span>
                                <h3 class="text-2xl font-black uppercase tracking-tight text-white mt-2 truncate" id="player-track">Sweat & Smile</h3>
                                <p class="text-zinc-400 font-semibold text-xs mt-1" id="player-artist">Padel Workout Vol. 1</p>
                            </div>
                            
                            <!-- Equalizer Visualizer -->
                            <div class="flex items-end justify-center md:justify-start gap-1 h-8 select-none" id="player-eq">
                                <div class="eq-bar"></div>
                                <div class="eq-bar"></div>
                                <div class="eq-bar"></div>
                                <div class="eq-bar"></div>
                                <div class="eq-bar"></div>
                                <div class="eq-bar"></div>
                            </div>
                        </div>
                    </div>

                    <!-- QUEUE LIST -->
                    <div class="bg-white border-4 border-black p-8 rounded-[2.5rem] shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
                        <div class="flex items-center justify-between mb-6 pb-4 border-b border-gray-100">
                            <h3 class="font-black uppercase italic text-2xl tracking-tighter flex items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                                    <line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/>
                                </svg>
                                Court Playlist Queue
                            </h3>
                            <span class="text-xs bg-gray-50 text-gray-500 font-bold px-3 py-1 border border-zinc-200 rounded-lg" id="queue-count-badge">
                                0 antrean
                            </span>
                        </div>

                        <!-- Queue Items -->
                        <div class="space-y-4 max-h-[360px] overflow-y-auto pr-2 no-scrollbar" id="queue-list-container">
                            
                            <c:choose>
                                <c:when test="${empty musicRequests}">
                                    <div class="py-12 text-center text-gray-400 font-medium italic">
                                        Belum ada lagu yang di-request di venue ini.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="req" items="${musicRequests}">
                                        <div class="queue-item border border-grid p-4 rounded-2xl flex items-center justify-between hover:bg-gray-50/50 transition-colors duration-150" 
                                             data-court-id="${req.courtId}">
                                            
                                            <!-- Song Detail -->
                                            <div class="flex items-center gap-4 min-w-0">
                                                <!-- Platform Icon -->
                                                <div class="shrink-0">
                                                    <c:choose>
                                                        <c:when test="${req.platform eq 'Spotify'}">
                                                            <span class="w-8 h-8 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold">S</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="w-8 h-8 rounded-full bg-rose-50 text-rose-600 flex items-center justify-center font-bold">A</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="min-w-0">
                                                    <h4 class="font-bold text-black text-sm truncate">${req.trackName}</h4>
                                                    <p class="text-xs text-gray-400 font-semibold truncate">by ${req.artist}</p>
                                                    <span class="text-[9px] font-bold text-zinc-500 uppercase mt-0.5 block">
                                                        <c:choose>
                                                            <c:when test="${empty req.courtName}">
                                                                Venue-wide
                                                            </c:when>
                                                            <c:otherwise>
                                                                Court: ${req.courtName}
                                                            </c:otherwise>
                                                        </c:choose>
                                                        • Requested by @${req.username}
                                                    </span>
                                                </div>
                                            </div>

                                            <!-- Status / Action -->
                                            <div class="flex items-center gap-3 shrink-0">
                                                <c:choose>
                                                    <c:when test="${req.status eq 'Pending'}">
                                                        <span class="px-2 py-0.5 bg-amber-50 text-amber-800 border border-amber-200 rounded text-[9px] font-bold uppercase tracking-wider">
                                                            Queued
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${req.status eq 'Played'}">
                                                        <span class="px-2 py-0.5 bg-emerald-50 text-emerald-800 border border-emerald-200 rounded text-[9px] font-bold uppercase tracking-wider">
                                                            Played
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="px-2 py-0.5 bg-rose-50 text-rose-800 border border-rose-200 rounded text-[9px] font-bold uppercase tracking-wider">
                                                            Rejected
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div>
            </div>
        <% } %>

    </main>

    <!-- Simulated Spotify/Apple Music Tracks Data -->
    <script>
        const MOCK_TRACKS = [
            { name: "Levitating", artist: "Dua Lipa", url: "https://open.spotify.com/track/39LLxExzy6HrmGvhs8j64I", platform: "Spotify" },
            { name: "Stronger", artist: "Kanye West", url: "https://open.spotify.com/track/4XFCYy5d68w0EBvVybR4EE", platform: "Spotify" },
            { name: "Eye of the Tiger", artist: "Survivor", url: "https://open.spotify.com/track/2KH16WveA16g466V2yU7uK", platform: "Spotify" },
            { name: "Remember the Name", artist: "Fort Minor", url: "https://open.spotify.com/track/6lUp5466V2yU7uK11sS2uK", platform: "Spotify" },
            { name: "Pump It", artist: "Black Eyed Peas", url: "https://open.spotify.com/track/5KH16WveA16g466V2yU7uK", platform: "Spotify" },
            { name: "Till I Collapse", artist: "Eminem", url: "https://open.spotify.com/track/4woWO05d68w0EBvVybR4EE", platform: "Spotify" },
            { name: "Blinding Lights", artist: "The Weeknd", url: "https://music.apple.com/id/album/blinding-lights/1499385336", platform: "Apple Music" },
            { name: "Physical", artist: "Dua Lipa", url: "https://music.apple.com/id/album/physical/1495799403", platform: "Apple Music" },
            { name: "Can't Stop", artist: "Red Hot Chili Peppers", url: "https://music.apple.com/id/album/cant-stop/948452332", platform: "Apple Music" },
            { name: "Lose Yourself", artist: "Eminem", url: "https://music.apple.com/id/album/lose-yourself/1440905330", platform: "Apple Music" }
        ];

        function selectPlatform(platform) {
            document.getElementById('platform-val').value = platform;
            
            const spBtn = document.getElementById('spotify-btn');
            const apBtn = document.getElementById('apple-btn');
            
            if (platform === 'Spotify') {
                spBtn.className = "border-2 border-black p-4 rounded-xl flex items-center justify-center gap-2 font-black uppercase text-xs tracking-wider transition-all bg-emerald-500 text-white shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]";
                apBtn.className = "border-2 border-black p-4 rounded-xl flex items-center justify-center gap-2 font-black uppercase text-xs tracking-wider transition-all bg-white text-black hover:bg-zinc-50 border-zinc-200";
            } else {
                apBtn.className = "border-2 border-black p-4 rounded-xl flex items-center justify-center gap-2 font-black uppercase text-xs tracking-wider transition-all bg-rose-500 text-white shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]";
                spBtn.className = "border-2 border-black p-4 rounded-xl flex items-center justify-center gap-2 font-black uppercase text-xs tracking-wider transition-all bg-white text-black hover:bg-zinc-50 border-zinc-200";
            }
            
            // Clear inputs
            document.getElementById('trackSearch').value = "";
            document.getElementById('trackName').value = "";
            document.getElementById('artist').value = "";
            document.getElementById('trackUrl').value = "";
            document.getElementById('search-results').classList.add('hidden');
        }

        function showMockSearch() {
            const query = document.getElementById('trackSearch').value.toLowerCase().trim();
            const platform = document.getElementById('platform-val').value;
            const dropdown = document.getElementById('search-results');
            
            if (!query) {
                dropdown.classList.add('hidden');
                return;
            }
            
            const matches = MOCK_TRACKS.filter(t => 
                t.platform === platform && 
                (t.name.toLowerCase().includes(query) || t.artist.toLowerCase().includes(query))
            );
            
            dropdown.innerHTML = "";
            
            if (matches.length === 0) {
                dropdown.innerHTML = `<div class="p-3 text-xs text-gray-400 font-semibold italic text-center">Tidak menemukan kecocokan. Silakan isi form di bawah manual.</div>`;
            } else {
                matches.forEach(t => {
                    const row = document.createElement('button');
                    row.type = "button";
                    row.className = "w-full text-left p-3 text-xs font-bold hover:bg-zinc-100 flex justify-between items-center transition-colors";
                    row.onclick = () => fillTrack(t.name, t.artist, t.url);
                    row.innerHTML = `
                        <span>${t.name} <span class="text-[10px] text-gray-400 font-medium">by ${t.artist}</span></span>
                        <span class="text-[8px] bg-zinc-100 text-zinc-600 px-2 py-0.5 rounded font-black tracking-widest uppercase">${t.platform}</span>
                    `;
                    dropdown.appendChild(row);
                });
            }
            dropdown.classList.remove('hidden');
        }

        function fillTrack(name, artist, url) {
            document.getElementById('trackName').value = name;
            document.getElementById('artist').value = artist;
            document.getElementById('trackUrl').value = url;
            document.getElementById('search-results').classList.add('hidden');
            document.getElementById('trackSearch').value = name;
        }

        // Close dropdown when clicking outside
        document.addEventListener('click', (e) => {
            const container = document.getElementById('search-results');
            const input = document.getElementById('trackSearch');
            if (container && e.target !== container && e.target !== input) {
                container.classList.add('hidden');
            }
        });

        // Realtime Client-side Queue Filtering & Now Playing simulator
        function filterQueue() {
            const selectedCourt = document.getElementById('courtId').value;
            const items = document.querySelectorAll('.queue-item');
            let visibleCount = 0;
            let currentPlayingTrack = "Sweat & Smile";
            let currentPlayingArtist = "Padel Workout Vol. 1";
            let playStatus = "Paused";

            items.forEach(item => {
                const itemCourt = item.getAttribute('data-court-id');
                // If venue wide OR matching court ID
                if (!selectedCourt || itemCourt === selectedCourt || !itemCourt) {
                    item.style.display = 'flex';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            });

            // Update queue count label
            const badge = document.getElementById('queue-count-badge');
            if (badge) {
                badge.innerText = visibleCount + " antrean";
            }

            // Find first Played song for this court, if none check pending, or fall back to default
            let foundPlaying = false;
            // Let's check from the items list for any Played song
            const playedItems = Array.from(items).filter(item => {
                const itemCourt = item.getAttribute('data-court-id');
                const statusSpan = item.querySelector('span.bg-emerald-50'); // Played status
                return statusSpan && (!selectedCourt || itemCourt === selectedCourt);
            });

            if (playedItems.length > 0) {
                // Take the most recent played song
                const trackHeader = playedItems[0].querySelector('h4').innerText;
                const artistParagraph = playedItems[0].querySelector('p').innerText;
                currentPlayingTrack = trackHeader;
                currentPlayingArtist = artistParagraph;
                playStatus = "Playing";
                foundPlaying = true;
            } else {
                // Check if there is a pending queue item, play it (simulated)
                const pendingItems = Array.from(items).filter(item => {
                    const itemCourt = item.getAttribute('data-court-id');
                    const statusSpan = item.querySelector('span.bg-amber-50'); // Queued/Pending status
                    return statusSpan && (!selectedCourt || itemCourt === selectedCourt);
                });
                if (pendingItems.length > 0) {
                    const trackHeader = pendingItems[pendingItems.length - 1].querySelector('h4').innerText;
                    const artistParagraph = pendingItems[pendingItems.length - 1].querySelector('p').innerText;
                    currentPlayingTrack = trackHeader;
                    currentPlayingArtist = artistParagraph;
                    playStatus = "Playing";
                    foundPlaying = true;
                }
            }

            // Update visualizer state
            const vinylDisc = document.getElementById('vinyl-disc');
            const needle = document.getElementById('player-needle');
            const eq = document.getElementById('player-eq');
            const pTrack = document.getElementById('player-track');
            const pArtist = document.getElementById('player-artist');

            if (pTrack) pTrack.innerText = currentPlayingTrack;
            if (pArtist) pArtist.innerText = currentPlayingArtist;

            if (playStatus === "Playing") {
                if (vinylDisc) vinylDisc.classList.remove('paused-vinyl');
                if (needle) needle.style.transform = "rotate(28deg)";
                if (eq) eq.style.opacity = "1";
            } else {
                if (vinylDisc) vinylDisc.classList.add('paused-vinyl');
                if (needle) needle.style.transform = "rotate(12deg)";
                if (eq) eq.style.opacity = "0.2";
            }
        }

        // Initialize queue filters on page load
        window.addEventListener('DOMContentLoaded', () => {
            filterQueue();
        });
    </script>
</body>
</html>
