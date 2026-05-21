<%-- Document : store_rent Created on : 5 May 2026, 13.47.13 Author : Faizul Afiat --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.mycompany.aplikasi_padel_tubes_pbo.model.CartItem" %>
<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    int cartItemCount = 0;
    int cartTotal = 0;
    if (cart != null) {
        for (CartItem item : cart) {
            cartItemCount += item.getQuantity();
            cartTotal += item.getSubtotal();
        }
    }
%>
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
                            <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">Padel<span
                                    class="text-blue-400">App</span></h1>
                        </div>
                        <div class="flex-1 border-r border-gray-200 hidden md:flex items-center px-8">
                            <a href="${pageContext.request.contextPath}/index.jsp"
                                class="text-xs font-bold uppercase tracking-widest text-gray-600 hover:text-black hover:underline transition-colors">←
                                Back to Dashboard</a>
                        </div>
                        <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4">
                            <!-- Cart Icon Button -->
                            <button onclick="toggleCartDrawer()" class="relative p-2 border-2 border-black rounded-xl hover:bg-cyan-100 transition-colors flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-5 h-5 text-black">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 0 0-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 0 0-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Zm12.75 0a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Z" />
                                </svg>
                                <% if (cartItemCount > 0) { %>
                                    <span class="absolute -top-2 -right-2 bg-red-500 border-2 border-black text-white text-[9px] font-black w-5 h-5 rounded-full flex items-center justify-center">
                                        <%= cartItemCount %>
                                    </span>
                                <% } %>
                            </button>

                            <span class="text-[10px] font-bold uppercase tracking-widest text-gray-500">
                                <%= session.getAttribute("user") !=null ? session.getAttribute("user") : "Admin" %>
                            </span>
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2"
                                stroke="currentColor" class="w-5 h-5 text-gray-700">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                    d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                            </svg>
                        </div>
                    </header>

                    <%-- MAIN AREA CONTAINER --%>
                        <div class="flex-1 p-6 pb-24 max-w-6xl w-full mx-auto">
                            <div class="mb-10">
                                <h1 class="text-5xl font-black uppercase tracking-tighter italic">Pro Shop <span
                                        class="text-cyan-500">&</span> Rentals</h1>
                                <p class="text-gray-400 font-bold uppercase text-xs tracking-widest mt-2">Equip yourself
                                    with the best gear</p>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8">
                                <c:forEach var="product" items="${productList}">

                                    <%-- FIXED-SIZE CARD ELEMENT --%>
                                        <div
                                            class="bg-white border-4 border-black rounded-[2.5rem] p-6 flex flex-col shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] hover:translate-x-1 hover:translate-y-1 hover:shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] transition-all group h-[500px]">

                                            <%-- 1. Wadah Gambar dengan Tinggi Fixed Mutlak --%>
                                                <div
                                                    class="w-full h-56 bg-gray-100 rounded-2xl overflow-hidden mb-4 border-2 border-black/5 relative flex-none">
                                                    <img src="${pageContext.request.contextPath}/assets/images/${product.image}"
                                                        alt="${product.name}"
                                                        class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300">

                                                    <span
                                                        class="absolute top-3 left-3 text-[9px] font-black uppercase tracking-widest px-2.5 py-1 rounded-md border-2 border-black shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] ${product.type == 'Rent' ? 'bg-yellow-300 text-black' : 'bg-cyan-400 text-black'}">
                                                        ${product.type}
                                                    </span>
                                                </div>

                                                <%-- 2. Detail Teks & Informasi (Menggunakan pembagi vertikal dinamis)
                                                    --%>
                                                    <div class="flex-1 flex flex-col justify-between">
                                                        <div class="space-y-1">
                                                            <span
                                                                class="text-[10px] font-black uppercase opacity-40 tracking-wider">Product
                                                                Catalog</span>
                                                            <h3
                                                                class="font-black uppercase italic text-xl leading-tight text-gray-900 line-clamp-2 h-14">
                                                                ${product.name}
                                                            </h3>
                                                        </div>

                                                        <%-- 3. Area Harga, Stok & Aksi Bawah --%>
                                                            <div class="mt-4 space-y-4">
                                                                <div
                                                                    class="flex justify-between items-end border-t-2 border-dashed border-gray-100 pt-3">
                                                                    <div class="flex flex-col">
                                                                        <span
                                                                            class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Rate
                                                                            / Price</span>
                                                                        <p class="font-black text-xl text-black">
                                                                            Rp ${product.price}
                                                                            <c:if test="${product.type == 'Rent'}"><span
                                                                                    class="text-xs font-bold text-gray-400 opacity-60">
                                                                                    / Session</span></c:if>
                                                                        </p>
                                                                    </div>
                                                                    <div class="flex flex-col items-end">
                                                                        <span
                                                                            class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Stock</span>
                                                                        <span
                                                                            class="font-bold text-xs ${product.stock > 0 ? 'text-gray-800' : 'text-red-500 font-black animate-pulse'}">
                                                                            ${product.stock > 0 ? product.stock : 'OUT
                                                                            OF STOCK'}
                                                                        </span>
                                                                    </div>
                                                                </div>

                                                                <form
                                                                    action="${pageContext.request.contextPath}/Cart"
                                                                    method="POST" class="m-0 p-0">
                                                                    <input type="hidden" name="productId"
                                                                        value="${product.id}">
                                                                    <input type="hidden" name="action"
                                                                        value="add">
                                                                    <c:choose>
                                                                        <c:when test="${product.stock > 0}">
                                                                            <button type="submit"
                                                                                class="w-full bg-black text-white hover:bg-cyan-400 hover:text-black border-2 border-black py-3.5 rounded-xl font-black uppercase text-xs tracking-wider transition-colors shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] hover:shadow-none active:scale-95 transition-all">
                                                                                ${product.type == 'Rent' ? 'Rent Equipment' : 'Purchase Item'}
                                                                            </button>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <button type="button" disabled
                                                                                class="w-full bg-gray-200 text-gray-400 border-2 border-gray-300 py-3.5 rounded-xl font-black uppercase text-xs tracking-wider cursor-not-allowed">
                                                                                Out of Stock
                                                                            </button>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </form>
                                                            </div>
                                                    </div>

                                        </div>
                                </c:forEach>
                            </div>
                        </div>

                        <%-- Neobrutalist-styled Toast Notification --%>
                            <c:if test="${not empty param.status}">
                                <div id="statusToast"
                                    class="fixed bottom-8 right-8 z-[9999] bg-white border-4 border-black p-6 rounded-[2rem] shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] max-w-sm flex flex-col gap-2 transition-all duration-300">
                                    <div class="flex items-center gap-3">
                                        <c:choose>
                                            <c:when test="${param.status == 'success' || param.status == 'cart_add_success'}">
                                                <span
                                                    class="w-8 h-8 rounded-full bg-emerald-400 border-2 border-black flex items-center justify-center font-black">✓</span>
                                                <h4 class="font-black uppercase tracking-tighter text-lg">
                                                    ${param.status == 'cart_add_success' ? 'Cart Updated' : 'Transaction Success!'}
                                                </h4>
                                            </c:when>
                                            <c:otherwise>
                                                <span
                                                    class="w-8 h-8 rounded-full bg-red-400 border-2 border-black flex items-center justify-center font-black">✗</span>
                                                <h4 class="font-black uppercase tracking-tighter text-lg">
                                                    Action Failed
                                                </h4>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <p class="text-xs font-bold text-gray-500 uppercase tracking-wide">
                                        <c:choose>
                                            <c:when test="${param.status == 'success'}">Your order has been placed successfully and product stock updated.</c:when>
                                            <c:when test="${param.status == 'cart_add_success'}">Item has been added to your cart successfully.</c:when>
                                            <c:when test="${param.status == 'max_stock_exceeded'}">Cannot add more. Available stock limit reached.</c:when>
                                            <c:when test="${param.status == 'insufficient_stock_for_checkout'}">Some items in your cart exceed available stock. Please reduce quantity.</c:when>
                                            <c:when test="${param.status == 'cart_empty'}">Your cart is empty. Please add items before checking out.</c:when>
                                            <c:when test="${param.status == 'out_of_stock'}">Sorry, the item you selected is currently out of stock.</c:when>
                                            <c:when test="${param.status == 'not_logged_in'}">Please log in to purchase or rent items.</c:when>
                                            <c:when test="${param.status == 'product_not_found'}">Product not found in database.</c:when>
                                            <c:when test="${param.status == 'db_error'}">Database error occurred. Please try again later.</c:when>
                                            <c:otherwise>Something went wrong. Please check your request.</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <button onclick="document.getElementById('statusToast').remove()"
                                        class="mt-2 bg-black text-white hover:bg-red-500 border-2 border-black py-2 rounded-xl font-black uppercase text-[10px] tracking-wider transition-colors shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] hover:shadow-none active:scale-95 transition-all text-center">
                                        Dismiss
                                    </button>
                                </div>
                            </c:if>
            <!-- CART DRAWER OVERLAY -->
            <div id="cartDrawerOverlay" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-[999] hidden transition-opacity duration-300 opacity-0" onclick="toggleCartDrawer()"></div>

            <!-- CART DRAWER PANEL -->
            <div id="cartDrawer" class="fixed top-0 right-0 bottom-0 w-full sm:w-[450px] bg-white border-l-4 border-black z-[1000] translate-x-full transition-transform duration-300 ease-in-out flex flex-col p-6 shadow-2xl">
                <div class="flex justify-between items-center border-b-4 border-black pb-4 mb-6 flex-none">
                    <div class="flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="w-6 h-6">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 10.5V6a3.75 3.75 0 1 0-7.5 0v4.5m11.356-1.993 1.263 12c.07.665-.45 1.243-1.119 1.243H4.25a1.125 1.125 0 0 1-1.12-1.243l1.264-12A1.125 1.125 0 0 1 5.513 7.5h12.974c.576 0 1.059.435 1.119 1.007ZM8.625 10.5a.375.375 0 1 1-.75 0 .375.375 0 0 1 .75 0Zm7.5 0a.375.375 0 1 1-.75 0 .375.375 0 0 1 .75 0Z" />
                        </svg>
                        <h2 class="text-2xl font-black uppercase italic tracking-tighter">Your Cart</h2>
                    </div>
                    <button onclick="toggleCartDrawer()" class="p-2 border-2 border-black rounded-lg hover:bg-red-100 transition-colors">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="w-4 h-4">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>

                <!-- Cart Items List -->
                <div class="flex-1 overflow-y-auto space-y-4 pr-1">
                    <% if (cart == null || cart.isEmpty()) { %>
                        <div class="flex flex-col items-center justify-center h-full text-center p-8">
                            <span class="text-4xl">🛒</span>
                            <p class="font-black text-lg uppercase mt-4">Your cart is empty</p>
                            <p class="text-xs font-bold text-gray-400 mt-1 uppercase tracking-wider">Add some gear to get started!</p>
                        </div>
                    <% } else { %>
                        <% for (CartItem item : cart) { %>
                            <div class="flex gap-4 p-4 border-2 border-black rounded-2xl bg-gray-50 relative group shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
                                <div class="w-16 h-16 rounded-xl border-2 border-black overflow-hidden bg-white flex-none">
                                    <img src="${pageContext.request.contextPath}/assets/images/<%= item.getProduct().getImage() %>" alt="<%= item.getProduct().getName() %>" class="w-full h-full object-cover">
                                </div>
                                <div class="flex-1 flex flex-col justify-between">
                                    <div>
                                        <div class="flex justify-between items-start gap-2">
                                            <h4 class="font-black text-xs uppercase italic leading-tight text-gray-900 line-clamp-1 mr-4"><%= item.getProduct().getName() %></h4>
                                            <span class="text-[8px] font-black uppercase tracking-widest px-2 py-0.5 rounded border border-black shadow-[1px_1px_0px_0px_rgba(0,0,0,1)] flex-none <%= "Rent".equals(item.getProduct().getType()) ? "bg-yellow-300" : "bg-cyan-400" %>">
                                                <%= item.getProduct().getType() %>
                                            </span>
                                        </div>
                                        <span class="text-[9px] font-bold uppercase text-gray-400"><%= item.getProduct().getCategory() %></span>
                                    </div>
                                    <div class="flex justify-between items-end mt-2">
                                        <p class="font-black text-sm text-black">
                                            Rp <%= item.getProduct().getPrice() %>
                                        </p>
                                        
                                        <!-- Qty Controls -->
                                        <div class="flex items-center border-2 border-black rounded-lg overflow-hidden bg-white">
                                            <form action="${pageContext.request.contextPath}/Cart" method="POST" class="m-0 p-0">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                                <input type="hidden" name="change" value="-1">
                                                <button type="submit" class="px-2 py-1 font-black text-xs hover:bg-gray-100 border-r-2 border-black">-</button>
                                            </form>
                                            <span class="px-3 font-black text-xs"><%= item.getQuantity() %></span>
                                            <form action="${pageContext.request.contextPath}/Cart" method="POST" class="m-0 p-0">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                                <input type="hidden" name="change" value="1">
                                                <button type="submit" class="px-2 py-1 font-black text-xs hover:bg-gray-100 border-l-2 border-black">+</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <!-- Remove Button -->
                                <form action="${pageContext.request.contextPath}/Cart" method="POST" class="absolute -top-2 -right-2 m-0 p-0">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                    <button type="submit" class="w-6 h-6 rounded-full bg-red-400 border-2 border-black flex items-center justify-center text-xs font-black shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] hover:translate-x-0.5 hover:translate-y-0.5 hover:shadow-none active:scale-95 transition-all">×</button>
                                </form>
                            </div>
                        <% } %>
                    <% } %>
                </div>

                <!-- Bottom Summary & Checkout -->
                <% if (cart != null && !cart.isEmpty()) { %>
                    <div class="border-t-4 border-black pt-6 mt-6 space-y-4 flex-none">
                        <div class="flex justify-between items-end">
                            <span class="font-black text-xs uppercase text-gray-400 tracking-widest">Total Amount</span>
                            <p class="font-black text-2xl text-black">Rp <%= cartTotal %></p>
                        </div>
                        
                        <div class="flex gap-4">
                            <form action="${pageContext.request.contextPath}/Cart" method="POST" class="w-1/3 m-0 p-0">
                                <input type="hidden" name="action" value="clear">
                                <button type="submit" class="w-full border-2 border-black py-3 rounded-xl font-black uppercase text-xs hover:bg-red-100 transition-colors">
                                    Clear
                                </button>
                            </form>
                            <form action="${pageContext.request.contextPath}/Cart" method="POST" class="w-2/3 m-0 p-0">
                                <input type="hidden" name="action" value="checkout">
                                <button type="submit" class="w-full bg-black text-white hover:bg-cyan-400 hover:text-black border-2 border-black py-3.5 rounded-xl font-black uppercase text-xs tracking-wider transition-colors shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] hover:shadow-none active:scale-95 transition-all text-center">
                                    Checkout Cart
                                </button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>

            <script>
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

                // Auto open cart if url has cartOpen=true parameter
                window.addEventListener('DOMContentLoaded', () => {
                    const urlParams = new URLSearchParams(window.location.search);
                    if (urlParams.get('cartOpen') === 'true') {
                        toggleCartDrawer();
                    }
                });
            </script>
    </body>

    </html>