<%-- 
    Document   : admin_dashboard.jsp
    Created on : 11 May 2026, 08.07.03
    Author     : Faizul Afiat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard - PadelApp</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
        <div class="flex min-h-screen bg-gray-50">
            <div class="w-72 bg-black text-white p-8 flex flex-col fixed h-full shadow-2xl">
                <div class="mb-12">
                    <h2 class="text-3xl font-black italic tracking-tighter text-cyan-400">PADELAPP</h2>
                    <p class="text-[10px] font-bold opacity-50 tracking-[0.2em] uppercase">ADMIN</p>
                </div>

                <nav class="space-y-6 flex-1">
                    <a href="AdminDashboard" class="block font-black text-xs uppercase tracking-widest border-l-4 border-cyan-400 pl-4">Dashboard</a>
                    <a href="ManageProducts" class="block font-black text-xs uppercase tracking-widest opacity-40 hover:opacity-100 hover:pl-4 transition-all">Manage Shop</a>
                    <a href="ManageBookings" class="block font-black text-xs uppercase tracking-widest opacity-40 hover:opacity-100 hover:pl-4 transition-all">Schedules</a>
                </nav>

                <a href="Logout" class="mt-auto bg-red-500/10 text-red-500 border-2 border-red-500 p-4 rounded-2xl text-center font-black text-xs uppercase hover:bg-red-500 hover:text-white transition-all">
                    Exit Session
                </a>
            </div>

            <div class="ml-72 p-12 w-full">
                <header class="mb-12 flex justify-between items-end">
                    <div>
                        <h1 class="text-5xl font-black uppercase italic tracking-tighter">Overview</h1>
                        <p class="text-gray-400 font-bold uppercase text-[10px] mt-2 tracking-widest">Real-time business analytics</p>
                    </div>
                    <div class="text-right">
                        <p class="font-black text-sm uppercase">Welcome back,</p>
                        <p class="text-cyan-500 font-black text-xl uppercase">Admin <span class="text-cyan-600 italic">${user}</span></p>
                    </div>
                </header>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <div class="bg-black text-white p-10 rounded-[3rem] shadow-xl relative overflow-hidden group">
                        <p class="text-[10px] font-black uppercase opacity-50 mb-2">Total Earnings</p>

                        <h2 class="text-4xl font-black italic tracking-tight text-cyan-400">
                            <fmt:setLocale value="id_ID"/>
                            <fmt:formatNumber value="${revenue}" type="currency" currencySymbol="Rp " maxFractionDigits="0"/>
                        </h2>

                        <div class="absolute -right-8 -bottom-8 w-32 h-32 bg-cyan-400/10 rounded-full blur-3xl group-hover:bg-cyan-400/20 transition-all"></div>
                    </div>

                    <div class="bg-white border-4 border-black p-10 rounded-[3rem] shadow-[10px_10px_0px_0px_rgba(0,0,0,1)]">
                        <p class="text-[10px] font-black uppercase opacity-40 mb-2">Inventory Size</p>
                        <h2 class="text-4xl font-black italic tracking-tight">${productCount} Items</h2>
                    </div>

                    <div class="bg-cyan-400 border-4 border-black p-10 rounded-[3rem] shadow-[10px_10px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between group cursor-pointer">
                        <div>
                            <p class="text-[10px] font-black uppercase opacity-60 mb-1">Stock Alert</p>
                            <h2 class="text-xl font-black uppercase leading-none">Add New <br>Product</h2>
                        </div>
                        <div class="w-12 h-12 bg-black rounded-full flex items-center justify-center text-white group-hover:scale-110 transition-transform">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor" stroke-width="3"><path d="M12 5v14M5 12h14"/></svg>
                        </div>
                    </div>
                </div>
                <div class="bg-white border-4 border-black rounded-[3rem] p-10 shadow-[12px_12px_0px_0px_rgba(0,0,0,1)] mt-12 overflow-hidden">
                    <h3 class="font-black uppercase italic text-2xl tracking-tighter mb-8">Court Rental Logs</h3>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <thead>
                                <tr class="border-b-4 border-black">
                                    <th class="py-4 font-black uppercase text-xs tracking-widest opacity-40">ID</th>
                                    <th class="py-4 font-black uppercase text-xs tracking-widest opacity-40">Customer</th>
                                    <th class="py-4 font-black uppercase text-xs tracking-widest opacity-40">Court</th>
                                    <th class="py-4 font-black uppercase text-xs tracking-widest opacity-40">Schedule</th>
                                    <th class="py-4 font-black uppercase text-xs tracking-widest opacity-40">Amount</th>
                                    <th class="py-4 font-black uppercase text-xs tracking-widest opacity-40">Status</th>
                                    <th class="py-4 font-black uppercase text-xs tracking-widest opacity-40 text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody class="text-sm font-bold">
                                <c:forEach var="b" items="${bookingList}">
                                    <tr class="border-b-2 border-gray-50 hover:bg-cyan-50 transition-colors">
                                        <td class="py-5 text-gray-400">#${b.id}</td>
                                        <td class="py-5 uppercase font-black">${b.username}</td>
                                        <td class="py-5">
                                            <span class="bg-black text-white px-3 py-1 rounded-full text-[10px] uppercase font-black">
                                                ${b.court}
                                            </span>
                                        </td>
                                        <td class="py-5">
                                            <div class="flex flex-col">
                                                <span class="text-gray-900 uppercase">${b.date}</span>
                                                <span class="text-[10px] text-cyan-600 font-black italic mt-1">
                                                    <fmt:formatDate value="${b.start}" pattern="HH:mm"/> - <fmt:formatDate value="${b.end}" pattern="HH:mm"/>
                                                </span>
                                            </div>
                                        </td>
                                        <td class="py-5 font-black text-cyan-600">
                                <fmt:formatNumber value="${b.total}" type="currency" currencySymbol="Rp " maxFractionDigits="0"/>
                                </td>
                                <td class="py-5">
                                    <c:set var="statusLower" value="${fn:toLowerCase(b.status)}" />
                                    <c:choose>
                                        <c:when test="${statusLower == 'Pending'}">
                                            <span class="bg-amber-100 text-amber-600 px-3 py-1 rounded-lg text-[10px] font-black uppercase border-2 border-amber-600 inline-block">
                                                Pending
                                            </span>
                                        </c:when>
                                        <c:when test="${statusLower == 'Confirmed'}">
                                            <span class="bg-greens-100 text-emerald-600 px-3 py-1 rounded-lg text-[10px] font-black uppercase border-2 border-emerald-600 inline-block">
                                                Confirmed
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="bg-red-100 text-red-600 px-3 py-1 rounded-lg text-[10px] font-black uppercase border-2 border-red-600 inline-block">
                                                ${b.status}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="py-5 text-center">
                                    <c:if test="${b.status == 'Pending' || b.status == 'pending' || b.status == 'PENDING'}">
                                        <div class="flex justify-center gap-2">
                                            <a href="UpdateStatusController?id=${b.id}&status=Confirmed" 
                                               class="bg-emerald-400 text-black p-2 rounded-xl border-2 border-black shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-[2px] hover:translate-y-[2px] transition-all">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                                            </a>
                                            <a href="UpdateStatusController?id=${b.id}&status=Cancelled" 
                                               class="bg-red-400 text-black p-2 rounded-xl border-2 border-black shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-[2px] hover:translate-y-[2px] transition-all">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M18 6L6 18M6 6l12 12"/></svg>
                                            </a>
                                        </div>
                                    </c:if>
                                </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
