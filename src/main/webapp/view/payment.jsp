<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/view/Login.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Payment - PadelApp</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            .border-grid {
                border-color: #e5e5e5;
            }
            body {
                font-family: 'Inter', sans-serif;
            }
            .payment-card {
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }
            .payment-card:hover {
                transform: translate(-4px, -4px);
                box-shadow: 8px 8px 0px 0px rgba(0, 0, 0, 1);
            }
            .payment-card.active {
                border-color: #000000 !important;
                background-color: #f8fafc;
                transform: translate(-4px, -4px);
                box-shadow: 8px 8px 0px 0px rgba(0, 0, 0, 1);
            }
        </style>
    </head>
    <body class="bg-white text-black min-h-screen flex flex-col">
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

        <header class="flex border-b border-grid bg-white sticky top-0 z-50">
            <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
                <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">
                    Padel<span class="text-blue-400">App</span>
                </h1>
            </div>
            <div class="flex-1 border-r border-grid hidden md:flex items-center px-8">
                <a href="${pageContext.request.contextPath}/Profile" class="text-xs font-bold uppercase tracking-widest hover:underline">
                    ← Cancel & Back to Profile
                </a>
            </div>
            <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4">
                <span class="text-[10px] font-bold uppercase tracking-widest">
                    <%= session.getAttribute("user") %>
                </span>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                </svg>
            </div>
        </header>

        <main class="flex flex-col lg:flex-row flex-1">
            <!-- Left Panel: Summary & Neo-Brutalist Total Card -->
            <div class="w-full lg:w-5/12 p-8 md:p-12 border-b lg:border-b-0 lg:border-r border-grid bg-white flex flex-col justify-between">
                <div>
                    <span class="text-xs font-bold uppercase block mb-4 opacity-50">Step 04 / Checkout</span>
                    <h2 class="text-4xl md:text-5xl font-black leading-none uppercase mb-8 tracking-tighter">
                        Selesaikan Pembayaran
                    </h2>
                    
                    <!-- Booking details card -->
                    <div class="border-4 border-black p-6 rounded-2xl bg-cyan-50 shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] space-y-4 mb-8">
                        <h3 class="text-xl font-black uppercase tracking-tight border-b-2 border-black/10 pb-2 flex justify-between items-center">
                            <span>Detail Pemesanan</span>
                            <span class="text-xs bg-black text-white px-2 py-0.5 rounded-full">#${booking.id}</span>
                        </h3>
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <p class="text-[10px] font-bold uppercase tracking-wider text-gray-500">Court / Lapangan</p>
                                <p class="text-sm font-black uppercase">${booking.court}</p>
                            </div>
                            <div>
                                <p class="text-[10px] font-bold uppercase tracking-wider text-gray-500">Tanggal Sewa</p>
                                <p class="text-sm font-bold">
                                    <fmt:formatDate value="${booking.date}" pattern="dd MMMM yyyy" />
                                </p>
                            </div>
                            <div class="col-span-2">
                                <p class="text-[10px] font-bold uppercase tracking-wider text-gray-500">Jadwal Jam</p>
                                <p class="text-sm font-bold flex items-center gap-1.5">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4 text-cyan-600">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                                    </svg>
                                    ${booking.start} - ${booking.end}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Grand Total Card -->
                <div class="border-4 border-black p-6 rounded-2xl bg-yellow-100 shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] flex justify-between items-center mt-auto">
                    <div>
                        <p class="text-xs font-black uppercase tracking-widest opacity-60">Total Tagihan</p>
                        <p class="text-3xl md:text-4xl font-black tracking-tighter mt-1">
                            <fmt:formatNumber value="${booking.total}" type="currency" currencySymbol="Rp " maxFractionDigits="0" />
                        </p>
                    </div>
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-10 h-10 text-black">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 18.75a60.07 60.07 0 0 1 15.797 2.101c.727.198 1.453-.342 1.453-1.096V18.75M3.75 4.5h16.5m-16.5 4.5h16.5m-16.5 4.5h16.5m-16.5 4.5h16.5M3 18.75h18M6.75 12h.008v.008H6.75V12Zm0 3h.008v.008H6.75V15Zm0 3h.008v.008H6.75V18Z" />
                    </svg>
                </div>
            </div>

            <!-- Right Panel: Payment Methods Selection -->
            <div class="flex-1 p-8 md:p-12 space-y-8 bg-gray-50/30">
                <h3 class="text-2xl font-black uppercase tracking-tight">Pilih Metode Pembayaran</h3>

                <!-- Forms Container -->
                <form id="paymentForm" action="${pageContext.request.contextPath}/PaymentController" method="POST" class="space-y-8">
                    <input type="hidden" name="booking_id" value="${booking.id}">
                    <input type="hidden" id="selectedMethod" name="payment_method" value="qris">

                    <!-- Method Tabs Grid -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <!-- QRIS Option -->
                        <div id="btn-qris" onclick="selectPaymentMethod('qris')" class="payment-card active cursor-pointer border-4 border-gray-200 bg-white p-5 rounded-2xl flex flex-col justify-between h-36">
                            <div class="flex justify-between items-start">
                                <span class="font-black text-lg uppercase tracking-tight">QRIS</span>
                                <span class="text-[9px] bg-emerald-100 text-emerald-800 font-extrabold uppercase px-2 py-0.5 rounded-full border border-emerald-300">Instant</span>
                            </div>
                            <p class="text-[10px] text-gray-500 font-bold uppercase tracking-wider">E-Wallet (Dana, OVO, GoPay, dll)</p>
                        </div>

                        <!-- Bank VA Option -->
                        <div id="btn-va" onclick="selectPaymentMethod('va')" class="payment-card cursor-pointer border-4 border-gray-200 bg-white p-5 rounded-2xl flex flex-col justify-between h-36">
                            <div class="flex justify-between items-start">
                                <span class="font-black text-lg uppercase tracking-tight">Virtual A/C</span>
                                <span class="text-[9px] bg-blue-100 text-blue-800 font-extrabold uppercase px-2 py-0.5 rounded-full border border-blue-300">Auto Verification</span>
                            </div>
                            <p class="text-[10px] text-gray-500 font-bold uppercase tracking-wider">Transfer BCA, Mandiri, BNI</p>
                        </div>

                        <!-- Credit Card Option -->
                        <div id="btn-cc" onclick="selectPaymentMethod('cc')" class="payment-card cursor-pointer border-4 border-gray-200 bg-white p-5 rounded-2xl flex flex-col justify-between h-36">
                            <div class="flex justify-between items-start">
                                <span class="font-black text-lg uppercase tracking-tight">Kartu Kredit</span>
                                <span class="text-[9px] bg-purple-100 text-purple-800 font-extrabold uppercase px-2 py-0.5 rounded-full border border-purple-300">Secure 3D</span>
                            </div>
                            <p class="text-[10px] text-gray-500 font-bold uppercase tracking-wider">Visa, Mastercard, JCB</p>
                        </div>
                    </div>

                    <!-- Payment Details Card (Dynamically displayed based on selection) -->
                    <div class="border-4 border-black rounded-2xl bg-white p-6 md:p-8 shadow-[6px_6px_0px_0px_rgba(0,0,0,1)]">
                        
                        <!-- QRIS Area -->
                        <div id="area-qris" class="space-y-6 flex flex-col items-center justify-center py-4">
                            <div class="text-center">
                                <h4 class="text-lg font-black uppercase tracking-tight">Scan Kode QRIS</h4>
                                <p class="text-xs text-gray-500 font-bold uppercase tracking-wide mt-1">Pindai menggunakan aplikasi pembayaran Anda</p>
                            </div>
                            
                            <!-- Premium Custom QR Code Representation -->
                            <div class="relative border-4 border-black p-4 bg-white rounded-2xl shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
                                <svg class="w-48 h-48" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <!-- QR code borders & design -->
                                    <path d="M5 5h30v10H15v20H5V5ZM5 65h10v20h20v10H5V65ZM65 5h20v20H95V5H65ZM85 65h10v30H65v-10h20v-20Z" fill="currentColor"/>
                                    <!-- Dynamic points representing QR patterns -->
                                    <rect x="10" y="10" width="10" height="10" fill="currentColor"/>
                                    <rect x="10" y="80" width="10" height="10" fill="currentColor"/>
                                    <rect x="80" y="10" width="10" height="10" fill="currentColor"/>
                                    
                                    <rect x="30" y="25" width="5" height="15" fill="currentColor"/>
                                    <rect x="45" y="15" width="10" height="5" fill="currentColor"/>
                                    <rect x="60" y="20" width="5" height="10" fill="currentColor"/>
                                    <rect x="25" y="45" width="15" height="5" fill="currentColor"/>
                                    <rect x="15" y="55" width="10" height="5" fill="currentColor"/>
                                    <rect x="40" y="40" width="20" height="20" fill="currentColor"/>
                                    <rect x="65" y="45" width="10" height="10" fill="currentColor"/>
                                    <rect x="80" y="35" width="10" height="5" fill="currentColor"/>
                                    <rect x="75" y="60" width="15" height="15" fill="currentColor"/>
                                    <rect x="30" y="70" width="20" height="5" fill="currentColor"/>
                                    <rect x="35" y="80" width="15" height="10" fill="currentColor"/>
                                    <!-- Scan animation beam -->
                                    <rect id="scan-line" x="4" y="5" width="92" height="2" fill="#22d3ee" opacity="0.8">
                                        <animate attributeName="y" values="5;95;5" dur="3s" repeatCount="indefinite" />
                                    </rect>
                                </svg>
                                
                                <div class="absolute inset-0 flex items-center justify-center">
                                    <div class="bg-black text-white px-2 py-1 rounded border-2 border-white text-[9px] font-black tracking-widest uppercase">
                                        QRIS
                                    </div>
                                </div>
                            </div>
                            
                            <span class="text-[10px] bg-cyan-100 text-cyan-800 font-extrabold uppercase px-3 py-1 rounded-full tracking-wider">
                                Menunggu Pembayaran Anda...
                            </span>
                        </div>

                        <!-- Bank VA Area -->
                        <div id="area-va" class="hidden space-y-6">
                            <div>
                                <h4 class="text-lg font-black uppercase tracking-tight">Virtual Account Bank</h4>
                                <p class="text-xs text-gray-500 font-bold uppercase tracking-wide mt-1">Pilih bank Anda untuk mendapatkan nomor rekening</p>
                            </div>
                            
                            <!-- Sub Tabs for Banks -->
                            <div class="flex border-2 border-black rounded-xl overflow-hidden divide-x-2 divide-black">
                                <button type="button" onclick="selectBank('bca', '80012${booking.id}${sessionScope.user_id}')" class="bank-tab flex-1 py-3 font-black text-xs uppercase bg-black text-white transition-colors" id="tab-bca">
                                    BCA
                                </button>
                                <button type="button" onclick="selectBank('mandiri', '90055${booking.id}${sessionScope.user_id}')" class="bank-tab flex-1 py-3 font-black text-xs uppercase hover:bg-gray-100 transition-colors" id="tab-mandiri">
                                    MANDIRI
                                </button>
                                <button type="button" onclick="selectBank('bni', '88539${booking.id}${sessionScope.user_id}')" class="bank-tab flex-1 py-3 font-black text-xs uppercase hover:bg-gray-100 transition-colors" id="tab-bni">
                                    BNI
                                </button>
                            </div>

                            <!-- VA details display card -->
                            <div class="border-2 border-dashed border-gray-400 p-6 rounded-xl bg-gray-50 flex items-center justify-between">
                                <div>
                                    <p id="bank-label" class="text-[10px] font-black uppercase text-gray-500">BCA VIRTUAL ACCOUNT</p>
                                    <p id="va-number" class="text-2xl font-black tracking-wider text-black mt-1">80012${booking.id}${sessionScope.user_id}</p>
                                </div>
                                <button type="button" onclick="copyVA()" class="bg-black text-white px-4 py-2 text-xs font-black uppercase hover:bg-cyan-400 hover:text-black border-2 border-black transition-colors rounded-lg flex items-center gap-1.5 active:scale-95">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-4 h-4">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 17.25v3.375c0 .621-.504 1.125-1.125 1.125h-9.75a1.125 1.125 0 0 1-1.125-1.125V7.875c0-.621.504-1.125 1.125-1.125H5.25m11.9-3.664A2.251 2.251 0 0 0 15 2.25h-3a2.251 2.251 0 0 0-2.15 1.586m5.8 0c.065.21.1.433.1.664v.75h-6V4.5c0-.231.035-.454.1-.664M6.75 7.375c0-.621.504-1.125 1.125-1.125h9.75c.621 0 1.125.504 1.125 1.125v10.5c0 .621-.504 1.125-1.125 1.125h-9.75a1.125 1.125 0 0 1-1.125-1.125V7.375Z" />
                                    </svg>
                                    Copy VA
                                </button>
                            </div>
                            
                            <!-- Copy Toast -->
                            <div id="va-toast" class="hidden text-xs bg-emerald-100 text-emerald-800 border border-emerald-300 p-2.5 rounded-lg text-center font-bold">
                                Nomor VA berhasil disalin ke clipboard!
                            </div>
                        </div>

                        <!-- Credit Card Area -->
                        <div id="area-cc" class="hidden space-y-6">
                            <div>
                                <h4 class="text-lg font-black uppercase tracking-tight">Kartu Kredit / Debit</h4>
                                <p class="text-xs text-gray-500 font-bold uppercase tracking-wide mt-1">Masukkan informasi kartu pembayaran Anda</p>
                            </div>
                            
                            <!-- Mock Credit Card Visual Representation -->
                            <div class="relative w-full max-w-sm mx-auto h-48 bg-gradient-to-tr from-gray-900 to-slate-800 text-white rounded-2xl p-6 shadow-xl overflow-hidden flex flex-col justify-between border-2 border-black">
                                <div class="absolute right-0 bottom-0 opacity-10 translate-x-12 translate-y-12">
                                    <!-- Watermark logo -->
                                    <svg width="200" height="200" viewBox="0 0 24 24" fill="currentColor">
                                        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2Zm1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93Zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39Z"/>
                                    </svg>
                                </div>
                                <div class="flex justify-between items-start z-10">
                                    <span class="font-extrabold text-sm tracking-widest uppercase italic">PadelCard</span>
                                    <svg class="h-8" viewBox="0 0 36 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <rect width="36" height="24" rx="4" fill="white" fill-opacity="0.1"/>
                                        <circle cx="12" cy="12" r="10" fill="#EB001B" fill-opacity="0.8"/>
                                        <circle cx="24" cy="12" r="10" fill="#F79E1B" fill-opacity="0.8"/>
                                    </svg>
                                </div>
                                <div class="z-10">
                                    <p id="card-num-preview" class="text-xl font-bold tracking-widest text-center my-3">•••• •••• •••• ••••</p>
                                </div>
                                <div class="flex justify-between items-center z-10">
                                    <div>
                                        <p class="text-[8px] uppercase tracking-wider opacity-60">Card Holder</p>
                                        <p id="card-holder-preview" class="text-xs font-black uppercase tracking-wide">
                                            <%= session.getAttribute("user") %>
                                        </p>
                                    </div>
                                    <div>
                                        <p class="text-[8px] uppercase tracking-wider opacity-60">Expires</p>
                                        <p id="card-expiry-preview" class="text-xs font-bold">MM/YY</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Input Fields -->
                            <div class="space-y-4">
                                <div>
                                    <label class="text-[10px] font-black uppercase text-gray-500 block mb-1">Nomor Kartu</label>
                                    <input type="text" id="cc-number" placeholder="1234 5678 1234 5678" maxlength="19" class="w-full border-2 border-black rounded-xl p-3 font-bold text-sm outline-none focus:border-cyan-400" oninput="formatCardNumber(this)">
                                </div>
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <label class="text-[10px] font-black uppercase text-gray-500 block mb-1">Masa Berlaku (Expired)</label>
                                        <input type="text" id="cc-expiry" placeholder="MM/YY" maxlength="5" class="w-full border-2 border-black rounded-xl p-3 font-bold text-sm outline-none focus:border-cyan-400" oninput="formatExpiry(this)">
                                    </div>
                                    <div>
                                        <label class="text-[10px] font-black uppercase text-gray-500 block mb-1">CVV</label>
                                        <input type="password" id="cc-cvv" placeholder="•••" maxlength="3" class="w-full border-2 border-black rounded-xl p-3 font-bold text-sm outline-none focus:border-cyan-400">
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <!-- Payment Button and Feedback Overlay -->
                    <div class="pt-4 flex flex-col items-center">
                        <button type="submit" class="w-full bg-black text-white py-5 font-black uppercase tracking-widest text-lg hover:bg-cyan-400 hover:text-black transition-all shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] border-2 border-black">
                            Confirm & Pay Now →
                        </button>
                    </div>
                </form>
            </div>
        </main>

        <!-- Loading Processing Overlay -->
        <div id="loadingOverlay" class="fixed inset-0 bg-black/80 backdrop-blur-sm z-[1000] flex flex-col justify-center items-center text-white hidden">
            <div class="border-4 border-white p-8 rounded-3xl bg-black shadow-[8px_8px_0px_0px_rgba(255,255,255,1)] flex flex-col items-center gap-6 max-w-sm text-center">
                <!-- Premium Brutalist Spinner -->
                <div class="relative w-16 h-16">
                    <div class="absolute inset-0 border-8 border-t-cyan-400 border-r-transparent border-b-transparent border-l-transparent rounded-full animate-spin"></div>
                    <div class="absolute inset-0 border-8 border-gray-800 rounded-full -z-10"></div>
                </div>
                <div>
                    <h4 class="text-xl font-black uppercase tracking-tight">Memproses Pembayaran</h4>
                    <p class="text-xs text-gray-400 font-bold uppercase tracking-wider mt-2">Mohon tunggu sebentar, jangan tutup atau muat ulang halaman ini...</p>
                </div>
            </div>
        </div>

        <script>
            function selectPaymentMethod(method) {
                // Update hidden input
                document.getElementById('selectedMethod').value = method;

                // Remove active classes from all tabs
                document.querySelectorAll('.payment-card').forEach(card => {
                    card.classList.remove('active');
                });

                // Hide all details area
                document.getElementById('area-qris').classList.add('hidden');
                document.getElementById('area-va').classList.add('hidden');
                document.getElementById('area-cc').classList.add('hidden');

                // Activate selected tab & details area
                if (method === 'qris') {
                    document.getElementById('btn-qris').classList.add('active');
                    document.getElementById('area-qris').classList.remove('hidden');
                } else if (method === 'va') {
                    document.getElementById('btn-va').classList.add('active');
                    document.getElementById('area-va').classList.remove('hidden');
                } else if (method === 'cc') {
                    document.getElementById('btn-cc').classList.add('active');
                    document.getElementById('area-cc').classList.remove('hidden');
                }
            }

            function selectBank(bank, number) {
                // Update bank visual tabs
                document.querySelectorAll('.bank-tab').forEach(tab => {
                    tab.classList.remove('bg-black', 'text-white');
                    tab.classList.add('hover:bg-gray-100');
                });
                
                const activeTab = document.getElementById('tab-' + bank);
                activeTab.classList.remove('hover:bg-gray-100');
                activeTab.classList.add('bg-black', 'text-white');

                // Update text details
                document.getElementById('bank-label').innerText = bank.toUpperCase() + ' VIRTUAL ACCOUNT';
                document.getElementById('va-number').innerText = number;
            }

            function copyVA() {
                const num = document.getElementById('va-number').innerText;
                navigator.clipboard.writeText(num).then(() => {
                    const toast = document.getElementById('va-toast');
                    toast.classList.remove('hidden');
                    setTimeout(() => {
                        toast.classList.add('hidden');
                    }, 3000);
                });
            }

            // CC Input Formats
            function formatCardNumber(input) {
                let val = input.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
                let formatted = '';
                for (let i = 0; i < val.length; i++) {
                    if (i > 0 && i % 4 === 0) {
                        formatted += ' ';
                    }
                    formatted += val[i];
                }
                input.value = formatted;
                
                // Update Card Preview
                const preview = document.getElementById('card-num-preview');
                preview.innerText = formatted.length > 0 ? formatted : '•••• •••• •••• ••••';
            }

            function formatExpiry(input) {
                let val = input.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
                let formatted = '';
                if (val.length > 2) {
                    formatted = val.substring(0, 2) + '/' + val.substring(2, 4);
                } else {
                    formatted = val;
                }
                input.value = formatted;

                // Update Expiry Preview
                const preview = document.getElementById('card-expiry-preview');
                preview.innerText = formatted.length > 0 ? formatted : 'MM/YY';
            }

            // Submit Processing Animation
            document.getElementById('paymentForm').onsubmit = function(e) {
                const method = document.getElementById('selectedMethod').value;
                if (method === 'cc') {
                    // validation CC
                    const ccNum = document.getElementById('cc-number').value;
                    const ccExp = document.getElementById('cc-expiry').value;
                    const ccCvv = document.getElementById('cc-cvv').value;

                    if (ccNum.length < 16 || ccExp.length < 5 || ccCvv.length < 3) {
                        alert("Mohon isi informasi kartu kredit secara lengkap!");
                        e.preventDefault();
                        return false;
                    }
                }

                // Show Loading overlay
                document.getElementById('loadingOverlay').classList.remove('hidden');
                
                // Delay submit slightly to feel premium & simulated loading
                e.preventDefault();
                setTimeout(() => {
                    document.getElementById('paymentForm').submit();
                }, 2000);
            };
        </script>
    </body>
</html>
