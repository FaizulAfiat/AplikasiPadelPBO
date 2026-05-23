<%-- 
    Document   : admin_dashboard.jsp
    Created on : 11 May 2026, 08.07.03
    Author     : Faizul Afiat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard - PadelApp</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;700;900&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Outfit', sans-serif;
            }
        </style>
    </head>
    <body class="bg-[#f0f0f0] text-black min-h-screen">
        <div class="flex min-h-screen">
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
                       class="flex items-center gap-3 px-4 py-3 font-black text-xs uppercase tracking-widest bg-cyan-400 text-black border-2 border-black rounded-xl shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] transition-all">
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
                    
                    <a href="${pageContext.request.contextPath}/AdminController#rental-logs" 
                       class="flex items-center gap-3 px-4 py-3 font-black text-xs uppercase tracking-widest text-zinc-400 hover:text-white border-2 border-transparent hover:border-black hover:bg-zinc-900 rounded-xl hover:translate-x-2 transition-all duration-200">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                            <rect width="18" height="18" x="3" y="4" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>
                        </svg>
                        Schedules
                    </a>

                    <a href="${pageContext.request.contextPath}/Profile" 
                       class="flex items-center gap-3 px-4 py-3 font-black text-xs uppercase tracking-widest text-zinc-400 hover:text-white border-2 border-transparent hover:border-black hover:bg-zinc-900 rounded-xl hover:translate-x-2 transition-all duration-200">
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
            <main class="ml-72 p-12 w-full max-w-7xl">
                <!-- Header -->
                <header class="mb-12 flex justify-between items-end">
                    <div>
                        <h1 class="text-6xl font-black uppercase italic tracking-tighter leading-none">Overview</h1>
                        <p class="text-zinc-500 font-bold uppercase text-xs mt-3 tracking-widest flex items-center gap-2">
                            <span class="w-1.5 h-1.5 bg-black rounded-full"></span>
                            Real-time business analytics
                        </p>
                    </div>
                    <div class="bg-white border-4 border-black p-4 rounded-2xl shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] text-right">
                        <p class="font-bold text-[10px] text-zinc-400 uppercase tracking-widest">Logged in admin</p>
                        <p class="text-black font-black text-lg uppercase flex items-center justify-end gap-2">
                            ${user}
                            <span class="w-3 h-3 bg-cyan-400 rounded-full border-2 border-black"></span>
                        </p>
                    </div>
                </header>

                <!-- Statistics Metrics Grid -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <!-- Earnings Card -->
                    <div class="bg-black text-white p-8 rounded-[2.5rem] border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] hover:-translate-x-1.5 hover:-translate-y-1.5 hover:shadow-[12px_12px_0px_0px_rgba(0,0,0,1)] transition-all duration-300 relative overflow-hidden group">
                        <div class="flex items-center justify-between mb-4">
                            <span class="text-[10px] font-black uppercase tracking-wider text-cyan-400">Total Earnings</span>
                            <div class="w-8 h-8 rounded-full bg-cyan-400/10 flex items-center justify-center text-cyan-400">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                                    <line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                                </svg>
                            </div>
                        </div>
                        <h2 class="text-3xl font-black italic tracking-tight text-white mt-2">
                            <fmt:setLocale value="id_ID"/>
                            <fmt:formatNumber value="${revenue}" type="currency" currencySymbol="Rp " maxFractionDigits="0"/>
                        </h2>
                        <div class="absolute -right-8 -bottom-8 w-24 h-24 bg-cyan-400/10 rounded-full blur-2xl group-hover:bg-cyan-400/20 transition-all"></div>
                    </div>

                    <!-- Bookings Card -->
                    <div class="bg-lime-300 text-black p-8 rounded-[2.5rem] border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] hover:-translate-x-1.5 hover:-translate-y-1.5 hover:shadow-[12px_12px_0px_0px_rgba(0,0,0,1)] transition-all duration-300 relative overflow-hidden group">
                        <div class="flex items-center justify-between mb-4">
                            <span class="text-[10px] font-black uppercase tracking-wider text-black opacity-60">Total Rentals</span>
                            <div class="w-8 h-8 rounded-full bg-black/10 flex items-center justify-center text-black">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                                    <rect width="18" height="18" x="3" y="4" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>
                                </svg>
                            </div>
                        </div>
                        <h2 class="text-3xl font-black italic tracking-tight text-black mt-2">
                            ${bookingCount} Bookings
                        </h2>
                    </div>

                    <!-- Products Card -->
                    <div class="bg-amber-400 text-black p-8 rounded-[2.5rem] border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] hover:-translate-x-1.5 hover:-translate-y-1.5 hover:shadow-[12px_12px_0px_0px_rgba(0,0,0,1)] transition-all duration-300 relative overflow-hidden group">
                        <div class="flex items-center justify-between mb-4">
                            <span class="text-[10px] font-black uppercase tracking-wider text-black opacity-60">Inventory Size</span>
                            <div class="w-8 h-8 rounded-full bg-black/10 flex items-center justify-center text-black">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                                    <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16zM3.27 6.96L12 12.01l8.73-5.05M12 22.08V12"/>
                                </svg>
                            </div>
                        </div>
                        <h2 class="text-3xl font-black italic tracking-tight text-black mt-2">
                            ${productCount} Items
                        </h2>
                    </div>

                    <!-- Quick Action Card -->
                    <div onclick="window.location.href='${pageContext.request.contextPath}/ManageProducts'" 
                         class="bg-fuchsia-400 text-black p-8 rounded-[2.5rem] border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] hover:-translate-x-1.5 hover:-translate-y-1.5 hover:shadow-[12px_12px_0px_0px_rgba(0,0,0,1)] transition-all duration-300 flex flex-col justify-between cursor-pointer group">
                        <div class="flex items-center justify-between">
                            <span class="text-[10px] font-black uppercase tracking-wider text-black opacity-60">Quick Actions</span>
                            <div class="w-8 h-8 rounded-full bg-black text-white flex items-center justify-center group-hover:scale-110 transition-transform">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                                    <path d="M5 12h14M12 5v14"/>
                                </svg>
                            </div>
                        </div>
                        <div class="mt-4">
                            <h3 class="font-black uppercase text-xl leading-none tracking-tight">Add New <br>Product →</h3>
                        </div>
                    </div>
                </div>

                <!-- Court Rental Logs Card -->
                <div id="rental-logs" class="bg-white border border-gray-200 rounded-[2.5rem] p-8 shadow-sm mt-12 overflow-hidden">
                    <div class="flex items-center justify-between mb-8 pb-4 border-b border-gray-200">
                        <h3 class="font-black uppercase italic text-3xl tracking-tighter flex items-center gap-3">
                            <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6M16 13H8M16 17H8M10 9H8"/>
                            </svg>
                            Court Rental Logs
                        </h3>
                        <span class="text-xs bg-gray-50 text-gray-600 font-bold px-3 py-1.5 border border-gray-200 rounded-lg">
                            ${fn:length(bookingList)} records
                        </span>
                    </div>

                    <div class="overflow-x-auto border border-gray-200 rounded-2xl">
                        <table class="w-full text-left border-collapse bg-white">
                            <thead>
                                <tr class="bg-gray-50 text-gray-500 font-bold uppercase text-[10px] tracking-wider border-b border-gray-200">
                                    <th class="py-3 px-4">ID</th>
                                    <th class="py-3 px-4">Customer</th>
                                    <th class="py-3 px-4">Court</th>
                                    <th class="py-3 px-4">Schedule</th>
                                    <th class="py-3 px-4">Amount</th>
                                    <th class="py-3 px-4">Status</th>
                                    <th class="py-3 px-4 text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="text-sm font-semibold divide-y divide-gray-100">
                                <c:choose>
                                    <c:when test="${empty bookingList}">
                                        <tr>
                                            <td colspan="7" class="py-12 text-center text-gray-400 font-medium italic bg-gray-50/50">
                                                No bookings recorded yet
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="b" items="${bookingList}">
                                            <tr class="hover:bg-gray-50/50 transition-colors text-gray-700">
                                                <!-- Booking ID -->
                                                <td class="py-4 px-4 font-semibold text-gray-400">#${b.id}</td>
                                                
                                                <!-- Customer Username -->
                                                <td class="py-4 px-4 uppercase font-semibold text-gray-900 tracking-tight">${b.username}</td>
                                                
                                                <!-- Court Name (Color Badge Specifics) -->
                                                <td class="py-4 px-4">
                                                    <c:choose>
                                                        <c:when test="${fn:contains(fn:toUpperCase(b.court), 'A')}">
                                                            <span class="px-2.5 py-1 bg-blue-50 text-blue-800 border border-blue-200 rounded-full text-[10px] font-bold uppercase tracking-wider">
                                                                ${b.court}
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${fn:contains(fn:toUpperCase(b.court), 'B')}">
                                                            <span class="px-2.5 py-1 bg-emerald-50 text-emerald-800 border border-emerald-200 rounded-full text-[10px] font-bold uppercase tracking-wider">
                                                                ${b.court}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="px-2.5 py-1 bg-gray-50 text-gray-800 border border-gray-200 rounded-full text-[10px] font-bold uppercase tracking-wider">
                                                                ${b.court}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                                <!-- Booking Time Range -->
                                                <td class="py-4 px-4">
                                                    <div class="flex flex-col">
                                                        <span class="text-gray-900 uppercase text-xs font-semibold"><fmt:formatDate value="${b.date}" pattern="dd MMM yyyy" /></span>
                                                        <span class="text-[10px] text-cyan-600 font-bold mt-1 flex items-center gap-1">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                                                <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                                                            </svg>
                                                            <fmt:formatDate value="${b.start}" pattern="HH:mm"/> - <fmt:formatDate value="${b.end}" pattern="HH:mm"/>
                                                        </span>
                                                    </div>
                                                </td>
                                                
                                                <!-- Total Price -->
                                                <td class="py-4 px-4 font-semibold text-gray-900">
                                                    <fmt:formatNumber value="${b.total}" type="currency" currencySymbol="Rp " maxFractionDigits="0"/>
                                                </td>
                                                
                                                <!-- Status Badge (Clean Border Style) -->
                                                <td class="py-4 px-4">
                                                    <c:set var="statusLower" value="${fn:toLowerCase(b.status)}" />
                                                    <c:choose>
                                                        <c:when test="${statusLower == 'pending'}">
                                                            <span class="px-2.5 py-1 bg-amber-50 text-amber-800 border border-amber-200 rounded-full text-[10px] font-bold uppercase tracking-wider inline-block">
                                                                Pending
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${statusLower == 'confirmed'}">
                                                            <span class="px-2.5 py-1 bg-emerald-50 text-emerald-800 border border-emerald-200 rounded-full text-[10px] font-bold uppercase tracking-wider inline-block">
                                                                Confirmed
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="px-2.5 py-1 bg-rose-50 text-rose-800 border border-rose-200 rounded-full text-[10px] font-bold uppercase tracking-wider inline-block">
                                                                ${b.status}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <!-- Actions (Approve, Cancel, or Locked states) -->
                                                <td class="py-4 px-4">
                                                    <div class="flex justify-center gap-2">
                                                        <c:choose>
                                                            <c:when test="${statusLower == 'pending'}">
                                                                <!-- For Pending: Admin can Approve or Cancel -->
                                                                <a href="UpdateStatusController?id=${b.id}&status=Confirmed" 
                                                                   title="Setujui Booking"
                                                                   class="bg-emerald-50 text-emerald-700 border border-emerald-200 p-2 rounded-xl hover:bg-emerald-100 transition-colors">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                                                                        <path d="M20 6L9 17l-5-5"/>
                                                                    </svg>
                                                                </a>
                                                                <a href="UpdateStatusController?id=${b.id}&status=Cancelled" 
                                                                   title="Batalkan Booking"
                                                                   class="bg-rose-50 text-rose-700 border border-rose-200 p-2 rounded-xl hover:bg-rose-100 transition-colors">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                                                                        <path d="M18 6L6 18M6 6l12 12"/>
                                                                    </svg>
                                                                </a>
                                                            </c:when>
                                                            <c:when test="${statusLower == 'confirmed'}">
                                                                <!-- For Confirmed (Model A): Admin can Cancel/Revoke -->
                                                                <a href="UpdateStatusController?id=${b.id}&status=Cancelled" 
                                                                   title="Batalkan Booking (Revoke)"
                                                                   class="bg-rose-50 text-rose-700 border border-rose-200 rounded-xl hover:bg-rose-100 transition-colors flex items-center gap-1 text-[10px] font-bold uppercase px-3 py-1.5">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                                                                        <path d="M18 6L6 18M6 6l12 12"/>
                                                                    </svg>
                                                                    Cancel
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <!-- For Cancelled: No further actions available -->
                                                                <span class="text-gray-400 text-[10px] font-semibold uppercase tracking-wider">Locked</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>
