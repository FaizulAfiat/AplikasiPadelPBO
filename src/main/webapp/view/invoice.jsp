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
        <title>Invoice Voucher - PadelApp</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            .border-grid {
                border-color: #e5e5e5;
            }
            body {
                font-family: 'Inter', sans-serif;
            }
            
            /* Ticket Perforation styling */
            .ticket-perforated {
                position: relative;
            }
            .ticket-perforated::before, .ticket-perforated::after {
                content: '';
                position: absolute;
                width: 24px;
                height: 24px;
                background-color: #f3f4f6; /* Gray-100 bg matching wrapper */
                border-radius: 50%;
                border: 4px solid #000000;
                top: 50%;
                transform: translateY(-50%);
                z-index: 10;
            }
            .ticket-perforated::before {
                left: -14px;
            }
            .ticket-perforated::after {
                right: -14px;
            }

            /* Paid stamp styling */
            .stamp {
                font-family: 'Courier New', Courier, monospace;
                transform: rotate(-12deg);
                border: 0.35rem double #10b981;
                color: #10b981;
            }

            /* Print layout CSS overrides */
            @media print {
                body {
                    background-color: white !important;
                    color: black !important;
                }
                header, .no-print {
                    display: none !important;
                }
                .ticket-container {
                    border: none !important;
                    box-shadow: none !important;
                    margin: 0 !important;
                    padding: 0 !important;
                    width: 100% !important;
                }
                .ticket-perforated::before, .ticket-perforated::after {
                    display: none !important;
                }
                .print-card {
                    border: 2px solid black !important;
                    border-radius: 8px !important;
                }
            }
        </style>
    </head>
    <body class="bg-gray-100 text-black min-h-screen flex flex-col">
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

        <header class="flex border-b border-grid bg-white sticky top-0 z-50 no-print">
            <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
                <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">
                    Padel<span class="text-blue-400">App</span>
                </h1>
            </div>
            <div class="flex-1 border-r border-grid hidden md:flex items-center px-8">
                <a href="${pageContext.request.contextPath}/Profile" class="text-xs font-bold uppercase tracking-widest hover:underline">
                    ← Back to Dashboard & Profile
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

        <main class="flex-1 flex flex-col items-center justify-center p-6 md:p-12">
            
            <div class="w-full max-w-4xl space-y-8">
                
                <!-- Success Alert Toast -->
                <c:if test="${not empty param.payment_success && param.payment_success eq 'true'}">
                    <div id="success-toast" class="border-4 border-black p-5 rounded-2xl bg-emerald-400 font-black uppercase italic shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] flex items-center justify-between no-print">
                        <div class="flex items-center gap-3">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" class="shrink-0 animate-bounce">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="9 11 12 14 22 4"></polyline>
                            </svg>
                            <span>Pembayaran Berhasil! E-Voucher Anda telah terbit.</span>
                        </div>
                        <button onclick="document.getElementById('success-toast').remove()" class="hover:opacity-70 transition-opacity">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>
                </c:if>

                <!-- Ticket Container (Neo-Brutalist Card) -->
                <div class="ticket-container bg-white border-4 border-black rounded-[2.5rem] shadow-[12px_12px_0px_0px_rgba(0,0,0,1)] overflow-hidden flex flex-col md:flex-row print-card">
                    
                    <!-- Left Section: Details (Perforated cut separates this from verification) -->
                    <div class="flex-1 p-8 md:p-10 space-y-8">
                        
                        <div class="flex justify-between items-start gap-4">
                            <div>
                                <span class="text-[10px] font-black tracking-widest text-cyan-600 uppercase bg-cyan-50 border border-cyan-300 px-3 py-1 rounded-full">E-Voucher Booking</span>
                                <h2 class="text-3xl font-black uppercase tracking-tight mt-3">PadelApp Invoice</h2>
                            </div>
                            
                            <!-- Stamp -->
                            <div class="stamp px-3 py-1 rounded font-black text-xs uppercase tracking-widest select-none">
                                Paid & Confirmed
                            </div>
                        </div>

                        <!-- Ticket details list -->
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 pt-4 border-t-2 border-black/5">
                            <div>
                                <p class="text-[10px] font-bold uppercase tracking-wider text-gray-400">Kode Invoice</p>
                                <p class="text-lg font-black uppercase tracking-tight">INV-PADEL-${invoice.id}</p>
                            </div>
                            <div>
                                <p class="text-[10px] font-bold uppercase tracking-wider text-gray-400">Nama Pelanggan</p>
                                <p class="text-lg font-black uppercase tracking-tight">${invoice.fullname} (${invoice.username})</p>
                                <p class="text-xs text-gray-500 font-bold">${invoice.email}</p>
                            </div>
                            <div>
                                <p class="text-[10px] font-bold uppercase tracking-wider text-gray-400">Lapangan (Court)</p>
                                <p class="text-lg font-black uppercase tracking-tight text-blue-500">${invoice.court}</p>
                            </div>
                            <div>
                                <p class="text-[10px] font-bold uppercase tracking-wider text-gray-400">Tanggal Sewa</p>
                                <p class="text-lg font-black">
                                    <fmt:formatDate value="${invoice.date}" pattern="dd MMM yyyy" />
                                </p>
                            </div>
                            <div>
                                <p class="text-[10px] font-bold uppercase tracking-wider text-gray-400">Waktu Sewa</p>
                                <div class="flex items-center gap-2 mt-1">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-5 h-5 text-gray-800">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                                    </svg>
                                    <span class="text-lg font-black">${invoice.start} - ${invoice.end}</span>
                                </div>
                            </div>
                            <div>
                                <p class="text-[10px] font-bold uppercase tracking-wider text-gray-400">Waktu Pemesanan / Transaksi</p>
                                <p class="text-sm font-black mt-1.5">${invoice.bookingTime}</p>
                            </div>
                        </div>

                        <!-- Price display summary -->
                        <div class="bg-gray-50 border-2 border-black p-5 rounded-2xl flex justify-between items-center">
                            <div>
                                <p class="text-[10px] font-black uppercase tracking-wider text-gray-400">Jumlah Pembayaran</p>
                                <p class="text-2xl font-black text-black">
                                    <fmt:formatNumber value="${invoice.total}" type="currency" currencySymbol="Rp " maxFractionDigits="0" />
                                </p>
                            </div>
                            <span class="text-[10px] font-extrabold uppercase bg-emerald-100 text-emerald-800 border border-emerald-300 px-3 py-1 rounded-full">
                                Lunas (FP)
                            </span>
                        </div>

                    </div>

                    <!-- Perforation line indicator on desktop -->
                    <div class="ticket-perforated hidden md:block w-[4px] border-r-2 border-dashed border-gray-400 relative h-full self-stretch bg-gray-50"></div>

                    <!-- Right Section: Scan Code (Tear off part) -->
                    <div class="w-full md:w-72 bg-gray-50/50 p-8 md:p-10 flex flex-col justify-between items-center text-center border-t-4 border-dashed border-gray-300 md:border-t-0 md:border-l-0">
                        <div class="space-y-2">
                            <h4 class="font-black uppercase text-xs tracking-widest text-gray-400">Scan di Lokasi</h4>
                            <p class="text-[10px] text-gray-500 font-bold uppercase leading-tight">Tunjukkan barcode/QR ini pada petugas lapangan PadelApp</p>
                        </div>

                        <!-- Barcode/QR Code design -->
                        <div class="my-6 p-4 border-4 border-black bg-white rounded-2xl shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
                            <svg class="w-36 h-36" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <rect width="10" height="10" fill="black"/>
                                <rect x="20" width="10" height="10" fill="black"/>
                                <rect x="30" width="10" height="10" fill="black"/>
                                <rect x="40" width="10" height="10" fill="black"/>
                                <rect x="50" width="10" height="10" fill="black"/>
                                <rect x="70" width="10" height="10" fill="black"/>
                                <rect x="80" width="10" height="10" fill="black"/>
                                <rect x="90" width="10" height="10" fill="black"/>
                                
                                <rect y="20" width="10" height="10" fill="black"/>
                                <rect x="20" y="20" width="10" height="10" fill="black"/>
                                <rect x="40" y="20" width="20" height="10" fill="black"/>
                                <rect x="80" y="20" width="10" height="10" fill="black"/>
                                
                                <rect x="10" y="30" width="20" height="10" fill="black"/>
                                <rect x="40" y="30" width="10" height="10" fill="black"/>
                                <rect x="60" y="30" width="20" height="10" fill="black"/>
                                <rect x="90" y="30" width="10" height="10" fill="black"/>
                                
                                <rect y="40" width="30" height="10" fill="black"/>
                                <rect x="50" y="40" width="10" height="10" fill="black"/>
                                <rect x="70" y="40" width="10" height="10" fill="black"/>
                                <rect x="90" y="40" width="10" height="10" fill="black"/>
                                
                                <rect x="10" y="50" width="10" height="10" fill="black"/>
                                <rect x="30" y="50" width="20" height="10" fill="black"/>
                                <rect x="60" y="50" width="10" height="10" fill="black"/>
                                <rect x="80" y="50" width="10" height="10" fill="black"/>
                                
                                <rect y="60" width="10" height="10" fill="black"/>
                                <rect x="20" y="60" width="10" height="10" fill="black"/>
                                <rect x="40" y="60" width="20" height="10" fill="black"/>
                                <rect x="70" y="60" width="20" height="10" fill="black"/>
                                
                                <rect x="10" y="70" width="10" height="10" fill="black"/>
                                <rect x="30" y="70" width="10" height="10" fill="black"/>
                                <rect x="60" y="70" width="10" height="10" fill="black"/>
                                <rect x="80" y="70" width="20" height="10" fill="black"/>
                                
                                <rect y="80" width="20" height="10" fill="black"/>
                                <rect x="30" y="80" width="30" height="10" fill="black"/>
                                <rect x="70" y="80" width="10" height="10" fill="black"/>
                                <rect x="90" y="80" width="10" height="10" fill="black"/>
                                
                                <rect x="10" y="90" width="20" height="10" fill="black"/>
                                <rect x="40" y="90" width="10" height="10" fill="black"/>
                                <rect x="60" y="90" width="20" height="10" fill="black"/>
                                <rect x="90" y="90" width="10" height="10" fill="black"/>
                            </svg>
                        </div>

                        <span class="text-[9px] font-mono tracking-widest text-gray-500 uppercase">
                            INV-PADEL-${invoice.id}
                        </span>
                    </div>

                </div>

                <!-- Action Controls (no print) -->
                <div class="flex flex-col sm:flex-row gap-6 justify-center items-center no-print">
                    <button onclick="window.print()" class="w-full sm:w-auto bg-black text-white hover:bg-cyan-400 hover:text-black border-2 border-black px-8 py-4 font-black uppercase tracking-widest text-sm transition-colors shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] hover:shadow-none">
                        Print / Download PDF ⎙
                    </button>
                    <a href="${pageContext.request.contextPath}/Profile" class="w-full sm:w-auto bg-white hover:bg-black hover:text-white border-2 border-black px-8 py-4 font-black uppercase tracking-widest text-sm transition-colors text-center shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] hover:shadow-none">
                        Back to Dashboard →
                    </a>
                </div>

            </div>

        </main>
    </body>
</html>
