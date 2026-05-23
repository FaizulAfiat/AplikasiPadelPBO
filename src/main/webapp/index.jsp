<%-- Document : index Created on : 4 May 2026, 10.41.41 Author : Faizul Afiat --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <% /* Jika tidak ada data user di session, tendang balik ke login */ if (session.getAttribute("user")==null) {
                response.sendRedirect("view/Login.html"); } %>
                <!DOCTYPE html>
                <html lang="id">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>PadelApp - Dashboard</title>
                    <script src="https://cdn.tailwindcss.com"></script>
                    <style>
                        .border-grid {
                            border-color: #e5e5e5;
                        }

                        body {
                            font-family: 'Inter', sans-serif;
                        }
                    </style>
                </head>

                <body class="bg-white text-black min-h-screen flex flex-col">
                    <header class="flex border-b border-grid bg-white sticky top-0 z-50">
                        <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
                            <span class="text-[10px] font-bold uppercase block opacity-50 md:text-xs">01 / Padel
                                Management</span>
                            <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">Padel<span
                                    class="text-blue-400">App</span></h1>
                        </div>

                        <div class="hidden md:flex flex-1 items-center justify-center border-r border-grid p-6">
                            <div class="flex items-center gap-2">
                                <span class="w-2 h-2 bg-blue-500 rounded-full animate-pulse"></span>
                                <span class="text-[10px] font-bold uppercase tracking-widest">Open for Bookings</span>
                            </div>
                        </div>

                        <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4 md:gap-6">
                            <button id="launchpad-trigger" class="hover:bg-gray-200 p-2 rounded-lg transition-all">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                    fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                    stroke-linejoin="round">
                                    <rect x="3" y="3" width="7" height="7"></rect>
                                    <rect x="14" y="3" width="7" height="7"></rect>
                                    <rect x="14" y="14" width="7" height="7"></rect>
                                    <rect x="3" y="14" width="7" height="7"></rect>
                                </svg>
                            </button>
                            <div class="flex items-center gap-2 group cursor-pointer">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2"
                                    stroke="currentColor" class="w-5 h-5">
                                    <path stroke-linecap="round" stroke-linejoin="round"
                                        d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                                </svg>
                                <span class="hidden lg:inline text-[10px] font-bold uppercase tracking-widest">
                                    <%= (session.getAttribute("user") !=null) ? session.getAttribute("user") : "Guest"
                                        %>
                                </span>
                            </div>
                            <button onclick="window.location.href='${pageContext.request.contextPath}/Logout'"
                                class="bg-black text-white px-4 py-2 md:px-6 md:py-2 rounded-full text-[10px] md:text-xs font-bold uppercase tracking-widest hover:bg-red-600 transition-colors">
                                Logout
                            </button>
                        </div>
                    </header>

                    <main class="flex flex-col flex-1">
                        <c:if test="${param.status eq 'success'}">
                            <div id="success-toast"
                                class="m-8 border-4 border-black p-5 rounded-2xl bg-emerald-400 font-black uppercase italic shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="3" class="shrink-0">
                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                    </svg>
                                    <span>Pemesanan lapangan berhasil dikonfirmasi! Silakan cek jadwal Anda.</span>
                                </div>
                                <button onclick="document.getElementById('success-toast').remove()"
                                    class="hover:opacity-70 transition-opacity">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="3">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                </button>
                            </div>
                        </c:if>
                        <div class="w-full border-b border-grid overflow-hidden relative group">
                            <img src="img/padel.jpg" alt="Padel Banner"
                                class="w-full h-64 md:h-96 object-cover grayscale group-hover:grayscale-0 transition-all duration-700">

                            <div class="absolute bottom-8 right-8 z-20">
                                <a href="BookingController" class="bg-blue-400 text-black px-8 py-4 font-black uppercase tracking-tighter text-xl 
                       border-2 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] 
                       hover:translate-x-[2px] hover:translate-y-[2px] hover:shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] 
                       transition-all inline-block">
                                    Book Now →
                                </a>
                            </div>
                        </div>

                        <div class="flex flex-col md:flex-row flex-1">
                            <div
                                class="w-full md:w-1/3 p-8 md:p-12 border-b md:border-b-0 md:border-r border-grid bg-white">
                                <span class="text-xs font-bold uppercase block mb-4 opacity-50">02 / Dashboard</span>
                                <h2
                                    class="text-4xl md:text-6xl font-black leading-none uppercase mb-8 tracking-tighter">
                                    What we do for athletes
                                </h2>
                                <div class="w-4 h-4 bg-cyan-400 rounded-full"></div>
                            </div>

                            <div class="flex-1 bg-white">
                                <div class="p-8 md:p-12 border-b border-grid group hover:bg-gray-50 transition-colors">
                                    <div class="flex flex-col sm:flex-row gap-4">
                                        <span class="text-xs font-bold w-12 pt-1 opacity-50">01</span>
                                        <div>
                                            <h3 class="text-3xl md:text-5xl font-black uppercase mb-4 tracking-tighter">
                                                Field Booking</h3>
                                            <p class="text-sm md:text-base text-gray-500 max-w-md leading-relaxed">
                                                Pesan lapangan Padel favoritmu secara instan dengan sistem konfirmasi
                                                otomatis.
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div class="p-8 md:p-12 border-b border-grid group hover:bg-gray-50 transition-colors">
                                    <div class="flex flex-col sm:flex-row gap-4">
                                        <span class="text-xs font-bold w-12 pt-1 opacity-50">02</span>
                                        <div>
                                            <h3 class="text-3xl md:text-5xl font-black uppercase mb-4 tracking-tighter">
                                                Member Stats</h3>
                                            <p class="text-sm md:text-base text-gray-500 max-w-md leading-relaxed">
                                                Pantau statistik permainan dan progres latihanmu setiap minggu melalui
                                                dashboard interaktif.
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                    <div id="launchpad"
                        class="fixed inset-0 z-[999] hidden bg-white/80 backdrop-blur-xl transition-all duration-300 opacity-0">
                        <button id="launchpad-close"
                            class="absolute top-8 right-8 text-black hover:scale-110 transition-transform">
                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24"
                                fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                stroke-linejoin="round">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>

                        <div class="h-full w-full flex items-center justify-center p-10">
                            <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-12 max-w-5xl w-full">

                                <a href="BookingController" class="group flex flex-col items-center gap-4 text-center">
                                    <div
                                        class="w-20 h-20 bg-black text-white rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 group-hover:shadow-cyan-400/50 transition-all duration-300">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32"
                                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                            stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                        </svg>
                                    </div>
                                    <span class="font-black uppercase text-sm tracking-tighter">Book Court</span>
                                </a>

                                <a href="${pageContext.request.contextPath}/ProfileController"
                                    class="group flex flex-col items-center gap-4 text-center">
                                    <div
                                        class="w-20 h-20 bg-white border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-all duration-300">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32"
                                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                            stroke-linecap="round" stroke-linejoin="round">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 12 16 14"></polyline>
                                        </svg>
                                    </div>
                                    <span class="font-black uppercase text-sm tracking-tighter">My Schedule</span>
                                </a>

                                <a href="${pageContext.request.contextPath}/MatchSetupController"
                                    class="group flex flex-col items-center gap-4 text-center">
                                    <div
                                        class="w-20 h-20 bg-yellow-400 border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-all duration-300">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32"
                                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                            stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6"></path>
                                            <path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18"></path>
                                            <path d="M4 22h16"></path>
                                            <path d="M10 14.66V17c0 .55-.47.98-.97 1.21C7.85 18.75 7 20.24 7 22"></path>
                                            <path d="M14 14.66V17c0 .55.47.98.97 1.21C16.15 18.75 17 20.24 17 22">
                                            </path>
                                            <path d="M18 2H6v7a6 6 0 0 0 12 0V2Z"></path>
                                        </svg>
                                    </div>
                                    <span class="font-black uppercase text-sm tracking-tighter">Score Counter</span>
                                </a>

                                <a href="${pageContext.request.contextPath}/ShopController"
                                    class="group flex flex-col items-center gap-4 text-center">
                                    <div
                                        class="w-20 h-20 bg-emerald-400 border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-all duration-300">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32"
                                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                                            stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"></path>
                                            <path d="M3 6h18"></path>
                                            <path d="M16 10a4 4 0 0 1-8 0"></path>
                                        </svg>
                                    </div>
                                    <span class="font-black uppercase text-sm tracking-tighter">Shop & Rent</span>
                                </a>

                                <a href="${pageContext.request.contextPath}/ProfileController"
                                    class="group flex flex-col items-center gap-4 text-center">
                                    <div
                                        class="w-20 h-20 bg-cyan-400 border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-all duration-300">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32"
                                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                            stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="12" cy="7" r="4"></circle>
                                        </svg>
                                    </div>
                                    <span class="font-black uppercase text-sm tracking-tighter">Profile</span>
                                </a>
                                    
                                    <a href="view/chat.jsp" class="group flex flex-col items-center gap-4 text-center">

    <div class="w-20 h-20 bg-pink-400 border-4 border-black rounded-2xl flex items-center justify-center shadow-[4px_4px_0px_#000] group-hover:-translate-y-1 transition">

        <svg xmlns="http://www.w3.org/2000/svg"
             width="34"
             height="34"
             fill="none"
             viewBox="0 0 24 24"
             stroke="black"
             stroke-width="2.5">

            <path stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M8 10h8M8 14h5m-9 6l2.3-2.3A2 2 0 0 1 7.7 17H19a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h1"/>

        </svg>

    </div>

    <span class="font-black uppercase text-sm tracking-tight">
        CHAT ROOM
    </span>

</a>
                            </div>
                        </div>
                    </div>
                </body>

                </html>
                <script>
                    const trigger = document.getElementById('launchpad-trigger');
                    const launchpad = document.getElementById('launchpad');
                    const closeBtn = document.getElementById('launchpad-close');

                    function openLaunchpad() {
                        launchpad.classList.remove('hidden');
                        // Delay sedikit agar transisi opacity terlihat
                        setTimeout(() => {
                            launchpad.classList.remove('opacity-0');
                        }, 10);
                    }

                    function closeLaunchpad() {
                        launchpad.classList.add('opacity-0');
                        // Tunggu transisi selesai baru sembunyikan
                        setTimeout(() => {
                            launchpad.classList.add('hidden');
                        }, 300);
                    }

                    trigger.addEventListener('click', openLaunchpad);
                    closeBtn.addEventListener('click', closeLaunchpad);

                    // Close jika klik area di luar grid
                    launchpad.addEventListener('click', (e) => {
                        if (e.target === launchpad)
                            closeLaunchpad();
                    });

                    // Close jika tekan tombol ESC
                    document.addEventListener('keydown', (e) => {
                        if (e.key === "Escape")
                            closeLaunchpad();
                    });
                    // halohalo tes tes
                </script>