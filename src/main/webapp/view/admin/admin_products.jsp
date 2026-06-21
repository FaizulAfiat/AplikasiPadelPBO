<%-- Document : admin_products Created on : 11 May 2026, 14.09.30 Author : Faizul Afiat --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <title>Manage Shop - PadelApp</title>
                    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">
                    <script src="https://cdn.tailwindcss.com"></script>
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
                                    class="flex items-center gap-3 px-4 py-3 font-semibold text-xs uppercase tracking-widest bg-cyan-500 text-white rounded-xl shadow-md shadow-cyan-500/20 transition-all hover:bg-cyan-600">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                                        <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4zM3 6h18M16 10a4 4 0 0 1-8 0"/>
                                    </svg>
                                    Manage Shop
                                </a>
                                <a href="AdminRentalController"
                                    class="flex items-center gap-3 px-4 py-3 font-semibold text-xs uppercase tracking-widest text-zinc-400 hover:text-white hover:bg-zinc-900 rounded-xl hover:translate-x-1.5 transition-all duration-200">
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

                        <!-- Main Content Area -->
                        <main class="ml-72 p-12 w-full max-w-7xl">
                            <header class="mb-12 flex justify-between items-end">
                                <div>
                                    <h1 class="text-5xl font-black uppercase italic tracking-tighter text-zinc-900">Shop Inventory</h1>
                                    <p class="text-zinc-500 font-bold uppercase text-xs mt-3 tracking-widest flex items-center gap-2">
                                        <span class="w-1.5 h-1.5 bg-cyan-500 rounded-full"></span>
                                        Manage racquets, balls, and gear
                                    </p>
                                </div>
                                <button onclick="toggleModal()"
                                    class="bg-cyan-500 hover:bg-cyan-600 text-white px-6 py-3 font-bold text-xs uppercase tracking-widest rounded-xl shadow-md shadow-cyan-500/20 transition-all">
                                    + Add New Product
                                </button>
                            </header>

                            <c:if test="${not empty param.success}">
                                <div class="mb-8 border border-emerald-200 p-4 rounded-2xl bg-emerald-50 text-emerald-800 font-semibold text-sm shadow-sm flex items-center justify-between">
                                    <div class="flex items-center gap-3">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                                            fill="none" stroke="currentColor" stroke-width="2.5" class="shrink-0 text-emerald-600">
                                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                        </svg>
                                        <span>
                                            <c:choose>
                                                <c:when test="${param.success eq 'delete'}">Produk berhasil dihapus dari inventaris!</c:when>
                                                <c:when test="${param.success eq 'edit'}">Produk berhasil diperbarui!</c:when>
                                                <c:otherwise>Produk baru berhasil ditambahkan!</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <button onclick="this.parentElement.remove()"
                                        class="text-emerald-500 hover:text-emerald-700 transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                                            fill="none" stroke="currentColor" stroke-width="2.5">
                                            <line x1="18" y1="6" x2="6" y2="18"></line>
                                            <line x1="6" y1="6" x2="18" y2="18"></line>
                                        </svg>
                                    </button>
                                </div>
                            </c:if>

                            <c:if test="${not empty param.error}">
                                <div class="mb-8 border border-rose-200 p-4 rounded-2xl bg-rose-50 text-rose-800 font-semibold text-sm shadow-sm flex items-center justify-between">
                                    <div class="flex items-center gap-3">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                                            fill="none" stroke="currentColor" stroke-width="2.5" class="shrink-0 text-rose-600">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <line x1="12" y1="8" x2="12" y2="12"></line>
                                            <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                        </svg>
                                        <span>
                                            <c:choose>
                                                <c:when test="${param.error eq 'delete'}">Gagal menghapus produk! Item ini mungkin masih terkait dengan transaksi aktif.</c:when>
                                                <c:when test="${param.error eq 'edit'}">Gagal memperbarui data produk!</c:when>
                                                <c:when test="${param.error eq 'notfound'}">Hapus gagal: Produk tidak ditemukan!</c:when>
                                                <c:when test="${param.error eq 'invalidid' or param.error eq 'missingid'}">Hapus gagal: ID Produk tidak valid!</c:when>
                                                <c:otherwise>Terjadi kesalahan pada sistem saat memproses produk!</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <button onclick="this.parentElement.remove()"
                                        class="text-rose-500 hover:text-rose-700 transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                                            fill="none" stroke="currentColor" stroke-width="2.5">
                                            <line x1="18" y1="6" x2="6" y2="18"></line>
                                            <line x1="6" y1="6" x2="18" y2="18"></line>
                                        </svg>
                                    </button>
                                </div>
                            </c:if>

                            <div class="bg-white border border-gray-200 rounded-3xl p-8 shadow-sm overflow-hidden">
                                <div class="overflow-x-auto border border-gray-200 rounded-2xl">
                                    <table class="w-full text-left border-collapse bg-white">
                                        <thead>
                                            <tr class="bg-gray-50 text-gray-500 font-bold uppercase text-[10px] tracking-wider border-b border-gray-200">
                                                <th class="py-3 px-4">Item</th>
                                                <th class="py-3 px-4">Category</th>
                                                <th class="py-3 px-4">Price</th>
                                                <th class="py-3 px-4">Stock</th>
                                                <th class="py-3 px-4 text-center">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody class="text-sm font-semibold divide-y divide-gray-100">
                                            <c:forEach var="p" items="${productList}">
                                                <tr class="hover:bg-gray-50/50 transition-colors text-gray-700">
                                                    <td class="py-4 px-4">
                                                        <div class="flex items-center gap-4">
                                                            <div class="w-12 h-12 rounded-xl border border-gray-200 shadow-sm overflow-hidden bg-white">
                                                                <img src="${pageContext.request.contextPath}/assets/images/${p.image}"
                                                                    alt="${p.name}"
                                                                    class="w-full h-full object-cover transition-all duration-300">
                                                            </div>
                                                            <span class="uppercase font-semibold text-gray-900 tracking-tight text-sm">${p.name}</span>
                                                        </div>
                                                    </td>
                                                    <td class="py-4 px-4">
                                                        <span class="bg-gray-50 text-gray-600 border border-gray-200 px-2.5 py-1 rounded-full text-[10px] uppercase font-bold tracking-wider">${p.category}</span>
                                                    </td>
                                                    <td class="py-4 px-4 text-cyan-600 font-semibold text-sm">
                                                        <fmt:setLocale value="id_ID" />
                                                        <fmt:formatNumber value="${p.price}" type="currency"
                                                            currencySymbol="Rp " maxFractionDigits="0" />
                                                    </td>
                                                    <td class="py-4 px-4 text-sm font-semibold text-gray-700">
                                                        <span class="${p.stock < 5 ? 'text-red-500' : ''}">${p.stock} pcs</span>
                                                    </td>
                                                    <td class="py-4 px-4">
                                                        <div class="flex justify-center gap-2">
                                                            <button type="button"
                                                                data-id="${p.id}"
                                                                data-name="<c:out value="${p.name}"/>"
                                                                data-category="<c:out value="${p.category}"/>"
                                                                data-type="<c:out value="${p.type}"/>"
                                                                data-price="${p.price}"
                                                                data-stock="${p.stock}"
                                                                data-rating="${p.rating}"
                                                                data-description="<c:out value="${p.description}"/>"
                                                                data-image="<c:out value="${p.image}"/>"
                                                                onclick="openEditModal(this)"
                                                                class="p-2 border border-gray-200 rounded-lg hover:bg-yellow-50 text-yellow-800 hover:border-yellow-200 transition-colors">
                                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                                    stroke-width="2.5">
                                                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                                                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                                                </svg>
                                                            </button>
                                                            <a href="${pageContext.request.contextPath}/DeleteProduct?id=${p.id}"
                                                                onclick="return confirm('Hapus produk ini?')"
                                                                class="p-2 border border-gray-200 rounded-lg hover:bg-red-50 text-red-800 hover:border-red-200 transition-colors">
                                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                                    stroke-width="2.5">
                                                                    <polyline points="3 6 5 6 21 6"></polyline>
                                                                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                                                    <line x1="10" y1="11" x2="10" y2="17"></line>
                                                                    <line x1="14" y1="11" x2="14" y2="17"></line>
                                                                </svg>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </main>
                    </div>

                    <div id="addModal"
                        class="fixed inset-0 bg-zinc-950/40 backdrop-blur-sm hidden z-[999] flex items-center justify-center p-4">
                        <div class="bg-white border border-gray-200 p-8 rounded-3xl w-full max-w-lg shadow-2xl max-h-[90vh] overflow-y-auto">
                            <div class="flex justify-between items-center mb-6">
                                <h2 class="text-3xl font-black uppercase italic tracking-tighter">New Product</h2>
                                <button type="button" onclick="toggleModal()"
                                    class="text-gray-400 hover:text-black transition-colors">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2.5">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                </button>
                            </div>
                            <form action="${pageContext.request.contextPath}/AddProduct" method="POST"
                                enctype="multipart/form-data" class="space-y-4 text-left">
                                <div>
                                    <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Product Name</label>
                                    <input type="text" name="name" placeholder="E.G. HEAD RACKET SPEED"
                                        class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-gray-50/50 focus:bg-white focus:border-black transition-all"
                                        required>
                                </div>

                                <div class="flex gap-4">
                                    <div class="w-1/2">
                                        <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Category</label>
                                        <select name="category"
                                            class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-white focus:border-black transition-all">
                                            <option value="Racket">Racket</option>
                                            <option value="Balls">Balls</option>
                                            <option value="Grip">Grip</option>
                                            <option value="Bag">Bag</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </div>
                                    <div class="w-1/2">
                                        <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Type</label>
                                        <select name="type"
                                            class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-white focus:border-black transition-all">
                                            <option value="Rent">Rent</option>
                                            <option value="Sale">Sale</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="flex gap-4">
                                    <div class="flex-1">
                                        <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Price (Rp)</label>
                                        <input type="number" name="price" placeholder="E.G. 150000"
                                            class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-gray-50/50 focus:bg-white focus:border-black transition-all"
                                            required>
                                    </div>
                                    <div class="w-24">
                                        <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Stock</label>
                                        <input type="number" name="stock" placeholder="10"
                                            class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-gray-50/50 focus:bg-white focus:border-black transition-all"
                                            required>
                                    </div>
                                    <div class="w-24">
                                        <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Rating</label>
                                        <input type="number" name="rating" placeholder="4.5" min="1.0" max="5.0"
                                            step="0.1" value="4.5"
                                            class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-gray-50/50 focus:bg-white focus:border-black transition-all"
                                            required>
                                    </div>
                                </div>

                                <div>
                                    <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Description</label>
                                    <textarea name="description" placeholder="WRITE DETAILED DESCRIPTION HERE..."
                                        class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-gray-50/50 focus:bg-white focus:border-black h-24 resize-none transition-all"
                                        required></textarea>
                                </div>

                                <div>
                                    <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Product Image</label>
                                    <div class="border border-gray-200 p-3 rounded-xl flex items-center bg-gray-50/50 focus-within:bg-white focus-within:border-black transition-all">
                                        <input type="file" name="image" accept="image/*"
                                            class="w-full font-semibold text-xs text-gray-600 cursor-pointer" required>
                                    </div>
                                </div>

                                <div class="flex gap-4 pt-4">
                                    <button type="button" onclick="toggleModal()"
                                        class="w-1/2 border border-gray-200 p-3 rounded-xl font-bold uppercase text-xs hover:bg-gray-50 hover:text-black transition-all">Cancel</button>
                                    <button type="submit"
                                        class="w-1/2 bg-black hover:bg-zinc-900 text-white p-3 rounded-xl font-bold uppercase text-xs transition-all shadow-md">Save Item</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div id="editModal"
                        class="fixed inset-0 bg-zinc-950/40 backdrop-blur-sm hidden z-[999] flex items-center justify-center p-4">
                        <div class="bg-white border border-gray-200 p-8 rounded-3xl w-full max-w-lg shadow-2xl max-h-[90vh] overflow-y-auto">
                            <div class="flex justify-between items-center mb-6">
                                <h2 class="text-3xl font-black uppercase italic tracking-tighter">Edit Product</h2>
                                <button type="button" onclick="closeEditModal()"
                                    class="text-gray-400 hover:text-black transition-colors">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2.5">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                </button>
                            </div>
                            <form action="${pageContext.request.contextPath}/EditProduct" method="POST"
                                enctype="multipart/form-data" class="space-y-4 text-left">
                                <input type="hidden" name="id" id="edit_id">
                                <input type="hidden" name="oldImage" id="edit_oldImage">
                                <div>
                                    <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Product Name</label>
                                    <input type="text" name="name" id="edit_name" placeholder="E.G. HEAD RACKET SPEED"
                                        class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-gray-50/50 focus:bg-white focus:border-black transition-all"
                                        required>
                                </div>

                                <div class="flex gap-4">
                                    <div class="w-1/2">
                                        <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Category</label>
                                        <select name="category" id="edit_category"
                                            class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-white focus:border-black transition-all">
                                            <option value="Racket">Racket</option>
                                            <option value="Balls">Balls</option>
                                            <option value="Grip">Grip</option>
                                            <option value="Bag">Bag</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </div>
                                    <div class="w-1/2">
                                        <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Type</label>
                                        <select name="type" id="edit_type"
                                            class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-white focus:border-black transition-all">
                                            <option value="Rent">Rent</option>
                                            <option value="Sale">Sale</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="flex gap-4">
                                    <div class="flex-1">
                                        <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Price (Rp)</label>
                                        <input type="number" name="price" id="edit_price" placeholder="E.G. 150000"
                                            class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-gray-50/50 focus:bg-white focus:border-black transition-all"
                                            required>
                                    </div>
                                    <div class="w-24">
                                        <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Stock</label>
                                        <input type="number" name="stock" id="edit_stock" placeholder="10"
                                            class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-gray-50/50 focus:bg-white focus:border-black transition-all"
                                            required>
                                    </div>
                                    <div class="w-24">
                                        <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Rating</label>
                                        <input type="number" name="rating" id="edit_rating" placeholder="4.5" min="1.0" max="5.0"
                                            step="0.1"
                                            class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-gray-50/50 focus:bg-white focus:border-black transition-all"
                                            required>
                                    </div>
                                </div>

                                <div>
                                    <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Description</label>
                                    <textarea name="description" id="edit_description" placeholder="WRITE DETAILED DESCRIPTION HERE..."
                                        class="w-full border border-gray-200 p-3 rounded-xl font-semibold outline-none bg-gray-50/50 focus:bg-white focus:border-black h-24 resize-none transition-all"
                                        required></textarea>
                                </div>

                                <div>
                                    <label class="text-[10px] font-bold uppercase tracking-wider text-gray-500 block mb-1.5">Product Image (Leave empty to keep current image)</label>
                                    <div class="mb-4 flex items-center gap-4">
                                        <div class="w-12 h-12 rounded-xl border border-gray-200 overflow-hidden bg-white shadow-sm">
                                            <img id="edit_img_preview" src="" alt="Current Product Image" class="w-full h-full object-cover">
                                        </div>
                                        <span id="edit_img_name" class="text-xs font-semibold text-gray-500 truncate max-w-[200px]">current_image.png</span>
                                    </div>
                                    <div class="border border-gray-200 p-3 rounded-xl flex items-center bg-gray-50/50 focus-within:bg-white focus-within:border-black transition-all">
                                        <input type="file" name="image" accept="image/*"
                                            class="w-full font-semibold text-xs text-gray-600 cursor-pointer">
                                    </div>
                                </div>

                                <div class="flex gap-4 pt-4">
                                    <button type="button" onclick="closeEditModal()"
                                        class="w-1/2 border border-gray-200 p-3 rounded-xl font-bold uppercase text-xs hover:bg-gray-50 hover:text-black transition-all">Cancel</button>
                                    <button type="submit"
                                        class="w-1/2 bg-black hover:bg-zinc-900 text-white p-3 rounded-xl font-bold uppercase text-xs transition-all shadow-md">Save Changes</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <script>
                        function toggleModal() {
                            const modal = document.getElementById('addModal');
                            modal.classList.toggle('hidden');
                        }

                        function openEditModal(button) {
                            const id = button.getAttribute('data-id');
                            const name = button.getAttribute('data-name');
                            const category = button.getAttribute('data-category');
                            const type = button.getAttribute('data-type');
                            const price = button.getAttribute('data-price');
                            const stock = button.getAttribute('data-stock');
                            const rating = button.getAttribute('data-rating');
                            const description = button.getAttribute('data-description');
                            const image = button.getAttribute('data-image');

                            document.getElementById('edit_id').value = id;
                            document.getElementById('edit_name').value = name;
                            document.getElementById('edit_category').value = category;
                            document.getElementById('edit_type').value = type;
                            document.getElementById('edit_price').value = price;
                            document.getElementById('edit_stock').value = stock;
                            document.getElementById('edit_rating').value = rating;
                            document.getElementById('edit_description').value = description;
                            document.getElementById('edit_oldImage').value = image;

                            // Image preview
                            const contextPath = "${pageContext.request.contextPath}";
                            document.getElementById('edit_img_preview').src = contextPath + "/assets/images/" + image;
                            document.getElementById('edit_img_name').innerText = image;

                            document.getElementById('editModal').classList.remove('hidden');
                        }

                        function closeEditModal() {
                            document.getElementById('editModal').classList.add('hidden');
                        }
                    </script>
                </body>

                </html>