<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Track Rentals - PadelApp</title>
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
<body class="bg-gray-50 text-black min-h-screen">
    <div class="flex min-h-screen">
        <!-- Sidebar Navigation -->
        <aside class="w-72 bg-zinc-950 text-white p-8 flex flex-col fixed h-full border-r border-zinc-900 shadow-sm z-50">
            <div class="mb-12 border-b border-zinc-900 pb-6">
                <h2 class="text-3xl font-black italic tracking-tighter text-cyan-400">PADELAPP</h2>
                <div class="flex items-center gap-2 mt-1">
                    <span class="w-2 h-2 bg-emerald-400 rounded-full animate-ping"></span>
                    <p class="text-[10px] font-black text-zinc-500 tracking-[0.2em] uppercase">SYSTEM ADMIN</p>
                </div>
            </div>
            <nav class="space-y-4 flex-1">
                <a href="AdminController"
                    class="flex items-center gap-3 px-4 py-3 font-semibold text-xs uppercase tracking-widest text-zinc-400 hover:text-white hover:bg-zinc-900 rounded-xl hover:translate-x-1.5 transition-all duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                        <rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/>
                    </svg>
                    Dashboard
                </a>
                <a href="ManageProducts"
                    class="flex items-center gap-3 px-4 py-3 font-semibold text-xs uppercase tracking-widest text-zinc-400 hover:text-white hover:bg-zinc-900 rounded-xl hover:translate-x-1.5 transition-all duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                        <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4zM3 6h18M16 10a4 4 0 0 1-8 0"/>
                    </svg>
                    Manage Shop
                </a>
                <a href="AdminRentalController"
                    class="flex items-center gap-3 px-4 py-3 font-semibold text-xs uppercase tracking-widest bg-cyan-500 text-white rounded-xl shadow-md shadow-cyan-500/20 transition-all hover:bg-cyan-600">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                        <rect width="18" height="18" x="3" y="4" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>
                    </svg>
                    Track Rentals
                </a>
                <a href="${pageContext.request.contextPath}/Profile"
                    class="flex items-center gap-3 px-4 py-3 font-semibold text-xs uppercase tracking-widest text-zinc-400 hover:text-white hover:bg-zinc-900 rounded-xl hover:translate-x-1.5 transition-all duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                    </svg>
                    Admin Profile
                </a>
            </nav>
            <div class="pt-6 border-t border-zinc-900 mt-auto">
                <a href="${pageContext.request.contextPath}/Logout"
                    class="block w-full bg-rose-500/10 text-rose-400 border border-rose-500/20 p-4 rounded-2xl text-center font-bold text-xs uppercase hover:bg-rose-500 hover:text-white transition-all shadow-sm">
                    Exit Session
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="ml-72 p-12 w-full max-w-7xl">
            <header class="mb-12 flex justify-between items-end">
                <div>
                    <h1 class="text-5xl font-black uppercase italic tracking-tighter text-zinc-900">Rental Tracking</h1>
                    <p class="text-zinc-500 font-bold uppercase text-xs mt-3 tracking-widest flex items-center gap-2">
                        <span class="w-1.5 h-1.5 bg-cyan-500 rounded-full"></span>
                        Track rackets, gear rentals and handle returns
                    </p>
                </div>
                <div class="bg-white border border-gray-200 px-6 py-3.5 rounded-2xl shadow-sm text-right flex items-center gap-4">
                    <div>
                        <p class="font-bold text-[9px] text-gray-400 uppercase tracking-widest text-right">Logged in admin</p>
                        <p class="text-gray-900 font-extrabold text-sm uppercase text-right">
                            ${user != null ? user : 'Admin'}
                        </p>
                    </div>
                    <div class="w-10 h-10 bg-cyan-50 rounded-xl border border-cyan-100 flex items-center justify-center text-cyan-600">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-5 h-5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                        </svg>
                    </div>
                </div>
            </header>

            <!-- Status Alerts / Toasts -->
            <c:if test="${not empty param.status}">
                <c:choose>
                    <c:when test="${param.status eq 'success_return'}">
                        <div class="mb-8 border border-emerald-200 p-4 rounded-2xl bg-emerald-50 text-emerald-800 font-semibold text-sm shadow-sm flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" class="shrink-0 text-emerald-600">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                </svg>
                                <span>Barang rental berhasil ditandai sebagai dikembalikan dan stok diperbarui!</span>
                            </div>
                            <button onclick="this.parentElement.remove()" class="text-emerald-500 hover:text-emerald-700 transition-colors">
                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                </svg>
                            </button>
                        </div>
                    </c:when>
                    <c:when test="${param.status eq 'already_returned'}">
                        <div class="mb-8 border border-amber-200 p-4 rounded-2xl bg-amber-50 text-amber-800 font-semibold text-sm shadow-sm flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" class="shrink-0 text-amber-600">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                </svg>
                                <span>Peringatan: Rental ini sudah ditandai sebagai dikembalikan sebelumnya!</span>
                            </div>
                            <button onclick="this.parentElement.remove()" class="text-amber-500 hover:text-amber-700 transition-colors">
                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                </svg>
                            </button>
                        </div>
                    </c:when>
                    <c:when test="${param.status eq 'not_found'}">
                        <div class="mb-8 border border-rose-200 p-4 rounded-2xl bg-rose-50 text-rose-800 font-semibold text-sm shadow-sm flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" class="shrink-0 text-rose-600">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="15" y1="9" x2="9" y2="15"></line>
                                    <line x1="9" y1="9" x2="15" y2="15"></line>
                                </svg>
                                <span>Gagal: Data rental tidak ditemukan!</span>
                            </div>
                            <button onclick="this.parentElement.remove()" class="text-rose-500 hover:text-rose-700 transition-colors">
                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                </svg>
                            </button>
                        </div>
                    </c:when>
                </c:choose>
            </c:if>

            <!-- Stats Overview Row -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
                <div class="bg-zinc-900 text-white p-6 rounded-3xl border border-zinc-800 shadow-sm hover:shadow-md hover:-translate-y-1 transition-all duration-300">
                    <p class="text-[10px] font-black text-cyan-400 uppercase tracking-widest mb-1">Total Active Rents</p>
                    <h3 class="text-3xl font-black italic tracking-tighter">${activeCount} Items</h3>
                </div>
                <div class="bg-white border border-gray-200 text-gray-900 p-6 rounded-3xl shadow-sm hover:shadow-md hover:-translate-y-1 transition-all duration-300">
                    <div class="flex items-center justify-between mb-1">
                        <p class="text-[10px] font-black text-gray-500 uppercase tracking-widest">Overdue Rents</p>
                        <span class="w-2 h-2 rounded-full bg-rose-500 animate-pulse"></span>
                    </div>
                    <h3 class="text-3xl font-black italic tracking-tighter text-rose-600">${overdueCount} Items</h3>
                </div>
                <div class="bg-white border border-gray-200 text-gray-900 p-6 rounded-3xl shadow-sm hover:shadow-md hover:-translate-y-1 transition-all duration-300">
                    <p class="text-[10px] font-black text-gray-500 uppercase tracking-widest mb-1">Returned Items</p>
                    <h3 class="text-3xl font-black italic tracking-tighter text-emerald-600">${returnedCount} Items</h3>
                </div>
                <div class="bg-white border border-gray-200 text-gray-900 p-6 rounded-3xl shadow-sm hover:shadow-md hover:-translate-y-1 transition-all duration-300">
                    <p class="text-[10px] font-black text-gray-500 uppercase tracking-widest mb-1">Total Records</p>
                    <h3 class="text-3xl font-black italic tracking-tighter text-amber-500">${fn:length(rentalsList)} Records</h3>
                </div>
            </div>

            <!-- Controls (Search & Filter) -->
            <div class="bg-white border border-gray-200 p-6 rounded-3xl shadow-sm mb-8">
                <form action="AdminRentalController" method="GET" class="flex flex-col md:flex-row gap-4 items-center justify-between">
                    <!-- Search Input -->
                    <div class="w-full md:w-96 relative">
                        <input type="text" name="search" value="${currentSearch}" placeholder="Cari penyewa, nama raket, atau kategori..." 
                               class="w-full bg-gray-50/50 border border-gray-200 rounded-xl px-4 py-3 text-sm font-semibold focus:outline-none focus:border-black focus:ring-1 focus:ring-black transition-all">
                    </div>

                    <!-- Status Filter Tabs -->
                    <div class="flex gap-2">
                        <input type="hidden" name="status" id="status-input" value="${currentStatus}">
                        <button type="button" onclick="filterByStatus('All')" 
                                class="px-4 py-2 text-xs font-bold uppercase rounded-xl border border-gray-200 tracking-wider transition-all ${currentStatus eq 'All' ? 'bg-black text-white border-black shadow-sm' : 'bg-white text-gray-700 hover:border-black'}">
                            All
                        </button>
                        <button type="button" onclick="filterByStatus('Active')" 
                                class="px-4 py-2 text-xs font-bold uppercase rounded-xl border border-gray-200 tracking-wider transition-all ${currentStatus eq 'Active' ? 'bg-cyan-500 text-white border-cyan-500 shadow-sm shadow-cyan-500/20' : 'bg-white text-gray-700 hover:border-black'}">
                            Active
                        </button>
                        <button type="button" onclick="filterByStatus('Overdue')" 
                                class="px-4 py-2 text-xs font-bold uppercase rounded-xl border border-gray-200 tracking-wider transition-all ${currentStatus eq 'Overdue' ? 'bg-rose-500 text-white border-rose-500 shadow-sm shadow-rose-500/20' : 'bg-white text-gray-700 hover:border-black'}">
                            Overdue
                        </button>
                        <button type="button" onclick="filterByStatus('Returned')" 
                                class="px-4 py-2 text-xs font-bold uppercase rounded-xl border border-gray-200 tracking-wider transition-all ${currentStatus eq 'Returned' ? 'bg-emerald-500 text-white border-emerald-500 shadow-sm shadow-emerald-500/20' : 'bg-white text-gray-700 hover:border-black'}">
                            Returned
                        </button>
                    </div>

                    <!-- Search Button -->
                    <button type="submit" class="w-full md:w-auto bg-black hover:bg-zinc-900 text-white px-6 py-3 rounded-xl text-xs font-bold uppercase tracking-widest transition-all shadow-sm">
                        Apply Filters
                    </button>
                </form>
            </div>

            <!-- Rentals Table -->
            <div class="bg-white border border-gray-200 rounded-3xl shadow-sm overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse bg-white">
                        <thead>
                            <tr class="bg-gray-50 border-b border-gray-200 text-gray-500 font-bold uppercase text-[10px] tracking-wider">
                                <th class="py-3 px-6">ID</th>
                                <th class="py-3 px-6">Customer</th>
                                <th class="py-3 px-6">Rented Item</th>
                                <th class="py-3 px-6 text-center">Qty</th>
                                <th class="py-3 px-6">Rental Period</th>
                                <th class="py-3 px-6">Actual Return</th>
                                <th class="py-3 px-6">Status</th>
                                <th class="py-3 px-6 text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody class="text-sm font-semibold divide-y divide-gray-100">
                            <c:choose>
                                <c:when test="${empty rentalsList}">
                                    <tr>
                                        <td colspan="8" class="py-16 text-center text-gray-400 font-medium italic bg-gray-50/50">
                                            Tidak ada data rental yang ditemukan.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="r" items="${rentalsList}">
                                        <tr class="hover:bg-gray-50/50 transition-colors text-gray-700">
                                            <!-- Rental ID -->
                                            <td class="py-4 px-6 font-semibold text-gray-400">#${r.rentalId}</td>
                                            
                                            <!-- Username -->
                                            <td class="py-4 px-6 uppercase font-semibold text-gray-900 tracking-tight text-sm">${r.username}</td>
                                            
                                            <!-- Product Name & Category -->
                                            <td class="py-4 px-6">
                                                <div class="flex items-center gap-3">
                                                    <div class="w-10 h-10 bg-gray-50 border border-gray-200 rounded-xl overflow-hidden shrink-0 flex items-center justify-center shadow-sm">
                                                        <img src="${pageContext.request.contextPath}/img/${not empty r.image ? r.image : 'default.png'}" 
                                                             alt="${r.productName}" 
                                                             class="object-cover w-full h-full"
                                                             onerror="this.src='${pageContext.request.contextPath}/img/default.png'">
                                                    </div>
                                                    <div class="flex flex-col">
                                                        <span class="text-gray-900 font-bold max-w-xs truncate">${r.productName}</span>
                                                        <span class="text-[9px] text-gray-400 uppercase tracking-widest font-black mt-0.5">${r.category}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            
                                            <!-- Quantity -->
                                            <td class="py-4 px-6 text-center text-gray-700 font-bold">${r.quantity} pcs</td>
                                            
                                            <!-- Rental Period (Court Session) -->
                                            <td class="py-4 px-6">
                                                <div class="flex flex-col">
                                                    <span class="text-xs text-gray-950 font-bold"><fmt:formatDate value="${r.rentalDate}" pattern="dd MMM yyyy"/></span>
                                                    <c:choose>
                                                        <c:when test="${not empty r.courtName}">
                                                            <span class="text-[10px] text-cyan-600 font-bold mt-1 uppercase tracking-wider">
                                                                ${r.courtName}
                                                            </span>
                                                            <span class="text-[10px] text-gray-400 font-semibold">
                                                                <fmt:formatDate value="${r.bookingStartTime}" type="time" pattern="HH:mm"/> - <fmt:formatDate value="${r.bookingEndTime}" type="time" pattern="HH:mm"/>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-xs text-gray-400 font-normal mt-1">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                            
                                            <!-- Return Date -->
                                            <td class="py-4 px-6">
                                                <c:choose>
                                                    <c:when test="${not empty r.returnDate}">
                                                        <span class="text-emerald-600 font-bold"><fmt:formatDate value="${r.returnDate}" pattern="dd MMM yyyy"/></span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Belum kembali</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            
                                            <!-- Status Badge -->
                                            <td class="py-4 px-6">
                                                <c:choose>
                                                    <c:when test="${r.status eq 'Active'}">
                                                        <span class="px-2.5 py-1 bg-cyan-50 text-cyan-800 border border-cyan-200 rounded-full text-[10px] font-bold uppercase tracking-wider inline-block">
                                                            Active
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${r.status eq 'Overdue'}">
                                                        <span class="px-2.5 py-1 bg-rose-50 text-rose-800 border border-rose-200 rounded-full text-[10px] font-bold uppercase tracking-wider inline-block animate-pulse">
                                                            Overdue
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${r.status eq 'Returned'}">
                                                        <span class="px-2.5 py-1 bg-emerald-50 text-emerald-800 border border-emerald-200 rounded-full text-[10px] font-bold uppercase tracking-wider inline-block">
                                                            Returned
                                                        </span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            
                                            <!-- Return Action Button -->
                                            <td class="py-4 px-6 text-center">
                                                <c:choose>
                                                    <c:when test="${r.status eq 'Active' or r.status eq 'Overdue'}">
                                                        <form action="AdminRentalController" method="POST" onsubmit="return confirm('Tandai barang sewa ini sudah dikembalikan oleh pelanggan?');">
                                                            <input type="hidden" name="action" value="return">
                                                            <input type="hidden" name="rentalId" value="${r.rentalId}">
                                                            <button type="submit" class="bg-emerald-500 hover:bg-emerald-600 text-white px-4 py-2 text-[10px] font-bold uppercase tracking-wider rounded-xl shadow-sm transition-all hover:shadow">
                                                                Return Item
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-xs text-gray-400 font-bold uppercase tracking-wider flex items-center justify-center gap-1">
                                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-emerald-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                                                                <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
                                                            </svg>
                                                            Done
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
        </main>
    </div>

    <script>
        function filterByStatus(status) {
            document.getElementById('status-input').value = status;
            document.forms[0].submit();
        }
    </script>
</body>
</html>
