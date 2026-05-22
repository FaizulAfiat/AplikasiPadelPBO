<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <title>Profile & Transactions - PadelApp</title>
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
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

        <header class="flex border-b border-grid bg-white sticky top-0 z-50">
            <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
                <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">
                    Padel<span class="text-blue-400">App</span>
                </h1>
            </div>
            <div class="flex-1 border-r border-grid hidden md:flex items-center px-8">
                <a href="${pageContext.request.contextPath}/index.jsp" class="text-xs font-bold uppercase tracking-widest hover:underline">
                    ← Back to Dashboard
                </a>
            </div>
            <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4">
                <span class="text-[10px] font-bold uppercase tracking-widest">
                    <%= session.getAttribute("user") %>
                </span>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                </svg>
            </div>
        </header>

        <main class="flex flex-col md:flex-row flex-1">
            <!-- Left Info Panel -->
            <div class="w-full md:w-1/4 p-8 md:p-12 border-b md:border-b-0 md:border-r border-grid bg-white">
                <span class="text-xs font-bold uppercase block mb-4 opacity-50">Profile & History</span>
                <h2 class="text-4xl md:text-5xl font-black leading-none uppercase mb-8 tracking-tighter">
                    My Account
                </h2>
                
                <div class="border-4 border-black p-6 rounded-2xl bg-yellow-100 shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] mb-8">
                    <p class="text-xs font-bold uppercase opacity-50">Logged In As</p>
                    <p class="text-2xl font-black uppercase tracking-tight"><%= session.getAttribute("user") %></p>
                    <p class="text-xs font-bold uppercase opacity-50 mt-4">Account Type</p>
                    <span class="inline-block mt-1 px-3 py-1 bg-black text-white text-[10px] font-black uppercase tracking-widest rounded-full">
                        ${not empty sessionScope.role ? sessionScope.role : 'Regular'}
                    </span>
                </div>

                <a href="${pageContext.request.contextPath}/Logout" class="inline-block w-full text-center border-4 border-black bg-rose-400 text-black py-3 font-black uppercase tracking-wider hover:bg-rose-500 transition-colors shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
                    Sign Out
                </a>
            </div>

            <!-- Right Tables Panel -->
            <div class="flex-1 p-8 md:p-12 space-y-12">
                <!-- Success Toast -->
                <c:if test="${not empty param.status && param.status == 'success'}">
                    <div id="success-toast" class="border-4 border-black p-5 rounded-2xl bg-emerald-400 font-black uppercase italic shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" class="shrink-0">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                            <span>Pemesanan lapangan berhasil dikonfirmasi!</span>
                        </div>
                        <button onclick="document.getElementById('success-toast').remove()" class="hover:opacity-70 transition-opacity">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>
                </c:if>

                <!-- Court Booking Schedule -->
                <div class="space-y-4">
                    <h3 class="text-2xl font-black uppercase tracking-tight flex items-center gap-2">
                        <span class="w-3 h-3 bg-blue-400 rounded-full"></span>
                        Jadwal Booking Lapangan
                    </h3>

                    <div class="border-4 border-black rounded-2xl overflow-hidden shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] bg-white">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="bg-black text-white font-black uppercase text-xs tracking-wider border-b-4 border-black">
                                        <th class="p-4">ID</th>
                                        <th class="p-4">Lapangan</th>
                                        <th class="p-4">Tanggal</th>
                                        <th class="p-4">Jam</th>
                                        <th class="p-4">Total Biaya</th>
                                        <th class="p-4">Status</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y-2 divide-black">
                                    <c:choose>
                                        <c:when test="${empty bookingHistory}">
                                            <tr>
                                                <td colspan="6" class="p-8 text-center text-gray-500 font-bold uppercase italic">
                                                    Belum ada jadwal pemesanan lapangan.
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="booking" items="${bookingHistory}">
                                                <tr class="hover:bg-gray-50 transition-colors font-bold text-sm">
                                                    <td class="p-4">#${booking.id}</td>
                                                    <td class="p-4 uppercase">${booking.court}</td>
                                                    <td class="p-4">
                                                        <fmt:formatDate value="${booking.date}" pattern="dd MMM yyyy" />
                                                    </td>
                                                    <td class="p-4">${booking.start} - ${booking.end}</td>
                                                    <td class="p-4">
                                                        <fmt:formatNumber value="${booking.total}" type="currency" currencySymbol="Rp " maxFractionDigits="0" />
                                                    </td>
                                                    <td class="p-4">
                                                        <c:choose>
                                                             <c:when test="${booking.status eq 'Pending'}">
                                                                 <div class="flex items-center gap-1.5 flex-wrap">
                                                                     <span class="px-3 py-1 bg-yellow-300 border-2 border-black rounded-full text-[10px] font-black uppercase tracking-wider">
                                                                         Pending
                                                                     </span>
                                                                     <a href="${pageContext.request.contextPath}/PaymentController?booking_id=${booking.id}" class="px-2.5 py-1 bg-black text-white hover:bg-cyan-400 hover:text-black border-2 border-black rounded-full text-[10px] font-black uppercase tracking-wider transition-colors shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] hover:shadow-none">
                                                                         Bayar
                                                                     </a>
                                                                 </div>
                                                             </c:when>
                                                             <c:when test="${booking.status eq 'Confirmed'}">
                                                                 <div class="flex items-center gap-1.5 flex-wrap">
                                                                     <span class="px-3 py-1 bg-emerald-400 border-2 border-black rounded-full text-[10px] font-black uppercase tracking-wider text-black">
                                                                         Confirmed
                                                                     </span>
                                                                     <a href="${pageContext.request.contextPath}/InvoiceController?booking_id=${booking.id}" class="px-2.5 py-1 bg-white text-black hover:bg-black hover:text-white border-2 border-black rounded-full text-[10px] font-black uppercase tracking-wider transition-colors shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] hover:shadow-none">
                                                                         Invoice
                                                                     </a>
                                                                 </div>
                                                             </c:when>
                                                            <c:when test="${booking.status eq 'Cancelled'}">
                                                                <span class="px-3 py-1 bg-rose-400 border-2 border-black rounded-full text-[10px] font-black uppercase tracking-wider">
                                                                    Cancelled
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="px-3 py-1 bg-gray-200 border-2 border-black rounded-full text-[10px] font-black uppercase tracking-wider">
                                                                    ${booking.status}
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

                <!-- Product Purchase/Rental History -->
                <div class="space-y-4">
                    <h3 class="text-2xl font-black uppercase tracking-tight flex items-center gap-2">
                        <span class="w-3 h-3 bg-emerald-400 rounded-full"></span>
                        Riwayat Belanja & Rental
                    </h3>

                    <div class="border-4 border-black rounded-2xl overflow-hidden shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] bg-white">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="bg-black text-white font-black uppercase text-xs tracking-wider border-b-4 border-black">
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
                                <tbody class="divide-y-2 divide-black">
                                    <c:choose>
                                        <c:when test="${empty transactionHistory}">
                                            <tr>
                                                <td colspan="8" class="p-8 text-center text-gray-500 font-bold uppercase italic">
                                                    Belum ada riwayat transaksi belanja.
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="tx" items="${transactionHistory}">
                                                <tr class="hover:bg-gray-50 transition-colors font-bold text-sm">
                                                    <td class="p-4">#${tx.id}</td>
                                                    <td class="p-4">${tx.productName}</td>
                                                    <td class="p-4 uppercase">${tx.category}</td>
                                                    <td class="p-4">${tx.quantity} pcs</td>
                                                    <td class="p-4">
                                                        <span class="px-2 py-0.5 border border-black text-[10px] font-black uppercase rounded bg-gray-100">
                                                            ${tx.type == 'Rent' ? 'Rental' : 'Purchase'}
                                                        </span>
                                                    </td>
                                                    <td class="p-4">
                                                        <fmt:formatDate value="${tx.date}" pattern="dd MMM yyyy" />
                                                    </td>
                                                    <td class="p-4">
                                                        <fmt:formatNumber value="${tx.total}" type="currency" currencySymbol="Rp " maxFractionDigits="0" />
                                                    </td>
                                                    <td class="p-4">
                                                        <c:choose>
                                                            <c:when test="${tx.status eq 'Processing'}">
                                                                <span class="px-3 py-1 bg-yellow-300 border-2 border-black rounded-full text-[10px] font-black uppercase tracking-wider">
                                                                    Processing
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${tx.status eq 'Completed'}">
                                                                <span class="px-3 py-1 bg-emerald-400 border-2 border-black rounded-full text-[10px] font-black uppercase tracking-wider text-black">
                                                                    Completed
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${tx.status eq 'Failed'}">
                                                                <span class="px-3 py-1 bg-rose-400 border-2 border-black rounded-full text-[10px] font-black uppercase tracking-wider">
                                                                    Failed
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="px-3 py-1 bg-gray-200 border-2 border-black rounded-full text-[10px] font-black uppercase tracking-wider">
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
                    <h3 class="text-2xl font-black uppercase tracking-tight flex items-center gap-2">
                        <span class="w-3 h-3 bg-purple-400 rounded-full"></span>
                        Riwayat Pertandingan
                    </h3>

                    <div class="border-4 border-black rounded-2xl overflow-hidden shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] bg-white">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="bg-black text-white font-black uppercase text-xs tracking-wider border-b-4 border-black">
                                        <th class="p-4">ID</th>
                                        <th class="p-4">Mode</th>
                                        <th class="p-4">Partner</th>
                                        <th class="p-4">Lawan</th>
                                        <th class="p-4">Skor</th>
                                        <th class="p-4">Hasil</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y-2 divide-black">
                                    <c:choose>
                                        <c:when test="${empty matchHistory}">
                                            <tr>
                                                <td colspan="6" class="p-8 text-center text-gray-500 font-bold uppercase italic">
                                                    Belum ada riwayat pertandingan.
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="match" items="${matchHistory}">
                                                <tr class="hover:bg-gray-50 transition-colors font-bold text-sm">
                                                    <td class="p-4">#${match.id}</td>
                                                    <td class="p-4 uppercase">${match.mode}</td>
                                                    <td class="p-4">${match.partner}</td>
                                                    <td class="p-4">${match.opponents}</td>
                                                    <td class="p-4">${match.score}</td>
                                                    <td class="p-4">
                                                        <c:choose>
                                                            <c:when test="${match.outcome eq 'WIN'}">
                                                                <span class="px-3 py-1 bg-emerald-400 border-2 border-black rounded-full text-[10px] font-black uppercase tracking-wider text-black">
                                                                    WIN
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${match.outcome eq 'LOSE'}">
                                                                <span class="px-3 py-1 bg-rose-400 border-2 border-black rounded-full text-[10px] font-black uppercase tracking-wider text-black">
                                                                    LOSE
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="px-3 py-1 bg-gray-200 border-2 border-black rounded-full text-[10px] font-black uppercase tracking-wider text-black">
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
    </body>
</html>

