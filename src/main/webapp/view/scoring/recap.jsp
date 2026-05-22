<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <header class="flex border-b border-black bg-white sticky top-0 z-50">
            <div class="p-4 md:p-6 border-r border-black w-1/2 md:w-1/4">
                <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">Padel<span class="text-cyan-400">App</span></h1>
            </div>
            <div class="flex-1 border-r border-black flex items-center px-8">
                <a href="${pageContext.request.contextPath}/index.jsp" class="text-xs font-black uppercase tracking-widest hover:underline">← Dashboard</a>
            </div>
            <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-2">
                <span class="text-[10px] font-black bg-black text-white px-3 py-1 rounded-full uppercase" id="mode-badge">${scoringStyle}</span>
            </div>
        </header>

        <div class="flex-1 p-6 pb-20 flex flex-col items-center max-w-4xl w-full mx-auto justify-center">

            <div class="text-center mb-8">
                <span class="text-xs font-black bg-black text-white px-4 py-1.5 rounded-full uppercase tracking-widest">Match #${matchId}</span>
                <h1 class="text-4xl font-black uppercase tracking-tighter italic mt-4">Match Recap</h1>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mt-2">The match has been successfully saved to history</p>
            </div>

            <%-- Winner Announcement Banner --%>
            <div class="w-full mb-8">
                <c:choose>
                    <c:when test="${winner eq 'TEAM 1 WINS!'}">
                        <div class="border-4 border-black p-6 rounded-2xl bg-cyan-400 text-black font-black uppercase italic shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] text-center text-2xl md:text-3xl animate-bounce">
                            🏆 Team 1 Wins!
                        </div>
                    </c:when>
                    <c:when test="${winner eq 'TEAM 2 WINS!'}">
                        <div class="border-4 border-black p-6 rounded-2xl bg-yellow-300 text-black font-black uppercase italic shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] text-center text-2xl md:text-3xl animate-bounce">
                            🏆 Team 2 Wins!
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="border-4 border-black p-6 rounded-2xl bg-gray-300 text-black font-black uppercase italic shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] text-center text-2xl md:text-3xl">
                            🤝 Draw Match!
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- Score Display --%>
            <div class="flex flex-col md:flex-row gap-8 w-full mb-12">
                <%-- Team 1 Card --%>
                <div class="flex-1 bg-black text-white p-8 rounded-[2.5rem] border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] flex flex-col items-center">
                    <span class="text-xs font-black uppercase tracking-widest text-cyan-400 mb-1">Team 1</span>
                    <span class="text-xs font-bold text-gray-400 uppercase mb-4 text-center select-none">
                        ${team1Players}
                    </span>
                    <div class="text-8xl font-black italic tabular-nums text-cyan-400">${skorTim1}</div>
                </div>

                <%-- Team 2 Card --%>
                <div class="flex-1 bg-white p-8 rounded-[2.5rem] border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] flex flex-col items-center">
                    <span class="text-xs font-black uppercase tracking-widest text-gray-400 mb-1">Team 2</span>
                    <span class="text-xs font-bold text-gray-500 uppercase mb-4 text-center select-none">
                        ${team2Players}
                    </span>
                    <div class="text-8xl font-black italic tabular-nums text-black">${skorTim2}</div>
                </div>
            </div>

            <%-- Action Options --%>
            <div class="flex flex-col sm:flex-row gap-6 w-full max-w-2xl">
                <a href="${pageContext.request.contextPath}/MatchSetupController" 
                   class="flex-1 bg-yellow-400 text-black text-center font-black uppercase tracking-wider py-5 rounded-2xl border-4 border-black shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-1 hover:translate-y-1 transition-all italic text-lg">
                    ⚡ Scoring Lagi
                </a>
                <a href="${pageContext.request.contextPath}/index.jsp" 
                   class="flex-1 bg-black text-white text-center font-black uppercase tracking-wider py-5 rounded-2xl border-4 border-black shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-1 hover:translate-y-1 transition-all italic text-lg">
                    🏠 Dashboard
                </a>
            </div>

        </div>

    </body>
</html>
