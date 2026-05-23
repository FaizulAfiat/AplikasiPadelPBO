<%-- Document : admin_products Created on : 11 May 2026, 14.09.30 Author : Faizul Afiat --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
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
                            <a href="AdminController"
                                class="block font-black text-xs uppercase tracking-widest opacity-40 hover:opacity-100 transition-all">Dashboard</a>
                            <a href="ManageProducts"
                                class="block font-black text-xs uppercase tracking-widest border-l-4 border-cyan-400 pl-4">Manage
                                Shop</a>
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

                    <div class="ml-72 p-12 w-full">
                        <header class="mb-12 flex justify-between items-end">
                            <div>
                                <h1 class="text-5xl font-black uppercase italic tracking-tighter">Shop Inventory</h1>
                                <p class="text-gray-400 font-bold uppercase text-[10px] mt-2 tracking-widest">Manage
                                    racquets, balls, and gear</p>
                            </div>
                            <button onclick="toggleModal()"
                                class="bg-cyan-400 border-4 border-black px-8 py-3 font-black uppercase italic shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-1 hover:translate-y-1 transition-all">
                                + Add New Product
                            </button>
                        </header>

                        <c:if test="${not empty param.success}">
                            <div
                                class="mb-8 border-4 border-black p-5 rounded-2xl bg-emerald-400 font-black uppercase italic shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="3" class="shrink-0">
                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                    </svg>
                                    <span>
                                        <c:choose>
                                            <c:when test="${param.success eq 'delete'}">Produk berhasil dihapus dari
                                                inventaris!</c:when>
                                            <c:when test="${param.success eq 'edit'}">Produk berhasil diperbarui!</c:when>
                                            <c:otherwise>Produk baru berhasil ditambahkan!</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <button onclick="this.parentElement.remove()"
                                    class="hover:opacity-70 transition-opacity">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="3">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                </button>
                            </div>
                        </c:if>

                        <c:if test="${not empty param.error}">
                            <div
                                class="mb-8 border-4 border-black p-5 rounded-2xl bg-rose-400 font-black uppercase italic shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="3" class="shrink-0">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <line x1="12" y1="8" x2="12" y2="12"></line>
                                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                    </svg>
                                    <span>
                                        <c:choose>
                                            <c:when test="${param.error eq 'delete'}">Gagal menghapus produk! Item ini
                                                mungkin masih terkait dengan transaksi aktif.</c:when>
                                            <c:when test="${param.error eq 'edit'}">Gagal memperbarui data produk!</c:when>
                                            <c:when test="${param.error eq 'notfound'}">Hapus gagal: Produk tidak
                                                ditemukan!</c:when>
                                            <c:when test="${param.error eq 'invalidid' or param.error eq 'missingid'}">
                                                Hapus gagal: ID Produk tidak valid!</c:when>
                                            <c:otherwise>Terjadi kesalahan pada sistem saat memproses produk!
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <button onclick="this.parentElement.remove()"
                                    class="hover:opacity-70 transition-opacity">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="3">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                </button>
                            </div>
                        </c:if>

                        <div
                            class="bg-white border border-gray-200 rounded-[2.5rem] p-8 shadow-sm overflow-hidden">
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
                                                        <div
                                                            class="w-12 h-12 rounded-xl border border-gray-200 shadow-sm overflow-hidden bg-white">
                                                            <img src="${pageContext.request.contextPath}/assets/images/${p.image}"
                                                                alt="${p.name}"
                                                                class="w-full h-full object-cover grayscale hover:grayscale-0 transition-all duration-300">
                                                        </div>
                                                        <span
                                                            class="uppercase font-semibold text-gray-900 tracking-tight text-sm">${p.name}</span>
                                                    </div>
                                                </td>
                                                <td class="py-4 px-4"><span
                                                        class="bg-gray-50 text-gray-600 border border-gray-200 px-2.5 py-1 rounded-full text-[10px] uppercase font-bold tracking-wider">${p.category}</span>
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
                                                            class="p-2 border border-gray-200 rounded-lg hover:bg-yellow-100 text-yellow-800 transition-colors">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                                viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                                stroke-width="2.5">
                                                                <path
                                                                    d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7">
                                                                </path>
                                                                <path
                                                                    d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z">
                                                                </path>
                                                            </svg>
                                                        </button>
                                                        <a href="${pageContext.request.contextPath}/DeleteProduct?id=${p.id}"
                                                            onclick="return confirm('Hapus produk ini?')"
                                                            class="p-2 border border-gray-200 rounded-lg hover:bg-red-100 text-red-800 transition-colors">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                                viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                                stroke-width="2.5">
                                                                <polyline points="3 6 5 6 21 6"></polyline>
                                                                <path
                                                                    d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2">
                                                                </path>
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
                    </div>

                    <div id="addModal"
                        class="fixed inset-0 bg-black/50 backdrop-blur-sm hidden z-[999] flex items-center justify-center p-4">
                        <div
                            class="bg-white border-4 border-black p-8 rounded-[2.5rem] w-full max-w-lg shadow-[15px_15px_0px_0px_rgba(0,0,0,1)] max-h-[90vh] overflow-y-auto">
                            <div class="flex justify-between items-center mb-6">
                                <h2 class="text-3xl font-black uppercase italic tracking-tighter">New Product</h2>
                                <button type="button" onclick="toggleModal()"
                                    class="hover:text-cyan-400 transition-colors">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="3">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                </button>
                            </div>
                            <form action="${pageContext.request.contextPath}/AddProduct" method="POST"
                                enctype="multipart/form-data" class="space-y-4 text-left">
                                <div>
                                    <label
                                        class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Product
                                        Name</label>
                                    <input type="text" name="name" placeholder="E.G. HEAD RACKET SPEED"
                                        class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:bg-cyan-50 focus:border-cyan-400"
                                        required>
                                </div>

                                <div class="flex gap-4">
                                    <div class="w-1/2">
                                        <label
                                            class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Category</label>
                                        <select name="category"
                                            class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:border-cyan-400">
                                            <option value="Racket">Racket</option>
                                            <option value="Balls">Balls</option>
                                            <option value="Grip">Grip</option>
                                            <option value="Bag">Bag</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </div>
                                    <div class="w-1/2">
                                        <label
                                            class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Type</label>
                                        <select name="type"
                                            class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:border-cyan-400">
                                            <option value="Rent">Rent</option>
                                            <option value="Sale">Sale</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="flex gap-4">
                                    <div class="flex-1">
                                        <label
                                            class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Price
                                            (Rp)</label>
                                        <input type="number" name="price" placeholder="E.G. 150000"
                                            class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:bg-cyan-50 focus:border-cyan-400"
                                            required>
                                    </div>
                                    <div class="w-24">
                                        <label
                                            class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Stock</label>
                                        <input type="number" name="stock" placeholder="10"
                                            class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:bg-cyan-50 focus:border-cyan-400"
                                            required>
                                    </div>
                                    <div class="w-24">
                                        <label
                                            class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Rating</label>
                                        <input type="number" name="rating" placeholder="4.5" min="1.0" max="5.0"
                                            step="0.1" value="4.5"
                                            class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:bg-cyan-50 focus:border-cyan-400"
                                            required>
                                    </div>
                                </div>

                                <div>
                                    <label
                                        class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Description</label>
                                    <textarea name="description" placeholder="WRITE DETAILED DESCRIPTION HERE..."
                                        class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:bg-cyan-50 focus:border-cyan-400 h-24 resize-none"
                                        required></textarea>
                                </div>

                                <div>
                                    <label
                                        class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Product
                                        Image</label>
                                    <div
                                        class="border-2 border-black p-3 rounded-xl flex items-center bg-gray-50 focus-within:bg-cyan-50">
                                        <input type="file" name="image" accept="image/*"
                                            class="w-full font-bold text-xs" required>
                                    </div>
                                </div>

                                <div class="flex gap-4 pt-4">
                                    <button type="button" onclick="toggleModal()"
                                        class="w-1/2 border-2 border-black p-3 rounded-xl font-black uppercase text-xs hover:bg-gray-100 transition-colors">Cancel</button>
                                    <button type="submit"
                                        class="w-1/2 bg-black text-white p-3 rounded-xl font-black uppercase text-xs hover:bg-cyan-400 hover:text-black transition-all">Save
                                        Item</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div id="editModal"
                        class="fixed inset-0 bg-black/50 backdrop-blur-sm hidden z-[999] flex items-center justify-center p-4">
                        <div
                            class="bg-white border-4 border-black p-8 rounded-[2.5rem] w-full max-w-lg shadow-[15px_15px_0px_0px_rgba(0,0,0,1)] max-h-[90vh] overflow-y-auto">
                            <div class="flex justify-between items-center mb-6">
                                <h2 class="text-3xl font-black uppercase italic tracking-tighter">Edit Product</h2>
                                <button type="button" onclick="closeEditModal()"
                                    class="hover:text-cyan-400 transition-colors">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="3">
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
                                    <label
                                        class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Product
                                        Name</label>
                                    <input type="text" name="name" id="edit_name" placeholder="E.G. HEAD RACKET SPEED"
                                        class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:bg-cyan-50 focus:border-cyan-400"
                                        required>
                                </div>

                                <div class="flex gap-4">
                                    <div class="w-1/2">
                                        <label
                                            class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Category</label>
                                        <select name="category" id="edit_category"
                                            class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:border-cyan-400">
                                            <option value="Racket">Racket</option>
                                            <option value="Balls">Balls</option>
                                            <option value="Grip">Grip</option>
                                            <option value="Bag">Bag</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </div>
                                    <div class="w-1/2">
                                        <label
                                            class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Type</label>
                                        <select name="type" id="edit_type"
                                            class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:border-cyan-400">
                                            <option value="Rent">Rent</option>
                                            <option value="Sale">Sale</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="flex gap-4">
                                    <div class="flex-1">
                                        <label
                                            class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Price
                                            (Rp)</label>
                                        <input type="number" name="price" id="edit_price" placeholder="E.G. 150000"
                                            class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:bg-cyan-50 focus:border-cyan-400"
                                            required>
                                    </div>
                                    <div class="w-24">
                                        <label
                                            class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Stock</label>
                                        <input type="number" name="stock" id="edit_stock" placeholder="10"
                                            class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:bg-cyan-50 focus:border-cyan-400"
                                            required>
                                    </div>
                                    <div class="w-24">
                                        <label
                                            class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Rating</label>
                                        <input type="number" name="rating" id="edit_rating" placeholder="4.5" min="1.0" max="5.0"
                                            step="0.1"
                                            class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:bg-cyan-50 focus:border-cyan-400"
                                            required>
                                    </div>
                                </div>

                                <div>
                                    <label
                                        class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Description</label>
                                    <textarea name="description" id="edit_description" placeholder="WRITE DETAILED DESCRIPTION HERE..."
                                        class="w-full border-2 border-black p-3 rounded-xl font-bold outline-none focus:bg-cyan-50 focus:border-cyan-400 h-24 resize-none"
                                        required></textarea>
                                </div>

                                <div>
                                    <label
                                        class="text-[10px] font-black uppercase tracking-wider opacity-60 block mb-1">Product
                                        Image (Leave empty to keep current image)</label>
                                    <div class="mb-2 flex items-center gap-4">
                                        <div class="w-12 h-12 rounded-lg border-2 border-black overflow-hidden bg-white shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]">
                                            <img id="edit_img_preview" src="" alt="Current Product Image" class="w-full h-full object-cover">
                                        </div>
                                        <span id="edit_img_name" class="text-xs font-bold text-gray-500 truncate max-w-[200px]">current_image.png</span>
                                    </div>
                                    <div
                                        class="border-2 border-black p-3 rounded-xl flex items-center bg-gray-50 focus-within:bg-cyan-50">
                                        <input type="file" name="image" accept="image/*"
                                            class="w-full font-bold text-xs">
                                    </div>
                                </div>

                                <div class="flex gap-4 pt-4">
                                    <button type="button" onclick="closeEditModal()"
                                        class="w-1/2 border-2 border-black p-3 rounded-xl font-black uppercase text-xs hover:bg-gray-100 transition-colors">Cancel</button>
                                    <button type="submit"
                                        class="w-1/2 bg-black text-white p-3 rounded-xl font-black uppercase text-xs hover:bg-cyan-400 hover:text-black transition-all">Save
                                        Changes</button>
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