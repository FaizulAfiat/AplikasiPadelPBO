<%-- Document : booking Created on : 4 May 2026, 11.07.07 Author : Faizul Afiat --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <% if (session.getAttribute("user")==null) { response.sendRedirect("Login.html"); } %>
            <!DOCTYPE html>
            <html lang="id">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Book a Field - PadelApp</title>
                <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">
                <script src="https://cdn.tailwindcss.com"></script>
                <style>
                    .border-grid {
                        border-color: #e5e5e5;
                    }

                    /* Hide scrollbar for Chrome, Safari and Opera */
                    .no-scrollbar::-webkit-scrollbar {
                        display: none;
                    }
                    /* Hide scrollbar for IE, Edge and Firefox */
                    .no-scrollbar {
                        -ms-overflow-style: none;  /* IE and Edge */
                        scrollbar-width: none;  /* Firefox */
                    }

                    /* Custom scrollbar for premium calendar list */
                    #time-grid::-webkit-scrollbar {
                        width: 6px;
                    }

                    #time-grid::-webkit-scrollbar-track {
                        background: transparent;
                    }

                    #time-grid::-webkit-scrollbar-thumb {
                        background: #cbd5e1;
                        border-radius: 3px;
                    }

                    #time-grid::-webkit-scrollbar-thumb:hover {
                        background: #94a3b8;
                    }

                    /* In Range State */
                    .slot-in-range {
                        background-color: #ecfeff !important;
                        border-color: #06b6d4 !important;
                        border-style: dashed !important;
                        color: #0891b2 !important;
                        transform: scale(0.995);
                    }

                    .slot-in-range .slot-time-text {
                        color: #0891b2 !important;
                    }

                    /* Start State */
                    .slot-start {
                        background-color: #000000 !important;
                        color: #ffffff !important;
                        border-color: #000000 !important;
                        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
                    }

                    .slot-start .slot-time-text {
                        color: #ffffff !important;
                    }

                    /* End State */
                    .slot-end {
                        background-color: #000000 !important;
                        color: #ffffff !important;
                        border-color: #000000 !important;
                        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
                    }

                    .slot-end .slot-time-text {
                        color: #ffffff !important;
                    }
                </style>
            </head>

            <body class="bg-white text-black min-h-screen md:h-screen md:overflow-hidden flex flex-col">
                <%@ taglib prefix="c" uri="jakarta.tags.core" %>
                    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

                        <header class="flex border-b border-grid bg-white sticky top-0 z-50">
                            <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
                                <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">Padel<span
                                        class="text-blue-400">App</span></h1>
                            </div>
                            <div class="flex-1 border-r border-grid hidden md:flex items-center px-8">
                                <a href="${pageContext.request.contextPath}/index.jsp"
                                    class="text-xs font-bold uppercase tracking-widest hover:underline">← Back to
                                    Dashboard</a>
                            </div>
                            <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4">
                                <span class="text-[10px] font-bold uppercase tracking-widest">
                                    <%= session.getAttribute("user")%>
                                </span>
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2"
                                    stroke="currentColor" class="w-5 h-5">
                                    <path stroke-linecap="round" stroke-linejoin="round"
                                        d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                                </svg>
                            </div>
                        </header>

                        <main class="flex flex-col md:flex-row flex-1 md:overflow-hidden">
                            <div
                                class="w-full md:w-1/3 p-8 md:p-12 border-b md:border-b-0 md:border-r border-grid bg-white md:overflow-y-auto no-scrollbar">
                                <span class="text-xs font-bold uppercase block mb-4 opacity-50">03 / Reservation</span>
                                <h2
                                    class="text-5xl md:text-7xl font-black leading-none uppercase mb-8 tracking-tighter">
                                    Reserve Your Court
                                </h2>
                                <p class="text-gray-500 uppercase font-bold text-xs leading-relaxed italic">
                                    Klik sekali untuk waktu mulai, klik lagi untuk waktu selesai.
                                </p>
                            </div>

                            <div class="flex-1 p-8 md:p-12 bg-white md:overflow-y-auto">
                                <c:if test="${not empty param.status && param.status != 'success'}">
                                    <div id="error-toast"
                                        class="mb-8 border-4 border-black p-5 rounded-2xl bg-rose-400 font-black uppercase italic shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between">
                                        <div class="flex items-center gap-3">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"
                                                class="shrink-0">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                            </svg>
                                            <span>
                                                <c:choose>
                                                    <c:when test="${param.status eq 'already_booked'}">Jadwal lapangan
                                                        sudah dipesan oleh orang lain!</c:when>
                                                    <c:when test="${param.status eq 'past_time'}">Gagal: Anda tidak
                                                        dapat memesan jadwal di masa lalu!</c:when>
                                                    <c:when test="${param.status eq 'invalid_date'}">Gagal: Tanggal
                                                        pemesanan tidak valid!</c:when>
                                                    <c:when test="${param.status eq 'invalid_time'}">Gagal: Waktu
                                                        pemesanan tidak valid!</c:when>
                                                    <c:otherwise>Terjadi kesalahan sistem saat memproses pemesanan!
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <button onclick="document.getElementById('error-toast').remove()"
                                            class="hover:opacity-70 transition-opacity">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                                <line x1="6" y1="6" x2="18" y2="18"></line>
                                            </svg>
                                        </button>
                                    </div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/BookingController" method="POST"
                                    class="w-full max-w-6xl space-y-12" id="bookingForm">
                                    <input type="hidden" name="start_time" id="start_time_input">
                                    <input type="hidden" name="end_time" id="end_time_input">
                                    <input type="hidden" name="total_price" id="input-price" value="0">

                                    <div class="border-b-2 border-black pb-2">
                                        <label class="text-xs font-bold uppercase opacity-50 block mb-2">Select
                                            Date</label>
                                        <c:set var="today" value="<%= java.time.LocalDate.now()%>" />
                                        <input type="date" name="match_date" id="match_date"
                                            value="${date != null ? date : today}" min="${today}"
                                            class="w-full bg-transparent text-2xl font-black outline-none" required
                                            onchange="updateSelection()">
                                    </div>

                                    <div class="border-b-2 border-black pb-6">
                                        <label class="text-xs font-bold uppercase opacity-50 block mb-4">Select
                                            Court</label>
                                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                                            <c:forEach var="court" items="${listLapangan}">
                                                <!-- Card Court -->
                                                <label class="relative block cursor-pointer group">
                                                    <input type="radio" name="court_id" value="${court.courtId}"
                                                        class="sr-only peer" ${courtId==court.courtId || (courtId==null
                                                        && court.courtId==1) ? 'checked' : '' }
                                                        onchange="updateSelection()">

                                                    <div
                                                        class="border-2 border-gray-200 rounded-2xl overflow-hidden bg-white transition-all duration-500 transform group-hover:-translate-y-1.5 group-hover:shadow-xl peer-checked:border-black peer-checked:ring-2 peer-checked:ring-black">
                                                        <!-- Image Container with soft zoom animation on hover -->
                                                        <div class="relative overflow-hidden h-44">
                                                            <img src="${pageContext.request.contextPath}/img/${court.courtId % 2 == 0 ? 'court_b.png' : 'court_a.png'}"
                                                                alt="${court.name}"
                                                                class="w-full h-full object-cover transition-transform duration-700 ease-out group-hover:scale-110">
                                                            <div
                                                                class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent">
                                                            </div>
                                                            <span
                                                                class="absolute bottom-3 left-4 text-white font-black text-xl uppercase tracking-wider">${court.name}</span>
                                                        </div>
                                                        <!-- Details -->
                                                        <div class="p-4">
                                                            <div class="flex justify-between items-center mb-2">
                                                                <span
                                                                    class="text-[10px] font-black px-2.5 py-1 ${court.courtId % 2 == 0 ? 'bg-green-100 text-green-800' : 'bg-blue-100 text-blue-800'} rounded-full uppercase tracking-wider">
                                                                    ${court.courtId % 2 == 0 ? 'Outdoor Court' : 'Indoor
                                                                    Court'}
                                                                </span>
                                                                <span class="text-xs font-extrabold text-gray-500">
                                                                    <fmt:formatNumber value="${court.pricePerHour}"
                                                                        type="currency" currencySymbol="Rp "
                                                                        maxFractionDigits="0" /> / hr
                                                                </span>
                                                            </div>
                                                            <p
                                                                class="text-[11px] text-gray-500 font-bold uppercase tracking-tight">
                                                                ${court.courtId % 2 == 0 ? 'Panoramic Sunset • Scenic
                                                                View • Premium Turf' : 'Pro Blue Turf • Glass Walls •
                                                                LED Spotlights'}
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <!-- Check badge -->
                                                    <div
                                                        class="absolute top-3 right-3 bg-black text-white p-1.5 rounded-full opacity-0 scale-75 transition-all duration-300 peer-checked:opacity-100 peer-checked:scale-100 z-10">
                                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none"
                                                            viewBox="0 0 24 24" stroke-width="3" stroke="currentColor"
                                                            class="w-4 h-4">
                                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                                d="m4.5 12.75 6 6 9-13.5" />
                                                        </svg>
                                                    </div>
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <div class="col-span-full">
                                        <label class="text-xs font-bold uppercase opacity-50 block mb-4">Select
                                            Schedule (Daily Timeline)</label>
                                        <div class="max-h-[550px] overflow-y-auto border border-gray-200 rounded-2xl p-4 bg-gray-50/50 shadow-inner space-y-3"
                                            id="time-grid">
                                            <c:forEach var="s" items="${timeSlots}">
                                                <div class="flex items-center gap-4 group">
                                                    <!-- Left: Time Indicator -->
                                                    <div class="w-20 text-right flex-shrink-0">
                                                        <span
                                                            class="text-sm font-black text-gray-800 tracking-tight block">${s.time}</span>
                                                        <span
                                                            class="text-[10px] font-semibold text-gray-400 block">${s.time.plusHours(1)}</span>
                                                    </div>

                                                    <!-- Middle line node -->
                                                    <div class="relative self-stretch flex flex-col items-center">
                                                        <div
                                                            class="w-3 h-3 rounded-full border-2 border-gray-300 bg-white group-hover:border-black transition-colors duration-300 z-10">
                                                        </div>
                                                        <div
                                                            class="w-[2px] flex-1 bg-gray-200 group-last:bg-transparent">
                                                        </div>
                                                    </div>

                                                    <!-- Right: Interactive Block -->
                                                    <c:choose>
                                                        <c:when test="${s.isAvailable}">
                                                            <button type="button" data-time="${s.time}"
                                                                onclick="handleSelection(this)"
                                                                class="time-slot flex-1 flex items-center justify-between p-4 border-2 border-gray-200 rounded-xl bg-white text-left transition-all duration-300 hover:border-black hover:shadow-md hover:-translate-y-0.5">
                                                                <div class="flex flex-col">
                                                                    <span
                                                                        class="text-sm font-bold text-gray-800 slot-time-text">${s.time}
                                                                        - ${s.time.plusHours(1)}</span>
                                                                    <span
                                                                        class="text-[10px] text-gray-400 font-medium uppercase tracking-wider slot-status-hint">Klik
                                                                        untuk memilih</span>
                                                                </div>
                                                                <span
                                                                    class="text-[10px] font-black px-2.5 py-1 bg-green-50 text-green-600 rounded-full border border-green-200 uppercase tracking-wider slot-badge">
                                                                    Tersedia
                                                                </span>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="button" disabled data-time="${s.time}"
                                                                class="flex-1 flex items-center justify-between p-4 border border-red-100 bg-red-50/50 rounded-xl text-left cursor-not-allowed">
                                                                <div class="flex flex-col opacity-60">
                                                                    <span
                                                                        class="text-sm font-bold text-gray-500 line-through slot-time-text">${s.time}
                                                                        - ${s.time.plusHours(1)}</span>
                                                                    <span
                                                                        class="text-[10px] text-red-500 font-semibold uppercase tracking-wider">Sudah
                                                                        Dipesan (Reservasi Aktif)</span>
                                                                </div>
                                                                <span
                                                                    class="text-[10px] font-black px-2.5 py-1 bg-red-100/80 text-red-600 rounded-full uppercase tracking-wider flex items-center gap-1">
                                                                    <svg xmlns="http://www.w3.org/2000/svg"
                                                                        viewBox="0 0 16 16" fill="currentColor"
                                                                        class="w-3.5 h-3.5">
                                                                        <path fill-rule="evenodd"
                                                                            d="M8 1a3.5 3.5 0 0 0-3.5 3.5V7A1.5 1.5 0 0 0 3 8.5v5A1.5 1.5 0 0 0 4.5 15h7a1.5 1.5 0 0 0 1.5-1.5v-5A1.5 1.5 0 0 0 12.5 7V4.5A3.5 3.5 0 0 0 8 1Zm2.5 6V4.5a2.5 2.5 0 1 0-5 0V7h5Z"
                                                                            clip-rule="evenodd" />
                                                                    </svg>
                                                                    Booked
                                                                </span>
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <div class="pt-8 flex flex-col md:flex-row items-center gap-8">
                                        <button type="submit"
                                            class="w-full md:w-auto bg-black text-white px-12 py-5 font-black uppercase tracking-widest text-lg hover:bg-cyan-400 hover:text-black transition-all shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
                                            Confirm Booking →
                                        </button>

                                        <div class="flex flex-col">
                                            <span class="text-xs font-bold uppercase opacity-50">Estimated Price</span>
                                            <span id="display-price"
                                                class="text-3xl font-black uppercase tracking-tighter">Rp 0</span>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </main>

                        <script>
                            function updateSelection() {
                                const dateVal = document.getElementById('match_date').value;
                                const courtRadio = document.querySelector('input[name="court_id"]:checked');
                                const courtVal = courtRadio ? courtRadio.value : '1';
                                window.location.href = '${pageContext.request.contextPath}/BookingController?date=' + dateVal + '&court_id=' + courtVal;
                            }

                            let firstClick = null;
                            let secondClick = null;
                            const pricePerHour = ${ pricePerHour != null ? pricePerHour : 250000};

                            function updateSlotUI(slot, state) {
                                const hint = slot.querySelector('.slot-status-hint');
                                const badge = slot.querySelector('.slot-badge');
                                if (!hint || !badge) return;

                                if (state === 'default') {
                                    hint.innerText = "Klik untuk memilih";
                                    hint.className = "text-[10px] text-gray-400 font-medium uppercase tracking-wider slot-status-hint";
                                    badge.innerText = "Tersedia";
                                    badge.className = "text-[10px] font-black px-2.5 py-1 bg-green-50 text-green-600 rounded-full border border-green-200 uppercase tracking-wider slot-badge";
                                } else if (state === 'start') {
                                    hint.innerText = "Waktu Mulai Terpilih";
                                    hint.className = "text-[10px] text-cyan-300 font-bold uppercase tracking-wider slot-status-hint";
                                    badge.innerText = "Mulai";
                                    badge.className = "text-[10px] font-black px-2.5 py-1 bg-cyan-950 text-cyan-400 rounded-full border border-cyan-800 uppercase tracking-wider slot-badge";
                                } else if (state === 'end') {
                                    hint.innerText = "Waktu Selesai Terpilih";
                                    hint.className = "text-[10px] text-cyan-300 font-bold uppercase tracking-wider slot-status-hint";
                                    badge.innerText = "Selesai";
                                    badge.className = "text-[10px] font-black px-2.5 py-1 bg-cyan-950 text-cyan-400 rounded-full border border-cyan-800 uppercase tracking-wider slot-badge";
                                } else if (state === 'in-range') {
                                    hint.innerText = "Sesi Terpilih";
                                    hint.className = "text-[10px] text-cyan-600 font-bold uppercase tracking-wider slot-status-hint";
                                    badge.innerText = "Terpilih";
                                    badge.className = "text-[10px] font-black px-2.5 py-1 bg-cyan-100 text-cyan-800 rounded-full border border-cyan-300 uppercase tracking-wider slot-badge";
                                }
                            }

                            function handleSelection(element) {
                                const time = element.getAttribute('data-time');
                                const allSlots = document.querySelectorAll('.time-slot');

                                if (!firstClick || (firstClick && secondClick)) {
                                    // RESET & SET START
                                    resetSelection(allSlots);
                                    firstClick = time;
                                    secondClick = null;
                                    element.classList.add('slot-start');
                                    updateSlotUI(element, 'start');
                                    updateDisplay(0);
                                } else {
                                    // SET END
                                    if (time <= firstClick) {
                                        alert("Waktu selesai harus setelah waktu mulai!");
                                        return;
                                    }

                                    // Cek apakah di tengah ada jam yang sudah terisi (disabled)
                                    if (isRangeBlocked(firstClick, time)) {
                                        alert("Maaf, ada jam yang sudah dipesan di antara pilihanmu!");
                                        resetSelection(allSlots);
                                        return;
                                    }

                                    secondClick = time;
                                    element.classList.add('slot-end');
                                    updateSlotUI(element, 'end');
                                    highlightRange(allSlots);
                                    updateLogic();
                                }
                            }

                            function isRangeBlocked(start, end) {
                                let blocked = false;
                                const allButtons = document.querySelectorAll('#time-grid button');
                                allButtons.forEach(btn => {
                                    const btnTime = btn.getAttribute('data-time');
                                    if (btnTime > start && btnTime < end && btn.disabled) {
                                        blocked = true;
                                    }
                                });
                                return blocked;
                            }

                            function highlightRange(slots) {
                                slots.forEach(slot => {
                                    const slotTime = slot.getAttribute('data-time');
                                    if (slotTime > firstClick && slotTime < secondClick) {
                                        slot.classList.add('slot-in-range');
                                        updateSlotUI(slot, 'in-range');
                                    }
                                });
                            }

                            function resetSelection(slots) {
                                slots.forEach(slot => {
                                    slot.classList.remove('slot-start', 'slot-end', 'slot-in-range');
                                    updateSlotUI(slot, 'default');
                                });
                                firstClick = null;
                                secondClick = null;
                                updateDisplay(0);
                            }

                            function updateLogic() {
                                document.getElementById('start_time_input').value = firstClick;
                                document.getElementById('end_time_input').value = secondClick;

                                let startH = parseInt(firstClick.split(':')[0]);
                                let endH = parseInt(secondClick.split(':')[0]);
                                let diff = endH - startH;

                                let totalPrice = diff * pricePerHour;
                                updateDisplay(totalPrice);
                            }

                            // Validasi Form sebelum kirim
                            document.getElementById('bookingForm').onsubmit = function (e) {
                                if (!firstClick || !secondClick) {
                                    alert("Pilih rentang waktu (klik jam mulai & jam selesai)!");
                                    e.preventDefault();
                                }
                            };

                            function updateDisplay(price) {
                                document.getElementById('input-price').value = price;
                                document.getElementById('display-price').innerText = new Intl.NumberFormat('id-ID', {
                                    style: 'currency',
                                    currency: 'IDR',
                                    minimumFractionDigits: 0
                                }).format(price);
                            }
                        </script>
            </body>

            </html>