<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Achievements - PadelApp</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .border-grid { border-color: #000; border-width: 2px; }
        .brutalist-shadow { box-shadow: 6px 6px 0px 0px rgba(0,0,0,1); }
        .brutalist-shadow-hover:hover { box-shadow: 2px 2px 0px 0px rgba(0,0,0,1); transform: translate(4px, 4px); }
        .tab-active { background-color: #3b82f6; color: black; border-bottom: 4px solid black; }
        .tab-inactive { background-color: #f3f4f6; color: #9ca3af; border-bottom: 4px solid black; }
        .tab-inactive:hover { background-color: #e5e7eb; color: black; cursor: pointer; }
        body { font-family: 'Inter', sans-serif; }
        
        /* Hide scrollbar for clean look */
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #f1f1f1; border-left: 2px solid black; }
        ::-webkit-scrollbar-thumb { background: #000; }
        ::-webkit-scrollbar-thumb:hover { background: #333; }
    </style>
</head>
<body class="bg-gray-50 text-black min-h-screen flex flex-col selection:bg-cyan-400 selection:text-black">

    <header class="flex border-b-4 border-black bg-white sticky top-0 z-50 h-20">
        <div class="p-4 md:p-6 border-r-4 border-black w-1/2 md:w-1/4 flex items-center">
            <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">
                Padel<span class="text-blue-500">App</span>
            </h1>
        </div>
        <div class="flex-1 border-r-4 border-black hidden md:flex items-center px-8">
            <a href="index.jsp" class="text-xs font-bold uppercase tracking-widest hover:underline hover:bg-black hover:text-white px-3 py-2 border-2 border-transparent hover:border-black transition-all">← Back to Dashboard</a>
        </div>
        <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4">
            <span class="text-xs font-black uppercase tracking-widest border-2 border-black px-4 py-2 bg-yellow-300 brutalist-shadow">
                <%= (session.getAttribute("user") != null) ? session.getAttribute("user") : "PLAYER" %>
            </span>
        </div>
    </header>

    <main class="flex flex-col md:flex-row flex-1 max-w-[1600px] w-full mx-auto">
        
        <!-- Left Sidebar: Premium Stats Layout -->
        <div class="w-full md:w-1/3 p-6 md:p-10 border-b-4 md:border-b-0 md:border-r-4 border-black bg-white flex flex-col justify-between">
            <div>
                <div class="inline-block border-2 border-black px-3 py-1 bg-cyan-400 text-[10px] font-black uppercase tracking-widest mb-6">
                    Overview
                </div>
                <h2 class="text-5xl md:text-7xl font-black leading-none uppercase tracking-tighter mb-8">
                    Your<br/><span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-500 to-cyan-400 stroke-black" style="-webkit-text-stroke: 2px black;">Stats.</span>
                </h2>
                
                <div class="grid grid-cols-2 gap-4 mt-8">
                    <!-- Stat Card -->
                    <div class="border-4 border-black bg-white p-4 flex flex-col justify-center brutalist-shadow brutalist-shadow-hover transition-all">
                        <span class="text-[10px] font-bold uppercase text-gray-500 mb-2">Bookings</span>
                        <span class="text-4xl font-black tracking-tighter">${totalBookings}</span>
                    </div>
                    <!-- Stat Card -->
                    <div class="border-4 border-black bg-lime-400 p-4 flex flex-col justify-center brutalist-shadow brutalist-shadow-hover transition-all">
                        <span class="text-[10px] font-bold uppercase text-black mb-2">Squads</span>
                        <span class="text-4xl font-black tracking-tighter">${totalCommunities}</span>
                    </div>
                    <!-- Stat Card -->
                    <div class="border-4 border-black bg-yellow-300 p-4 flex flex-col justify-center col-span-2 brutalist-shadow brutalist-shadow-hover transition-all relative overflow-hidden group">
                        <div class="absolute -right-4 -bottom-4 opacity-20 text-8xl group-hover:scale-110 transition-transform">⭐</div>
                        <span class="text-[10px] font-bold uppercase text-black mb-2 relative z-10">Total Unlocked</span>
                        <span class="text-6xl font-black tracking-tighter relative z-10">${userAchievements.size()}</span>
                    </div>
                </div>
            </div>

            <div class="mt-12 p-6 bg-black text-white border-4 border-black relative overflow-hidden group">
                <div class="absolute inset-0 bg-gradient-to-r from-purple-600 to-blue-600 opacity-0 group-hover:opacity-20 transition-opacity"></div>
                <span class="text-[10px] font-bold uppercase text-gray-400 block mb-2">Membership Status</span>
                <span class="text-3xl font-black tracking-tighter uppercase text-transparent bg-clip-text bg-gradient-to-r from-yellow-300 to-yellow-600">
                    ${premiumStatus}
                </span>
            </div>
        </div>

        <!-- Right Content: Achievements List -->
        <div class="flex-1 flex flex-col bg-gray-50">
            <!-- TABS -->
            <div class="flex border-b-4 border-black bg-white sticky top-0 z-10">
                <button id="tab-unlocked" onclick="switchTab('unlocked')" class="flex-1 p-6 text-xl md:text-2xl font-black uppercase tracking-tighter tab-active transition-colors flex items-center justify-center gap-3">
                    Unlocked <span class="bg-black text-white text-sm px-3 py-1 rounded-full">${userAchievements.size()}</span>
                </button>
                <button id="tab-locked" onclick="switchTab('locked')" class="flex-1 p-6 text-xl md:text-2xl font-black uppercase tracking-tighter tab-inactive transition-colors flex items-center justify-center gap-3">
                    Locked 
                    <c:set var="lockedCount" value="0"/>
                    <c:forEach var="ach" items="${allAchievements}">
                        <c:if test="${!ach.is_unlocked}"><c:set var="lockedCount" value="${lockedCount + 1}"/></c:if>
                    </c:forEach>
                    <span class="bg-gray-400 text-white text-sm px-3 py-1 rounded-full">${lockedCount}</span>
                </button>
            </div>

            <div class="flex-1 overflow-y-auto p-6 md:p-10">
                
                <!-- UNLOCKED LIST -->
                <div id="content-unlocked" class="space-y-6 block">
                    <c:if test="${userAchievements.size() > 0}">
                        <c:forEach var="ach" items="${userAchievements}">
                            <div onclick="openModal(${ach.achievementId})" class="cursor-pointer bg-white border-4 border-black p-6 flex flex-col md:flex-row items-center gap-6 brutalist-shadow brutalist-shadow-hover transition-all relative group">
                                <div class="absolute top-4 right-4 opacity-0 group-hover:opacity-100 transition-opacity">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-blue-500"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                                </div>
                                <div class="w-20 h-20 bg-${ach.badgeColor}-400 border-4 border-black rounded-full flex items-center justify-center flex-shrink-0 text-4xl shadow-inner">
                                    ${ach.achievementIcon}
                                </div>
                                <div class="flex-1 text-center md:text-left">
                                    <h4 class="text-2xl font-black uppercase tracking-tighter">${ach.achievementName}</h4>
                                    <p class="text-xs font-bold text-gray-500 uppercase mt-2">${ach.description}</p>
                                </div>
                                <div class="bg-black text-white p-4 border-2 border-black flex flex-col items-center justify-center min-w-[140px]">
                                    <span class="text-[10px] font-black uppercase text-cyan-400">Achieved On</span>
                                    <span class="text-sm font-bold uppercase mt-1">
                                        <fmt:formatDate value="${ach.unlockedAt}" pattern="dd MMM yyyy"/>
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>
                    <c:if test="${userAchievements.size() == 0}">
                        <div class="p-12 border-4 border-dashed border-gray-300 text-center bg-white">
                            <span class="text-4xl block mb-4">😢</span>
                            <span class="text-lg font-black uppercase text-gray-400 tracking-widest">No achievements unlocked yet.<br/>Start playing!</span>
                        </div>
                    </c:if>
                </div>

                <!-- LOCKED LIST -->
                <div id="content-locked" class="space-y-6 hidden">
                    <c:forEach var="ach" items="${allAchievements}">
                        <c:if test="${!ach.is_unlocked}">
                            <div class="bg-gray-100 border-4 border-gray-300 p-6 flex flex-col md:flex-row items-center gap-6 opacity-80 grayscale hover:grayscale-0 transition-all group">
                                <div class="w-20 h-20 bg-gray-200 border-4 border-gray-400 rounded-full flex items-center justify-center flex-shrink-0 text-4xl group-hover:scale-110 transition-transform">
                                    ${ach.icon}
                                </div>
                                <div class="flex-1 text-center md:text-left">
                                    <h4 class="text-2xl font-black uppercase tracking-tighter text-gray-600 group-hover:text-black transition-colors">${ach.name}</h4>
                                    <p class="text-xs font-bold text-gray-500 uppercase mt-2">${ach.description}</p>
                                    
                                    <!-- Progress Bar / Status -->
                                    <div class="mt-4 flex flex-col md:flex-row gap-4 items-center md:items-start">
                                        <span class="text-[10px] font-black uppercase tracking-widest bg-gray-200 px-3 py-2 text-gray-600 border-2 border-gray-300 group-hover:border-black group-hover:bg-white transition-colors">
                                            Goal: 
                                            <c:choose>
                                                <c:when test="${ach.milestone_type == 'booking'}">${ach.milestone_value} Bookings</c:when>
                                                <c:when test="${ach.milestone_type == 'community'}">Join ${ach.milestone_value} Squads</c:when>
                                                <c:when test="${ach.milestone_type == 'community_created'}">Create ${ach.milestone_value} Squad</c:when>
                                                <c:when test="${ach.milestone_type == 'premium'}">Premium Status</c:when>
                                            </c:choose>
                                        </span>
                                        <span class="text-[10px] font-bold uppercase tracking-widest text-gray-500 flex items-center mt-1 md:mt-2">
                                            Currently at: 
                                            <span class="ml-2 font-black text-black">
                                                <c:choose>
                                                    <c:when test="${ach.milestone_type == 'booking'}">${totalBookings}</c:when>
                                                    <c:when test="${ach.milestone_type == 'community'}">${totalCommunities}</c:when>
                                                    <c:when test="${ach.milestone_type == 'community_created'}">--</c:when>
                                                    <c:when test="${ach.milestone_type == 'premium'}">${premiumStatus}</c:when>
                                                </c:choose>
                                            </span>
                                        </span>
                                    </div>
                                </div>
                                <div class="p-6 border-4 border-gray-300 rounded-full flex items-center justify-center bg-gray-200 text-gray-400 group-hover:bg-black group-hover:text-white transition-colors">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                    <c:if test="${lockedCount == 0}">
                        <div class="p-12 border-4 border-dashed border-gray-300 text-center bg-white">
                            <span class="text-4xl block mb-4">🌟</span>
                            <span class="text-lg font-black uppercase text-gray-400 tracking-widest">You have unlocked everything!<br/>Amazing!</span>
                        </div>
                    </c:if>
                </div>

            </div>
        </div>
    </main>

    <!-- MODAL -->
    <div id="achievement-modal" class="fixed inset-0 z-[999] hidden flex items-center justify-center p-4">
        <!-- Backdrop -->
        <div class="absolute inset-0 bg-white/80 backdrop-blur-sm" onclick="closeModal()"></div>
        
        <!-- Modal Content -->
        <div class="relative bg-white border-4 border-black brutalist-shadow max-w-xl w-full flex flex-col animate-[fade-in_0.2s_ease-out]">
            <button onclick="closeModal()" class="absolute top-4 right-4 bg-black text-white p-2 border-2 border-black hover:bg-red-500 transition-colors z-10">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>

            <!-- Current Achievement Info -->
            <div class="p-10 border-b-4 border-black flex flex-col items-center text-center relative overflow-hidden">
                <div class="absolute -top-10 -left-10 text-9xl opacity-5" id="modal-bg-icon"></div>
                <div id="modal-curr-icon" class="text-7xl mb-4 relative z-10 drop-shadow-md"></div>
                <h3 id="modal-curr-name" class="text-4xl font-black uppercase tracking-tighter relative z-10"></h3>
                <p id="modal-curr-desc" class="text-sm font-bold text-gray-500 uppercase mt-2 relative z-10"></p>
                <div class="mt-6 bg-lime-400 border-2 border-black px-4 py-2 text-xs font-black uppercase brutalist-shadow-sm">
                    ACHIEVEMENT UNLOCKED
                </div>
            </div>

            <!-- Next Mission Info -->
            <div id="modal-next-section" class="p-8 bg-gray-50">
                <span class="text-xs font-black uppercase text-gray-400 tracking-widest block mb-4">Next Mission in this category:</span>
                <div class="bg-white border-2 border-dashed border-gray-400 p-4 flex items-center gap-4 group hover:border-blue-500 transition-colors">
                    <div id="modal-next-icon" class="text-4xl opacity-50 group-hover:opacity-100 transition-opacity"></div>
                    <div class="flex-1">
                        <h4 id="modal-next-name" class="text-xl font-black uppercase tracking-tighter text-gray-600 group-hover:text-black transition-colors"></h4>
                        <p id="modal-next-goal" class="text-[10px] font-bold text-gray-400 uppercase mt-1"></p>
                    </div>
                    <div class="bg-blue-500 text-black px-3 py-1 border-2 border-black text-[10px] font-black uppercase brutalist-shadow-sm">
                        LOCKED
                    </div>
                </div>
            </div>

            <!-- Max Tier Message -->
            <div id="modal-max-message" class="p-8 bg-gray-50 hidden text-center">
                <span class="text-3xl block mb-2">🚀</span>
                <span class="text-sm font-black uppercase text-purple-600 tracking-widest">You have reached the highest tier for this category!</span>
            </div>
        </div>
    </div>

    <script>
        const allAchData = [
            <c:forEach var="a" items="${allAchievements}" varStatus="status">
                {
                    id: ${a.achievement_id},
                    name: "${a.name}",
                    desc: "${a.description}",
                    icon: "${a.icon}",
                    color: "${a.badge_color}",
                    type: "${a.milestone_type}",
                    value: ${a.milestone_value},
                    unlocked: ${a.is_unlocked}
                }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        function switchTab(tab) {
            const unlockedBtn = document.getElementById('tab-unlocked');
            const lockedBtn = document.getElementById('tab-locked');
            const unlockedContent = document.getElementById('content-unlocked');
            const lockedContent = document.getElementById('content-locked');

            if (tab === 'unlocked') {
                unlockedBtn.className = 'flex-1 p-6 text-xl md:text-2xl font-black uppercase tracking-tighter tab-active transition-colors flex items-center justify-center gap-3';
                lockedBtn.className = 'flex-1 p-6 text-xl md:text-2xl font-black uppercase tracking-tighter tab-inactive transition-colors flex items-center justify-center gap-3';
                
                unlockedContent.classList.remove('hidden');
                lockedContent.classList.add('hidden');
            } else {
                lockedBtn.className = 'flex-1 p-6 text-xl md:text-2xl font-black uppercase tracking-tighter tab-active transition-colors flex items-center justify-center gap-3';
                unlockedBtn.className = 'flex-1 p-6 text-xl md:text-2xl font-black uppercase tracking-tighter tab-inactive transition-colors flex items-center justify-center gap-3';
                
                lockedContent.classList.remove('hidden');
                unlockedContent.classList.add('hidden');
            }
        }

        function openModal(id) {
            const curr = allAchData.find(a => a.id === id);
            if (!curr) return;

            // find next mission
            const nextMissions = allAchData.filter(a => a.type === curr.type && a.value > curr.value);
            nextMissions.sort((a,b) => a.value - b.value);
            const next = nextMissions.length > 0 ? nextMissions[0] : null;

            // populate modal
            document.getElementById('modal-bg-icon').innerText = curr.icon;
            document.getElementById('modal-curr-icon').innerText = curr.icon;
            document.getElementById('modal-curr-name').innerText = curr.name;
            document.getElementById('modal-curr-desc').innerText = curr.desc;

            if (next) {
                document.getElementById('modal-next-section').style.display = 'block';
                document.getElementById('modal-max-message').style.display = 'none';
                
                document.getElementById('modal-next-icon').innerText = next.icon;
                document.getElementById('modal-next-name').innerText = next.name;
                
                let goalText = "Goal: ";
                if (next.type === 'booking') goalText += next.value + " Bookings";
                else if (next.type === 'community') goalText += "Join " + next.value + " Squads";
                else if (next.type === 'community_created') goalText += "Create " + next.value + " Squads";
                else if (next.type === 'premium') goalText += "Premium Status";
                
                document.getElementById('modal-next-goal').innerText = goalText;
            } else {
                document.getElementById('modal-next-section').style.display = 'none';
                document.getElementById('modal-max-message').style.display = 'block';
            }

            document.getElementById('achievement-modal').classList.remove('hidden');
        }

        function closeModal() {
            document.getElementById('achievement-modal').classList.add('hidden');
        }
    </script>
</body>
</html>
