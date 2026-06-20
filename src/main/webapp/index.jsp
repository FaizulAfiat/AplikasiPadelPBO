<%-- Document : index Created on : 4 May 2026, 10.41.41 Author : Faizul Afiat --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="java.sql.*, java.util.*, com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
    <%
        List<Map<String, Object>> courts = new ArrayList<>();
        List<Map<String, Object>> tournaments = new ArrayList<>();
        List<Map<String, Object>> products = new ArrayList<>();
        List<Map<String, Object>> leaderboard = new ArrayList<>();

        try (Connection conn = Koneksi.getConnection()) {
            // Fetch courts
            String sqlCourts = "SELECT * FROM courts ORDER BY name ASC";
            try (PreparedStatement ps = conn.prepareStatement(sqlCourts); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> c = new HashMap<>();
                    c.put("court_id", rs.getInt("court_id"));
                    c.put("name", rs.getString("name"));
                    c.put("price_per_hour", rs.getInt("price_per_hour"));
                    c.put("status", rs.getString("status"));
                    courts.add(c);
                }
            }

            // Fetch tournaments
            String sqlTournaments = "SELECT tn.*, c.name AS court_name FROM tournament_news tn " +
                                     "LEFT JOIN courts c ON tn.court_id = c.court_id " +
                                     "ORDER BY tn.tournament_date DESC, tn.news_id DESC LIMIT 3";
            try (PreparedStatement ps = conn.prepareStatement(sqlTournaments); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> t = new HashMap<>();
                    t.put("news_id", rs.getInt("news_id"));
                    t.put("title", rs.getString("title"));
                    t.put("content", rs.getString("content"));
                    t.put("image_url", rs.getString("image_url"));
                    t.put("tournament_date", rs.getDate("tournament_date"));
                    t.put("court_name", rs.getString("court_name"));
                    t.put("max_participants", rs.getInt("max_participants"));
                    t.put("current_participants", rs.getInt("current_participants"));
                    tournaments.add(t);
                }
            }

            // Fetch featured products
            String sqlProducts = "SELECT * FROM products WHERE name NOT LIKE '%test%' AND price < 10000000 " +
                                 "ORDER BY rating DESC, product_id ASC LIMIT 3";
            try (PreparedStatement ps = conn.prepareStatement(sqlProducts); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> p = new HashMap<>();
                    p.put("product_id", rs.getInt("product_id"));
                    p.put("name", rs.getString("name"));
                    p.put("price", rs.getInt("price"));
                    p.put("image", rs.getString("image"));
                    p.put("description", rs.getString("description"));
                    p.put("rating", rs.getDouble("rating"));
                    p.put("type", rs.getString("type"));
                    products.add(p);
                }
            }

            // Fetch top players leaderboard
            String sqlLeaderboard = "SELECT u.username, SUM(ps.poin_didapat) as total_points, COUNT(ps.match_id) as matches_played " +
                                    "FROM player_scores ps " +
                                    "JOIN users u ON ps.user_id = u.user_id " +
                                    "GROUP BY ps.user_id " +
                                    "ORDER BY total_points DESC LIMIT 3";
            try (PreparedStatement ps = conn.prepareStatement(sqlLeaderboard); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> l = new HashMap<>();
                    l.put("username", rs.getString("username"));
                    l.put("total_points", rs.getInt("total_points"));
                    l.put("matches_played", rs.getInt("matches_played"));
                    leaderboard.add(l);
                }
            }
        } catch (Exception e) {
            System.err.println("[Dashboard Seeder/Fetch Error] " + e.getMessage());
        }

        // Set to page context for easy JSTL use
        pageContext.setAttribute("courtsList", courts);
        pageContext.setAttribute("tournamentsList", tournaments);
        pageContext.setAttribute("productsList", products);
        pageContext.setAttribute("leaderboardList", leaderboard);
    %>
    <%-- Guest is allowed to access index.jsp directly --%>
    <!DOCTYPE html>
                <html lang="id">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>PadelApp - Dashboard</title>
                    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">
                    <script src="https://cdn.tailwindcss.com"></script>
                    <style>
                        .border-grid {
                            border-color: #e5e7eb;
                        }

                        body {
                            font-family: 'Inter', sans-serif;
                            background-color: #f9fafb;
                        }
                        
                        .neobrutalist-card {
                            border: 1px solid #e5e7eb;
                            background-color: #ffffff;
                            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05), 0 1px 2px 0 rgba(0, 0, 0, 0.03);
                            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                        }
                        
                        .neobrutalist-card:hover {
                            transform: translateY(-4px);
                            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -2px rgba(0, 0, 0, 0.02);
                        }
                        
                        .neobrutalist-button {
                            border: 1px solid #e5e7eb;
                            background-color: #ffffff;
                            color: #374151;
                            box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                            transition: all 0.2s ease-in-out;
                        }
                        
                        .neobrutalist-button:hover {
                            border-color: #000000;
                            background-color: #f9fafb;
                            color: #000000;
                        }
                        
                        .neobrutalist-button:active {
                            transform: scale(0.98);
                        }

                        .no-scrollbar::-webkit-scrollbar {
                            display: none;
                        }
                        .no-scrollbar {
                            -ms-overflow-style: none;
                            scrollbar-width: none;
                        }
                    </style>
                </head>

                <body class="bg-white text-black min-h-screen flex flex-col">
                    <header class="flex border-b border-grid bg-white sticky top-0 z-50">
                        <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
                            <span class="text-[10px] font-bold uppercase block opacity-50 md:text-xs">01 / Padel
                                Management</span>
                            <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">Padel<span
                                    class="text-blue-400">App</span></h1>
                        </div>

                        <div
                            class="hidden md:flex flex-1 items-center justify-center border-r border-grid p-6 relative">
                            <% if (session.getAttribute("user") !=null) { %>
                                <div class="w-full max-w-md relative">
                                    <form action="${pageContext.request.contextPath}/SearchFriendController"
                                        method="GET"
                                        class="w-full flex items-center border border-gray-200 rounded-xl overflow-hidden bg-white shadow-sm hover:border-black transition-colors"
                                        id="search-form">
                                        <input type="text" id="search-input" name="keyword" autocomplete="off"
                                            placeholder="Search users by username..."
                                            class="w-full px-4 py-2.5 text-xs font-semibold outline-none placeholder:text-gray-400"
                                            required>
                                        <button type="submit"
                                            class="bg-black text-white hover:bg-zinc-800 px-5 py-2.5 text-xs font-bold uppercase tracking-wider transition-colors shrink-0">Search</button>
                                    </form>
                                    <div id="suggestions-dropdown"
                                        class="absolute left-0 right-0 top-full mt-1.5 bg-white border border-gray-200 rounded-xl shadow-lg z-50 hidden overflow-hidden divide-y divide-gray-100">
                                    </div>
                                </div>
                                <% } else { %>
                                    <div class="flex items-center gap-2">
                                        <span class="w-2 h-2 bg-blue-500 rounded-full animate-pulse"></span>
                                        <span class="text-[10px] font-bold uppercase tracking-widest">Open for
                                            Bookings</span>
                                    </div>
                                    <% } %>
                        </div>

                        <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4 md:gap-6">
                            <% if (session.getAttribute("user") !=null) { %>
                                <button id="launchpad-trigger" class="hover:bg-gray-200 p-2 rounded-lg transition-all">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round">
                                        <rect x="3" y="3" width="7" height="7"></rect>
                                        <rect x="14" y="3" width="7" height="7"></rect>
                                        <rect x="14" y="14" width="7" height="7"></rect>
                                        <rect x="3" y="14" width="7" height="7"></rect>
                                    </svg>
                                </button>
                                <div class="flex items-center gap-2 group cursor-pointer"
                                    onclick="window.location.href='${pageContext.request.contextPath}/ProfileController'">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                        stroke-width="2" stroke="currentColor" class="w-5 h-5">
                                        <path stroke-linecap="round" stroke-linejoin="round"
                                            d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                                    </svg>
                                    <span class="hidden lg:inline text-[10px] font-bold uppercase tracking-widest">
                                        <%= session.getAttribute("user") %>
                                    </span>
                                </div>
                                <button onclick="window.location.href='${pageContext.request.contextPath}/Logout'"
                                    class="bg-black text-white px-4 py-2 md:px-6 md:py-2 rounded-full text-[10px] md:text-xs font-bold uppercase tracking-widest hover:bg-red-600 transition-colors">
                                    Logout
                                </button>
                                <% } else { %>
                                    <button
                                        onclick="window.location.href='${pageContext.request.contextPath}/view/Login.html'"
                                        class="bg-black text-white px-4 py-2 md:px-6 md:py-2 rounded-full text-[10px] md:text-xs font-bold uppercase tracking-widest hover:bg-blue-600 transition-colors">
                                        Login
                                    </button>
                                    <% } %>
                        </div>
                    </header>

                    <main class="flex flex-col flex-1 bg-gray-50/50">
                        <c:if test="${param.status eq 'success'}">
                            <div id="success-toast"
                                class="m-6 border border-emerald-200 p-5 rounded-3xl bg-emerald-50 text-emerald-800 font-semibold flex items-center justify-between shadow-sm max-w-[1440px] w-full mx-auto">
                                <div class="flex items-center gap-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2.5" class="shrink-0">
                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                    </svg>
                                    <span>Pemesanan lapangan berhasil dikonfirmasi! Silakan cek jadwal Anda.</span>
                                </div>
                                <button onclick="document.getElementById('success-toast').remove()"
                                    class="hover:opacity-70 transition-opacity">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2.5">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                </button>
                            </div>
                        </c:if>

                        <div class="flex-1 p-6 pb-24 max-w-[1440px] w-full mx-auto space-y-10">
                            <!-- Hero Section Banner -->
                            <div class="w-full bg-white border border-gray-200 rounded-3xl overflow-hidden relative group shadow-sm">
                                <img src="img/padel.jpg" alt="Padel Banner"
                                    class="w-full h-64 md:h-[400px] object-cover group-hover:scale-105 transition-transform duration-700">
                                <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-black/20 to-transparent"></div>
                                <div class="absolute bottom-8 left-8 right-8 z-20 text-white flex flex-col md:flex-row md:items-end justify-between gap-4">
                                    <div>
                                        <h2 class="text-3xl md:text-5xl font-black uppercase tracking-tighter italic mb-2">Ready to Play?</h2>
                                        <p class="text-xs font-bold uppercase tracking-wider text-gray-300">Book your court, find match partners, and track stats</p>
                                    </div>
                                    <a href="${not empty sessionScope.user ? 'BookingController' : 'view/Login.html'}" class="bg-blue-500 hover:bg-blue-600 text-white px-8 py-3.5 font-bold uppercase
                                        tracking-wider text-xs rounded-xl shadow transition-all duration-200 shrink-0 hover:-translate-y-0.5 active:translate-y-0 text-center">
                                        Book Now →
                                    </a>
                                </div>
                            </div>

                            <!-- Dashboard Stats Intro Card -->
                            <div class="bg-white border border-gray-200 rounded-3xl p-8 shadow-sm">
                                <div class="mb-8">
                                    <span class="text-xs font-bold uppercase block mb-3 text-cyan-600 tracking-wider">02 / Our Services</span>
                                    <h2 class="text-3xl md:text-4xl font-black leading-tight uppercase tracking-tighter">
                                        What we do <br>for <span class="text-cyan-500">athletes</span>
                                    </h2>
                                    <p class="text-xs text-gray-400 font-medium mt-3 max-w-lg">Platform lengkap untuk komunitas padel — dari booking lapangan hingga tracking performa atletmu.</p>
                                </div>

                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-0 divide-y md:divide-y-0 md:divide-x divide-gray-100">
                                    <!-- Item 1 -->
                                    <div class="py-6 md:pr-8 first:pt-0 last:pb-0">
                                        <div class="flex gap-4 items-start">
                                            <div class="w-10 h-10 bg-black rounded-xl flex items-center justify-center shrink-0">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                            </div>
                                            <div>
                                                <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">01</span>
                                                <h3 class="text-base font-black uppercase tracking-tight text-gray-900 mt-0.5">Field Booking</h3>
                                                <p class="text-xs text-gray-500 leading-relaxed mt-1.5">Pesan lapangan Padel favoritmu secara instan dengan sistem konfirmasi otomatis dan pilihan waktu fleksibel.</p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Item 2 -->
                                    <div class="py-6 md:px-8">
                                        <div class="flex gap-4 items-start">
                                            <div class="w-10 h-10 bg-blue-500 rounded-xl flex items-center justify-center shrink-0">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                                            </div>
                                            <div>
                                                <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">02</span>
                                                <h3 class="text-base font-black uppercase tracking-tight text-gray-900 mt-0.5">Member Stats</h3>
                                                <p class="text-xs text-gray-500 leading-relaxed mt-1.5">Pantau statistik permainan dan progres latihanmu setiap minggu melalui dashboard interaktif real-time.</p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Item 3 -->
                                    <div class="py-6 md:pl-8">
                                        <div class="flex gap-4 items-start">
                                            <div class="w-10 h-10 bg-amber-400 rounded-xl flex items-center justify-center shrink-0">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="black" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6"></path><path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18"></path><path d="M4 22h16"></path><path d="M10 14.66V17c0 .55-.47.98-.97 1.21C7.85 18.75 7 20.24 7 22"></path><path d="M14 14.66V17c0 .55.47.98.97 1.21C16.15 18.75 17 20.24 17 22"></path><path d="M18 2H6v7a6 6 0 0 0 12 0V2Z"></path></svg>
                                            </div>
                                            <div>
                                                <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">03</span>
                                                <h3 class="text-base font-black uppercase tracking-tight text-gray-900 mt-0.5">Tournaments <span class="text-[9px] bg-amber-100 text-amber-700 px-2 py-0.5 rounded-full font-bold ml-1 align-middle">PRO</span></h3>
                                                <p class="text-xs text-gray-500 leading-relaxed mt-1.5">Ikuti turnamen kompetitif antar member, lihat bracket, dan buktikan kemampuanmu di papan peringkat.</p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Item 4 -->
                                    <div class="py-6 md:pr-8 border-t md:border-t border-gray-100">
                                        <div class="flex gap-4 items-start">
                                            <div class="w-10 h-10 bg-rose-500 rounded-xl flex items-center justify-center shrink-0">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                            </div>
                                            <div>
                                                <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">04</span>
                                                <h3 class="text-base font-black uppercase tracking-tight text-gray-900 mt-0.5">Track Health <span class="text-[9px] bg-amber-100 text-amber-700 px-2 py-0.5 rounded-full font-bold ml-1 align-middle">PRO</span></h3>
                                                <p class="text-xs text-gray-500 leading-relaxed mt-1.5">Monitor kalori, detak jantung, dan kebugaran tubuhmu setelah setiap sesi padel dengan analisis mendalam.</p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Item 5 -->
                                    <div class="py-6 md:px-8 border-t md:border-t border-gray-100">
                                        <div class="flex gap-4 items-start">
                                            <div class="w-10 h-10 bg-emerald-500 rounded-xl flex items-center justify-center shrink-0">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"></path><path d="M3 6h18"></path><path d="M16 10a4 4 0 0 1-8 0"></path></svg>
                                            </div>
                                            <div>
                                                <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">05</span>
                                                <h3 class="text-base font-black uppercase tracking-tight text-gray-900 mt-0.5">Shop & Rent</h3>
                                                <p class="text-xs text-gray-500 leading-relaxed mt-1.5">Beli atau sewa peralatan padel premium — raket, grip, tas, dan aksesoris dari brand terbaik.</p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Item 6 -->
                                    <div class="py-6 md:pl-8 border-t md:border-t border-gray-100">
                                        <div class="flex gap-4 items-start">
                                            <div class="w-10 h-10 bg-purple-500 rounded-xl flex items-center justify-center shrink-0">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                            </div>
                                            <div>
                                                <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">06</span>
                                                <h3 class="text-base font-black uppercase tracking-tight text-gray-900 mt-0.5">Community</h3>
                                                <p class="text-xs text-gray-500 leading-relaxed mt-1.5">Temukan teman bermain, bangun koneksi sesama penggemar padel, dan jadilah bagian komunitas aktif kami.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>


                            <!-- SECTION 1: Live Court Availability -->
                            <div>
                                <div class="mb-6">
                                    <span class="text-xs font-bold uppercase block text-cyan-600 tracking-wider">03 / Court Status</span>
                                    <h2 class="text-3xl md:text-4xl font-black uppercase tracking-tighter italic mt-1">
                                        🏟️ Live Court Availability
                                    </h2>
                                </div>
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                                    <c:choose>
                                        <c:when test="${empty courtsList}">
                                            <!-- Fallback jika data kosong -->
                                            <div class="bg-white border border-gray-200 rounded-3xl p-6 flex flex-col justify-between h-48 shadow-sm hover:shadow-md transition-all duration-300">
                                                <div>
                                                    <h3 class="text-xl font-bold uppercase text-gray-900">Court A</h3>
                                                    <p class="text-xs font-semibold text-gray-500 mt-1">Rp 250.000 / jam</p>
                                                </div>
                                                <div class="flex items-center justify-between">
                                                    <span class="px-3 py-1 bg-emerald-50 text-emerald-700 border border-emerald-200 font-bold uppercase text-[9px] tracking-wider rounded-full">Available</span>
                                                    <a href="${not empty sessionScope.user ? 'BookingController' : 'view/Login.html'}" class="px-4 py-2 bg-black hover:bg-zinc-800 text-white font-bold uppercase text-[10px] tracking-wider rounded-xl transition-all shadow-sm active:scale-95">Book</a>
                                                </div>
                                            </div>
                                            <div class="bg-white border border-gray-200 rounded-3xl p-6 flex flex-col justify-between h-48 shadow-sm hover:shadow-md transition-all duration-300">
                                                <div>
                                                    <h3 class="text-xl font-bold uppercase text-gray-900">Court B</h3>
                                                    <p class="text-xs font-semibold text-gray-500 mt-1">Rp 250.000 / jam</p>
                                                </div>
                                                <div class="flex items-center justify-between">
                                                    <span class="px-3 py-1 bg-emerald-50 text-emerald-700 border border-emerald-200 font-bold uppercase text-[9px] tracking-wider rounded-full">Available</span>
                                                    <a href="${not empty sessionScope.user ? 'BookingController' : 'view/Login.html'}" class="px-4 py-2 bg-black hover:bg-zinc-800 text-white font-bold uppercase text-[10px] tracking-wider rounded-xl transition-all shadow-sm active:scale-95">Book</a>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="court" items="${courtsList}">
                                                <div class="bg-white border border-gray-200 rounded-3xl p-6 flex flex-col justify-between h-48 shadow-sm hover:shadow-md hover:-translate-y-1 transition-all duration-300">
                                                    <div>
                                                        <h3 class="text-xl font-bold uppercase text-gray-900">${court.name}</h3>
                                                        <p class="text-xs font-semibold text-gray-500 mt-1">
                                                            <fmt:setLocale value="id_ID" />
                                                            <fmt:formatNumber value="${court.price_per_hour}" type="currency" currencySymbol="Rp " maxFractionDigits="0" /> / jam
                                                        </p>
                                                    </div>
                                                    <div class="flex items-center justify-between">
                                                        <c:choose>
                                                            <c:when test="${court.status eq 'Available'}">
                                                                <span class="px-3 py-1 bg-emerald-50 text-emerald-700 border border-emerald-200 font-bold uppercase text-[9px] tracking-wider rounded-full">Available</span>
                                                            </c:when>
                                                            <c:when test="${court.status eq 'Maintenance'}">
                                                                <span class="px-3 py-1 bg-amber-50 text-amber-700 border border-amber-200 font-bold uppercase text-[9px] tracking-wider rounded-full">Maintenance</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="px-3 py-1 bg-rose-50 text-rose-700 border border-rose-200 font-bold uppercase text-[9px] tracking-wider rounded-full">Full</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        
                                                        <a href="${not empty sessionScope.user ? 'BookingController' : 'view/Login.html'}" class="px-4 py-2 bg-black hover:bg-zinc-800 text-white font-bold uppercase text-[10px] tracking-wider rounded-xl transition-all shadow-sm active:scale-95">Book</a>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- SECTION 2: Upcoming Club Tournaments -->
                            <div>
                                <div class="mb-6">
                                    <span class="text-xs font-bold uppercase block text-cyan-600 tracking-wider">04 / Club Tournaments</span>
                                    <h2 class="text-3xl md:text-4xl font-black uppercase tracking-tighter italic mt-1">
                                        🏆 Upcoming Club Tournaments
                                    </h2>
                                </div>
                                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                                    <c:choose>
                                        <c:when test="${empty tournamentsList}">
                                            <div class="col-span-full bg-white border border-gray-200 rounded-3xl p-8 text-center font-bold uppercase text-gray-400 shadow-sm">
                                                Belum ada turnamen terdekat saat ini. Stay tuned!
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="item" items="${tournamentsList}">
                                                <div class="bg-white border border-gray-200 rounded-3xl overflow-hidden flex flex-col justify-between shadow-sm hover:shadow-md hover:-translate-y-1 transition-all duration-300 group">
                                                    <div class="h-44 bg-zinc-100 overflow-hidden relative">
                                                        <img src="${pageContext.request.contextPath}/${item.image_url}" 
                                                             alt="${item.title}" 
                                                             class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                                                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/img/padel.jpg';">
                                                        
                                                        <!-- Slots Badge -->
                                                        <div class="absolute top-4 left-4 bg-black/70 backdrop-blur-sm text-white px-2.5 py-1 text-[9px] font-bold uppercase tracking-wider rounded-md border border-white/20">
                                                            Slot: ${item.current_participants} / ${item.max_participants}
                                                        </div>
                                                    </div>
                                                    <div class="p-6 space-y-4">
                                                        <div class="flex items-center justify-between text-[10px] font-bold uppercase tracking-wider text-gray-400">
                                                            <span>🏟️ ${item.court_name}</span>
                                                            <span>📅 <fmt:formatDate value="${item.tournament_date}" pattern="dd MMM yyyy" /></span>
                                                        </div>
                                                        <h3 class="text-lg font-bold uppercase tracking-tight text-gray-900 line-clamp-1">${item.title}</h3>
                                                        <p class="text-xs text-gray-500 font-medium line-clamp-2">${item.content}</p>
                                                        
                                                        <a href="${pageContext.request.contextPath}/TournamentNewsController" class="block w-full text-center bg-amber-400 hover:bg-amber-500 text-black py-2.5 rounded-xl font-bold uppercase text-[10px] tracking-wider transition-colors shadow-sm">
                                                            Ikuti Turnamen →
                                                        </a>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- SECTION 3: Community & Store Highlights -->
                            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                                <!-- Left: Leaderboard -->
                                <div class="bg-white border border-gray-200 rounded-3xl p-6 md:p-8 shadow-sm">
                                    <span class="text-xs font-bold uppercase block mb-3 text-cyan-600 tracking-wider">05 / Community Standings</span>
                                    <h2 class="text-3xl font-black uppercase mb-6 tracking-tighter italic">
                                        🥇 PadelApp Leaderboard
                                    </h2>
                                    <div class="space-y-4">
                                        <c:choose>
                                            <c:when test="${empty leaderboardList}">
                                                <div class="bg-gray-50 border border-gray-100 p-6 rounded-2xl text-center font-bold uppercase text-gray-400">
                                                    Mainkan match dan catat skor untuk memunculkan peringkat!
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="player" items="${leaderboardList}" varStatus="status">
                                                    <div class="bg-gray-50/50 border border-gray-100 p-4 rounded-2xl flex items-center justify-between hover:bg-gray-50 transition-colors">
                                                        <div class="flex items-center gap-4">
                                                            <span class="w-8 h-8 rounded-full flex items-center justify-center font-bold text-sm
                                                                ${status.index == 0 ? 'bg-amber-100 text-amber-800' : ''}
                                                                ${status.index == 1 ? 'bg-gray-100 text-gray-800' : ''}
                                                                ${status.index == 2 ? 'bg-orange-50 text-orange-800' : ''}">
                                                                ${status.index + 1}
                                                            </span>
                                                            <div>
                                                                <h4 class="font-bold uppercase text-sm text-gray-900">@${player.username}</h4>
                                                                <p class="text-[10px] font-bold text-gray-400 uppercase tracking-wider">${player.matches_played} matches played</p>
                                                            </div>
                                                        </div>
                                                        <div class="text-right">
                                                            <span class="font-black text-lg text-blue-500">${player.total_points}</span>
                                                            <span class="text-[10px] font-bold uppercase text-gray-400 block tracking-wider">PTS</span>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Right: Featured Equipment -->
                                <div class="bg-white border border-gray-200 rounded-3xl p-6 md:p-8 shadow-sm">
                                    <span class="text-xs font-bold uppercase block mb-3 text-cyan-600 tracking-wider">06 / Pro Store</span>
                                    <h2 class="text-3xl font-black uppercase mb-6 tracking-tighter italic">
                                        🎒 Featured Gear & Rentals
                                    </h2>
                                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                                        <c:choose>
                                            <c:when test="${empty productsList}">
                                                <div class="col-span-full bg-gray-50 border border-gray-100 p-6 rounded-2xl text-center font-bold uppercase text-gray-400">
                                                    Peralatan padel premium akan segera hadir di toko.
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="prod" items="${productsList}">
                                                    <div class="bg-white border border-gray-100 rounded-2xl p-4 flex flex-col justify-between h-[300px] hover:border-gray-200 hover:shadow-sm transition-all group">
                                                        <div class="space-y-2">
                                                            <div class="h-28 bg-gray-50 rounded-xl overflow-hidden flex items-center justify-center p-2 relative">
                                                                <img src="${pageContext.request.contextPath}/assets/images/${prod.image}" 
                                                                     alt="${prod.name}" 
                                                                     class="max-h-full max-w-full object-contain group-hover:scale-105 transition-transform duration-300"
                                                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/img/padel.jpg';">
                                                                <span class="absolute top-1.5 left-1.5 px-2 py-0.5 text-[8px] font-bold uppercase rounded-full bg-yellow-100 text-yellow-800 border border-yellow-200">
                                                                    ★ ${prod.rating}
                                                                </span>
                                                                <span class="absolute top-1.5 right-1.5 px-2 py-0.5 text-[8px] font-bold uppercase rounded-full
                                                                    ${prod.type eq 'Rent' ? 'bg-amber-100 text-amber-800' : 'bg-emerald-100 text-emerald-800'}">
                                                                    ${prod.type}
                                                                </span>
                                                            </div>
                                                            <h3 class="font-bold text-xs uppercase tracking-tight line-clamp-2 h-8 leading-tight text-gray-900">${prod.name}</h3>
                                                        </div>
                                                        <div class="pt-2 border-t border-gray-100">
                                                            <p class="text-[9px] font-bold text-gray-400 uppercase tracking-wider mb-1">
                                                                ${prod.type eq 'Rent' ? 'Sewa / jam' : 'Harga'}
                                                            </p>
                                                            <p class="font-black text-sm text-gray-900 mb-3">
                                                                <fmt:formatNumber value="${prod.price}" type="currency" currencySymbol="Rp " maxFractionDigits="0" />
                                                            </p>
                                                            <a href="${pageContext.request.contextPath}/ShopController" class="block w-full text-center bg-cyan-400 hover:bg-cyan-500 text-black py-1.5 rounded-lg font-bold uppercase text-[9px] tracking-wider transition-colors">
                                                                Go To Store
                                                            </a>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                    <% if (session.getAttribute("user") !=null) { %>
                        <div id="launchpad"
                            class="fixed inset-0 z-[999] hidden bg-white/80 backdrop-blur-xl transition-all duration-300 opacity-0">
                            <button id="launchpad-close"
                                class="absolute top-8 right-8 text-black hover:scale-110 transition-transform">
                                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24"
                                    fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                    stroke-linejoin="round">
                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                </svg>
                            </button>

                            <div class="h-full w-full flex items-center justify-center p-10">
                                <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-12 max-w-5xl w-full">

                                    <a href="BookingController"
                                        class="group flex flex-col items-center gap-4 text-center">
                                        <div
                                            class="w-20 h-20 bg-black text-white rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 group-hover:shadow-cyan-400/50 transition-all duration-300">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                                stroke-linecap="round" stroke-linejoin="round">
                                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                                <line x1="3" y1="10" x2="21" y2="10"></line>
                                            </svg>
                                        </div>
                                        <span class="font-black uppercase text-sm tracking-tighter">Book Court</span>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/MatchSetupController"
                                        class="group flex flex-col items-center gap-4 text-center">
                                        <div
                                            class="w-20 h-20 bg-yellow-400 border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-all duration-300">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                                stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6"></path>
                                                <path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18"></path>
                                                <path d="M4 22h16"></path>
                                                <path d="M10 14.66V17c0 .55-.47.98-.97 1.21C7.85 18.75 7 20.24 7 22">
                                                </path>
                                                <path d="M14 14.66V17c0 .55.47.98.97 1.21C16.15 18.75 17 20.24 17 22">
                                                </path>
                                                <path d="M18 2H6v7a6 6 0 0 0 12 0V2Z"></path>
                                            </svg>
                                        </div>
                                        <span class="font-black uppercase text-sm tracking-tighter">Score Counter</span>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/ShopController"
                                        class="group flex flex-col items-center gap-4 text-center">
                                        <div
                                            class="w-20 h-20 bg-emerald-400 border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-all duration-300">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                                                stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"></path>
                                                <path d="M3 6h18"></path>
                                                <path d="M16 10a4 4 0 0 1-8 0"></path>
                                            </svg>
                                        </div>
                                        <span class="font-black uppercase text-sm tracking-tighter">Shop & Rent</span>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/ProfileController"
                                        class="group flex flex-col items-center gap-4 text-center">
                                        <div
                                            class="w-20 h-20 bg-cyan-400 border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-all duration-300">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                                stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="12" cy="7" r="4"></circle>
                                            </svg>
                                        </div>
                                        <span class="font-black uppercase text-sm tracking-tighter">Profile</span>
                                    </a>

                                    <c:choose>
                                        <c:when test="${sessionScope.role eq 'Premium' or sessionScope.role eq 'Admin'}">
                                            <a href="${pageContext.request.contextPath}/TrackHealth"
                                                class="group flex flex-col items-center gap-4 text-center">
                                                <div
                                                    class="w-20 h-20 bg-rose-400 border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 group-hover:shadow-rose-400/50 transition-all duration-300">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="black" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                                        <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"></path>
                                                    </svg>
                                                </div>
                                                <span class="font-black uppercase text-sm tracking-tighter text-black">Track Health</span>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <button onclick="openPremiumModal()"
                                                class="group flex flex-col items-center gap-4 text-center cursor-pointer outline-none bg-transparent border-0">
                                                <div
                                                    class="w-20 h-20 bg-rose-400 border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 group-hover:shadow-rose-400/50 transition-all duration-300 relative">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="black" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                                        <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"></path>
                                                    </svg>
                                                    <span class="absolute -top-2 -right-2 bg-purple-600 text-white text-[8px] font-black uppercase px-1.5 py-0.5 rounded-full border border-black">PRO</span>
                                                </div>
                                                <span class="font-black uppercase text-sm tracking-tighter text-zinc-500">Track Health <span class="text-purple-600 text-[10px]">★</span></span>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>

                                    <a href="${pageContext.request.contextPath}/chat"
                                        class="group flex flex-col items-center gap-4 text-center">
                                        <div
                                            class="w-20 h-20 bg-pink-400 border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 group-hover:shadow-pink-400/50 transition-all duration-300">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="34" height="34" fill="none"
                                                viewBox="0 0 24 24" stroke="black" stroke-width="2.5">
                                                <path stroke-linecap="round" stroke-linejoin="round"
                                                    d="M8 10h8M8 14h5m-9 6l2.3-2.3A2 2 0 0 1 7.7 17H19a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h1" />
                                            </svg>
                                        </div>
                                        <span class="font-black uppercase text-sm tracking-tighter">Chat Room</span>
                                    </a>

                                    <c:choose>
                                        <c:when test="${sessionScope.role eq 'Premium' or sessionScope.role eq 'Admin'}">
                                            <a href="${pageContext.request.contextPath}/TournamentNewsController" class="group flex flex-col items-center gap-4 text-center">
                                                <div
                                                    class="w-20 h-20 bg-amber-400 border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 group-hover:shadow-amber-400/50 transition-all duration-300">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="black" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                                        <path d="M4 22h16a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v16a2 2 0 0 1-2 2Zm0 0a2 2 0 0 1-2-2v-9c0-1.1.9-2 2-2h2"></path>
                                                        <path d="M18 14h-8M18 18h-8M16 6H10v4h6V6Z"></path>
                                                    </svg>
                                                </div>
                                                <span class="font-black uppercase text-sm tracking-tighter text-black">Tournaments</span>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <button onclick="openPremiumModal()"
                                                class="group flex flex-col items-center gap-4 text-center cursor-pointer outline-none bg-transparent border-0">
                                                <div
                                                    class="w-20 h-20 bg-amber-400 border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 group-hover:shadow-amber-400/50 transition-all duration-300 relative">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="black" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                                        <path d="M4 22h16a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v16a2 2 0 0 1-2 2Zm0 0a2 2 0 0 1-2-2v-9c0-1.1.9-2 2-2h2"></path>
                                                        <path d="M18 14h-8M18 18h-8M16 6H10v4h6V6Z"></path>
                                                    </svg>
                                                    <span class="absolute -top-2 -right-2 bg-purple-600 text-white text-[8px] font-black uppercase px-1.5 py-0.5 rounded-full border border-black">PRO</span>
                                                </div>
                                                <span class="font-black uppercase text-sm tracking-tighter text-zinc-500">Tournaments <span class="text-purple-600 text-[10px]">★</span></span>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>

                                    <a href="${pageContext.request.contextPath}/MusicController"
                                        class="group flex flex-col items-center gap-4 text-center">
                                        <div
                                            class="w-20 h-20 bg-purple-500 border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-all duration-300">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                                stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M9 18V5l12-2v13"></path>
                                                <circle cx="6" cy="18" r="3"></circle>
                                                <circle cx="18" cy="16" r="3"></circle>
                                            </svg>
                                        </div>
                                        <span class="font-black uppercase text-sm tracking-tighter">Music Request</span>
                                    </a>

                                    <c:choose>
                                        <c:when test="${sessionScope.role eq 'Premium' or sessionScope.role eq 'Admin'}">
                                            <div class="group flex flex-col items-center gap-4 text-center cursor-default">
                                                <div
                                                    class="w-20 h-20 bg-gradient-to-tr from-amber-400 to-yellow-500 text-black border-4 border-black rounded-2xl flex items-center justify-center shadow-lg relative">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                                    </svg>
                                                    <span class="absolute -top-2 -right-2 bg-black text-white text-[8px] font-black uppercase px-1.5 py-0.5 rounded-full border border-yellow-400">Active</span>
                                                </div>
                                                <span class="font-black uppercase text-sm tracking-tighter text-amber-500">Premium Active</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <button onclick="openPremiumModal()"
                                                class="group flex flex-col items-center gap-4 text-center cursor-pointer outline-none bg-transparent border-0">
                                                <div
                                                    class="w-20 h-20 bg-gradient-to-tr from-indigo-600 via-purple-600 to-pink-500 text-white border-4 border-black rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 group-hover:shadow-purple-500/50 transition-all duration-300 relative overflow-hidden">
                                                    <div class="absolute inset-0 bg-white/20 translate-y-full skew-y-12 group-hover:-translate-y-full transition-transform duration-1000"></div>
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                                    </svg>
                                                </div>
                                                <span class="font-black uppercase text-sm tracking-tighter text-indigo-600">Go Premium ⭐</span>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>

                                </div>
                            </div>
                        </div>

                        <!-- PREMIUM SUBSCRIBE MODAL -->
                        <div id="premium-modal" class="fixed inset-0 z-[1000] hidden bg-black/70 backdrop-blur-md flex items-center justify-center p-6 opacity-0 transition-opacity duration-300">
                            <div class="bg-zinc-950 text-white border-4 border-black rounded-[2.5rem] p-8 md:p-10 max-w-lg w-full relative shadow-2xl overflow-hidden">
                                <div class="absolute -top-24 -left-24 w-48 h-48 bg-purple-600/30 rounded-full blur-3xl"></div>
                                <div class="absolute -bottom-24 -right-24 w-48 h-48 bg-cyan-500/30 rounded-full blur-3xl"></div>
                                
                                <button onclick="closePremiumModal()" class="absolute top-6 right-6 text-zinc-400 hover:text-white transition-colors">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                </button>

                                <div class="text-center space-y-6 relative z-10">
                                    <div class="inline-block p-4 bg-gradient-to-tr from-amber-400 to-yellow-500 rounded-3xl border-2 border-white shadow-lg text-black animate-bounce">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                            <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                        </svg>
                                    </div>

                                    <div>
                                        <h3 class="text-3xl font-black uppercase italic tracking-tighter bg-gradient-to-r from-amber-200 via-yellow-400 to-amber-200 bg-clip-text text-transparent">Unlock Premium</h3>
                                        <p class="text-[10px] text-zinc-400 font-bold uppercase tracking-widest mt-1">Upgrade your PadelApp experience to the next level</p>
                                    </div>

                                    <div class="space-y-3.5 text-left border-y border-zinc-900 py-6 my-4">
                                        <div class="flex items-center gap-3">
                                            <span class="text-emerald-400 text-lg font-bold">✓</span>
                                            <p class="text-xs font-semibold text-zinc-300">Daftar turnamen eksklusif klub & liga bergengsi</p>
                                        </div>
                                        <div class="flex items-center gap-3">
                                            <span class="text-emerald-400 text-lg font-bold">✓</span>
                                            <p class="text-xs font-semibold text-zinc-300">Request antrean musik DJ tak terbatas (Regular maks 3)</p>
                                        </div>
                                        <div class="flex items-center gap-3">
                                            <span class="text-emerald-400 text-lg font-bold">✓</span>
                                            <p class="text-xs font-semibold text-zinc-300">Prioritas pemesanan jadwal lapangan utama</p>
                                        </div>
                                        <div class="flex items-center gap-3">
                                            <span class="text-emerald-400 text-lg font-bold">✓</span>
                                            <p class="text-xs font-semibold text-zinc-300">Badge premium emas khusus di profil Anda</p>
                                        </div>
                                    </div>

                                    <div class="space-y-4">
                                        <div class="bg-zinc-900 border border-zinc-800 p-4 rounded-2xl flex justify-between items-center text-left">
                                            <div>
                                                <p class="text-[9px] font-black text-zinc-400 uppercase tracking-widest">Harga Berlangganan</p>
                                                <p class="text-xl font-black text-white mt-0.5">Rp 99.000 <span class="text-xs font-semibold text-zinc-500">/ bulan</span></p>
                                            </div>
                                            <span class="text-[9px] font-black bg-purple-500/10 text-purple-400 border border-purple-500/30 px-3 py-1 rounded-full uppercase">Best Value</span>
                                        </div>

                                        <form action="${pageContext.request.contextPath}/UpgradePremiumController" method="POST">
                                            <button type="submit" class="w-full bg-gradient-to-r from-amber-400 to-yellow-500 hover:from-amber-500 hover:to-yellow-600 text-black py-4 rounded-2xl font-black uppercase text-xs tracking-widest shadow-lg hover:shadow-yellow-500/20 active:scale-[0.98] transition-all cursor-pointer">
                                                Berlangganan Sekarang ⚡
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                </body>

                </html>
                <script>
                    const trigger = document.getElementById('launchpad-trigger');
                    const launchpad = document.getElementById('launchpad');
                    const closeBtn = document.getElementById('launchpad-close');
                    const premiumModal = document.getElementById('premium-modal');

                    function openPremiumModal() {
                        closeLaunchpad();
                        if (premiumModal) {
                            premiumModal.classList.remove('hidden');
                            setTimeout(() => {
                                premiumModal.classList.remove('opacity-0');
                            }, 10);
                        }
                    }

                    function closePremiumModal() {
                        if (premiumModal) {
                            premiumModal.classList.add('opacity-0');
                            setTimeout(() => {
                                premiumModal.classList.add('hidden');
                            }, 300);
                        }
                    }

                    function openLaunchpad() {
                        launchpad.classList.remove('hidden');
                        // Delay sedikit agar transisi opacity terlihat
                        setTimeout(() => {
                            launchpad.classList.remove('opacity-0');
                        }, 10);
                    }

                    function closeLaunchpad() {
                        launchpad.classList.add('opacity-0');
                        setTimeout(() => {
                            launchpad.classList.add('hidden');
                        }, 300);
                    }

                    if (trigger) {
                        trigger.addEventListener('click', openLaunchpad);
                    }
                    if (closeBtn) {
                        closeBtn.addEventListener('click', closeLaunchpad);
                    }

                    // Close jika klik area di luar grid
                    if (launchpad) {
                        launchpad.addEventListener('click', (e) => {
                            if (e.target === launchpad)
                                closeLaunchpad();
                        });
                    }

                    if (premiumModal) {
                        premiumModal.addEventListener('click', (e) => {
                            if (e.target === premiumModal)
                                closePremiumModal();
                        });
                    }

                    // Close jika tekan tombol ESC
                    document.addEventListener('keydown', (e) => {
                        if (e.key === "Escape") {
                            closeLaunchpad();
                            closePremiumModal();
                        }
                    });

                    // Autocomplete Search Suggestions
                    const searchInput = document.getElementById('search-input');
                    const suggestionsDropdown = document.getElementById('suggestions-dropdown');
                    const searchForm = document.getElementById('search-form');

                    if (searchInput && suggestionsDropdown) {
                        searchInput.addEventListener('input', () => {
                            const val = searchInput.value.trim();
                            if (val.length === 0) {
                                suggestionsDropdown.innerHTML = '';
                                suggestionsDropdown.classList.add('hidden');
                                return;
                            }

                            fetch('${pageContext.request.contextPath}/SearchSuggestionsController?keyword=' + encodeURIComponent(val))
                                .then(res => res.json())
                                .then(data => {
                                    if (data.length === 0) {
                                        suggestionsDropdown.innerHTML = '';
                                        suggestionsDropdown.classList.add('hidden');
                                        return;
                                    }

                                    let html = '';
                                    data.forEach(item => {
                                        html += `<button type="button" class="w-full text-left px-4 py-2.5 hover:bg-gray-50 text-xs font-semibold text-gray-700 uppercase tracking-wider transition-colors select-suggestion-btn" data-value="${item}">
                                                    @${item}
                                                 </button>`;
                                    });
                                    suggestionsDropdown.innerHTML = html;
                                    suggestionsDropdown.classList.remove('hidden');

                                    // Add event listeners to buttons
                                    document.querySelectorAll('.select-suggestion-btn').forEach(btn => {
                                        btn.addEventListener('click', () => {
                                            searchInput.value = btn.getAttribute('data-value');
                                            suggestionsDropdown.classList.add('hidden');
                                            searchForm.submit();
                                        });
                                    });
                                })
                                .catch(err => console.error('Error fetching suggestions:', err));
                        });

                        // Close dropdown when clicked outside
                        document.addEventListener('click', (e) => {
                            if (e.target !== searchInput && e.target !== suggestionsDropdown && !suggestionsDropdown.contains(e.target)) {
                                suggestionsDropdown.classList.add('hidden');
                            }
                        });
                    }
                </script>
                <% } else { %>
                    </body>

                    </html>
                    <% } %>