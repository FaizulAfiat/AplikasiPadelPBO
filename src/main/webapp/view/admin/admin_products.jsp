<%-- 
    Document   : admin_products
    Created on : 11 May 2026, 14.09.30
    Author     : Faizul Afiat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Manage Shop - PadelApp</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 flex min-h-screen">
        <div class="w-72 bg-black text-white p-8 flex flex-col fixed h-full shadow-2xl">
            <div class="mb-12">
                <h2 class="text-3xl font-black italic tracking-tighter text-cyan-400">PADELAPP</h2>
                <p class="text-[10px] font-bold opacity-50 tracking-[0.2em] uppercase">ADMIN</p>
            </div>
            <nav class="space-y-6 flex-1">
                <a href="AdminController" class="block font-black text-xs uppercase tracking-widest opacity-40 hover:opacity-100 transition-all">Dashboard</a>
                <a href="ManageProducts" class="block font-black text-xs uppercase tracking-widest border-l-4 border-cyan-400 pl-4">Manage Shop</a>
                <a href="ManageBookings" class="block font-black text-xs uppercase tracking-widest opacity-40 hover:opacity-100 transition-all">Schedules</a>
            </nav>

            <a href="${pageContext.request.contextPath}/Logout" class="mt-auto bg-red-500/10 text-red-500 border-2 border-red-500 p-4 rounded-2xl text-center font-black text-xs uppercase hover:bg-red-500 hover:text-white transition-all">
                Exit Session
            </a>
        </div>

        <div class="ml-72 p-12 w-full">
            <header class="mb-12 flex justify-between items-end">
                <div>
                    <h1 class="text-5xl font-black uppercase italic tracking-tighter">Shop Inventory</h1>
                    <p class="text-gray-400 font-bold uppercase text-[10px] mt-2 tracking-widest">Manage racquets, balls, and gear</p>
                </div>
                <button onclick="toggleModal()" class="bg-cyan-400 border-4 border-black px-8 py-3 font-black uppercase italic shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-1 hover:translate-y-1 transition-all">
                    + Add New Product
                </button>
            </header>

            <div class="bg-white border-4 border-black rounded-[3rem] p-10 shadow-[12px_12px_0px_0px_rgba(0,0,0,1)] overflow-hidden">
                <table class="w-full text-left">
                    <thead>
                        <tr class="border-b-4 border-black">
                            <th class="py-4 font-black uppercase text-xs opacity-40">Item</th>
                            <th class="py-4 font-black uppercase text-xs opacity-40">Category</th>
                            <th class="py-4 font-black uppercase text-xs opacity-40">Price</th>
                            <th class="py-4 font-black uppercase text-xs opacity-40">Stock</th>
                            <th class="py-4 font-black uppercase text-xs opacity-40 text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody class="font-bold">
                        <c:forEach var="p" items="${productList}">
                            <tr class="border-b-2 border-gray-100 hover:bg-cyan-50">
                                <td class="py-5">
                                    <div class="flex items-center gap-4">
                                        <div class="w-16 h-16 rounded-2xl border-4 border-black shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] overflow-hidden bg-white">
                                            <img src="${pageContext.request.contextPath}/assets/images/${p.image}" alt="${p.name}" class="w-full h-full object-cover grayscale hover:grayscale-0 transition-all duration-300">
                                        </div>
                                        <span class="uppercase font-black text-lg tracking-tighter">${p.name}</span>
                                    </div>
                                </td>
                                <td class="py-5"><span class="bg-gray-100 px-3 py-1 rounded-full text-[10px] uppercase">${p.category}</span></td>
                                <td class="py-5 text-cyan-600 font-black">
                                    <fmt:setLocale value="id_ID"/>
                                    <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="Rp " maxFractionDigits="0"/>
                                </td>
                                <td class="py-5">
                                    <span class="${p.stock < 5 ? 'text-red-500' : ''}">${p.stock} pcs</span>
                                </td>
                                <td class="py-5">
                                    <div class="flex justify-center gap-2">
                                        <a href="EditProduct?id=${p.id}" class="p-2 border-2 border-black rounded-lg hover:bg-yellow-400 transition-colors">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                        </a>
                                        <a href="DeleteProduct?id=${p.id}" onclick="return confirm('Hapus produk ini?')" class="p-2 border-2 border-black rounded-lg hover:bg-red-500 hover:text-white transition-colors">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="addModal" class="fixed inset-0 bg-black/50 backdrop-blur-sm hidden z-[999] flex items-center justify-center p-4">
            <div class="bg-white border-4 border-black p-10 rounded-[3rem] w-full max-w-md shadow-[15px_15px_0px_0px_rgba(0,0,0,1)]">
                <h2 class="text-3xl font-black uppercase italic mb-6">New Product</h2>
                <form action="${pageContext.request.contextPath}/AddProduct" method="POST" enctype="multipart/form-data" class="space-y-4">
                    <input type="text" name="name" placeholder="PRODUCT NAME" class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:bg-cyan-50" required>
                    <select name="category" class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none">
                        <option value="Racquet">Racket</option>
                        <option value="Balls">Balls</option>
                        <option value="Apparel">Grip</option>
                        <option value="Other">Other</option>
                    </select>
                    <select name="type" class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none">
                        <option value="Rent">Rent</option>
                        <option value="Sale">Sale</option>
                    </select>
                    <div class="flex gap-4">
                        <input type="number" name="price" placeholder="PRICE" class="w-1/2 border-2 border-black p-3 rounded-xl font-bold outline-none" required>
                        <input type="number" name="stock" placeholder="STOCK" class="w-1/2 border-2 border-black p-3 rounded-xl font-bold outline-none" required>
                    </div>
                    <div class="border-2 border-black p-3 rounded-xl">
                        <label class="text-[10px] font-black opacity-50 block mb-1">PRODUCT IMAGE</label>
                        <input type="file" name="image" accept="image/*" class="w-full font-bold text-xs" required>
                    </div>                    
                    <div class="flex gap-4 pt-4">
                        <button type="button" onclick="toggleModal()" class="w-1/2 border-2 border-black p-3 rounded-xl font-black uppercase text-xs">Cancel</button>
                        <button type="submit" class="w-1/2 bg-black text-white p-3 rounded-xl font-black uppercase text-xs hover:bg-cyan-400 hover:text-black transition-all">Save Item</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function toggleModal() {
                const modal = document.getElementById('addModal');
                modal.classList.toggle('hidden');
            }
        </script>
    </body>
</html>