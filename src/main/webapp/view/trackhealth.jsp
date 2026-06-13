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
    <title>Track Health - PadelApp</title>
    
    <!-- Google Fonts: Inter & Outfit -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Outfit:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .border-grid {
            border-color: #e5e5e5;
        }
        body {
            font-family: 'Inter', sans-serif;
            background-color: #FCFCFC;
        }
        .neobrutalism-shadow {
            box-shadow: 6px 6px 0px 0px rgba(0,0,0,1);
        }
        .neobrutalism-shadow-hover:hover {
            box-shadow: 2px 2px 0px 0px rgba(0,0,0,1);
            transform: translate(4px, 4px);
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
<body class="bg-[#FCFCFC] text-black min-h-screen flex flex-col antialiased">
    <header class="flex border-b border-grid bg-white sticky top-0 z-50">
        <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
            <span class="text-[10px] font-bold uppercase block opacity-50 md:text-xs">01 / Padel Management</span>
            <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">
                Padel<span class="text-blue-400">App</span>
            </h1>
        </div>
        <div class="flex-1 border-r border-grid hidden md:flex items-center px-8 bg-white">
            <a href="${pageContext.request.contextPath}/index.jsp" class="text-xs font-bold uppercase tracking-widest hover:underline flex items-center gap-1">
                ← Back to Dashboard
            </a>
        </div>
        <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4 md:gap-6 bg-white">
            <div class="flex items-center gap-2">
                <div class="w-8 h-8 rounded-full bg-black text-white flex items-center justify-center font-bold uppercase text-xs shadow-sm">
                    <%= initial %>
                </div>
                <span class="hidden lg:inline text-[10px] font-bold uppercase tracking-widest text-zinc-600">
                    @<%= uname %>
                </span>
            </div>
        </div>
    </header>

    <main class="flex-1 p-6 md:p-10 max-w-7xl w-full mx-auto space-y-8">
        
        <!-- Welcome & Status Banner -->
        <div class="flex flex-col md:flex-row md:items-end justify-between gap-6 pb-6 border-b border-grid">
            <div>
                <h1 class="text-5xl font-black uppercase italic tracking-tighter leading-none">Track Health</h1>
                <p class="text-zinc-500 font-bold uppercase text-xs mt-3 tracking-widest flex items-center gap-2">
                    <span class="w-1.5 h-1.5 bg-rose-500 rounded-full"></span>
                    Monitor workouts, daily steps, BMI and evaluate your performance score.
                </p>
            </div>
            <div class="flex flex-wrap gap-3">
                <button onclick="openModal('profileModal')" class="bg-white text-black border-2 border-black px-5 py-2.5 text-xs font-black uppercase tracking-widest rounded-xl hover:bg-gray-50 transition-all active:scale-95 shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
                    Update Profile
                </button>
                <button onclick="openModal('sessionModal')" class="bg-rose-400 text-black border-2 border-black px-5 py-2.5 text-xs font-black uppercase tracking-widest rounded-xl hover:bg-rose-500 transition-all active:scale-95 shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
                    Log Padel Session
                </button>
                <button onclick="openModal('metricModal')" class="bg-emerald-400 text-black border-2 border-black px-5 py-2.5 text-xs font-black uppercase tracking-widest rounded-xl hover:bg-emerald-500 transition-all active:scale-95 shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
                    Log Daily Metric
                </button>
            </div>
        </div>

        <c:if test="${not empty param.status}">
            <c:choose>
                <c:when test="${param.status eq 'profile_updated'}">
                    <div class="p-4 border-2 border-black rounded-xl bg-emerald-100 text-emerald-900 font-bold text-xs uppercase tracking-wider neobrutalism-shadow flex justify-between items-center">
                        <span>✓ Physical profile successfully updated!</span>
                        <button onclick="this.parentElement.remove()" class="font-bold">×</button>
                    </div>
                </c:when>
                <c:when test="${param.status eq 'session_logged'}">
                    <div class="p-4 border-2 border-black rounded-xl bg-rose-100 text-rose-900 font-bold text-xs uppercase tracking-wider neobrutalism-shadow flex justify-between items-center">
                        <span>✓ New Padel session logged successfully!</span>
                        <button onclick="this.parentElement.remove()" class="font-bold">×</button>
                    </div>
                </c:when>
                <c:when test="${param.status eq 'metric_logged'}">
                    <div class="p-4 border-2 border-black rounded-xl bg-emerald-100 text-emerald-900 font-bold text-xs uppercase tracking-wider neobrutalism-shadow flex justify-between items-center">
                        <span>✓ Daily health metrics updated successfully!</span>
                        <button onclick="this.parentElement.remove()" class="font-bold">×</button>
                    </div>
                </c:when>
                <c:when test="${param.status eq 'invalid_time'}">
                    <div class="p-4 border-2 border-black rounded-xl bg-rose-100 text-rose-900 font-bold text-xs uppercase tracking-wider neobrutalism-shadow flex justify-between items-center">
                        <span>⚠ Error: End time must be after start time!</span>
                        <button onclick="this.parentElement.remove()" class="font-bold">×</button>
                    </div>
                </c:when>
                <c:when test="${param.status eq 'error'}">
                    <div class="p-4 border-2 border-black rounded-xl bg-rose-100 text-rose-900 font-bold text-xs uppercase tracking-wider neobrutalism-shadow flex justify-between items-center">
                        <span>⚠ Error: Something went wrong processing your request!</span>
                        <button onclick="this.parentElement.remove()" class="font-bold">×</button>
                    </div>
                </c:when>
            </c:choose>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            
            <div class="space-y-8 lg:col-span-1">
                <div class="border-4 border-black p-8 rounded-3xl bg-white shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] text-center relative overflow-hidden group">
                    <div class="absolute -right-4 -top-4 w-24 h-24 bg-rose-100 rounded-full opacity-50 group-hover:scale-110 transition-transform"></div>
                    <span class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block mb-2">Fitness Performance Score</span>
                    
                    <div class="relative inline-flex items-center justify-center mb-4">
                        <!-- Big Score Value -->
                        <div class="text-6xl font-black tracking-tighter text-black uppercase italic">
                            <fmt:formatNumber value="${performanceScore.fitnessScore}" maxFractionDigits="1" />%
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <c:choose>
                            <c:when test="${performanceScore.category eq 'Excellent'}">
                                <span class="px-4 py-1.5 bg-emerald-400 border-2 border-black text-xs font-black uppercase tracking-wider rounded-full shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]">
                                    Excellent
                                </span>
                            </c:when>
                            <c:when test="${performanceScore.category eq 'Good'}">
                                <span class="px-4 py-1.5 bg-cyan-300 border-2 border-black text-xs font-black uppercase tracking-wider rounded-full shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]">
                                    Good
                                </span>
                            </c:when>
                            <c:when test="${performanceScore.category eq 'Average'}">
                                <span class="px-4 py-1.5 bg-amber-400 border-2 border-black text-xs font-black uppercase tracking-wider rounded-full shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]">
                                    Average
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="px-4 py-1.5 bg-rose-400 border-2 border-black text-xs font-black uppercase tracking-wider rounded-full shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]">
                                    Poor
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <p class="text-xs text-gray-500 font-semibold leading-relaxed px-2">
                        Calculated from your workout consistency, daily steps, resting heart rate, and BMI normality. Keep moving!
                    </p>
                </div>

                <!-- Physical profile & BMI card -->
                <div class="border-4 border-black p-8 rounded-3xl bg-white shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
                    <h3 class="font-black uppercase italic text-lg tracking-tighter mb-6 flex items-center gap-2">
                        <span class="w-3.5 h-3.5 bg-rose-400 rounded-full border-2 border-black"></span>
                        Physical Stats & BMI
                    </h3>
                    <div class="space-y-4">
                        <div class="flex justify-between border-b border-gray-100 pb-2">
                            <span class="text-xs font-bold text-gray-400 uppercase">Age</span>
                            <span class="text-sm font-black">${user.age > 0 ? user.age : 'Not set'} Years</span>
                        </div>
                        <div class="flex justify-between border-b border-gray-100 pb-2">
                            <span class="text-xs font-bold text-gray-400 uppercase">Weight</span>
                            <span class="text-sm font-black">${user.weight > 0 ? user.weight : 'Not set'} kg</span>
                        </div>
                        <div class="flex justify-between border-b border-gray-100 pb-2">
                            <span class="text-xs font-bold text-gray-400 uppercase">Height</span>
                            <span class="text-sm font-black">${user.height > 0 ? user.height : 'Not set'} cm</span>
                        </div>
                        <div class="flex justify-between items-center pt-2">
                            <span class="text-xs font-bold text-gray-400 uppercase">Calculated BMI</span>
                            <div class="text-right">
                                <span class="text-lg font-black block leading-none">
                                    <fmt:formatNumber value="${bmi}" maxFractionDigits="1" />
                                </span>
                                <span class="text-[9px] font-black uppercase text-zinc-500">
                                    <c:choose>
                                        <c:when test="${bmi <= 0}">Not set</c:when>
                                        <c:when test="${bmi < 18.5}">Underweight</c:when>
                                        <c:when test="${bmi < 25}">Normal Weight</c:when>
                                        <c:when test="${bmi < 30}">Overweight</c:when>
                                        <c:otherwise>Obese</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Column 2 & 3: Workout Summary & Historical Data Logs -->
            <div class="lg:col-span-2 space-y-8">
                
                <!-- Quick Stats Grid -->
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
                    <!-- Stat 1: Total Sessions -->
                    <div class="border-4 border-black p-6 rounded-2xl bg-white shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] relative overflow-hidden">
                        <span class="text-[9px] font-black text-gray-400 uppercase tracking-widest block mb-1">Total Padel Sessions</span>
                        <span class="text-3xl font-black block leading-none italic">${activitySummary.totalSessions} Sessions</span>
                        <span class="text-[10px] text-gray-400 block mt-2 font-semibold">Active play log history</span>
                    </div>

                    <!-- Stat 2: Total Duration -->
                    <div class="border-4 border-black p-6 rounded-2xl bg-white shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] relative overflow-hidden">
                        <span class="text-[9px] font-black text-gray-400 uppercase tracking-widest block mb-1">Total Duration</span>
                        <span class="text-3xl font-black block leading-none italic">${activitySummary.totalDuration} Mins</span>
                        <span class="text-[10px] text-gray-400 block mt-2 font-semibold">Time spent on the court</span>
                    </div>

                    <!-- Stat 3: Calories Burned -->
                    <div class="border-4 border-black p-6 rounded-2xl bg-white shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] relative overflow-hidden">
                        <span class="text-[9px] font-black text-gray-400 uppercase tracking-widest block mb-1">Workout Calories</span>
                        <span class="text-3xl font-black block leading-none italic text-rose-500">${activitySummary.totalCalories} Kcal</span>
                        <span class="text-[10px] text-gray-400 block mt-2 font-semibold">Estimated calories burned</span>
                    </div>
                </div>

                <!-- Tabs & Tables for Health Logs -->
                <div class="border-4 border-black rounded-3xl bg-white shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] overflow-hidden">
                    <!-- Tab headers -->
                    <div class="flex border-b-4 border-black">
                        <button onclick="switchTab('sessionsTab', 'metricsTab', this)" class="flex-1 text-center py-4 font-black uppercase text-xs tracking-wider border-r-4 border-black bg-rose-300 transition-colors" id="sessionsTabBtn">
                            Recent Workouts
                        </button>
                        <button onclick="switchTab('metricsTab', 'sessionsTab', this)" class="flex-1 text-center py-4 font-black uppercase text-xs tracking-wider bg-gray-50 hover:bg-gray-100 transition-colors" id="metricsTabBtn">
                            Daily Health Metrics
                        </button>
                    </div>

                    <!-- Sessions Tab Contents -->
                    <div id="sessionsTab" class="p-6">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="text-gray-400 font-black uppercase text-[10px] tracking-wider border-b-2 border-gray-150">
                                        <th class="pb-3">Date</th>
                                        <th class="pb-3">Time Range</th>
                                        <th class="pb-3">Duration</th>
                                        <th class="pb-3">Avg Heart Rate</th>
                                        <th class="pb-3">Calories</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-100 text-sm font-semibold text-zinc-700">
                                    <c:choose>
                                        <c:when test="${empty recentSessions}">
                                            <tr>
                                                <td colspan="5" class="py-8 text-center text-gray-400 italic font-medium">No workout sessions logged. Get on the court!</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="sessionObj" items="${recentSessions}">
                                                <tr>
                                                    <td class="py-3.5">
                                                        <fmt:formatDate value="${sessionObj.startTime}" pattern="dd MMM yyyy" />
                                                    </td>
                                                    <td class="py-3.5 text-zinc-500">
                                                        <fmt:formatDate value="${sessionObj.startTime}" pattern="HH:mm" /> - <fmt:formatDate value="${sessionObj.endTime}" pattern="HH:mm" />
                                                    </td>
                                                    <td class="py-3.5 font-black text-black">${sessionObj.durationMinutes} mins</td>
                                                    <td class="py-3.5">${sessionObj.avgHeartRate} bpm</td>
                                                    <td class="py-3.5 font-bold text-rose-500">${sessionObj.caloriesBurned} kcal</td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Metrics Tab Contents -->
                    <div id="metricsTab" class="p-6 hidden">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="text-gray-400 font-black uppercase text-[10px] tracking-wider border-b-2 border-gray-150">
                                        <th class="pb-3">Record Date</th>
                                        <th class="pb-3">Resting HR</th>
                                        <th class="pb-3">BMI</th>
                                        <th class="pb-3">Steps Taken</th>
                                        <th class="pb-3">Daily Burn</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-100 text-sm font-semibold text-zinc-700">
                                    <c:choose>
                                        <c:when test="${empty recentMetrics}">
                                            <tr>
                                                <td colspan="5" class="py-8 text-center text-gray-400 italic font-medium">No daily metrics recorded. Log steps and pulse to track score.</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="metricObj" items="${recentMetrics}">
                                                <tr>
                                                    <td class="py-3.5">
                                                        <fmt:formatDate value="${metricObj.recordDate}" pattern="dd MMM yyyy" />
                                                    </td>
                                                    <td class="py-3.5">${metricObj.restingHeartRate} bpm</td>
                                                    <td class="py-3.5">
                                                        <fmt:formatNumber value="${metricObj.bmi}" maxFractionDigits="1" />
                                                    </td>
                                                    <td class="py-3.5 font-black text-black">
                                                        <fmt:formatNumber value="${metricObj.totalSteps}" /> steps
                                                    </td>
                                                    <td class="py-3.5 font-bold text-emerald-600">${metricObj.caloriesDaily} kcal</td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>

            </div>
        </div>

    </main>

    <!-- MODAL 1: Update Physical Profile -->
    <div id="profileModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/60 hidden backdrop-blur-sm p-4">
        <div class="w-full max-w-md bg-white border-4 border-black p-8 rounded-3xl neobrutalism-shadow">
            <div class="flex justify-between items-center mb-6">
                <h3 class="text-2xl font-black uppercase italic tracking-tighter">Edit Physical profile</h3>
                <button onclick="closeModal('profileModal')" class="text-2xl font-black hover:scale-110 transition-transform">×</button>
            </div>
            <form action="${pageContext.request.contextPath}/TrackHealth" method="POST" class="space-y-4 text-left">
                <input type="hidden" name="action" value="updateProfile">
                <div>
                    <label class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block mb-1">Age (Years)</label>
                    <input type="number" name="age" value="${user.age}" required min="1" max="120" class="w-full px-4 py-3 border-2 border-black rounded-xl text-sm font-semibold outline-none focus:bg-zinc-50">
                </div>
                <div>
                    <label class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block mb-1">Weight (kg)</label>
                    <input type="number" step="0.1" name="weight" value="${user.weight}" required min="10" max="300" class="w-full px-4 py-3 border-2 border-black rounded-xl text-sm font-semibold outline-none focus:bg-zinc-50">
                </div>
                <div>
                    <label class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block mb-1">Height (cm)</label>
                    <input type="number" step="0.1" name="height" value="${user.height}" required min="50" max="250" class="w-full px-4 py-3 border-2 border-black rounded-xl text-sm font-semibold outline-none focus:bg-zinc-50">
                </div>
                <button type="submit" class="w-full py-4 bg-black text-white font-black uppercase tracking-widest text-xs rounded-xl border-2 border-black hover:bg-zinc-800 transition-colors shadow-sm">
                    Save profile
                </button>
            </form>
        </div>
    </div>

    <!-- MODAL 2: Log Padel Session -->
    <div id="sessionModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/60 hidden backdrop-blur-sm p-4">
        <div class="w-full max-w-md bg-white border-4 border-black p-8 rounded-3xl neobrutalism-shadow">
            <div class="flex justify-between items-center mb-6">
                <h3 class="text-2xl font-black uppercase italic tracking-tighter text-rose-500">Log Padel Session</h3>
                <button onclick="closeModal('sessionModal')" class="text-2xl font-black hover:scale-110 transition-transform">×</button>
            </div>
            <form action="${pageContext.request.contextPath}/TrackHealth" method="POST" class="space-y-4 text-left">
                <input type="hidden" name="action" value="logSession">
                <div>
                    <label class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block mb-1">Start Time</label>
                    <input type="datetime-local" id="startTimeInput" name="startTime" required class="w-full px-4 py-3 border-2 border-black rounded-xl text-sm font-semibold outline-none focus:bg-zinc-50">
                </div>
                <div>
                    <label class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block mb-1">End Time</label>
                    <input type="datetime-local" id="endTimeInput" name="endTime" required class="w-full px-4 py-3 border-2 border-black rounded-xl text-sm font-semibold outline-none focus:bg-zinc-50">
                </div>
                <div>
                    <label class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block mb-1">Average Heart Rate (bpm)</label>
                    <input type="number" step="1" name="avgHeartRate" placeholder="e.g. 145" required min="50" max="220" class="w-full px-4 py-3 border-2 border-black rounded-xl text-sm font-semibold outline-none focus:bg-zinc-50">
                </div>
                <button type="submit" class="w-full py-4 bg-rose-400 text-black font-black uppercase tracking-widest text-xs rounded-xl border-2 border-black hover:bg-rose-500 transition-colors shadow-sm">
                    Submit Workout
                </button>
            </form>
        </div>
    </div>

    <!-- MODAL 3: Log Health Metric -->
    <div id="metricModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/60 hidden backdrop-blur-sm p-4">
        <div class="w-full max-w-md bg-white border-4 border-black p-8 rounded-3xl neobrutalism-shadow">
            <div class="flex justify-between items-center mb-6">
                <h3 class="text-2xl font-black uppercase italic tracking-tighter text-emerald-500">Log Daily Health Metric</h3>
                <button onclick="closeModal('metricModal')" class="text-2xl font-black hover:scale-110 transition-transform">×</button>
            </div>
            <form action="${pageContext.request.contextPath}/TrackHealth" method="POST" class="space-y-4 text-left">
                <input type="hidden" name="action" value="logMetric">
                <div>
                    <label class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block mb-1">Record Date</label>
                    <input type="date" id="recordDateInput" name="recordDate" required class="w-full px-4 py-3 border-2 border-black rounded-xl text-sm font-semibold outline-none focus:bg-zinc-50">
                </div>
                <div>
                    <label class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block mb-1">Resting Heart Rate (bpm)</label>
                    <input type="number" name="restingHeartRate" placeholder="e.g. 65" required min="40" max="120" class="w-full px-4 py-3 border-2 border-black rounded-xl text-sm font-semibold outline-none focus:bg-zinc-50">
                </div>
                <div>
                    <label class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block mb-1">Total Steps</label>
                    <input type="number" name="totalSteps" placeholder="e.g. 8500" required min="0" max="100000" class="w-full px-4 py-3 border-2 border-black rounded-xl text-sm font-semibold outline-none focus:bg-zinc-50">
                </div>
                <div>
                    <label class="text-[10px] font-black uppercase tracking-wider text-zinc-400 block mb-1">Total Daily Calories Burned (kcal)</label>
                    <input type="number" name="caloriesDaily" placeholder="e.g. 2100" required min="500" max="8000" class="w-full px-4 py-3 border-2 border-black rounded-xl text-sm font-semibold outline-none focus:bg-zinc-50">
                </div>
                <button type="submit" class="w-full py-4 bg-emerald-400 text-black font-black uppercase tracking-widest text-xs rounded-xl border-2 border-black hover:bg-emerald-500 transition-colors shadow-sm">
                    Submit metrics
                </button>
            </form>
        </div>
    </div>

    <!-- Script for interactive actions -->
    <script>
        function openModal(id) {
            const modal = document.getElementById(id);
            if (modal) {
                // Set default dates/times where relevant
                const now = new Date();
                if (id === 'sessionModal') {
                    // Set default start time to 1 hour ago and end time to now
                    const oneHourAgo = new Date(now.getTime() - 60 * 60 * 1000);
                    document.getElementById('startTimeInput').value = formatDatetimeLocal(oneHourAgo);
                    document.getElementById('endTimeInput').value = formatDatetimeLocal(now);
                } else if (id === 'metricModal') {
                    // Set default record date to today
                    document.getElementById('recordDateInput').value = formatDateISO(now);
                }
                modal.classList.remove('hidden');
            }
        }

        function closeModal(id) {
            const modal = document.getElementById(id);
            if (modal) {
                modal.classList.add('hidden');
            }
        }

        function formatDatetimeLocal(date) {
            const ten = function (i) { return (i < 10 ? '0' : '') + i; };
            const YYYY = date.getFullYear();
            const MM = ten(date.getMonth() + 1);
            const DD = ten(date.getDate());
            const HH = ten(date.getHours());
            const II = ten(date.getMinutes());
            return YYYY + '-' + MM + '-' + DD + 'T' + HH + ':' + II;
        }

        function formatDateISO(date) {
            const ten = function (i) { return (i < 10 ? '0' : '') + i; };
            const YYYY = date.getFullYear();
            const MM = ten(date.getMonth() + 1);
            const DD = ten(date.getDate());
            return YYYY + '-' + MM + '-' + DD;
        }

        function switchTab(activeId, inactiveId, activeBtn) {
            document.getElementById(activeId).classList.remove('hidden');
            document.getElementById(inactiveId).classList.add('hidden');
            
            // Stylings for buttons
            const activeBtnId = activeId + 'Btn';
            const inactiveBtnId = inactiveId + 'Btn';
            
            const ab = document.getElementById(activeBtnId);
            const ib = document.getElementById(inactiveBtnId);
            
            ab.classList.remove('bg-gray-50', 'hover:bg-gray-100');
            ab.classList.add('bg-rose-300', 'border-r-4', 'border-black');
            
            ib.classList.remove('bg-rose-300', 'border-r-4', 'border-black');
            ib.classList.add('bg-gray-50', 'hover:bg-gray-100');
        }
    </script>
</body>
</html>
