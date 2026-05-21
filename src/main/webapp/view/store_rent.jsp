<%-- 
    Document   : store_rent
    Created on : 5 May 2026, 13.47.13
    Author     : Faizul Afiat
--%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Shop & Rent - PadelApp</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col m-0 p-0">

    <%-- HEADER COMPONENT: Menggunakan gaya grid minimalis konsisten --%>
    <header class="flex border-b border-gray-200 bg-white sticky top-0 z-50 w-full">
        <div class="p-4 md:p-6 border-r border-gray-200 w-1/2 md:w-1/4">
            <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">Padel<span class="text-blue-400">App</span></h1>
        </div>
        <div class="flex-1 border-r border-gray-200 hidden md:flex items-center px-8">
            <a href="${pageContext.request.contextPath}/AdminDashboard" class="text-xs font-bold uppercase tracking-widest text-gray-600 hover:text-black hover:underline transition-colors">← Back to Dashboard</a>
        </div>
        <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4">
            <span class="text-[10px] font-bold uppercase tracking-widest text-gray-500">
                <%= session.getAttribute("user") != null ? session.getAttribute("user") : "Admin" %>
            </span>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5 text-gray-700">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
            </svg>
        </div>
    </header>

    <%-- MAIN AREA CONTAINER --%>
    <div class="flex-1 p-6 pb-24 max-w-6xl w-full mx-auto">
        <div class="mb-10">
            <h1 class="text-5xl font-black uppercase tracking-tighter italic">Pro Shop <span class="text-cyan-500">&</span> Rentals</h1>
            <p class="text-gray-400 font-bold uppercase text-xs tracking-widest mt-2">Equip yourself with the best gear</p>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8">
            <c:forEach var="product" items="${productList}">
                
                <%-- FIXED-SIZE CARD ELEMENT --%>
                <div class="bg-white border-4 border-black rounded-[2.5rem] p-6 flex flex-col shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] hover:translate-x-1 hover:translate-y-1 hover:shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] transition-all group h-[480px]">
                    
                    <%-- 1. Wadah Gambar dengan Tinggi Fixed Mutlak --%>
                    <div class="w-full h-56 bg-gray-100 rounded-2xl overflow-hidden mb-4 border-2 border-black/5 relative flex-none">
                        <img src="${pageContext.request.contextPath}/assets/images/${product.image}" 
                             alt="${product.name}" 
                             class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300">
                        
                        <span class="absolute top-3 left-3 text-[9px] font-black uppercase tracking-widest px-2.5 py-1 rounded-md border-2 border-black shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] ${product.type == 'Rent' ? 'bg-yellow-300 text-black' : 'bg-cyan-400 text-black'}">
                            ${product.type}
                        </span>
                    </div>

                    <%-- 2. Detail Teks & Informasi (Menggunakan pembagi vertikal dinamis) --%>
                    <div class="flex-1 flex flex-col justify-between">
                        <div class="space-y-1">
                            <span class="text-[10px] font-black uppercase opacity-40 tracking-wider">Product Catalog</span>
                            <h3 class="font-black uppercase italic text-xl leading-tight text-gray-900 line-clamp-2">
                                ${product.name}
                            </h3>
                        </div>
                        
                        <%-- 3. Area Harga & Aksi Bawah --%>
                        <div class="mt-4 space-y-4">
                            <div class="flex flex-col border-t-2 border-dashed border-gray-100 pt-3">
                                <span class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Rate / Price</span>
                                <p class="font-black text-xl text-black">
                                    Rp ${product.price}
                                    <c:if class="text-xs font-bold text-gray-400 opacity-60" test="${product.type == 'Rent'}"> / Session</c:if>
                                </p>
                            </div>

                            <button class="w-full bg-black text-white hover:bg-cyan-400 hover:text-black border-2 border-black py-3.5 rounded-xl font-black uppercase text-xs tracking-wider transition-colors shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] hover:shadow-none active:scale-95 transition-all">
                                ${product.type == 'Rent' ? 'Rent Equipment' : 'Purchase Item'}
                            </button>
                        </div>
                    </div>

                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>x    