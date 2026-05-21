<%-- 
    Document   : score
    Created on : 5 May 2026, 13.16.59
    Author     : Faizul Afiat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Live Score Counter - PadelApp</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100 min-h-screen flex flex-col">

        <%-- Header --%>
        <header class="flex border-b border-black bg-white sticky top-0 z-50">
            <div class="p-4 md:p-6 border-r border-black w-1/2 md:w-1/4">
                <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">Padel<span class="text-cyan-400">App</span></h1>
            </div>
            <div class="flex-1 border-r border-black flex items-center px-8">
                <a href="${pageContext.request.contextPath}/MatchSetup" class="text-xs font-black uppercase tracking-widest hover:underline">← Exit Match</a>
            </div>
            <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-2">
                <span class="text-[10px] font-black bg-black text-white px-3 py-1 rounded-full uppercase" id="mode-badge">MODE</span>
            </div>
        </header>\

        <div class="flex-1 p-6 pb-20 flex flex-col items-center max-w-4xl w-full mx-auto">

            <div class="text-center mb-8">
                <h1 class="text-4xl font-black uppercase tracking-tighter italic">Live Arena</h1>
                <p id="mode-desc" class="text-xs font-bold text-gray-400 uppercase tracking-widest mt-2"></p>
            </div>

            <%-- Score Display --%>
            <div class="flex flex-col md:flex-row gap-8 w-full mb-12">
                <div class="flex-1 bg-black text-white p-8 rounded-[2.5rem] border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] flex flex-col items-center">
                    <span class="text-xs font-black uppercase tracking-widest text-cyan-400 mb-2">Team 1</span>
                    <div id="scoreTim1" class="text-9xl font-black italic tabular-nums text-cyan-400">0</div>
                    <button id="btnTim1" onclick="addScore(1)" class="mt-8 w-full bg-cyan-400 text-black font-black py-4 rounded-2xl border-2 border-black shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-1 hover:translate-y-1 active:scale-95 transition-all uppercase italic text-lg">+ Point</button>
                </div>

                <div class="flex-1 bg-white p-8 rounded-[2.5rem] border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] flex flex-col items-center">
                    <span class="text-xs font-black uppercase tracking-widest text-gray-400 mb-2">Team 2</span>
                    <div id="scoreTim2" class="text-9xl font-black italic tabular-nums text-black">0</div>
                    <button id="btnTim2" onclick="addScore(2)" class="mt-8 w-full bg-black text-white font-black py-4 rounded-2xl border-2 border-black shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-1 hover:translate-y-1 active:scale-95 transition-all uppercase italic text-lg">+ Point</button>
                </div>
            </div>

            <%-- Match History Timeline Log --%>
            <div class="w-full bg-white border-4 border-black rounded-[2.5rem] p-8 shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] mb-8">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="font-black uppercase italic text-2xl flex items-center gap-3">Match Logs</h3>
                    <span id="match-status" class="text-xs font-black bg-yellow-400 border-2 border-black px-4 py-1 rounded-full uppercase tracking-wider">In Progress</span>
                </div>
                <div id="historyList" class="space-y-4 max-h-[200px] overflow-y-auto pr-2">
                    <div class="text-center py-10 border-4 border-dashed border-gray-200 rounded-3xl">
                        <p class="text-gray-400 font-black uppercase text-xs tracking-widest">Awaiting First Serve...</p>
                    </div>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/SaveScoreController" method="POST" class="w-full flex gap-4">
                <input type="hidden" name="booking_id" value="${param.booking_id}">
                <input type="hidden" name="scoring_style" value="${param.scoring_style}">
                <input type="hidden" name="p1_tim1" value="${param.p1_tim1}">
                <input type="hidden" name="p2_tim1" value="${param.p2_tim1}">
                <input type="hidden" name="p1_tim2" value="${param.p1_tim2}">
                <input type="hidden" name="p2_tim2" value="${param.p2_tim2}">

                <input type="hidden" id="input_skor_tim1" name="skor_tim1" value="0">
                <input type="hidden" id="input_skor_tim2" name="skor_tim2" value="0">

                <button type="button" onclick="resetMatch()" class="w-1/3 border-4 border-black bg-gray-200 py-4 rounded-2xl font-black uppercase text-xs">Reset Board</button>
                <button type="submit" id="btnSubmitMatch" disabled class="w-2/3 border-4 border-black bg-green-400 py-4 rounded-2xl font-black uppercase opacity-30 cursor-not-allowed text-xs transition-all">Submit Final Score</button>
            </form>
        </div>

        <script>
            const urlParams = new URLSearchParams(window.location.search);
            const scoringStyle = urlParams.get('scoring_style') || 'AMERICANO';
            const maxAmericanoPoints = 32;

            let scoreTim1 = 0;
            let scoreTim2 = 0;
            let setTim1 = 0;
            let setTim2 = 0;
            let logHistory = [];
            const tennisPoints = ["0", "15", "30", "40", "ADV", "GAME"];

            document.getElementById('mode-badge').innerText = scoringStyle;
            document.getElementById('mode-desc').innerText = scoringStyle === "AMERICANO"
                    ? "First to reach 32 points total wins"
                    : "Traditional system. Win games to secure victory";

            function addScore(team) {
                if (scoringStyle === "AMERICANO") {
                    if (scoreTim1 + scoreTim2 >= maxAmericanoPoints)
                        return;
                    if (team === 1)
                        scoreTim1++;
                    else
                        scoreTim2++;
                    addLog(team === 1 ? "Team 1 scores!" : "Team 2 scores!");

                    if ((scoreTim1 + scoreTim2) === maxAmericanoPoints)
                        triggerMatchFinished();
                } else {
                    if (team === 1) {
                        if (scoreTim1 === 3 && scoreTim2 === 3)
                            scoreTim1 = 4;
                        else if (scoreTim1 === 3 && scoreTim2 === 4)
                            scoreTim2 = 3;
                        else
                            scoreTim1++;
                    } else {
                        if (scoreTim2 === 3 && scoreTim1 === 3)
                            scoreTim2 = 4;
                        else if (scoreTim2 === 3 && scoreTim1 === 4)
                            scoreTim1 = 3;
                        else
                            scoreTim2++;
                    }

                    if (scoreTim1 === 5 || (scoreTim1 === 4 && scoreTim2 < 3)) {
                        setTim1++;
                        addLog("Team 1 wins a Game Set!");
                        scoreTim1 = 0;
                        scoreTim2 = 0;
                    } else if (scoreTim2 === 5 || (scoreTim2 === 4 && scoreTim1 < 3)) {
                        setTim2++;
                        addLog("Team 2 wins a Game Set!");
                        scoreTim1 = 0;
                        scoreTim2 = 0;
                    }

                    // Pada sistem Tradisional, tombol selesai bisa diaktifkan secara manual kapan pun oleh admin
                    triggerMatchFinished();
                }
                updateInterface();
            }

            function updateInterface() {
                if (scoringStyle === "AMERICANO") {
                    document.getElementById('scoreTim1').innerText = scoreTim1;
                    document.getElementById('scoreTim2').innerText = scoreTim2;
                    document.getElementById('input_skor_tim1').value = scoreTim1;
                    document.getElementById('input_skor_tim2').value = scoreTim2;
                } else {
                    document.getElementById('scoreTim1').innerText = tennisPoints[scoreTim1];
                    document.getElementById('scoreTim2').innerText = tennisPoints[scoreTim2];
                    document.getElementById('input_skor_tim1').value = setTim1; // Yang disubmit jumlah set-nya
                    document.getElementById('input_skor_tim2').value = setTim2;
                }
                renderLog();
            }

            function triggerMatchFinished() {
                document.getElementById('match-status').innerText = "Match Concluded";
                document.getElementById('match-status').className = "text-xs font-black bg-green-400 border-2 border-black px-4 py-1 rounded-full uppercase text-black animate-pulse";

                const btn = document.getElementById('btnSubmitMatch');
                btn.disabled = false;
                btn.className = "w-2/3 border-4 border-black bg-green-400 py-4 rounded-2xl font-black uppercase text-xs text-black shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-1 hover:translate-y-1 transition-all";
            }

            function addLog(event) {
                const now = new Date();
                const time = now.getHours().toString().padStart(2, '0') + ":" + now.getMinutes().toString().padStart(2, '0');
                logHistory.unshift({time: time, event: event, currentScore: scoringStyle === "AMERICANO" ? (scoreTim1 + " - " + scoreTim2) : (setTim1 + " - " + setTim2)});
            }

            function renderLog() {
                const container = document.getElementById('historyList');
                if (logHistory.length === 0)
                    return;

                let htmlResult = "";
                for (let i = 0; i < logHistory.length; i++) {
                    let item = logHistory[i];

                    let colorClass = "text-black";
                    if (item.event.indexOf('Team 1') !== -1) {
                        colorClass = "text-cyan-600";
                    }

                    htmlResult += '<div class="flex items-center gap-4 mb-3">';
                    htmlResult += '  <div class="text-[10px] font-black text-gray-400 w-12">' + item.time + '</div>';
                    htmlResult += '  <div class="relative flex-1 bg-gray-50 border-2 border-black p-3 rounded-xl flex justify-between items-center">';
                    htmlResult += '    <div class="absolute -left-[9px] w-4 h-4 bg-black rounded-full border-4 border-white"></div>';
                    htmlResult += '    <div class="flex flex-col text-left">';
                    htmlResult += '      <span class="text-[9px] font-black text-gray-400 uppercase tracking-wider">Match Event</span>';
                    htmlResult += '      <span class="font-black text-xs uppercase italic ' + colorClass + '">' + item.event + '</span>';
                    htmlResult += '    </div>';
                    htmlResult += '    <div class="flex flex-col items-end">';
                    htmlResult += '      <span class="text-[9px] font-black text-gray-400 uppercase tracking-wider">Score</span>';
                    htmlResult += '      <span class="font-black text-xs tabular-nums bg-black text-white px-2 py-0.5 rounded">' + item.currentScore + '</span>';
                    htmlResult += '    </div>';
                    htmlResult += '  </div>';
                    htmlResult += '</div>';
                }

                container.innerHTML = htmlResult;
            }

            function resetMatch() {
                if (confirm("Reset current match board?")) {
                    window.location.reload();
                }
            }
        </script>
    </body>
</html>