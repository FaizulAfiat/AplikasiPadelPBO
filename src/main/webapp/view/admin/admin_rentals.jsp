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
<body class="bg-gray-50 flex min-h-screen">
    <!-- Sidebar Navigation -->
    <div class="w-72 bg-black text-white p-8 flex flex-col fixed h-full shadow-2xl">
        <div class="mb-12">
            <h2 class="text-3xl font-black italic tracking-tighter text-cyan-400">PADELAPP</h2>
            <p class="text-[10px] font-bold opacity-50 tracking-[0.2em] uppercase">SYSTEM ADMIN</p>
        </div>
        <nav class="space-y-6 flex-1">
            <a href="AdminController"
                class="block font-black text-xs uppercase tracking-widest opacity-40 hover:opacity-100 transition-all">Dashboard</a>
            <a href="ManageProducts"
                class="block font-black text-xs uppercase tracking-widest opacity-40 hover:opacity-100 transition-all">Manage Shop</a>
            <a href="AdminRentalController"
                class="block font-black text-xs uppercase tracking-widest border-l-4 border-cyan-400 pl-4">Track Rentals</a>
            <a href="AdminController#rental-logs"
                class="block font-black text-xs uppercase tracking-widest opacity-40 hover:opacity-100 transition-all">Schedules</a>
            <a href="${pageContext.request.contextPath}/Profile"
                class="block font-black text-xs uppercase tracking-widest opacity-40 hover:opacity-100 transition-all">Profile</a>
        </nav>

        <a href="${pageContext.request.contextPath}/Logout"
            class="mt-auto bg-red-500/10 text-red-500 border-2 border-red-500 p-4 rounded-2xl text-center font-black text-xs uppercase hover:bg-red-500 hover:text-white transition-all">
            Exit Session
        </a>
    </div>

    <!-- Main Content -->
    <div class="ml-72 p-12 w-full max-w-7xl">
        <header class="mb-12 flex justify-between items-end">
            <div>
                <h1 class="text-5xl font-black uppercase italic tracking-tighter">Rental Tracking</h1>
                <p class="text-gray-400 font-bold uppercase text-[10px] mt-2 tracking-widest">Track rackets, gear rentals and handle returns</p>
            </div>
            <div class="bg-white border-4 border-black p-4 rounded-2xl shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] text-right">
                <p class="font-bold text-[10px] text-zinc-400 uppercase tracking-widest">Logged in admin</p>
                <p class="text-black font-black text-lg uppercase flex items-center justify-end gap-2">
                    ${user != null ? user : 'Admin'}
                    <span class="w-3 h-3 bg-cyan-400 rounded-full border-2 border-black"></span>
                </p>
            </div>
        </header>

        <!-- Status Alerts / Toasts -->
        <c:if test="${not empty param.status}">
            <c:choose>
                <c:when test="${param.status eq 'success_return'}">
                    <div class="mb-8 border-4 border-black p-5 rounded-2xl bg-emerald-400 font-black uppercase italic shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                            <span>Barang rental berhasil ditandai sebagai dikembalikan dan stok diperbarui!</span>
                        </div>
                        <button onclick="this.parentElement.remove()" class="hover:opacity-70 transition-opacity">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>
                </c:when>
                <c:when test="${param.status eq 'already_returned'}">
                    <div class="mb-8 border-4 border-black p-5 rounded-2xl bg-amber-400 font-black uppercase italic shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                            <span>Peringatan: Rental ini sudah ditandai sebagai dikembalikan sebelumnya!</span>
                        </div>
                        <button onclick="this.parentElement.remove()" class="hover:opacity-70 transition-opacity">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>
                </c:when>
                <c:when test="${param.status eq 'not_found'}">
                    <div class="mb-8 border-4 border-black p-5 rounded-2xl bg-rose-400 font-black uppercase italic shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="15" y1="9" x2="9" y2="15"></line>
                                <line x1="9" y1="9" x2="15" y2="15"></line>
                            </svg>
                            <span>Gagal: Data rental tidak ditemukan!</span>
                        </div>
                        <button onclick="this.parentElement.remove()" class="hover:opacity-70 transition-opacity">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
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
            <div class="bg-black text-white p-6 rounded-[2rem] border-4 border-black shadow-[6px_6px_0px_0px_rgba(0,0,0,1)]">
                <p class="text-[10px] font-black text-cyan-400 uppercase tracking-widest mb-1">Total Active Rents</p>
                <h3 class="text-3xl font-black italic tracking-tighter">${activeCount} Items</h3>
            </div>
            <div class="bg-rose-400 text-black p-6 rounded-[2rem] border-4 border-black shadow-[6px_6px_0px_0px_rgba(0,0,0,1)]">
                <p class="text-[10px] font-black opacity-60 uppercase tracking-widest mb-1">Overdue Rents</p>
                <h3 class="text-3xl font-black italic tracking-tighter">${overdueCount} Items</h3>
            </div>
            <div class="bg-emerald-400 text-black p-6 rounded-[2rem] border-4 border-black shadow-[6px_6px_0px_0px_rgba(0,0,0,1)]">
                <p class="text-[10px] font-black opacity-60 uppercase tracking-widest mb-1">Returned Items</p>
                <h3 class="text-3xl font-black italic tracking-tighter">${returnedCount} Items</h3>
            </div>
            <div class="bg-amber-400 text-black p-6 rounded-[2rem] border-4 border-black shadow-[6px_6px_0px_0px_rgba(0,0,0,1)]">
                <p class="text-[10px] font-black opacity-60 uppercase tracking-widest mb-1">Total Records</p>
                <h3 class="text-3xl font-black italic tracking-tighter">${fn:length(rentalsList)} Records</h3>
            </div>
        </div>

        <!-- Controls (Search & Filter) -->
        <div class="bg-white border-4 border-black p-6 rounded-3xl shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] mb-8">
            <form action="AdminRentalController" method="GET" class="flex flex-col md:flex-row gap-4 items-center justify-between">
                <!-- Search Input -->
                <div class="w-full md:w-96 relative">
                    <input type="text" name="search" value="${currentSearch}" placeholder="Cari penyewa, nama raket, atau kategori..." 
                           class="w-full bg-gray-50 border-2 border-gray-300 rounded-xl px-4 py-3 text-sm font-semibold focus:outline-none focus:border-black transition-all">
                </div>

                <!-- Status Filter Tabs -->
                <div class="flex gap-2">
                    <input type="hidden" name="status" id="status-input" value="${currentStatus}">
                    <button type="button" onclick="filterByStatus('All')" 
                            class="px-4 py-2 text-xs font-black uppercase rounded-lg border-2 border-black tracking-widest transition-all ${currentStatus eq 'All' ? 'bg-black text-white' : 'bg-white text-black hover:bg-gray-100'}">
                        All
                    </button>
                    <button type="button" onclick="filterByStatus('Active')" 
                            class="px-4 py-2 text-xs font-black uppercase rounded-lg border-2 border-black tracking-widest transition-all ${currentStatus eq 'Active' ? 'bg-cyan-400 text-black' : 'bg-white text-black hover:bg-gray-100'}">
                        Active
                    </button>
                    <button type="button" onclick="filterByStatus('Overdue')" 
                            class="px-4 py-2 text-xs font-black uppercase rounded-lg border-2 border-black tracking-widest transition-all ${currentStatus eq 'Overdue' ? 'bg-rose-500 text-white shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]' : 'bg-white text-black hover:bg-gray-100'}">
                        Overdue
                    </button>
                    <button type="button" onclick="filterByStatus('Returned')" 
                            class="px-4 py-2 text-xs font-black uppercase rounded-lg border-2 border-black tracking-widest transition-all ${currentStatus eq 'Returned' ? 'bg-emerald-400 text-black' : 'bg-white text-black hover:bg-gray-100'}">
                        Returned
                    </button>
                </div>

                <!-- Search Button -->
                <button type="submit" class="w-full md:w-auto bg-black text-white px-8 py-3 rounded-xl text-xs font-black uppercase tracking-widest hover:bg-zinc-800 transition-all">
                    Apply Filters
                </button>
            </form>
        </div>

        <!-- Rentals Table -->
        <div class="bg-white border-4 border-black rounded-[2rem] shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-100 border-b-4 border-black text-black font-black uppercase text-xs tracking-wider">
                            <th class="py-4 px-6">ID</th>
                            <th class="py-4 px-6">Customer</th>
                            <th class="py-4 px-6">Rented Item</th>
                            <th class="py-4 px-6 text-center">Qty</th>
                            <th class="py-4 px-6">Rental Period</th>
                            <th class="py-4 px-6">Actual Return</th>
                            <th class="py-4 px-6">Status</th>
                            <th class="py-4 px-6 text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody class="text-sm font-semibold divide-y-2 divide-gray-100">
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
                                        <td class="py-5 px-6 font-black text-gray-400">#${r.rentalId}</td>
                                        
                                        <!-- Username -->
                                        <td class="py-5 px-6 uppercase font-black text-black tracking-tight">${r.username}</td>
                                        
                                        <!-- Product Name & Category -->
                                        <td class="py-5 px-6">
                                            <div class="flex items-center gap-3">
                                                <div class="w-10 h-10 bg-gray-100 border border-gray-300 rounded-lg overflow-hidden shrink-0 flex items-center justify-center">
                                                    <img src="${pageContext.request.contextPath}/img/${not empty r.image ? r.image : 'default.png'}" 
                                                         alt="${r.productName}" 
                                                         class="object-contain w-8 h-8"
                                                         onerror="this.src='${pageContext.request.contextPath}/img/default.png'">
                                                </div>
                                                <div class="flex flex-col">
                                                    <span class="text-black font-bold max-w-xs truncate">${r.productName}</span>
                                                    <span class="text-[10px] text-gray-400 uppercase tracking-widest font-black mt-0.5">${r.category}</span>
                                                </div>
                                            </div>
                                        </td>
                                        
                                        <!-- Quantity -->
                                        <td class="py-5 px-6 text-center text-black font-bold">${r.quantity} pcs</td>
                                        
                                        <!-- Rental Period (Court Session) -->
                                        <td class="py-5 px-6">
                                            <div class="flex flex-col">
                                                <span class="text-xs text-black font-bold"><fmt:formatDate value="${r.rentalDate}" pattern="dd MMM yyyy"/></span>
                                                <c:choose>
                                                    <c:when test="${not empty r.courtName}">
                                                        <span class="text-[11px] text-cyan-600 font-black mt-1 uppercase tracking-wider">
                                                            ${r.courtName}
                                                        </span>
                                                        <span class="text-[11px] text-gray-500 font-bold">
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
                                        <td class="py-5 px-6">
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
                                        <td class="py-5 px-6">
                                            <c:choose>
                                                <c:when test="${r.status eq 'Active'}">
                                                    <span class="px-3 py-1 bg-cyan-100 text-cyan-800 border-2 border-cyan-400 rounded-full text-[10px] font-black uppercase tracking-widest">
                                                        Active
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.status eq 'Overdue'}">
                                                    <span class="px-3 py-1 bg-rose-100 text-rose-800 border-2 border-rose-400 rounded-full text-[10px] font-black uppercase tracking-widest animate-pulse">
                                                        Overdue
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.status eq 'Returned'}">
                                                    <span class="px-3 py-1 bg-emerald-100 text-emerald-800 border-2 border-emerald-400 rounded-full text-[10px] font-black uppercase tracking-widest">
                                                        Returned
                                                    </span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        
                                        <!-- Return Action Button -->
                                        <td class="py-5 px-6 text-center">
                                            <c:choose>
                                                <c:when test="${r.status eq 'Active' or r.status eq 'Overdue'}">
                                                    <form action="AdminRentalController" method="POST" onsubmit="return confirm('Tandai barang sewa ini sudah dikembalikan oleh pelanggan?');">
                                                        <input type="hidden" name="action" value="return">
                                                        <input type="hidden" name="rentalId" value="${r.rentalId}">
                                                        <button type="submit" class="bg-emerald-400 hover:bg-emerald-500 border-2 border-black px-4 py-2 text-[10px] font-black uppercase tracking-widest text-black rounded-lg shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-[2px] hover:translate-y-[2px] transition-all">
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
    </div>

    <script>
        function filterByStatus(status) {
            document.getElementById('status-input').value = status;
            document.forms[0].submit();
        }
    </script>
</body>
</html>
