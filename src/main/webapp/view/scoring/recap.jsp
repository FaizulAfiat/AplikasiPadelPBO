<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Match Recap - PadelApp</title>
            <script src="https://cdn.tailwindcss.com"></script>
        </head>

        <body class="bg-gray-100 min-h-screen flex flex-col font-sans">

            <%-- Header --%>
                <header class="flex border-b border-gray-200 bg-white sticky top-0 z-50">
                    <div class="p-4 md:p-6 border-r border-gray-200 w-1/2 md:w-1/4">
                        <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">Padel<span
                                class="text-blue-400">App</span></h1>
                    </div>
                    <div class="flex-1 border-r border-gray-200 flex items-center px-8">
                        <a href="${pageContext.request.contextPath}/index.jsp"
                            class="text-xs font-bold uppercase tracking-widest text-gray-600 hover:text-black hover:underline transition-colors">←
                            Dashboard</a>
                    </div>
                    <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-2">
                        <span
                            class="text-[10px] font-bold bg-gray-100 text-gray-800 border border-gray-200 px-3 py-1.5 rounded-full uppercase"
                            id="mode-badge">${scoringStyle}</span>
                    </div>
                </header>

                <div class="flex-1 p-6 pb-20 flex flex-col items-center max-w-4xl w-full mx-auto justify-center">

                    <div class="text-center mb-8">
                        <span
                            class="text-xs font-bold bg-gray-100 text-gray-800 border border-gray-200 px-4 py-1.5 rounded-full uppercase tracking-widest">Match
                            #${matchId}</span>
                        <h1 class="text-4xl font-black uppercase tracking-tighter italic mt-4">Match Recap</h1>
                        <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mt-2">The match has been
                            successfully saved to history</p>
                    </div>

                    <%-- Winner Announcement Banner --%>
                        <div class="w-full mb-8">
                            <c:choose>
                                <c:when test="${winner eq 'TEAM 1 WINS!'}">
                                    <div
                                        class="border border-cyan-200 p-6 rounded-2xl bg-cyan-50 text-cyan-800 font-bold uppercase italic shadow-sm text-center text-2xl md:text-3xl animate-bounce">
                                        🏆 Team 1 Wins!
                                    </div>
                                </c:when>
                                <c:when test="${winner eq 'TEAM 2 WINS!'}">
                                    <div
                                        class="border border-yellow-200 p-6 rounded-2xl bg-yellow-50 text-yellow-800 font-bold uppercase italic shadow-sm text-center text-2xl md:text-3xl animate-bounce">
                                        🏆 Team 2 Wins!
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div
                                        class="border border-gray-200 p-6 rounded-2xl bg-gray-50 text-gray-800 font-bold uppercase italic shadow-sm text-center text-2xl md:text-3xl">
                                        🤝 Draw Match!
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <%-- Score Display --%>
                            <div class="flex flex-col md:flex-row gap-8 w-full mb-12">
                                <%-- Team 1 Card --%>
                                    <div
                                        class="flex-1 bg-gray-900 text-white p-8 rounded-[2.5rem] border border-gray-800 shadow-sm flex flex-col items-center">
                                        <span
                                            class="text-xs font-bold uppercase tracking-widest text-cyan-400 mb-1">Team
                                            1</span>
                                        <span
                                            class="text-xs font-semibold text-gray-400 uppercase mb-4 text-center select-none">
                                            ${team1Players}
                                        </span>
                                        <div class="text-8xl font-black italic tabular-nums text-cyan-400">${skorTim1}
                                        </div>
                                    </div>

                                    <%-- Team 2 Card --%>
                                        <div
                                            class="flex-1 bg-white p-8 rounded-[2.5rem] border border-gray-200 shadow-sm flex flex-col items-center">
                                            <span
                                                class="text-xs font-bold uppercase tracking-widest text-gray-400 mb-1">Team
                                                2</span>
                                            <span
                                                class="text-xs font-semibold text-gray-500 uppercase mb-4 text-center select-none">
                                                ${team2Players}
                                            </span>
                                            <div class="text-8xl font-black italic tabular-nums text-black">${skorTim2}
                                            </div>
                                        </div>
                            </div>

                            <%-- Action Options --%>
                                <div class="flex flex-col sm:flex-row gap-6 w-full max-w-2xl">
                                    <a href="${pageContext.request.contextPath}/MatchSetupController"
                                        class="flex-1 bg-yellow-400 text-black text-center font-bold uppercase tracking-wider py-4 rounded-2xl border border-yellow-500 shadow-sm hover:bg-yellow-500 transition-all italic text-lg">
                                        Scoring Lagi
                                    </a>
                                    <a href="${pageContext.request.contextPath}/index.jsp"
                                        class="flex-1 bg-black text-white text-center font-bold uppercase tracking-wider py-4 rounded-2xl border border-black shadow-sm hover:bg-zinc-800 transition-all italic text-lg">
                                        Dashboard
                                    </a>
                                </div>

                </div>

        </body>

        </html>