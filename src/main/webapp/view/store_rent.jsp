<%-- Document : store_rent Created on : 5 May 2026, 13.47.13 Author : Faizul Afiat --%>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ page import="com.mycompany.aplikasi_padel_tubes_pbo.model.CartItem" %>
                <%@ page import="java.util.List" %>
                    <%@ page import="java.text.NumberFormat" %>
                        <%@ page import="java.util.Locale" %>
                            <%@page contentType="text/html" pageEncoding="UTF-8" %>
                                <% List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
                                        int cartItemCount = 0;
                                        int cartTotal = 0;
                                        if (cart != null) {
                                        for (CartItem item : cart) {
                                        cartItemCount += item.getQuantity();
                                        cartTotal += item.getSubtotal();
                                        }
                                        }
                                        NumberFormat rupiahFormat = NumberFormat.getNumberInstance(new Locale("id",
                                        "ID"));
                                        %>
                                        <!DOCTYPE html>
                                        <html>

                                        <head>
                                            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                                            <title>Shop & Rent - PadelApp</title>
                                            <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">
                                            <script src="https://cdn.tailwindcss.com"></script>
                                        </head>

                                        <body class="bg-gray-50 min-h-screen flex flex-col m-0 p-0">

                                            <%-- HEADER COMPONENT: Menggunakan gaya grid minimalis konsisten --%>
                                                <header
                                                    class="flex border-b border-gray-200 bg-white sticky top-0 z-50 w-full">
                                                    <div class="p-4 md:p-6 border-r border-gray-200 w-1/2 md:w-1/4">
                                                        <h1
                                                            class="text-xl font-black tracking-tighter uppercase md:text-2xl">
                                                            Padel<span class="text-blue-400">App</span></h1>
                                                    </div>
                                                    <div
                                                        class="flex-1 border-r border-gray-200 hidden md:flex items-center px-8">
                                                        <a href="${pageContext.request.contextPath}/index.jsp"
                                                            class="text-xs font-bold uppercase tracking-widest text-gray-600 hover:text-black hover:underline transition-colors">←
                                                            Back to Dashboard</a>
                                                    </div>
                                                    <div
                                                        class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4">
                                                        <!-- Cart Icon Button -->
                                                        <button onclick="toggleCartDrawer()"
                                                            class="relative p-2.5 border border-gray-200 rounded-xl hover:bg-cyan-50 hover:border-cyan-200 hover:text-cyan-600 transition-colors flex items-center justify-center">
                                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none"
                                                                viewBox="0 0 24 24" stroke-width="2.5"
                                                                stroke="currentColor" class="w-5 h-5 text-black">
                                                                <path stroke-linecap="round" stroke-linejoin="round"
                                                                    d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 0 0-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 0 0-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Zm12.75 0a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Z" />
                                                            </svg>
                                                            <% if (cartItemCount> 0) { %>
                                                                <span
                                                                    class="absolute -top-1.5 -right-1.5 bg-red-500 text-white text-[9px] font-extrabold w-4.5 h-4.5 rounded-full flex items-center justify-center">
                                                                    <%= cartItemCount %>
                                                                </span>
                                                                <% } %>
                                                        </button>

                                                        <span
                                                            class="text-[10px] font-bold uppercase tracking-widest text-gray-500">
                                                            <%= session.getAttribute("user") !=null ?
                                                                session.getAttribute("user") : "Admin" %>
                                                        </span>
                                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none"
                                                            viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"
                                                            class="w-5 h-5 text-gray-700">
                                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                                d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                                                        </svg>
                                                    </div>
                                                </header>

                                                <%-- MAIN AREA CONTAINER --%>
                                                    <div class="flex-1 p-6 pb-24 max-w-6xl w-full mx-auto">
                                                        <div class="mb-10">
                                                            <h1
                                                                class="text-5xl font-black uppercase tracking-tighter italic">
                                                                Pro Shop <span class="text-cyan-500">&</span> Rentals
                                                            </h1>
                                                            <p
                                                                class="text-gray-400 font-bold uppercase text-xs tracking-widest mt-2">
                                                                Equip yourself
                                                                with the best gear</p>
                                                        </div>

                                                        <!-- Category and Sorting Controls Bar -->
                                                        <div class="bg-white border border-gray-200 rounded-3xl p-6 mb-10 shadow-sm space-y-6 text-left">
                                                            <!-- Upper row: Search and Filters -->
                                                            <div class="flex flex-col md:flex-row gap-4 justify-between items-center">
                                                                <!-- Search Bar -->
                                                                <div class="relative w-full md:w-80">
                                                                    <input type="text" id="searchQuery" oninput="filterAndSortProducts()" 
                                                                           placeholder="Search gear..." 
                                                                           class="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-2xl font-semibold text-sm focus:outline-none focus:border-black focus:ring-1 focus:ring-black transition-all bg-gray-50/50">
                                                                    <div class="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400">
                                                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-4 h-4">
                                                                            <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.602 10.602Z" />
                                                                        </svg>
                                                                    </div>
                                                                </div>

                                                                <!-- Dropdowns: Type & Sort -->
                                                                <div class="flex gap-4 w-full md:w-auto">
                                                                    <!-- Type Filter -->
                                                                    <div class="flex-1 md:flex-initial">
                                                                        <select id="filterType" onchange="filterAndSortProducts()" 
                                                                                class="w-full md:w-44 px-4 py-3 border border-gray-200 rounded-2xl font-semibold text-sm bg-white focus:outline-none focus:border-black transition-all">
                                                                            <option value="All">All Types</option>
                                                                            <option value="Sale">For Sale</option>
                                                                            <option value="Rent">For Rent</option>
                                                                        </select>
                                                                    </div>

                                                                    <!-- Sort Dropdown -->
                                                                    <div class="flex-1 md:flex-initial">
                                                                        <select id="sortBy" onchange="filterAndSortProducts()" 
                                                                                class="w-full md:w-48 px-4 py-3 border border-gray-200 rounded-2xl font-semibold text-sm bg-white focus:outline-none focus:border-black transition-all">
                                                                            <option value="default">Default Sort</option>
                                                                            <option value="price_asc">Price: Low to High</option>
                                                                            <option value="price_desc">Price: High to Low</option>
                                                                            <option value="rating">Rating: Highest First</option>
                                                                            <option value="name_asc">Name: A to Z</option>
                                                                        </select>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- Lower row: Category Tabs -->
                                                            <div class="flex flex-wrap gap-2 border-t border-gray-100 pt-4">
                                                                <button type="button" onclick="selectCategory(this)" data-category="All" 
                                                                        class="category-btn active px-4 py-2 border border-black bg-black text-white rounded-xl text-xs font-bold uppercase tracking-wider transition-all">
                                                                    All Items
                                                                </button>
                                                                <button type="button" onclick="selectCategory(this)" data-category="Racket" 
                                                                        class="category-btn px-4 py-2 border border-gray-200 bg-white text-gray-700 hover:border-black rounded-xl text-xs font-bold uppercase tracking-wider transition-all">
                                                                    Rackets
                                                                </button>
                                                                <button type="button" onclick="selectCategory(this)" data-category="Balls" 
                                                                        class="category-btn px-4 py-2 border border-gray-200 bg-white text-gray-700 hover:border-black rounded-xl text-xs font-bold uppercase tracking-wider transition-all">
                                                                    Balls
                                                                </button>
                                                                <button type="button" onclick="selectCategory(this)" data-category="Grip" 
                                                                        class="category-btn px-4 py-2 border border-gray-200 bg-white text-gray-700 hover:border-black rounded-xl text-xs font-bold uppercase tracking-wider transition-all">
                                                                    Grips
                                                                </button>
                                                                <button type="button" onclick="selectCategory(this)" data-category="Bag" 
                                                                        class="category-btn px-4 py-2 border border-gray-200 bg-white text-gray-700 hover:border-black rounded-xl text-xs font-bold uppercase tracking-wider transition-all">
                                                                    Bags
                                                                </button>
                                                                <button type="button" onclick="selectCategory(this)" data-category="Other" 
                                                                        class="category-btn px-4 py-2 border border-gray-200 bg-white text-gray-700 hover:border-black rounded-xl text-xs font-bold uppercase tracking-wider transition-all">
                                                                    Others
                                                                </button>
                                                            </div>
                                                        </div>

                                                        <!-- Product Grid -->
                                                        <div id="productGrid"
                                                            class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8">
                                                            <c:forEach var="product" items="${productList}">

                                                                <%-- FIXED-SIZE CARD ELEMENT --%>
                                                                    <div
                                                                        class="product-card bg-white border border-gray-200 rounded-3xl p-6 flex flex-col shadow-sm hover:shadow-md transition-all group h-[530px] cursor-pointer"
                                                                        data-id="${product.id}"
                                                                        data-name="<c:out value='${product.name}' />"
                                                                        data-image="${product.image}"
                                                                        data-type="${product.type}"
                                                                        data-category="<c:out value='${product.category}' />"
                                                                        data-rating="${product.rating}"
                                                                        data-description="<c:out value='${product.description}' default='No description available.' />"
                                                                        data-price="${product.price}"
                                                                        data-stock="${product.stock}"
                                                                        onclick="openProductModal(event, this)">

                                                                        <%-- 1. Wadah Gambar dengan Tinggi Fixed Mutlak
                                                                            --%>
                                                                            <div
                                                                                class="w-full h-56 bg-gray-50 rounded-2xl overflow-hidden mb-4 border border-gray-100 relative flex-none">
                                                                                <img src="${pageContext.request.contextPath}/assets/images/${product.image}"
                                                                                    alt="${product.name}"
                                                                                    class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">

                                                                                <span
                                                                                    class="absolute top-3 left-3 text-[9px] font-bold uppercase tracking-widest px-2.5 py-1 rounded-full border ${product.type == 'Rent' ? 'bg-yellow-100 text-yellow-800 border-yellow-200' : 'bg-cyan-100 text-cyan-800 border-cyan-200'}">
                                                                                    ${product.type}
                                                                                </span>
                                                                            </div>

                                                                            <%-- 2. Detail Teks & Informasi (Menggunakan
                                                                                pembagi vertikal dinamis) --%>
                                                                                <div
                                                                                    class="flex-1 flex flex-col justify-between">
                                                                                    <div class="space-y-1">
                                                                                        <span
                                                                                            class="text-[10px] font-black uppercase opacity-40 tracking-wider">Product
                                                                                            Catalog</span>
                                                                                        <h3
                                                                                            class="font-black uppercase italic text-xl leading-tight text-gray-900 line-clamp-2 h-14">
                                                                                            ${product.name}
                                                                                        </h3>
                                                                                        <div class="flex items-center gap-2 pt-1.5">
                                                                                            <div class="flex items-center gap-1 bg-yellow-100 text-yellow-800 border border-yellow-200 px-2 py-0.5 rounded-full text-[10px] font-bold">
                                                                                                <span>★</span>
                                                                                                <span>${product.rating}</span>
                                                                                            </div>
                                                                                            <span
                                                                                                class="text-[9px] font-bold uppercase text-gray-400 tracking-wider">Rating</span>
                                                                                        </div>
                                                                                    </div>

                                                                                    <%-- 3. Area Harga, Stok & Aksi
                                                                                        Bawah --%>
                                                                                        <div class="mt-4 space-y-4">
                                                                                            <div
                                                                                                class="flex justify-between items-end border-t-2 border-dashed border-gray-100 pt-3">
                                                                                                <div
                                                                                                    class="flex flex-col">
                                                                                                    <span
                                                                                                        class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Price</span>
                                                                                                    <p
                                                                                                        class="font-black text-xl text-black">
                                                                                                        <fmt:setLocale
                                                                                                            value="id_ID" />
                                                                                                        <fmt:formatNumber
                                                                                                            value="${product.price}"
                                                                                                            type="currency"
                                                                                                            currencySymbol="Rp "
                                                                                                            maxFractionDigits="0" />
                                                                                                        <c:if
                                                                                                            test="${product.type == 'Rent'}">
                                                                                                            <span
                                                                                                                class="text-xs font-bold text-gray-400 opacity-60">
                                                                                                                /
                                                                                                                Hour</span>
                                                                                                        </c:if>
                                                                                                    </p>
                                                                                                </div>
                                                                                                <div
                                                                                                    class="flex flex-col items-end">
                                                                                                    <span
                                                                                                        class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Stock</span>
                                                                                                    <span
                                                                                                        class="font-bold text-xs ${product.stock > 0 ? 'text-gray-800' : 'text-red-500 font-black animate-pulse'}">
                                                                                                        ${product.stock
                                                                                                        > 0 ?
                                                                                                        product.stock :
                                                                                                        'OUT
                                                                                                        OF STOCK'}
                                                                                                    </span>
                                                                                                </div>
                                                                                            </div>

                                                                                            <div class="flex gap-3">
                                                                                                <!-- View Detail Button -->
                                                                                                <button
                                                                                                    type="button"
                                                                                                    onclick="event.stopPropagation(); openProductModal(event, this.closest('.product-card'))"
                                                                                                    class="flex-1 bg-white text-gray-700 hover:bg-gray-50 border border-gray-200 py-2.5 rounded-xl font-bold uppercase text-[10px] tracking-wider transition-all text-center shadow-sm hover:shadow active:scale-95">
                                                                                                    Details
                                                                                                </button>

                                                                                                <!-- Rent/Buy Form -->
                                                                                                <form
                                                                                                    action="${pageContext.request.contextPath}/Cart"
                                                                                                    method="POST"
                                                                                                    class="flex-1 m-0 p-0">
                                                                                                    <input type="hidden"
                                                                                                        name="productId"
                                                                                                        value="${product.id}">
                                                                                                    <input type="hidden"
                                                                                                        name="action"
                                                                                                        value="add">
                                                                                                    <c:choose>
                                                                                                        <c:when
                                                                                                            test="${product.stock > 0}">
                                                                                                            <button
                                                                                                                type="submit"
                                                                                                                class="w-full bg-black text-white hover:bg-zinc-800 border border-black py-2.5 rounded-xl font-bold uppercase text-[10px] tracking-wider transition-all shadow-sm hover:shadow active:scale-95">
                                                                                                                ${product.type
                                                                                                                == 'Rent' ?
                                                                                                                'Rent' :
                                                                                                                'Buy'}
                                                                                                            </button>
                                                                                                        </c:when>
                                                                                                        <c:otherwise>
                                                                                                            <button
                                                                                                                type="button"
                                                                                                                disabled
                                                                                                                class="w-full bg-gray-100 text-gray-400 border border-gray-200 py-2.5 rounded-xl font-bold uppercase text-[10px] tracking-wider cursor-not-allowed">
                                                                                                                Out Stock
                                                                                                            </button>
                                                                                                        </c:otherwise>
                                                                                                    </c:choose>
                                                                                                </form>
                                                                                            </div>
                                                                                        </div>
                                                                                </div>

                                                                    </div>
                                                            </c:forEach>
                                                        </div>
                                                    </div>

                                                    <%-- Toast Notification --%>
                                                        <c:if test="${not empty param.status}">
                                                            <div id="statusToast"
                                                                class="fixed bottom-8 right-8 z-[9999] bg-white border border-gray-200 p-6 rounded-3xl shadow-lg max-w-sm flex flex-col gap-2 transition-all duration-300">
                                                                <div class="flex items-center gap-3">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${param.status == 'success' || param.status == 'cart_add_success'}">
                                                                            <span
                                                                                class="w-8 h-8 rounded-full bg-emerald-100 text-emerald-800 border border-emerald-200 flex items-center justify-center font-bold">✓</span>
                                                                            <h4
                                                                                class="font-black uppercase tracking-tighter text-lg">
                                                                                ${param.status == 'cart_add_success' ?
                                                                                'Cart Updated' : 'Transaction Success!'}
                                                                            </h4>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span
                                                                                class="w-8 h-8 rounded-full bg-red-100 text-red-800 border border-red-200 flex items-center justify-center font-bold">✗</span>
                                                                            <h4
                                                                                class="font-black uppercase tracking-tighter text-lg">
                                                                                Action Failed
                                                                            </h4>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <p
                                                                    class="text-xs font-bold text-gray-500 uppercase tracking-wide">
                                                                    <c:choose>
                                                                        <c:when test="${param.status == 'success'}">Your
                                                                            order has been placed successfully and
                                                                            product stock updated.</c:when>
                                                                        <c:when
                                                                            test="${param.status == 'cart_add_success'}">
                                                                            Item has been added to your cart
                                                                            successfully.</c:when>
                                                                        <c:when
                                                                            test="${param.status == 'max_stock_exceeded'}">
                                                                            Cannot add more. Available stock limit
                                                                            reached.</c:when>
                                                                        <c:when
                                                                            test="${param.status == 'insufficient_stock_for_checkout'}">
                                                                            Some items in your cart exceed available
                                                                            stock. Please reduce quantity.</c:when>
                                                                        <c:when test="${param.status == 'cart_empty'}">
                                                                            Your cart is empty. Please add items before
                                                                            checking out.</c:when>
                                                                        <c:when
                                                                            test="${param.status == 'out_of_stock'}">
                                                                            Sorry, the item you selected is currently
                                                                            out of stock.</c:when>
                                                                        <c:when
                                                                            test="${param.status == 'not_logged_in'}">
                                                                            Please log in to purchase or rent items.
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${param.status == 'product_not_found'}">
                                                                            Product not found in database.</c:when>
                                                                        <c:when test="${param.status == 'db_error'}">
                                                                            Database error occurred. Please try again
                                                                            later.</c:when>
                                                                        <c:otherwise>Something went wrong. Please check
                                                                            your request.</c:otherwise>
                                                                    </c:choose>
                                                                </p>
                                                                <button
                                                                    onclick="document.getElementById('statusToast').remove()"
                                                                    class="mt-2 bg-black text-white hover:bg-zinc-800 border border-black py-2 rounded-xl font-bold uppercase text-[10px] tracking-wider transition-all text-center shadow-sm hover:shadow active:scale-95">
                                                                    Dismiss
                                                                </button>
                                                            </div>
                                                        </c:if>
                                                        <!-- PRODUCT DETAIL OVERLAY & MODAL -->
                                                        <div id="productDetailOverlay"
                                                            class="fixed inset-0 bg-black/50 backdrop-blur-sm z-[1001] hidden transition-opacity duration-300 opacity-0"
                                                            onclick="closeProductModal()"></div>

                                                        <div id="productDetailModal"
                                                            class="fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[90%] max-w-2xl bg-white border border-gray-200 z-[1002] rounded-3xl p-6 md:p-8 shadow-xl hidden transition-all duration-300 transform scale-95 opacity-0 flex flex-col md:flex-row gap-6 md:gap-8">
                                                            
                                                            <!-- Close Button -->
                                                            <button onclick="closeProductModal()"
                                                                class="absolute top-4 right-4 p-2 border border-gray-200 rounded-lg hover:bg-gray-50 text-gray-500 hover:text-gray-800 transition-colors z-10">
                                                                <svg xmlns="http://www.w3.org/2000/svg" fill="none"
                                                                    viewBox="0 0 24 24" stroke-width="3"
                                                                    stroke="currentColor" class="w-4 h-4">
                                                                    <path stroke-linecap="round"
                                                                        stroke-linejoin="round"
                                                                        d="M6 18 18 6M6 6l12 12" />
                                                                </svg>
                                                            </button>
                                                            
                                                            <!-- Left Column: Product Image -->
                                                            <div class="w-full md:w-1/2 h-64 md:h-80 bg-gray-50 rounded-2xl overflow-hidden border border-gray-100 relative flex-none">
                                                                <img id="modalProductImage" src="" alt="" class="w-full h-full object-cover">
                                                                <span id="modalProductType" class=""></span>
                                                            </div>
                                                            
                                                            <!-- Right Column: Product Info -->
                                                            <div class="flex-1 flex flex-col justify-between">
                                                                <div class="space-y-3">
                                                                    <div>
                                                                        <span class="text-[10px] font-black uppercase opacity-45 tracking-wider">Product Catalog</span>
                                                                        <span id="modalProductCategory" class="ml-2 text-[10px] font-bold uppercase bg-gray-100 text-gray-600 px-2.5 py-1 rounded-full border border-gray-200"></span>
                                                                    </div>
                                                                    
                                                                    <h2 id="modalProductName" class="font-black uppercase italic text-2xl md:text-3xl leading-tight text-gray-900"></h2>
                                                                    
                                                                    <!-- Rating Badge -->
                                                                    <div class="flex items-center gap-2">
                                                                        <div class="flex items-center gap-1 bg-yellow-100 text-yellow-800 border border-yellow-200 px-2.5 py-0.5 rounded-full text-xs font-bold shadow-sm">
                                                                            <span>★</span>
                                                                            <span id="modalProductRating"></span>
                                                                        </div>
                                                                        <span class="text-[10px] font-bold uppercase text-gray-400 tracking-wider">Rating</span>
                                                                    </div>
                                                                    
                                                                    <!-- Scrollable Description -->
                                                                    <div class="border-t-2 border-dashed border-gray-200 pt-3">
                                                                        <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest block mb-1">Description</span>
                                                                        <p id="modalProductDescription" class="text-xs text-gray-600 font-bold leading-relaxed max-h-32 overflow-y-auto pr-2"></p>
                                                                    </div>
                                                                </div>
                                                                
                                                                <!-- Price, Stock and Add to Cart Action -->
                                                                <div class="mt-6 space-y-4">
                                                                    <div class="flex justify-between items-end border-t-2 border-dashed border-gray-200 pt-3">
                                                                        <div class="flex flex-col">
                                                                            <span class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Price</span>
                                                                            <p id="modalProductPrice" class="font-black text-2xl text-black"></p>
                                                                        </div>
                                                                        <div class="flex flex-col items-end">
                                                                            <span class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Stock</span>
                                                                            <span id="modalProductStock" class=""></span>
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <!-- Add to Cart Form -->
                                                                    <form action="${pageContext.request.contextPath}/Cart" method="POST" id="modalForm" class="m-0 p-0">
                                                                        <input type="hidden" name="productId" id="modalProductId" value="">
                                                                        <input type="hidden" name="action" value="add">
                                                                        <button type="submit" id="modalSubmitBtn" class=""></button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!-- CART DRAWER OVERLAY -->
                                                        <div id="cartDrawerOverlay"
                                                            class="fixed inset-0 bg-black/50 backdrop-blur-sm z-[999] hidden transition-opacity duration-300 opacity-0"
                                                            onclick="toggleCartDrawer()"></div>

                                                        <!-- CART DRAWER PANEL -->
                                                        <div id="cartDrawer"
                                                            class="fixed top-0 right-0 bottom-0 w-full sm:w-[450px] bg-white border-l border-gray-200 z-[1000] translate-x-full transition-transform duration-300 ease-in-out flex flex-col p-6 shadow-2xl">
                                                            <div
                                                                class="flex justify-between items-center border-b border-gray-200 pb-4 mb-6 flex-none">
                                                                <div class="flex items-center gap-2">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none"
                                                                        viewBox="0 0 24 24" stroke-width="3"
                                                                        stroke="currentColor" class="w-6 h-6">
                                                                        <path stroke-linecap="round"
                                                                            stroke-linejoin="round"
                                                                            d="M15.75 10.5V6a3.75 3.75 0 1 0-7.5 0v4.5m11.356-1.993 1.263 12c.07.665-.45 1.243-1.119 1.243H4.25a1.125 1.125 0 0 1-1.12-1.243l1.264-12A1.125 1.125 0 0 1 5.513 7.5h12.974c.576 0 1.059.435 1.119 1.007ZM8.625 10.5a.375.375 0 1 1-.75 0 .375.375 0 0 1 .75 0Zm7.5 0a.375.375 0 1 1-.75 0 .375.375 0 0 1 .75 0Z" />
                                                                    </svg>
                                                                    <h2
                                                                        class="text-2xl font-black uppercase italic tracking-tighter">
                                                                        Your Cart</h2>
                                                                </div>
                                                                <button onclick="toggleCartDrawer()"
                                                                    class="p-2 border border-gray-200 rounded-lg hover:bg-gray-50 text-gray-500 hover:text-gray-800 transition-colors">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none"
                                                                        viewBox="0 0 24 24" stroke-width="3"
                                                                        stroke="currentColor" class="w-4 h-4">
                                                                        <path stroke-linecap="round"
                                                                            stroke-linejoin="round"
                                                                            d="M6 18 18 6M6 6l12 12" />
                                                                    </svg>
                                                                </button>
                                                            </div>

                                                            <!-- Cart Items List -->
                                                            <div class="flex-1 overflow-y-auto space-y-4 pr-1">
                                                                <% if (cart==null || cart.isEmpty()) { %>
                                                                    <div
                                                                        class="flex flex-col items-center justify-center h-full text-center p-8">
                                                                        <span class="text-4xl">🛒</span>
                                                                        <p class="font-black text-lg uppercase mt-4">
                                                                            Your cart is empty</p>
                                                                        <p
                                                                            class="text-xs font-bold text-gray-400 mt-1 uppercase tracking-wider">
                                                                            Add some gear to get started!</p>
                                                                    </div>
                                                                    <% } else { %>
                                                                        <% for (CartItem item : cart) { %>
                                                                            <div
                                                                                class="cart-item flex gap-4 p-4 border border-gray-200 rounded-2xl bg-gray-50 relative group shadow-sm"
                                                                                data-type="<%= item.getProduct().getType() %>"
                                                                                data-price="<%= item.getProduct().getPrice() %>"
                                                                                data-qty="<%= item.getQuantity() %>">
                                                                                <div
                                                                                    class="w-16 h-16 rounded-xl border border-gray-200 overflow-hidden bg-white flex-none">
                                                                                    <img src="${pageContext.request.contextPath}/assets/images/<%= item.getProduct().getImage() %>"
                                                                                        alt="<%= item.getProduct().getName() %>"
                                                                                        class="w-full h-full object-cover">
                                                                                </div>
                                                                                <div
                                                                                    class="flex-1 flex flex-col justify-between">
                                                                                    <div>
                                                                                        <div
                                                                                            class="flex justify-between items-start gap-2">
                                                                                            <h4
                                                                                                class="font-black text-xs uppercase italic leading-tight text-gray-900 line-clamp-1 mr-4">
                                                                                                <%= item.getProduct().getName()
                                                                                                    %>
                                                                                            </h4>
                                                                                            <span class="text-[8px] font-bold uppercase tracking-widest px-2 py-0.5 rounded border flex-none 
                                                                                                <c:choose>
                                                                                                    <c:when test="
                                                                                                ${item.product.type=='Rent'
                                                                                                }">bg-yellow-100 text-yellow-800 border-yellow-200
                                                                                                </c:when>
                                                                                                <c:otherwise>bg-cyan-100 text-cyan-800 border-cyan-200
                                                                                                </c:otherwise>
                                                                                                </c:choose>">
                                                                                                ${item.product.type}
                                                                                            </span>
                                                                                        </div>
                                                                                        <span
                                                                                            class="text-[9px] font-bold uppercase text-gray-400">
                                                                                            <%= item.getProduct().getCategory()
                                                                                                %>
                                                                                        </span>
                                                                                    </div>
                                                                                    <div
                                                                                        class="flex justify-between items-end mt-2">
                                                                                        <p
                                                                                            class="item-price-display font-black text-sm text-black">
                                                                                            Rp <%=
                                                                                                rupiahFormat.format(item.getProduct().getPrice())
                                                                                                %>
                                                                                        </p>

                                                                                        <!-- Qty Controls -->
                                                                                        <div
                                                                                            class="flex items-center border border-gray-200 rounded-lg overflow-hidden bg-white">
                                                                                            <form
                                                                                                action="${pageContext.request.contextPath}/Cart"
                                                                                                method="POST"
                                                                                                class="m-0 p-0">
                                                                                                <input type="hidden"
                                                                                                    name="action"
                                                                                                    value="update">
                                                                                                <input type="hidden"
                                                                                                    name="productId"
                                                                                                    value="<%= item.getProduct().getId() %>">
                                                                                                <input type="hidden"
                                                                                                    name="change"
                                                                                                    value="-1">
                                                                                                <button type="submit"
                                                                                                    class="px-2.5 py-1 font-bold text-xs hover:bg-gray-50 border-r border-gray-200 text-gray-500 hover:text-black">-</button>
                                                                                            </form>
                                                                                            <span
                                                                                                class="px-3 font-black text-xs">
                                                                                                <%= item.getQuantity()
                                                                                                    %>
                                                                                            </span>
                                                                                            <form
                                                                                                action="${pageContext.request.contextPath}/Cart"
                                                                                                method="POST"
                                                                                                class="m-0 p-0">
                                                                                                <input type="hidden"
                                                                                                    name="action"
                                                                                                    value="update">
                                                                                                <input type="hidden"
                                                                                                    name="productId"
                                                                                                    value="<%= item.getProduct().getId() %>">
                                                                                                <input type="hidden"
                                                                                                    name="change"
                                                                                                    value="1">
                                                                                                <button type="submit"
                                                                                                    class="px-2.5 py-1 font-bold text-xs hover:bg-gray-50 border-l border-gray-200 text-gray-500 hover:text-black">+</button>
                                                                                            </form>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <!-- Remove Button -->
                                                                                <form
                                                                                    action="${pageContext.request.contextPath}/Cart"
                                                                                    method="POST"
                                                                                    class="absolute -top-2 -right-2 m-0 p-0">
                                                                                    <input type="hidden" name="action"
                                                                                        value="remove">
                                                                                    <input type="hidden"
                                                                                        name="productId"
                                                                                        value="<%= item.getProduct().getId() %>">
                                                                                    <button type="submit"
                                                                                        class="w-6 h-6 rounded-full bg-red-50 hover:bg-red-100 text-red-600 border border-red-200 flex items-center justify-center text-xs font-bold shadow-sm active:scale-95 transition-all">×</button>
                                                                                </form>
                                                                            </div>
                                                                            <% } %>
                                                                                <% } %>
                                                            </div>

                                                            <!-- Bottom Summary & Checkout -->
                                                            <% if (cart !=null && !cart.isEmpty()) { %>
                                                                <% 
                                                                boolean cartHasRentals = false;
                                                                for (CartItem item : cart) {
                                                                    if ("Rent".equalsIgnoreCase(item.getProduct().getType())) {
                                                                        cartHasRentals = true;
                                                                        break;
                                                                    }
                                                                }
                                                                List<java.util.Map<String, Object>> userBookings = (List<java.util.Map<String, Object>>) request.getAttribute("userBookings");
                                                                %>
                                                                <div
                                                                    class="border-t border-gray-200 pt-6 mt-6 space-y-4 flex-none">
                                                                    
                                                                    <% if (cartHasRentals) { %>
                                                                        <div class="border-b border-gray-100 pb-4 mb-2">
                                                                            <label class="block text-[10px] font-black uppercase text-gray-400 tracking-widest mb-2">Select Linked Court Booking</label>
                                                                            <% if (userBookings == null || userBookings.isEmpty()) { %>
                                                                                <div class="p-3 border border-red-200 bg-red-50 text-red-700 rounded-2xl text-[11px] font-bold leading-snug">
                                                                                    ⚠️ You must have an active/confirmed court booking to rent equipment. Please book a court first.
                                                                                </div>
                                                                            <% } else { %>
                                                                                <select id="bookingSelect" onchange="updateCartPricesWithBooking()" class="w-full px-4 py-2.5 border border-gray-200 rounded-2xl font-bold text-xs bg-white focus:outline-none focus:border-black transition-all">
                                                                                    <% for (java.util.Map<String, Object> bk : userBookings) { %>
                                                                                        <option value="<%= bk.get("id") %>" data-hours="<%= bk.get("hours") %>">
                                                                                            <%= bk.get("court") %> - <%= bk.get("date") %> (<%= bk.get("hours") %> hrs)
                                                                                        </option>
                                                                                    <% } %>
                                                                                </select>
                                                                            <% } %>
                                                                        </div>
                                                                    <% } %>

                                                                    <div class="flex justify-between items-end">
                                                                        <span
                                                                            class="font-black text-xs uppercase text-gray-400 tracking-widest">Total
                                                                            Amount</span>
                                                                        <p id="cartTotalDisplay" class="font-black text-2xl text-black">Rp <%=
                                                                                rupiahFormat.format(cartTotal) %>
                                                                        </p>
                                                                    </div>

                                                                    <div class="flex gap-4">
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/Cart"
                                                                            method="POST" class="w-1/3 m-0 p-0">
                                                                            <input type="hidden" name="action"
                                                                                value="clear">
                                                                            <button type="submit"
                                                                                class="w-full border border-gray-200 text-gray-700 py-3 rounded-xl font-bold uppercase text-xs hover:bg-red-50 hover:text-red-600 hover:border-red-200 transition-colors shadow-sm">
                                                                                Clear
                                                                            </button>
                                                                        </form>
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/Cart"
                                                                            method="POST" class="w-2/3 m-0 p-0">
                                                                            <input type="hidden" name="action"
                                                                                value="checkout">
                                                                            <input type="hidden" name="bookingId" id="checkoutBookingId" value="">
                                                                            <button type="submit"
                                                                                id="checkoutBtn"
                                                                                <%= (cartHasRentals && (userBookings == null || userBookings.isEmpty())) ? "disabled" : "" %>
                                                                                class="w-full bg-black text-white hover:bg-zinc-800 border border-black py-3.5 rounded-xl font-bold uppercase text-xs tracking-wider transition-colors shadow-sm active:scale-95 text-center disabled:bg-gray-200 disabled:text-gray-400 disabled:border-gray-200 disabled:cursor-not-allowed">
                                                                                Checkout Cart
                                                                            </button>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                                <% } %>
                                                        </div>

                                                        <script>
                                                            // Filter & Sort Logic for Products
                                                            function filterAndSortProducts() {
                                                                const searchQuery = document.getElementById('searchQuery').value.toLowerCase();
                                                                const activeCategory = document.querySelector('.category-btn.active').getAttribute('data-category');
                                                                const activeType = document.getElementById('filterType').value;
                                                                const activeSort = document.getElementById('sortBy').value;

                                                                const grid = document.getElementById('productGrid');
                                                                const cards = Array.from(grid.getElementsByClassName('product-card'));

                                                                let visibleCount = 0;

                                                                cards.forEach(card => {
                                                                    const name = card.getAttribute('data-name').toLowerCase();
                                                                    const category = card.getAttribute('data-category');
                                                                    const type = card.getAttribute('data-type');

                                                                    const matchesSearch = name.includes(searchQuery);
                                                                    const matchesCategory = (activeCategory === 'All') || (category === activeCategory);
                                                                    const matchesType = (activeType === 'All') || (type === activeType);

                                                                    if (matchesSearch && matchesCategory && matchesType) {
                                                                        card.style.display = 'flex';
                                                                        visibleCount++;
                                                                    } else {
                                                                        card.style.display = 'none';
                                                                    }
                                                                });

                                                                // Sort DOM nodes
                                                                cards.sort((a, b) => {
                                                                    if (activeSort === 'price_asc') {
                                                                        return parseInt(a.getAttribute('data-price')) - parseInt(b.getAttribute('data-price'));
                                                                    } else if (activeSort === 'price_desc') {
                                                                        return parseInt(b.getAttribute('data-price')) - parseInt(a.getAttribute('data-price'));
                                                                    } else if (activeSort === 'rating') {
                                                                        return parseFloat(b.getAttribute('data-rating')) - parseFloat(a.getAttribute('data-rating'));
                                                                    } else if (activeSort === 'name_asc') {
                                                                        return a.getAttribute('data-name').localeCompare(b.getAttribute('data-name'));
                                                                    } else {
                                                                        // Default: sort by database id
                                                                        return parseInt(a.getAttribute('data-id')) - parseInt(b.getAttribute('data-id'));
                                                                    }
                                                                });

                                                                // Re-append sorted cards
                                                                cards.forEach(card => grid.appendChild(card));

                                                                // If no products matched, display a friendly placeholder
                                                                let placeholder = document.getElementById('noProductsPlaceholder');
                                                                if (visibleCount === 0) {
                                                                    if (!placeholder) {
                                                                        placeholder = document.createElement('div');
                                                                        placeholder.id = 'noProductsPlaceholder';
                                                                        placeholder.className = 'col-span-full py-16 text-center text-gray-400 font-bold uppercase tracking-widest bg-white border border-gray-200 rounded-3xl';
                                                                        placeholder.innerHTML = `
                                                                            <span class="text-4xl block mb-2">🔍</span>
                                                                            No gear matched your filter
                                                                        `;
                                                                        grid.appendChild(placeholder);
                                                                    }
                                                                } else {
                                                                    if (placeholder) {
                                                                        placeholder.remove();
                                                                    }
                                                                }
                                                            }

                                                            function selectCategory(button) {
                                                                const buttons = document.querySelectorAll('.category-btn');
                                                                buttons.forEach(btn => {
                                                                    btn.classList.remove('bg-black', 'text-white', 'border-black');
                                                                    btn.classList.add('bg-white', 'text-gray-700', 'border-gray-200');
                                                                    btn.classList.remove('active');
                                                                });

                                                                button.classList.add('bg-black', 'text-white', 'border-black');
                                                                button.classList.remove('bg-white', 'text-gray-700', 'border-gray-200');
                                                                button.classList.add('active');

                                                                filterAndSortProducts();
                                                            }

                                                            function toggleCartDrawer() {
                                                                const drawer = document.getElementById('cartDrawer');
                                                                const overlay = document.getElementById('cartDrawerOverlay');

                                                                if (drawer.classList.contains('translate-x-full')) {
                                                                    // Open
                                                                    overlay.classList.remove('hidden');
                                                                    setTimeout(() => {
                                                                        overlay.classList.remove('opacity-0');
                                                                        drawer.classList.remove('translate-x-full');
                                                                    }, 10);
                                                                } else {
                                                                    // Close
                                                                    drawer.classList.add('translate-x-full');
                                                                    overlay.classList.add('opacity-0');
                                                                    setTimeout(() => {
                                                                        overlay.classList.add('hidden');
                                                                    }, 300);
                                                                }
                                                            }

                                                            function openProductModal(event, card) {
                                                                // If click is on interactive elements in the card, ignore
                                                                if (event.target.closest('form') || event.target.closest('button[type="submit"]') || event.target.closest('.no-modal-click')) {
                                                                    return;
                                                                }

                                                                const id = card.getAttribute('data-id');
                                                                const name = card.getAttribute('data-name');
                                                                const image = card.getAttribute('data-image');
                                                                const type = card.getAttribute('data-type');
                                                                const category = card.getAttribute('data-category');
                                                                const rating = card.getAttribute('data-rating');
                                                                const description = card.getAttribute('data-description');
                                                                const price = parseInt(card.getAttribute('data-price'));
                                                                const stock = parseInt(card.getAttribute('data-stock'));

                                                                document.getElementById('modalProductImage').src = `${pageContext.request.contextPath}/assets/images/` + image;
                                                                document.getElementById('modalProductImage').alt = name;
                                                                document.getElementById('modalProductType').textContent = type;

                                                                const typeBadge = document.getElementById('modalProductType');
                                                                if (type === 'Rent') {
                                                                    typeBadge.className = "absolute top-3 left-3 text-[9px] font-bold uppercase tracking-widest px-2.5 py-1 rounded-full border bg-yellow-100 text-yellow-800 border-yellow-200";
                                                                } else {
                                                                    typeBadge.className = "absolute top-3 left-3 text-[9px] font-bold uppercase tracking-widest px-2.5 py-1 rounded-full border bg-cyan-100 text-cyan-800 border-cyan-200";
                                                                }

                                                                document.getElementById('modalProductName').textContent = name;
                                                                document.getElementById('modalProductCategory').textContent = category;
                                                                document.getElementById('modalProductRating').textContent = rating;
                                                                document.getElementById('modalProductDescription').textContent = description;

                                                                // Format Price to Rupiah
                                                                const rupiahFormat = new Intl.NumberFormat('id-ID', {
                                                                    style: 'currency',
                                                                    currency: 'IDR',
                                                                    minimumFractionDigits: 0
                                                                }).format(price).replace("IDR", "Rp");
                                                                
                                                                document.getElementById('modalProductPrice').innerHTML = rupiahFormat + (type === 'Rent' ? ' <span class="text-xs font-bold text-gray-400 opacity-60">/ Hour</span>' : '');

                                                                const stockBadge = document.getElementById('modalProductStock');
                                                                if (stock > 0) {
                                                                    stockBadge.textContent = stock;
                                                                    stockBadge.className = "font-bold text-xs text-gray-800";
                                                                } else {
                                                                    stockBadge.textContent = "OUT OF STOCK";
                                                                    stockBadge.className = "font-bold text-xs text-red-500 font-black animate-pulse";
                                                                }

                                                                document.getElementById('modalProductId').value = id;

                                                                const submitBtn = document.getElementById('modalSubmitBtn');
                                                                if (stock > 0) {
                                                                    submitBtn.disabled = false;
                                                                    submitBtn.textContent = type === 'Rent' ? 'Rent Equipment' : 'Purchase Item';
                                                                    submitBtn.className = "w-full bg-black text-white hover:bg-zinc-800 border border-black py-3.5 rounded-xl font-bold uppercase text-xs tracking-wider transition-all shadow-sm active:scale-95 text-center";
                                                                } else {
                                                                    submitBtn.disabled = true;
                                                                    submitBtn.textContent = 'Out of Stock';
                                                                    submitBtn.className = "w-full bg-gray-100 text-gray-400 border border-gray-200 py-3.5 rounded-xl font-bold uppercase text-xs tracking-wider cursor-not-allowed text-center";
                                                                }

                                                                const modal = document.getElementById('productDetailModal');
                                                                const overlay = document.getElementById('productDetailOverlay');

                                                                modal.classList.remove('hidden');
                                                                overlay.classList.remove('hidden');
                                                                setTimeout(() => {
                                                                    overlay.classList.remove('opacity-0');
                                                                    modal.classList.remove('opacity-0', 'scale-95');
                                                                }, 10);
                                                            }

                                                            function closeProductModal() {
                                                                const modal = document.getElementById('productDetailModal');
                                                                const overlay = document.getElementById('productDetailOverlay');

                                                                modal.classList.add('opacity-0', 'scale-95');
                                                                overlay.classList.add('opacity-0');
                                                                setTimeout(() => {
                                                                    modal.classList.add('hidden');
                                                                    overlay.classList.add('hidden');
                                                                }, 300);
                                                            }

                                                            function updateCartPricesWithBooking() {
                                                                const bookingSelect = document.getElementById('bookingSelect');
                                                                let hours = 1.0;
                                                                if (bookingSelect) {
                                                                    const selectedOption = bookingSelect.options[bookingSelect.selectedIndex];
                                                                    if (selectedOption) {
                                                                        hours = parseFloat(selectedOption.getAttribute('data-hours')) || 1.0;
                                                                        const checkoutBookingId = document.getElementById('checkoutBookingId');
                                                                        if (checkoutBookingId) {
                                                                            checkoutBookingId.value = selectedOption.value;
                                                                        }
                                                                    }
                                                                }

                                                                let cartTotal = 0;
                                                                const cartItems = document.querySelectorAll('.cart-item');
                                                                cartItems.forEach(item => {
                                                                    const type = item.getAttribute('data-type');
                                                                    const price = parseInt(item.getAttribute('data-price')) || 0;
                                                                    const qty = parseInt(item.getAttribute('data-qty')) || 0;
                                                                    
                                                                    let itemTotal = 0;
                                                                    if (type === 'Rent') {
                                                                        itemTotal = price * qty * hours;
                                                                        const priceDisplay = item.querySelector('.item-price-display');
                                                                        if (priceDisplay) {
                                                                            const formattedItemTotal = new Intl.NumberFormat('id-ID', {
                                                                                style: 'currency',
                                                                                currency: 'IDR',
                                                                                minimumFractionDigits: 0
                                                                            }).format(price).replace("IDR", "Rp") + " × " + qty + " × " + hours + "h";
                                                                            priceDisplay.textContent = formattedItemTotal;
                                                                        }
                                                                    } else {
                                                                        itemTotal = price * qty;
                                                                        const priceDisplay = item.querySelector('.item-price-display');
                                                                        if (priceDisplay) {
                                                                            const formattedItemTotal = new Intl.NumberFormat('id-ID', {
                                                                                style: 'currency',
                                                                                currency: 'IDR',
                                                                                minimumFractionDigits: 0
                                                                            }).format(price).replace("IDR", "Rp") + " × " + qty;
                                                                            priceDisplay.textContent = formattedItemTotal;
                                                                        }
                                                                    }
                                                                    cartTotal += itemTotal;
                                                                });

                                                                const totalDisplay = document.getElementById('cartTotalDisplay');
                                                                if (totalDisplay) {
                                                                    const formattedTotal = new Intl.NumberFormat('id-ID', {
                                                                        style: 'currency',
                                                                        currency: 'IDR',
                                                                        minimumFractionDigits: 0
                                                                    }).format(cartTotal).replace("IDR", "Rp");
                                                                    totalDisplay.textContent = formattedTotal;
                                                                }
                                                            }

                                                            // Auto open cart if url has cartOpen=true parameter
                                                            window.addEventListener('DOMContentLoaded', () => {
                                                                const urlParams = new URLSearchParams(window.location.search);
                                                                if (urlParams.get('cartOpen') === 'true') {
                                                                    toggleCartDrawer();
                                                                }
                                                                updateCartPricesWithBooking();
                                                            });
                                                        </script>
                                        </body>

                                        </html>