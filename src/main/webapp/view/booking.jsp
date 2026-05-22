<%-- 
    Document   : booking
    Created on : 4 May 2026, 11.07.07
    Author     : Faizul Afiat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("Login.html");
    }
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Book a Field - PadelApp</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            .border-grid {
                border-color: #e5e5e5;
            }
            .slot-in-range {
                background-color: #22d3ee !important;
                border-color: #0891b2 !important;
                color: #000 !important;
            }
            .slot-start, .slot-end {
                background-color: #000 !important;
                color: #fff !important;
                border-color: #000 !important;
            }
        </style>
    </head>
    <body class="bg-white text-black min-h-screen flex flex-col">
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

        <header class="flex border-b border-grid bg-white sticky top-0 z-50">
            <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
                <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">Padel<span class="text-blue-400">App</span></h1>
            </div>
            <div class="flex-1 border-r border-grid hidden md:flex items-center px-8">
                <a href="${pageContext.request.contextPath}/index.jsp" class="text-xs font-bold uppercase tracking-widest hover:underline">← Back to Dashboard</a>
            </div>
            <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4">
                <span class="text-[10px] font-bold uppercase tracking-widest">
                    <%= session.getAttribute("user")%>
                </span>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                </svg>
            </div>
        </header>

        <main class="flex flex-col md:flex-row flex-1">
            <div class="w-full md:w-1/3 p-8 md:p-12 border-b md:border-b-0 md:border-r border-grid bg-white">
                <span class="text-xs font-bold uppercase block mb-4 opacity-50">03 / Reservation</span>
                <h2 class="text-5xl md:text-7xl font-black leading-none uppercase mb-8 tracking-tighter">
                    Reserve Your Court
                </h2>
                <p class="text-gray-500 uppercase font-bold text-xs leading-relaxed italic">
                    Klik sekali untuk waktu mulai, klik lagi untuk waktu selesai.
                </p>
            </div>

            <div class="flex-1 p-8 md:p-12 bg-white">
                <c:if test="${not empty param.status && param.status != 'success'}">
                    <div id="error-toast"
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
                                    <c:when test="${param.status eq 'already_booked'}">Jadwal lapangan sudah dipesan oleh orang lain!</c:when>
                                    <c:when test="${param.status eq 'past_time'}">Gagal: Anda tidak dapat memesan jadwal di masa lalu!</c:when>
                                    <c:when test="${param.status eq 'invalid_date'}">Gagal: Tanggal pemesanan tidak valid!</c:when>
                                    <c:when test="${param.status eq 'invalid_time'}">Gagal: Waktu pemesanan tidak valid!</c:when>
                                    <c:otherwise>Terjadi kesalahan sistem saat memproses pemesanan!</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <button onclick="document.getElementById('error-toast').remove()"
                            class="hover:opacity-70 transition-opacity">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                                fill="none" stroke="currentColor" stroke-width="3">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/BookingController" method="POST" class="max-w-2xl space-y-12" id="bookingForm">
                    <input type="hidden" name="start_time" id="start_time_input">
                    <input type="hidden" name="end_time" id="end_time_input">
                    <input type="hidden" name="total_price" id="input-price" value="0">

                    <div class="border-b-2 border-black pb-2">
                        <label class="text-xs font-bold uppercase opacity-50 block mb-2">Select Date</label>
                        <c:set var="today" value="<%= java.time.LocalDate.now()%>" />
                        <input type="date" name="match_date" id="match_date" 
                               value="${not empty match_date ? match_date : today}"
                               min="${today}"
                               class="w-full bg-transparent text-2xl font-black outline-none" required
                               onchange="window.location.href = '${pageContext.request.contextPath}/BookingController?date=' + this.value">
                    </div>

                    <div class="col-span-full">
                        <label class="text-xs font-bold uppercase opacity-50 block mb-4">Select Schedule</label>
                        <div class="grid grid-cols-4 gap-4" id="time-grid">
                            <c:forEach var="hour" begin="6" end="21">
                                <fmt:formatNumber var="formattedHour" value="${hour}" minIntegerDigits="2" />
                                <c:set var="slotTime" value="${formattedHour}:00" />
                                <button type="button" 
                                        data-time="${slotTime}" 
                                        id="slot-${slotTime}"
                                        onclick="handleSelection(this)"
                                        class="time-slot p-4 border-2 border-black rounded-xl font-black transition-all hover:bg-gray-100">
                                    ${slotTime}
                                </button>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="border-b-2 border-black pb-2">
                        <label class="text-xs font-bold uppercase opacity-50 block mb-2">Court Number</label>
                        <div class="flex gap-8 mt-2">
                            <label class="flex items-center gap-2 cursor-pointer">
                                <input type="radio" name="court_id" value="1" class="court-radio w-4 h-4 accent-black" checked>
                                <span class="font-bold uppercase">Court A</span>
                            </label>
                            <label class="flex items-center gap-2 cursor-pointer">
                                <input type="radio" name="court_id" value="2" class="court-radio w-4 h-4 accent-black">
                                <span class="font-bold uppercase">Court B</span>
                            </label>
                        </div>
                    </div>

                    <div class="pt-8 flex flex-col md:flex-row items-center gap-8">
                        <button type="submit" class="w-full md:w-auto bg-black text-white px-12 py-5 font-black uppercase tracking-widest text-lg hover:bg-cyan-400 hover:text-black transition-all shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
                            Confirm Booking →
                        </button>

                        <div class="flex flex-col">
                            <span class="text-xs font-bold uppercase opacity-50">Estimated Price</span>
                            <span id="display-price" class="text-3xl font-black uppercase tracking-tighter">Rp 0</span>
                        </div>
                    </div>
                </form>
            </div>
        </main>

        <script>
            // Data booking dari server
            const bookedA = [
                <c:forEach var="slot" items="${bookedSlotsA}" varStatus="status">
                    "${slot}"${not status.last ? ',' : ''}
                </c:forEach>
            ];
            const bookedB = [
                <c:forEach var="slot" items="${bookedSlotsB}" varStatus="status">
                    "${slot}"${not status.last ? ',' : ''}
                </c:forEach>
            ];
            const isToday = ${isToday != null ? isToday : false};
            const currentHour = ${currentHour != null ? currentHour : -1};

            let firstClick = null;
            let secondClick = null;
            const pricePerHour = 250000;

            function updateTimeSlots() {
                const courtRadio = document.querySelector('input[name="court_id"]:checked');
                const courtId = courtRadio ? courtRadio.value : '1';
                const bookedList = courtId === '1' ? bookedA : bookedB;
                
                const allSlots = document.querySelectorAll('.time-slot');
                
                // Reset selected values
                resetSelection(allSlots);
                
                allSlots.forEach(slot => {
                    const slotTime = slot.getAttribute('data-time');
                    const slotHour = parseInt(slotTime.split(':')[0]);
                    
                    let isDisabled = false;
                    
                    // 1. Past time restriction for today
                    if (isToday && slotHour <= currentHour) {
                        isDisabled = true;
                    }
                    
                    // 2. Already booked slots
                    if (bookedList.includes(slotTime)) {
                        isDisabled = true;
                    }
                    
                    slot.disabled = isDisabled;
                    if (isDisabled) {
                        slot.classList.add('bg-gray-100', 'line-through', 'cursor-not-allowed', 'opacity-50', 'border-gray-300');
                        slot.classList.remove('hover:bg-gray-100', 'border-black');
                    } else {
                        slot.classList.remove('bg-gray-100', 'line-through', 'cursor-not-allowed', 'opacity-50', 'border-gray-300');
                        slot.classList.add('hover:bg-gray-100', 'border-black');
                    }
                });
            }

            function handleSelection(element) {
                if (element.disabled) return;
                const time = element.getAttribute('data-time');
                const allSlots = document.querySelectorAll('.time-slot');

                if (!firstClick || (firstClick && secondClick)) {
                    // RESET & SET START
                    resetSelection(allSlots);
                    firstClick = time;
                    secondClick = null;
                    element.classList.add('slot-start');
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
                    }
                });
            }

            function resetSelection(slots) {
                slots.forEach(slot => {
                    slot.classList.remove('slot-start', 'slot-end', 'slot-in-range');
                });
                firstClick = null;
                secondClick = null;
                document.getElementById('start_time_input').value = "";
                document.getElementById('end_time_input').value = "";
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

            function updateDisplay(price) {
                document.getElementById('input-price').value = price;
                document.getElementById('display-price').innerText = new Intl.NumberFormat('id-ID', {
                    style: 'currency',
                    currency: 'IDR',
                    minimumFractionDigits: 0
                }).format(price);
            }

            // Validasi Form sebelum kirim
            document.getElementById('bookingForm').onsubmit = function (e) {
                if (!firstClick || !secondClick) {
                    alert("Pilih rentang waktu (klik jam mulai & jam selesai)!");
                    e.preventDefault();
                }
            };

            // Bind radio change listeners
            document.querySelectorAll('.court-radio').forEach(radio => {
                radio.addEventListener('change', updateTimeSlots);
            });

            // Initialize on load
            window.addEventListener('DOMContentLoaded', updateTimeSlots);
        </script>
    </body>
</html>