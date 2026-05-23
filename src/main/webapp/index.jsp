<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("view/Login.html");
    }
%>

<!DOCTYPE html>
<html lang="id">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

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

        <!-- HEADER -->

        <header class="flex border-b border-grid bg-white sticky top-0 z-50">

            <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">

                <span class="text-[10px] font-bold uppercase block opacity-50 md:text-xs">

                    01 / Padel Management

                </span>

                <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">

                    Padel<span class="text-blue-400">App</span>

                </h1>

            </div>

            <div class="hidden md:flex flex-1 items-center justify-center border-r border-grid p-6">

                <div class="flex items-center gap-2">

                    <span class="w-2 h-2 bg-blue-500 rounded-full animate-pulse"></span>

                    <span class="text-[10px] font-bold uppercase tracking-widest">

                        Open for Bookings

                    </span>

                </div>

            </div>

            <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4 md:gap-6">

                <!-- LAUNCHPAD BUTTON -->

                <button id="launchpad-trigger"
                        class="hover:bg-gray-200 p-2 rounded-lg transition-all">

                    <svg xmlns="http://www.w3.org/2000/svg"
                         width="24"
                         height="24"
                         viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2"
                         stroke-linecap="round"
                         stroke-linejoin="round">

                    <rect x="3" y="3" width="7" height="7"></rect>
                    <rect x="14" y="3" width="7" height="7"></rect>
                    <rect x="14" y="14" width="7" height="7"></rect>
                    <rect x="3" y="14" width="7" height="7"></rect>

                    </svg>

                </button>

                <!-- USER -->

                <div class="flex items-center gap-2 group cursor-pointer">

                    <svg xmlns="http://www.w3.org/2000/svg"
                         fill="none"
                         viewBox="0 0 24 24"
                         stroke-width="2"
                         stroke="currentColor"
                         class="w-5 h-5">

                    <path stroke-linecap="round"
                          stroke-linejoin="round"
                          d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z"/>

                    </svg>

                    <span class="hidden lg:inline text-[10px] font-bold uppercase tracking-widest">

                        <%= (session.getAttribute("user") != null)
                                ? session.getAttribute("user")
                                : "Guest"%>

                    </span>

                </div>

                <!-- LOGOUT -->

                <button onclick="window.location.href = '${pageContext.request.contextPath}/Logout'"
                        class="bg-black text-white px-4 py-2 md:px-6 md:py-2 rounded-full text-[10px] md:text-xs font-bold uppercase tracking-widest hover:bg-red-600 transition-colors">

                    Logout

                </button>

            </div>

        </header>

        <!-- MAIN -->

        <main class="flex flex-col flex-1">

            <!-- HERO -->

            <div class="w-full border-b border-grid overflow-hidden relative group">

                <img src="img/padel.jpg"
                     alt="Padel Banner"
                     class="w-full h-64 md:h-96 object-cover grayscale group-hover:grayscale-0 transition-all duration-700">

                <div class="absolute bottom-8 right-8 z-20">

                    <a href="BookingController"
                       class="bg-blue-400 text-black px-8 py-4 font-black uppercase tracking-tighter text-xl border-2 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] hover:translate-x-[2px] hover:translate-y-[2px] hover:shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] transition-all inline-block">

                        Book Now →

                    </a>

                </div>

            </div>

            <!-- CONTENT -->

            <div class="flex flex-col md:flex-row flex-1">

                <!-- LEFT -->

                <div class="w-full md:w-1/3 p-8 md:p-12 border-b md:border-b-0 md:border-r border-grid bg-white">

                    <span class="text-xs font-bold uppercase block mb-4 opacity-50">

                        02 / Dashboard

                    </span>

                    <h2 class="text-4xl md:text-6xl font-black leading-none uppercase mb-8 tracking-tighter">

                        What we do for athletes

                    </h2>

                    <div class="w-4 h-4 bg-cyan-400 rounded-full"></div>

                </div>

                <!-- RIGHT -->

                <div class="flex-1 bg-white">

                    <!-- FIELD BOOKING -->

                    <div class="p-8 md:p-12 border-b border-grid group hover:bg-gray-50 transition-colors">

                        <div class="flex flex-col sm:flex-row gap-4">

                            <span class="text-xs font-bold w-12 pt-1 opacity-50">

                                01

                            </span>

                            <div>

                                <h3 class="text-3xl md:text-5xl font-black uppercase mb-4 tracking-tighter">

                                    Field Booking

                                </h3>

                                <p class="text-sm md:text-base text-gray-500 max-w-md leading-relaxed">

                                    Pesan lapangan Padel favoritmu secara instan.

                                </p>

                            </div>

                        </div>

                    </div>

                    <!-- MEMBER STATS -->

                    <div class="p-8 md:p-12 border-b border-grid group hover:bg-gray-50 transition-colors">

                        <div class="flex flex-col sm:flex-row gap-4">

                            <span class="text-xs font-bold w-12 pt-1 opacity-50">

                                02

                            </span>

                            <div>

                                <h3 class="text-3xl md:text-5xl font-black uppercase mb-4 tracking-tighter">

                                    Member Stats

                                </h3>

                                <p class="text-sm md:text-base text-gray-500 max-w-md leading-relaxed">

                                    Pantau statistik permainan dan latihan.

                                </p>

                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </main>

        <!-- LAUNCHPAD -->

        <div id="launchpad"
             class="fixed inset-0 z-[999] hidden bg-white/80 backdrop-blur-xl transition-all duration-300 opacity-0">

            <button id="launchpad-close"
                    class="absolute top-8 right-8 text-black text-3xl hover:scale-110 transition-transform">

                ✕

            </button>

            <div class="h-full w-full flex items-center justify-center p-10">

                <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-12 max-w-6xl w-full">

                    <!-- BOOK COURT -->

                    <a href="BookingController"
                       class="bg-black text-white p-6 rounded-2xl text-center font-black uppercase hover:scale-105 transition-all">

                        Book Court

                    </a>

                    <!-- PROFILE -->

                    <a href="${pageContext.request.contextPath}/ProfileController"
                       class="bg-cyan-400 p-6 rounded-2xl text-center font-black uppercase hover:scale-105 transition-all">

                        Profile

                    </a>

                    <!-- FRIEND LIST -->

                    <a href="viewFriends?userId=1"
                       class="bg-pink-400 p-6 rounded-2xl text-center font-black uppercase hover:scale-105 transition-all">

                        Friend List

                    </a>

                    <!-- TRACK HEALTH -->

                    <a href="${pageContext.request.contextPath}/view/trackhealth.jsp"
                       class="bg-green-400 p-6 rounded-2xl text-center font-black uppercase hover:scale-105 transition-all">

                        Track Health

                    </a>

                    <!-- HEALTH HISTORY -->

                    <a href="${pageContext.request.contextPath}/view/healthhistory.jsp"
                       class="bg-yellow-300 p-6 rounded-2xl text-center font-black uppercase hover:scale-105 transition-all">

                        Health History

                    </a>

                </div>

            </div>

        </div>

        <!-- SCRIPT -->

        <script>

            const trigger =
                    document.getElementById('launchpad-trigger');

            const launchpad =
                    document.getElementById('launchpad');

            const closeBtn =
                    document.getElementById('launchpad-close');

            function openLaunchpad() {

                launchpad.classList.remove('hidden');

                setTimeout(() => {

                    launchpad.classList.remove('opacity-0');

                }, 10);

            }

            function closeLaunchpad() {

                launchpad.classList.add('opacity-0');

                setTimeout(() => {

                    launchpad.classList.add('hidden');

                }, 300);

            }

            trigger.addEventListener('click', openLaunchpad);

            closeBtn.addEventListener('click', closeLaunchpad);

        </script>

    </body>

</html>