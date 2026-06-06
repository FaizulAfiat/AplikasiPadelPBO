<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/view/Login.html");
        return;
    }
    String uname = (String) session.getAttribute("user");
    String initial = (uname != null && !uname.isEmpty()) ? uname.substring(0, 1).toUpperCase() : "?";
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PadelApp - Turnamen Club</title>
    <!-- Google Fonts: Inter & Outfit -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Outfit:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa;
        }
        .neobrutalist-card {
            border: 4px solid #000000;
            box-shadow: 6px 6px 0px 0px #000000;
        }
        .neobrutalist-button {
            border: 3px solid #000000;
            box-shadow: 4px 4px 0px 0px #000000;
            transition: all 0.15s ease-in-out;
        }
        .neobrutalist-button:hover {
            transform: translate(2px, 2px);
            box-shadow: 2px 2px 0px 0px #000000;
        }
        .neobrutalist-button:active {
            transform: translate(4px, 4px);
            box-shadow: 0px 0px 0px 0px #000000;
        }
    </style>
</head>
<body class="min-h-screen flex flex-col antialiased">
    <!-- Header -->
    <header class="flex border-b-4 border-black bg-white sticky top-0 z-50">
        <div class="p-4 md:p-6 border-r-4 border-black w-1/2 md:w-1/4">
            <span class="text-[10px] font-bold uppercase block opacity-50 md:text-xs">03 / News & Updates</span>
            <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">
                Padel<span class="text-blue-500">App</span>
            </h1>
        </div>
        <div class="flex-1 border-r-4 border-black hidden md:flex items-center px-8 bg-white">
            <a href="${pageContext.request.contextPath}/index.jsp" class="text-xs font-bold uppercase tracking-widest hover:underline flex items-center gap-1">
                ← Back to Dashboard
            </a>
        </div>
        <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4 md:gap-6 bg-white">
            <div class="flex items-center gap-2">
                <div class="w-8 h-8 rounded-full bg-black text-white flex items-center justify-center font-bold uppercase text-xs border-2 border-black">
                    <%= initial %>
                </div>
                <span class="hidden lg:inline text-[10px] font-bold uppercase tracking-widest text-zinc-600">
                    @<%= uname %>
                </span>
            </div>
        </div>
    </header>

    <!-- Main Content Area -->
    <main class="flex-1 max-w-7xl w-full mx-auto p-6 md:p-10 space-y-10">
        <!-- Toast Status Notifications -->
        <c:if test="${not empty param.status}">
            <c:choose>
                <c:when test="${param.status eq 'upgrade_success'}">
                    <div class="neobrutalist-card bg-emerald-400 p-5 rounded-2xl font-black uppercase flex items-center justify-between" id="status-toast">
                        <span>🎉 Akun Anda Berhasil Di-upgrade ke Premium! Selamat menikmati konten eksklusif.</span>
                        <button onclick="document.getElementById('status-toast').remove()" class="font-black text-xl">×</button>
                    </div>
                </c:when>
                <c:when test="${param.status eq 'registration_success'}">
                    <div class="neobrutalist-card bg-cyan-400 p-5 rounded-2xl font-black uppercase flex items-center justify-between" id="status-toast">
                        <span>🎾 Registrasi Turnamen Berhasil! Cek kuota peserta terbaru di bawah ini.</span>
                        <button onclick="document.getElementById('status-toast').remove()" class="font-black text-xl">×</button>
                    </div>
                </c:when>
                <c:when test="${param.status eq 'create_success'}">
                    <div class="neobrutalist-card bg-emerald-400 p-5 rounded-2xl font-black uppercase flex items-center justify-between" id="status-toast">
                        <span>🏆 Turnamen Baru Berhasil Ditambahkan dan Dipublikasikan!</span>
                        <button onclick="document.getElementById('status-toast').remove()" class="font-black text-xl">×</button>
                    </div>
                </c:when>
                <c:when test="${param.status eq 'already_registered'}">
                    <div class="neobrutalist-card bg-yellow-400 p-5 rounded-2xl font-black uppercase flex items-center justify-between" id="status-toast">
                        <span>⚠️ Anda sudah terdaftar di turnamen ini!</span>
                        <button onclick="document.getElementById('status-toast').remove()" class="font-black text-xl">×</button>
                    </div>
                </c:when>
                <c:when test="${param.status eq 'premium_only'}">
                    <div class="neobrutalist-card bg-rose-400 p-5 rounded-2xl font-black uppercase flex items-center justify-between" id="status-toast">
                        <span>🚫 Pendaftaran hanya tersedia untuk member Premium!</span>
                        <button onclick="document.getElementById('status-toast').remove()" class="font-black text-xl">×</button>
                    </div>
                </c:when>
            </c:choose>
        </c:if>

        <!-- Page Header & Tab Controls -->
        <div class="flex flex-col md:flex-row md:items-end justify-between border-b-4 border-black pb-6 gap-4">
            <div>
                <h2 class="text-5xl font-black uppercase italic tracking-tighter leading-none">Club Tournaments</h2>
                <p class="text-zinc-500 font-bold uppercase text-xs mt-2 tracking-widest flex items-center gap-2">
                    <span class="w-2 h-2 bg-amber-400 rounded-full animate-ping"></span>
                    Informasi & Registrasi kompetisi PadelApp eksklusif
                </p>
            </div>
            <div class="flex gap-4">
                <button onclick="switchTab('tournaments')" id="tab-btn-tournaments" class="neobrutalist-button bg-black text-white px-5 py-3 font-bold uppercase text-xs tracking-wider rounded-xl">
                    Daftar Turnamen
                </button>
                <c:if test="${role eq 'Admin'}">
                    <button onclick="switchTab('add-form')" id="tab-btn-add-form" class="neobrutalist-button bg-white text-black px-5 py-3 font-bold uppercase text-xs tracking-wider rounded-xl">
                        + Tambah Turnamen (Admin)
                    </button>
                </c:if>
            </div>
        </div>

        <!-- Tab 1: Tournament List -->
        <div id="tab-tournaments" class="space-y-10">
            <!-- Premium Upgrade Promotion Panel for Regular Users -->
            <c:if test="${role ne 'Premium' and role ne 'Admin'}">
                <div class="neobrutalist-card bg-amber-300 p-8 rounded-[2rem] flex flex-col md:flex-row items-center justify-between gap-6 relative overflow-hidden">
                    <div class="space-y-3 z-10">
                        <span class="inline-block px-3 py-1 bg-black text-amber-300 text-[10px] font-black uppercase tracking-widest rounded-full">PROMO UPGRADE PREMIUM</span>
                        <h3 class="text-3xl font-black uppercase tracking-tight leading-none">Buka Akses Informasi & Pendaftaran Turnamen!</h3>
                        <p class="text-sm font-semibold text-black max-w-2xl leading-relaxed">
                            Sebagai member reguler, konten berita turnamen sengaja dikunci. Upgrade ke member **Premium** hari ini untuk menikmati informasi lengkap, pendaftaran langsung, kuota prioritas, dan potongan harga rental.
                        </p>
                    </div>
                    <form action="${pageContext.request.contextPath}/UpgradePremiumController" method="POST" class="shrink-0 z-10">
                        <button type="submit" class="neobrutalist-button bg-black text-white px-8 py-4 font-black uppercase text-sm tracking-wider rounded-2xl hover:bg-zinc-800">
                            Upgrade Ke Premium →
                        </button>
                    </form>
                    <!-- Background decor elements -->
                    <div class="absolute -right-10 -bottom-10 w-48 h-48 bg-amber-400 rounded-full opacity-50 z-0"></div>
                </div>
            </c:if>

            <!-- News Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <c:choose>
                    <c:when test="${empty tournaments}">
                        <div class="col-span-full neobrutalist-card bg-white p-12 text-center text-zinc-400 font-bold uppercase italic rounded-[2rem]">
                            Belum ada turnamen yang dipublikasikan saat ini.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${tournaments}">
                            <div class="neobrutalist-card bg-white rounded-[2rem] overflow-hidden flex flex-col">
                                <!-- Tournament Image Header -->
                                <div class="h-48 border-b-4 border-black bg-zinc-100 overflow-hidden relative">
                                    <img src="${pageContext.request.contextPath}/${item.imageUrl}" 
                                         alt="${item.title}" 
                                         class="w-full h-full object-cover grayscale hover:grayscale-0 transition-all duration-300"
                                         onerror="this.src='${pageContext.request.contextPath}/img/default.png'">
                                    
                                    <!-- Date Badge -->
                                    <div class="absolute top-4 left-4 bg-black text-white px-3 py-1.5 border-2 border-white text-[10px] font-black uppercase tracking-wider rounded-lg shadow-sm">
                                        <fmt:formatDate value="${item.tournamentDate}" pattern="dd MMM yyyy" />
                                    </div>
                                    
                                    <!-- Status Badge -->
                                    <div class="absolute top-4 right-4 shadow-sm">
                                        <c:choose>
                                            <c:when test="${item.isUpcoming()}">
                                                <span class="bg-emerald-400 text-black border-2 border-black px-2.5 py-1 text-[9px] font-black uppercase tracking-widest rounded-full">
                                                    Upcoming
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="bg-zinc-300 text-zinc-700 border-2 border-zinc-600 px-2.5 py-1 text-[9px] font-black uppercase tracking-widest rounded-full">
                                                    Past
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Card Content -->
                                <div class="p-6 flex-1 flex flex-col justify-between">
                                    <div>
                                        <!-- Court & Slots Info -->
                                        <div class="flex items-center justify-between text-[10px] font-black uppercase tracking-widest text-zinc-400 mb-2">
                                            <span>🏟️ ${item.courtName}</span>
                                            <span>👥 ${item.currentParticipants} / ${item.maxParticipants} SLOT</span>
                                        </div>

                                        <h4 class="text-2xl font-black uppercase tracking-tight line-clamp-1 mb-3">${item.title}</h4>
                                        
                                        <!-- Blurred Text for Regular, Normal Text for Premium -->
                                        <c:choose>
                                            <c:when test="${role eq 'Premium' or role eq 'Admin'}">
                                                <p class="text-zinc-500 font-medium text-xs leading-relaxed line-clamp-3 mb-6">
                                                    ${item.content}
                                                </p>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="text-zinc-300 font-medium text-xs leading-relaxed line-clamp-3 mb-6 blur-sm select-none">
                                                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.
                                                </p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="pt-4 border-t-2 border-dashed border-zinc-200">
                                        <c:choose>
                                            <c:when test="${role eq 'Premium' or role eq 'Admin'}">
                                                <button onclick="openModal('${item.id}', '${item.title}', '${item.content}', '${item.courtName}', '${item.tournamentDate}', '${item.maxParticipants}', '${item.currentParticipants}', '${item.isUpcoming()}', ${registeredNewsIds.contains(item.id)})" 
                                                        class="w-full text-center neobrutalist-button bg-cyan-400 text-black py-3 rounded-xl font-black uppercase text-[10px] tracking-wider">
                                                    Detail & Registrasi
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/UpgradePremiumController" method="POST">
                                                    <button type="submit" class="w-full text-center neobrutalist-button bg-amber-400 text-black py-3 rounded-xl font-black uppercase text-[10px] tracking-wider">
                                                        Upgrade to Unlock
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Tab 2: Admin Add Form (Hidden by default) -->
        <c:if test="${role eq 'Admin'}">
            <div id="tab-add-form" class="hidden">
                <div class="neobrutalist-card bg-white p-8 md:p-12 rounded-[2.5rem] max-w-2xl mx-auto text-left">
                    <h3 class="text-3xl font-black uppercase tracking-tight italic mb-8 flex items-center gap-3">
                        <span class="w-3 h-3 bg-amber-400 rounded-full border-2 border-black"></span>
                        Publish New Tournament
                    </h3>
                    
                    <form action="${pageContext.request.contextPath}/AdminAddTournamentController" method="POST" class="space-y-6">
                        <div>
                            <label class="block text-[10px] font-black uppercase tracking-widest text-zinc-400 mb-2">Nama / Judul Turnamen</label>
                            <input type="text" name="title" required placeholder="Contoh: Padel Doubles Championship 2026" 
                                   class="w-full p-4 border-4 border-black rounded-xl font-bold placeholder:text-zinc-300 outline-none focus:bg-zinc-50 focus:translate-x-1 focus:translate-y-1 transition-all">
                        </div>

                        <div>
                            <label class="block text-[10px] font-black uppercase tracking-widest text-zinc-400 mb-2">Deskripsi Lengkap Berita</label>
                            <textarea name="content" rows="6" required placeholder="Masukkan seluruh informasi turnamen secara lengkap (jadwal detail, jersey, benefit, regulasi tim, hadiah total, dll.)" 
                                      class="w-full p-4 border-4 border-black rounded-xl font-bold placeholder:text-zinc-300 outline-none focus:bg-zinc-50 focus:translate-x-1 focus:translate-y-1 transition-all"></textarea>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-[10px] font-black uppercase tracking-widest text-zinc-400 mb-2">Tempat Lapangan (Court)</label>
                                <select name="court_id" required class="w-full p-4 border-4 border-black rounded-xl font-black bg-white outline-none">
                                    <c:forEach var="court" items="${courts}">
                                        <option value="${court.id}">${court.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label class="block text-[10px] font-black uppercase tracking-widest text-zinc-400 mb-2">Tanggal Pelaksanaan</label>
                                <input type="date" name="tournament_date" required 
                                       class="w-full p-4 border-4 border-black rounded-xl font-black outline-none">
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-[10px] font-black uppercase tracking-widest text-zinc-400 mb-2">Maksimum Peserta (Slot)</label>
                                <input type="number" name="max_participants" required min="2" max="128" value="16" 
                                       class="w-full p-4 border-4 border-black rounded-xl font-black outline-none">
                            </div>
                            <div>
                                <label class="block text-[10px] font-black uppercase tracking-widest text-zinc-400 mb-2">Path File Gambar Banner</label>
                                <input type="text" name="image_url" placeholder="img/padel.jpg" value="img/padel.jpg"
                                       class="w-full p-4 border-4 border-black rounded-xl font-bold outline-none">
                            </div>
                        </div>

                        <div class="pt-6">
                            <button type="submit" class="w-full neobrutalist-button bg-amber-400 text-black py-4 font-black uppercase text-xs tracking-wider rounded-2xl">
                                Publish Turnamen Sekarang →
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>
    </main>

    <!-- Detail & Registration Modal -->
    <div id="detail-modal" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-6 hidden">
        <div class="neobrutalist-card bg-white max-w-xl w-full rounded-[2.5rem] p-8 md:p-10 relative text-left">
            <button onclick="closeModal()" class="absolute top-6 right-6 font-black text-2xl hover:scale-110 transition-transform">×</button>
            
            <div class="space-y-6">
                <div>
                    <span id="modal-date-court" class="text-[10px] font-black uppercase tracking-widest text-zinc-400"></span>
                    <h3 id="modal-title" class="text-3xl font-black uppercase tracking-tight leading-none mt-2"></h3>
                </div>

                <div class="border-2 border-black p-4 rounded-xl bg-zinc-50 flex items-center justify-between text-xs font-black uppercase tracking-wider">
                    <span>👥 Total Pendaftar saat ini:</span>
                    <span id="modal-participants" class="bg-black text-white px-2 py-1 rounded-md"></span>
                </div>

                <div class="max-h-60 overflow-y-auto no-scrollbar">
                    <p id="modal-content" class="text-zinc-500 font-semibold text-xs leading-relaxed whitespace-pre-wrap"></p>
                </div>

                <div class="pt-4 border-t-4 border-black flex gap-4">
                    <button onclick="closeModal()" class="flex-1 neobrutalist-button bg-white text-black py-3.5 rounded-xl font-black uppercase text-xs tracking-wider">
                        Kembali
                    </button>
                    
                    <form id="modal-reg-form" action="${pageContext.request.contextPath}/TournamentRegistrationController" method="POST" class="flex-1">
                        <input type="hidden" name="news_id" id="modal-news-id">
                        <button type="submit" id="modal-reg-btn" class="w-full neobrutalist-button bg-cyan-400 text-black py-3.5 rounded-xl font-black uppercase text-xs tracking-wider">
                            Daftar Turnamen
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script>
        function switchTab(tabName) {
            const listTab = document.getElementById('tab-tournaments');
            const formTab = document.getElementById('tab-add-form');
            const listBtn = document.getElementById('tab-btn-tournaments');
            const formBtn = document.getElementById('tab-btn-add-form');

            if (tabName === 'tournaments') {
                listTab.classList.remove('hidden');
                if (formTab) formTab.classList.add('hidden');
                listBtn.classList.add('bg-black', 'text-white');
                listBtn.classList.remove('bg-white', 'text-black');
                if (formBtn) {
                    formBtn.classList.remove('bg-black', 'text-white');
                    formBtn.classList.add('bg-white', 'text-black');
                }
            } else {
                listTab.classList.add('hidden');
                if (formTab) formTab.classList.remove('hidden');
                listBtn.classList.remove('bg-black', 'text-white');
                listBtn.classList.add('bg-white', 'text-black');
                if (formBtn) {
                    formBtn.classList.add('bg-black', 'text-white');
                    formBtn.classList.remove('bg-white', 'text-black');
                }
            }
        }

        // Modal Functionality
        const modal = document.getElementById('detail-modal');
        const modalNewsId = document.getElementById('modal-news-id');
        const modalTitle = document.getElementById('modal-title');
        const modalContent = document.getElementById('modal-content');
        const modalDateCourt = document.getElementById('modal-date-court');
        const modalParticipants = document.getElementById('modal-participants');
        const modalRegBtn = document.getElementById('modal-reg-btn');

        function openModal(id, title, content, courtName, dateStr, maxVal, currentVal, isUpcoming, isAlreadyRegistered) {
            modalNewsId.value = id;
            modalTitle.innerText = title;
            modalContent.innerText = content;
            modalDateCourt.innerText = "🏟️ " + courtName + " | 📅 " + dateStr;
            modalParticipants.innerText = currentVal + " / " + maxVal + " SLOT";

            // Check pendaftaran status
            if (isAlreadyRegistered) {
                modalRegBtn.innerText = "✓ Sudah Terdaftar";
                modalRegBtn.disabled = true;
                modalRegBtn.classList.remove('bg-cyan-400');
                modalRegBtn.classList.add('bg-emerald-400', 'cursor-not-allowed', 'pointer-events-none');
            } else if (isUpcoming === "false") {
                modalRegBtn.innerText = "Selesai (Past)";
                modalRegBtn.disabled = true;
                modalRegBtn.classList.remove('bg-cyan-400');
                modalRegBtn.classList.add('bg-zinc-300', 'text-zinc-500', 'cursor-not-allowed', 'pointer-events-none');
            } else if (parseInt(currentVal) >= parseInt(maxVal)) {
                modalRegBtn.innerText = "Penuh (Full)";
                modalRegBtn.disabled = true;
                modalRegBtn.classList.remove('bg-cyan-400');
                modalRegBtn.classList.add('bg-rose-400', 'cursor-not-allowed', 'pointer-events-none');
            } else {
                modalRegBtn.innerText = "Daftar Turnamen";
                modalRegBtn.disabled = false;
                modalRegBtn.classList.add('bg-cyan-400');
                modalRegBtn.classList.remove('bg-emerald-400', 'bg-zinc-300', 'text-zinc-500', 'bg-rose-400', 'cursor-not-allowed', 'pointer-events-none');
            }

            modal.classList.remove('hidden');
        }

        function closeModal() {
            modal.classList.add('hidden');
        }

        // Close on clicking outside modal content
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                closeModal();
            }
        });

        // Close on pressing ESC
        document.addEventListener('keydown', (e) => {
            if (e.key === "Escape") {
                closeModal();
            }
        });
    </script>
</body>
</html>
