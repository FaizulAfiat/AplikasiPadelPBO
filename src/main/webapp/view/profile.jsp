<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/view/Login.html");
        return;
    }
    
    /* Extract user initial for the avatar */
    String uname = (String) request.getAttribute("username");
    if (uname == null) {
        uname = (String) session.getAttribute("user");
    }
    String initial = (uname != null && !uname.isEmpty()) ? uname.substring(0, 1).toUpperCase() : "?";
%>
<!DOCTYPE html>
        <html lang="id">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Profil & Transaksi - PadelApp</title>

            <!-- Google Fonts: Inter & Outfit (matching index.jsp / admin_dashboard.jsp) -->
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Outfit:wght@300;400;500;700;900&display=swap"
                rel="stylesheet">

            <script src="https://cdn.tailwindcss.com"></script>
            <style>
                .border-grid {
                    border-color: #e5e5e5;
                }

                body {
                    font-family: 'Inter', sans-serif;
                    background-color: #fcfcfc;
                }

                body.admin-mode {
                    font-family: 'Outfit', sans-serif;
                    background-color: #f0f0f0;
                }

                .no-scrollbar::-webkit-scrollbar {
                    display: none;
                }

                .no-scrollbar {
                    -ms-overflow-style: none;
                    scrollbar-width: none;
                }
            </style>
        </head>

        <body class="${role eq 'Admin' ? 'bg-[#f0f0f0] text-black min-h-screen admin-mode' : 'bg-[#FCFCFC] text-black min-h-screen md:h-screen md:overflow-hidden flex flex-col antialiased'}">
            <%@ taglib prefix="c" uri="jakarta.tags.core" %>
                <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

                <c:choose>
                    <c:when test="${role eq 'Admin'}">
                        <div class="flex min-h-screen w-full">
                            <!-- Sidebar Navigation -->
                            <aside class="w-72 bg-black text-white p-8 flex flex-col fixed h-full border-r-4 border-black shadow-[8px_0px_0px_0px_rgba(0,0,0,1)] z-50">
                                <div class="mb-12 border-b-4 border-zinc-800 pb-6">
                                    <h2 class="text-3xl font-black italic tracking-tighter text-cyan-400">PADELAPP</h2>
                                    <div class="flex items-center gap-2 mt-1">
                                        <span class="w-2.5 h-2.5 bg-emerald-400 rounded-full animate-ping"></span>
                                        <p class="text-[10px] font-black text-zinc-400 tracking-[0.2em] uppercase">SYSTEM ADMIN</p>
                                    </div>
                                </div>

                                <nav class="space-y-4 flex-1">
                                    <a href="${pageContext.request.contextPath}/AdminController" 
                                       class="flex items-center gap-3 px-4 py-3 font-black text-xs uppercase tracking-widest text-zinc-400 hover:text-white border-2 border-transparent hover:border-black hover:bg-zinc-900 rounded-xl hover:translate-x-2 transition-all duration-200">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                                            <rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/>
                                        </svg>
                                        Dashboard
                                    </a>
                                    
                                    <a href="${pageContext.request.contextPath}/ManageProducts" 
                                       class="flex items-center gap-3 px-4 py-3 font-black text-xs uppercase tracking-widest text-zinc-400 hover:text-white border-2 border-transparent hover:border-black hover:bg-zinc-900 rounded-xl hover:translate-x-2 transition-all duration-200">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                                            <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4zM3 6h18M16 10a4 4 0 0 1-8 0"/>
                                        </svg>
                                        Manage Shop
                                    </a>
                                    
                                    <a href="${pageContext.request.contextPath}/AdminRentalController" 
                                       class="flex items-center gap-3 px-4 py-3 font-black text-xs uppercase tracking-widest text-zinc-400 hover:text-white border-2 border-transparent hover:border-black hover:bg-zinc-900 rounded-xl hover:translate-x-2 transition-all duration-200">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                                            <rect width="18" height="18" x="3" y="4" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>
                                        </svg>
                                        Track Rentals
                                    </a>
                                    
                                    <a href="${pageContext.request.contextPath}/AdminController#rental-logs" 
                                       class="flex items-center gap-3 px-4 py-3 font-black text-xs uppercase tracking-widest text-zinc-400 hover:text-white border-2 border-transparent hover:border-black hover:bg-zinc-900 rounded-xl hover:translate-x-2 transition-all duration-200">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                            <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                                        </svg>
                                        Schedules
                                    </a>

                                    <a href="${pageContext.request.contextPath}/Profile" 
                                       class="flex items-center gap-3 px-4 py-3 font-black text-xs uppercase tracking-widest bg-cyan-400 text-black border-2 border-black rounded-xl shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] transition-all">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                                        </svg>
                                        Admin Profile
                                    </a>
                                </nav>

                                <div class="pt-6 border-t-4 border-zinc-800 mt-auto">
                                    <a href="${pageContext.request.contextPath}/Logout" 
                                       class="block w-full bg-rose-500/10 text-rose-500 border-2 border-rose-500 p-4 rounded-2xl text-center font-black text-xs uppercase hover:bg-rose-500 hover:text-white hover:shadow-[4px_4px_0px_0px_rgba(244,63,94,0.3)] transition-all">
                                        Exit Session
                                    </a>
                                </div>
                            </aside>

                            <!-- Main Content Area -->
                            <main class="ml-72 p-12 w-full max-w-7xl bg-[#f0f0f0]">
                                <!-- Header -->
                                <header class="mb-12 flex justify-between items-end">
                                    <div>
                                        <h1 class="text-6xl font-black uppercase italic tracking-tighter leading-none">Admin Profile</h1>
                                        <p class="text-zinc-500 font-bold uppercase text-xs mt-3 tracking-widest flex items-center gap-2">
                                            <span class="w-1.5 h-1.5 bg-black rounded-full"></span>
                                            Manage your administrative account settings
                                        </p>
                                    </div>
                                    <div class="bg-white border-4 border-black p-4 rounded-2xl shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] text-right">
                                        <p class="font-bold text-[10px] text-zinc-400 uppercase tracking-widest">Logged in admin</p>
                                        <p class="text-black font-black text-lg uppercase flex items-center justify-end gap-2">
                                            @${username}
                                            <span class="w-3 h-3 bg-cyan-400 rounded-full border-2 border-black"></span>
                                        </p>
                                    </div>
                                </header>

                                <div class="flex flex-col lg:flex-row gap-12">
                                    <!-- Left Info Panel (Admin Card) -->
                                    <div class="w-full lg:w-1/3 space-y-6">
                                        <div class="border-4 border-black p-8 rounded-[2.5rem] bg-white shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] text-left">
                                            <div class="w-20 h-20 bg-black text-white rounded-full flex items-center justify-center text-3xl font-bold uppercase mx-auto mb-6 shadow-sm">
                                                <%= initial %>
                                            </div>
                                            
                                            <div class="space-y-4">
                                                <div>
                                                    <span class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block">Nama Lengkap</span>
                                                    <span class="text-lg font-bold text-black block">${not empty fullname ? fullname : 'Belum diatur'}</span>
                                                </div>
                                                <div>
                                                    <span class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block">Username</span>
                                                    <span class="text-base font-semibold text-zinc-700 block">@${username}</span>
                                                </div>
                                                <div>
                                                    <span class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block">Email</span>
                                                    <span class="text-base font-semibold text-zinc-700 block break-all">${email}</span>
                                                </div>
                                                <div>
                                                    <span class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block">Jenis Kelamin</span>
                                                    <span class="text-base font-semibold text-zinc-700 block">
                                                        <c:choose>
                                                            <c:when test="${gender eq 'L'}">Laki-laki</c:when>
                                                            <c:when test="${gender eq 'P'}">Perempuan</c:when>
                                                            <c:otherwise><span class="italic text-zinc-400">Belum diatur</span></c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                                <div>
                                                    <span class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block mb-1">Tipe Akun</span>
                                                    <span class="inline-block px-3 py-1 bg-black text-cyan-400 border border-zinc-800 text-[10px] font-black uppercase tracking-wider rounded-full shadow-sm">
                                                        Admin System
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Action Buttons -->
                                        <div class="space-y-4">
                                            <button onclick="openModal()" class="w-full text-center bg-cyan-400 text-black border-4 border-black py-4 rounded-2xl font-black uppercase text-xs tracking-wider hover:bg-black hover:text-white transition-all shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-1 hover:translate-y-1">
                                                Edit Profil Admin
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Right Tables Panel (Admin Info Panel) -->
                                    <div class="flex-1 space-y-8 bg-white border-4 border-black rounded-[2.5rem] p-8 shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] text-left">
                                        <h3 class="font-black uppercase italic text-2xl tracking-tighter flex items-center gap-3">
                                            <span class="w-3 h-3 bg-cyan-400 rounded-full border border-black"></span>
                                            Admin Information
                                        </h3>
                                        <p class="text-sm font-semibold text-zinc-500 leading-relaxed">
                                            Sebagai administrator sistem PadelApp, Anda memiliki hak penuh untuk mengelola inventaris toko, mengonfirmasi pemesanan lapangan, serta memantau semua riwayat transaksi dan jadwal pertandingan. 
                                        </p>
                                        <p class="text-sm font-semibold text-zinc-500 leading-relaxed">
                                            Untuk menjaga keamanan sistem, disarankan untuk memperbarui kata sandi secara berkala melalui tombol **Edit Profil Admin** di sebelah kiri.
                                        </p>
                                        <div class="grid grid-cols-2 gap-4 pt-4">
                                            <div class="border border-zinc-200 p-6 rounded-2xl bg-zinc-50/50">
                                                <span class="text-[9px] font-black text-zinc-400 uppercase tracking-widest block">Role Authorization</span>
                                                <span class="text-sm font-bold text-zinc-700 mt-1 block">Full Access</span>
                                            </div>
                                            <div class="border border-zinc-200 p-6 rounded-2xl bg-zinc-50/50">
                                                <span class="text-[9px] font-black text-zinc-400 uppercase tracking-widest block">System Status</span>
                                                <span class="text-sm font-bold text-emerald-600 mt-1 block flex items-center gap-1.5">
                                                    <span class="w-2 h-2 bg-emerald-500 rounded-full"></span> Online
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </main>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Navigation Header (Matching index.jsp) -->
                        <header class="flex border-b border-grid bg-white sticky top-0 z-50">
                        <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
                            <span class="text-[10px] font-bold uppercase block opacity-50 md:text-xs">01 / Padel
                                Management</span>
                            <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">
                                Padel<span class="text-blue-400">App</span>
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
                                <div
                                    class="w-8 h-8 rounded-full bg-black text-white flex items-center justify-center font-bold uppercase text-xs shadow-sm">
                                    <%= initial %>
                                </div>
                                <span
                                    class="hidden lg:inline text-[10px] font-bold uppercase tracking-widest text-zinc-600">
                                    @<%= uname %>
                                </span>
                            </div>
                        </div>
                    </header>

                    <!-- Main Content Area -->
                    <main class="flex flex-col md:flex-row flex-1 md:overflow-hidden">
                        <!-- Left Info Panel -->
                        <aside
                            class="w-full md:w-1/4 p-8 border-b md:border-b-0 md:border-r border-grid bg-white md:overflow-y-auto no-scrollbar">
                            <span class="text-xs font-bold uppercase block mb-2 tracking-widest text-gray-400">02 /
                                Profile</span>
                            <h2 class="text-3xl font-black leading-none uppercase mb-6 tracking-tighter">
                                My Account
                            </h2>

                            <!-- Account Info Block -->
                            <div class="border border-grid p-6 rounded-2xl bg-gray-50/50 shadow-sm mb-6">
                                <div
                                    class="w-16 h-16 bg-black text-white rounded-full flex items-center justify-center text-2xl font-bold uppercase mx-auto mb-6 shadow-sm">
                                    <%= initial %>
                                </div>

                                <div class="space-y-4">
                                    <div>
                                        <span
                                            class="text-[10px] font-bold uppercase tracking-wider text-gray-400 block">Nama
                                            Lengkap</span>
                                        <span class="text-base font-semibold text-black block">
                                            ${not empty fullname ? fullname : 'Belum diatur'}
                                        </span>
                                    </div>
                                    <div>
                                        <span
                                            class="text-[10px] font-bold uppercase tracking-wider text-gray-400 block">Username</span>
                                        <span class="text-sm font-medium text-gray-700 block">@${username}</span>
                                    </div>
                                    <div>
                                        <span
                                            class="text-[10px] font-bold uppercase tracking-wider text-gray-400 block">Email</span>
                                        <span class="text-sm font-medium text-gray-700 block break-all">${email}</span>
                                    </div>
                                    <div>
                                        <span
                                            class="text-[10px] font-bold uppercase tracking-wider text-gray-400 block">Jenis
                                            Kelamin</span>
                                        <span class="text-sm font-medium text-gray-700 block">
                                            <c:choose>
                                                <c:when test="${gender eq 'L'}">Laki-laki</c:when>
                                                <c:when test="${gender eq 'P'}">Perempuan</c:when>
                                                <c:otherwise><span class="italic text-gray-400">Belum diatur</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div>
                                        <span
                                            class="text-[10px] font-bold uppercase tracking-wider text-gray-400 block mb-1">Tipe
                                            Akun</span>
                                        <c:choose>
                                            <c:when test="${role eq 'Admin'}">
                                                <span
                                                    class="inline-block px-2.5 py-0.5 bg-black text-white text-[10px] font-bold uppercase tracking-wider rounded-full">
                                                    Admin
                                                </span>
                                            </c:when>
                                            <c:when test="${role eq 'Premium'}">
                                                <span
                                                    class="inline-block px-2.5 py-0.5 bg-zinc-800 text-white text-[10px] font-bold uppercase tracking-wider rounded-full">
                                                    Premium
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span
                                                    class="inline-block px-2.5 py-0.5 bg-white text-gray-800 text-[10px] font-bold uppercase tracking-wider rounded-full border border-gray-200">
                                                    Regular
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="space-y-3">
                                <button onclick="openModal()"
                                    class="w-full text-center bg-black text-white py-3 rounded-xl font-bold uppercase text-xs tracking-wider hover:bg-zinc-800 transition-colors shadow-sm">
                                    Edit Profil
                                </button>
                                <a href="${pageContext.request.contextPath}/Logout"
                                    class="inline-block w-full text-center border border-gray-300 bg-white text-gray-700 py-3 rounded-xl font-bold uppercase text-xs tracking-wider hover:bg-gray-50 hover:text-black transition-colors shadow-sm">
                                    Keluar Akun
                                </a>
                            </div>
                        </aside>

                        <!-- Right Tables Panel -->
                        <div class="flex-1 p-8 space-y-8 bg-[#FCFCFC] md:overflow-y-auto">
                            <!-- Notifications (Light / Minimal style) -->
                            <c:if test="${not empty param.status}">
                                <c:choose>
                                    <c:when test="${param.status == 'profile_updated'}">
                                        <div id="toast-success"
                                            class="border border-emerald-200 p-4 rounded-xl bg-emerald-50 text-emerald-800 font-medium text-sm flex items-center justify-between shadow-sm">
                                            <div class="flex items-center gap-3">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2" class="shrink-0 text-emerald-600">
                                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                                </svg>
                                                <span>Profil Anda berhasil diperbarui!</span>
                                            </div>
                                            <button onclick="document.getElementById('toast-success').remove()"
                                                class="hover:opacity-75 transition-opacity text-emerald-600">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                                </svg>
                                            </button>
                                        </div>
                                    </c:when>

                                    <c:when test="${param.status == 'success'}">
                                        <div id="toast-booking-success"
                                            class="border border-emerald-200 p-4 rounded-xl bg-emerald-50 text-emerald-800 font-medium text-sm flex items-center justify-between shadow-sm">
                                            <div class="flex items-center gap-3">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2" class="shrink-0 text-emerald-600">
                                                    <circle cx="12" cy="12" r="10"></circle>
                                                    <polyline points="12 6 12 12 16 14"></polyline>
                                                </svg>
                                                <span>Pemesanan lapangan berhasil dikonfirmasi!</span>
                                            </div>
                                            <button onclick="document.getElementById('toast-booking-success').remove()"
                                                class="hover:opacity-75 transition-opacity text-emerald-600">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                                </svg>
                                            </button>
                                        </div>
                                    </c:when>

                                    <c:when test="${param.status == 'error'}">
                                        <div id="toast-error"
                                            class="border border-rose-200 p-4 rounded-xl bg-rose-50 text-rose-800 font-medium text-sm flex items-center justify-between shadow-sm">
                                            <div class="flex items-center gap-3">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2" class="shrink-0 text-rose-600">
                                                    <polygon
                                                        points="7.86 2 16.14 2 22 7.86 22 16.14 16.14 22 7.86 22 2 16.14 2 7.86 7.86 2">
                                                    </polygon>
                                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                                </svg>
                                                <span>Terjadi kesalahan saat memproses data!</span>
                                            </div>
                                            <button onclick="document.getElementById('toast-error').remove()"
                                                class="hover:opacity-75 transition-opacity text-rose-600">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                                </svg>
                                            </button>
                                        </div>
                                    </c:when>
                                </c:choose>
                            </c:if>



                            <!-- Active Rentals Section -->
                            <div class="space-y-4 mb-8">
                                <h3 class="text-lg font-bold uppercase tracking-tight flex items-center gap-2">
                                    <span class="w-2.5 h-2.5 bg-cyan-400 rounded-full animate-pulse"></span>
                                    Rental Aktif Saya
                                </h3>

                                <div class="border border-grid rounded-2xl overflow-hidden shadow-sm bg-white">
                                    <div class="overflow-x-auto">
                                        <table class="w-full text-left border-collapse">
                                            <thead>
                                                <tr class="bg-gray-50 text-gray-500 font-bold uppercase text-[10px] tracking-wider border-b border-grid">
                                                    <th class="p-4">Rental ID</th>
                                                    <th class="p-4">Produk</th>
                                                    <th class="p-4">Kategori</th>
                                                    <th class="p-4">Jumlah</th>
                                                    <th class="p-4">Tanggal Sewa</th>
                                                    <th class="p-4">Batas Pengembalian</th>
                                                    <th class="p-4">Sisa Waktu</th>
                                                    <th class="p-4">Status</th>
                                                </tr>
                                            </thead>
                                            <tbody class="divide-y divide-gray-100">
                                                <c:choose>
                                                    <c:when test="${empty activeRentals}">
                                                        <tr>
                                                            <td colspan="8" class="p-8 text-center text-gray-400 font-medium italic bg-gray-50/50">
                                                                Anda tidak memiliki sewa barang yang sedang aktif.
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="rental" items="${activeRentals}">
                                                            <tr class="hover:bg-gray-50 transition-colors duration-150 text-gray-700 text-sm">
                                                                <td class="p-4 font-semibold">#${rental.id}</td>
                                                                <td class="p-4">
                                                                    <div class="flex items-center gap-3">
                                                                        <div class="w-8 h-8 bg-gray-100 border border-gray-200 rounded overflow-hidden shrink-0 flex items-center justify-center">
                                                                            <img src="${pageContext.request.contextPath}/img/${not empty rental.image ? rental.image : 'default.png'}" 
                                                                                 alt="${rental.productName}" 
                                                                                 class="object-contain w-6 h-6"
                                                                                 onerror="this.src='${pageContext.request.contextPath}/img/default.png'">
                                                                        </div>
                                                                        <span class="font-bold text-black max-w-xs truncate">${rental.productName}</span>
                                                                    </div>
                                                                </td>
                                                                <td class="p-4 uppercase text-xs text-gray-500">${rental.category}</td>
                                                                <td class="p-4">${rental.quantity} pcs</td>
                                                                <td class="p-4">
                                                                    <fmt:formatDate value="${rental.rentalDate}" pattern="dd MMM yyyy" />
                                                                </td>
                                                                <td class="p-4 text-rose-600 font-semibold">
                                                                    <fmt:formatDate value="${rental.dueDate}" pattern="dd MMM yyyy" />
                                                                </td>
                                                                <td class="p-4 font-semibold">
                                                                    <c:choose>
                                                                        <c:when test="${rental.remainingDays < 0}">
                                                                            <span class="text-rose-600 font-black animate-pulse">Terlambat ${-rental.remainingDays} Hari</span>
                                                                        </c:when>
                                                                        <c:when test="${rental.remainingDays == 0}">
                                                                            <span class="text-yellow-600 font-bold">Hari ini</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-cyan-600">${rental.remainingDays} Hari lagi</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="p-4">
                                                                    <c:choose>
                                                                        <c:when test="${rental.status eq 'Active'}">
                                                                            <span class="px-2 py-0.5 bg-cyan-50 text-cyan-800 border border-cyan-200 rounded text-[9px] font-bold uppercase tracking-wider">
                                                                                Active
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${rental.status eq 'Overdue'}">
                                                                            <span class="px-2 py-0.5 bg-rose-50 text-rose-800 border border-rose-200 rounded text-[9px] font-bold uppercase tracking-wider animate-pulse">
                                                                                Overdue
                                                                            </span>
                                                                        </c:when>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- Product Purchase/Rental History -->
                            <div class="space-y-4">
                                <h3 class="text-lg font-bold uppercase tracking-tight flex items-center gap-2">
                                    <span class="w-2.5 h-2.5 bg-emerald-500 rounded-full"></span>
                                    Riwayat Belanja & Rental
                                </h3>

                                <div class="border border-grid rounded-2xl overflow-hidden shadow-sm bg-white">
                                    <div class="overflow-x-auto">
                                        <table class="w-full text-left border-collapse">
                                            <thead>
                                                <tr
                                                    class="bg-gray-50 text-gray-500 font-bold uppercase text-[10px] tracking-wider border-b border-grid">
                                                    <th class="p-4">Tx ID</th>
                                                    <th class="p-4">Produk</th>
                                                    <th class="p-4">Kategori</th>
                                                    <th class="p-4">Jumlah</th>
                                                    <th class="p-4">Jenis</th>
                                                    <th class="p-4">Tanggal</th>
                                                    <th class="p-4">Total Biaya</th>
                                                    <th class="p-4">Status</th>
                                                </tr>
                                            </thead>
                                            <tbody class="divide-y divide-gray-100">
                                                <c:choose>
                                                    <c:when test="${empty transactionHistory}">
                                                        <tr>
                                                            <td colspan="8"
                                                                class="p-8 text-center text-gray-400 font-medium italic bg-gray-50/50">
                                                                Belum ada riwayat transaksi belanja.
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="tx" items="${transactionHistory}">
                                                            <tr
                                                                class="hover:bg-gray-50 transition-colors duration-150 text-gray-700 text-sm">
                                                                <td class="p-4 font-semibold">#${tx.id}</td>
                                                                <td class="p-4 font-semibold text-black">
                                                                    ${tx.productName}</td>
                                                                <td class="p-4 uppercase text-xs text-gray-500">
                                                                    ${tx.category}</td>
                                                                <td class="p-4">${tx.quantity} pcs</td>
                                                                <td class="p-4">
                                                                    <span
                                                                        class="px-2 py-0.5 border border-gray-200 text-[9px] font-bold uppercase rounded bg-gray-50 text-gray-600">
                                                                        ${tx.type == 'Rent' ? 'Rental' : 'Purchase'}
                                                                    </span>
                                                                </td>
                                                                <td class="p-4 font-medium">
                                                                    <fmt:formatDate value="${tx.date}"
                                                                        pattern="dd MMM yyyy" />
                                                                </td>
                                                                <td class="p-4 font-semibold text-black">
                                                                    <fmt:formatNumber value="${tx.total}"
                                                                        type="currency" currencySymbol="Rp "
                                                                        maxFractionDigits="0" />
                                                                </td>
                                                                <td class="p-4">
                                                                    <c:choose>
                                                                        <c:when test="${tx.status eq 'Processing'}">
                                                                            <span
                                                                                class="px-2.5 py-1 bg-yellow-50 text-yellow-800 border border-yellow-200 rounded-full text-[10px] font-bold uppercase tracking-wider">
                                                                                Processing
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${tx.status eq 'Completed'}">
                                                                            <span
                                                                                class="px-2.5 py-1 bg-emerald-50 text-emerald-800 border border-emerald-200 rounded-full text-[10px] font-bold uppercase tracking-wider">
                                                                                Completed
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${tx.status eq 'Failed'}">
                                                                            <span
                                                                                class="px-2.5 py-1 bg-rose-50 text-rose-800 border border-rose-200 rounded-full text-[10px] font-bold uppercase tracking-wider">
                                                                                Failed
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span
                                                                                class="px-2.5 py-1 bg-gray-50 text-gray-600 border border-gray-200 rounded-full text-[10px] font-bold uppercase tracking-wider">
                                                                                ${tx.status}
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- Match History -->
                            <div class="space-y-4">
                                <h3 class="text-lg font-bold uppercase tracking-tight flex items-center gap-2">
                                    <span class="w-2.5 h-2.5 bg-purple-400 rounded-full"></span>
                                    Riwayat Pertandingan
                                </h3>

                                <div class="border border-grid rounded-2xl overflow-hidden shadow-sm bg-white">
                                    <div class="overflow-x-auto">
                                        <table class="w-full text-left border-collapse">
                                            <thead>
                                                <tr
                                                    class="bg-gray-50 text-gray-500 font-bold uppercase text-[10px] tracking-wider border-b border-grid">
                                                    <th class="p-4">ID</th>
                                                    <th class="p-4">Mode</th>
                                                    <th class="p-4">Partner</th>
                                                    <th class="p-4">Lawan</th>
                                                    <th class="p-4">Skor</th>
                                                    <th class="p-4">Hasil</th>
                                                </tr>
                                            </thead>
                                            <tbody class="divide-y divide-gray-100">
                                                <c:choose>
                                                    <c:when test="${empty matchHistory}">
                                                        <tr>
                                                            <td colspan="6"
                                                                class="p-8 text-center text-gray-400 font-medium italic bg-gray-50/50">
                                                                Belum ada riwayat pertandingan.
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="match" items="${matchHistory}">
                                                            <tr
                                                                class="hover:bg-gray-50 transition-colors duration-150 text-gray-700 text-sm">
                                                                <td class="p-4 font-semibold">#${match.id}</td>
                                                                <td class="p-4 uppercase text-xs text-gray-500">
                                                                    ${match.mode}</td>
                                                                <td class="p-4 font-medium">${match.partner}</td>
                                                                <td class="p-4 font-medium">${match.opponents}</td>
                                                                <td class="p-4 font-semibold text-black">${match.score}
                                                                </td>
                                                                <td class="p-4">
                                                                    <c:choose>
                                                                        <c:when test="${match.outcome eq 'WIN'}">
                                                                            <span
                                                                                class="px-2.5 py-1 bg-emerald-50 text-emerald-800 border border-emerald-200 rounded-full text-[10px] font-bold uppercase tracking-wider">
                                                                                WIN
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${match.outcome eq 'LOSE'}">
                                                                            <span
                                                                                class="px-2.5 py-1 bg-rose-50 text-rose-800 border border-rose-200 rounded-full text-[10px] font-bold uppercase tracking-wider">
                                                                                LOSE
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span
                                                                                class="px-2.5 py-1 bg-gray-50 text-gray-600 border border-gray-200 rounded-full text-[10px] font-bold uppercase tracking-wider">
                                                                                DRAW
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                    </c:otherwise>
                </c:choose>

                <!-- Edit Profile Modal (Clean & Modern) -->
                    <div id="edit-profile-modal"
                        class="fixed inset-0 z-50 hidden bg-black/55 backdrop-blur-sm flex items-center justify-center p-4">
                        <div
                            class="w-full max-w-md bg-white border border-grid rounded-2xl shadow-xl overflow-hidden transition-all transform duration-300">
                            <!-- Modal Header -->
                            <div
                                class="bg-gray-50 text-black p-4 flex justify-between items-center border-b border-grid">
                                <h3 class="font-bold uppercase tracking-wider text-xs text-gray-700">Edit Profil Anda
                                </h3>
                                <button onclick="closeModal()" class="text-gray-400 hover:text-black transition-colors">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                </button>
                            </div>

                            <!-- Modal Body / Form -->
                            <form action="${pageContext.request.contextPath}/Profile" method="POST"
                                class="p-6 space-y-4">
                                <div>
                                    <label for="fullname"
                                        class="block text-[10px] font-bold uppercase tracking-wider mb-2 text-gray-500">
                                        Nama Lengkap
                                    </label>
                                    <input type="text" id="fullname" name="fullname" value="${fullname}" required
                                        class="w-full px-4 py-2.5 border border-gray-300 rounded-xl font-medium placeholder-gray-400 focus:outline-none focus:border-black focus:ring-1 focus:ring-black transition-all bg-white"
                                        placeholder="Masukkan nama lengkap Anda">
                                </div>

                                <div>
                                    <label for="gender"
                                        class="block text-[10px] font-bold uppercase tracking-wider mb-2 text-gray-500">
                                        Jenis Kelamin
                                    </label>
                                    <select id="gender" name="gender" required
                                        class="w-full px-4 py-2.5 border border-gray-300 rounded-xl font-medium bg-white focus:outline-none focus:border-black focus:ring-1 focus:ring-black transition-all">
                                        <option value="" disabled ${empty gender ? 'selected' : '' }>Pilih Jenis Kelamin
                                        </option>
                                        <option value="L" ${gender eq 'L' ? 'selected' : '' }>Laki-laki</option>
                                        <option value="P" ${gender eq 'P' ? 'selected' : '' }>Perempuan</option>
                                    </select>
                                </div>

                                <div>
                                    <label for="email"
                                        class="block text-[10px] font-bold uppercase tracking-wider mb-2 text-gray-500">
                                        Email
                                    </label>
                                    <input type="email" id="email" name="email" value="${email}" required
                                        class="w-full px-4 py-2.5 border border-gray-300 rounded-xl font-medium placeholder-gray-400 focus:outline-none focus:border-black focus:ring-1 focus:ring-black transition-all bg-white"
                                        placeholder="nama@email.com">
                                </div>

                                <div>
                                    <label for="password"
                                        class="block text-[10px] font-bold uppercase tracking-wider mb-2 text-gray-500">
                                        Kata Sandi Baru
                                    </label>
                                    <input type="password" id="password" name="password"
                                        class="w-full px-4 py-2.5 border border-gray-300 rounded-xl font-medium placeholder-gray-400 focus:outline-none focus:border-black focus:ring-1 focus:ring-black transition-all bg-white"
                                        placeholder="••••••••">
                                    <span class="block text-[10px] text-gray-400 mt-2">
                                        * Biarkan kosong jika tidak ingin mengubah kata sandi.
                                    </span>
                                </div>

                                <!-- Modal Footer -->
                                <div class="flex gap-4 pt-4 border-t border-grid">
                                    <button type="button" onclick="closeModal()"
                                        class="flex-1 text-center border border-gray-300 bg-white text-gray-700 py-2.5 rounded-xl font-bold uppercase text-xs tracking-wider hover:bg-gray-50 transition-colors shadow-sm">
                                        Batal
                                    </button>
                                    <button type="submit"
                                        class="flex-1 text-center bg-black text-white py-2.5 rounded-xl font-bold uppercase text-xs tracking-wider hover:bg-zinc-800 transition-colors shadow-sm">
                                        Simpan
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <script>
                        function openModal() {
                            const modal = document.getElementById('edit-profile-modal');
                            modal.classList.remove('hidden');
                            document.body.style.overflow = 'hidden';
                        }

                        function closeModal() {
                            const modal = document.getElementById('edit-profile-modal');
                            modal.classList.add('hidden');
                            document.body.style.overflow = '';
                        }

                        // Close modal if user clicks outside of the modal content
                        window.addEventListener('click', function (e) {
                            const modal = document.getElementById('edit-profile-modal');
                            if (e.target === modal) {
                                closeModal();
                            }
                        });
                    </script>
        </body>

        </html>