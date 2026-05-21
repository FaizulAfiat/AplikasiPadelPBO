<%-- 
    Document   : match_setup
    Created on : 19 May 2026, 12.43.58
    Author     : Faizul Afiat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Match Setup - PadelApp</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 min-h-screen flex flex-col m-0 p-0">

        <header class="flex w-full border-b border-gray-200 bg-white sticky top-0 z-50">
            <div class="p-4 md:p-6 border-r border-gray-200 w-1/2 md:w-1/4">
                <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">
                    Padel<span class="text-blue-400">App</span>
                </h1>
            </div>

            <div class="flex-1 border-r border-gray-200 hidden md:flex items-center px-8">
                <a href="${pageContext.request.contextPath}/index.jsp" class="text-xs font-bold uppercase tracking-widest text-gray-600 hover:text-black hover:underline transition-colors">
                    ← Back to Dashboard
                </a>
            </div>

            <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4">
                <span class="text-[10px] font-bold uppercase tracking-widest text-gray-500">
                    <%= session.getAttribute("user") != null ? session.getAttribute("user") : "Admin"%>
                </span>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5 text-gray-700">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                </svg>
            </div>
        </header>

        <%-- MAIN CONTENT WRAPPER: Mendorong konten konfigurasi tepat di tengah sisa layar --%>
        <div class="flex-1 bg-gray-100 flex flex-col items-center justify-center p-6 pb-20 w-full">
            <div class="w-full max-w-4xl bg-white border-4 border-black rounded-[2.5rem] p-10 shadow-[12px_12px_0px_0px_rgba(0,0,0,1)] space-y-8">

                <div>
                    <h1 class="text-4xl font-black uppercase italic tracking-tighter">Match Configuration</h1>
                    <p class="text-gray-400 font-bold uppercase text-[10px] tracking-widest mt-1">Register players into the pool first, then arrange the teams</p>
                </div>

                <%-- 1. GAME MODE SELECTION --%>
                <div class="border-b-4 border-black pb-6">
                    <label class="text-xs font-black uppercase tracking-widest opacity-50 block mb-2">Scoring Style / Game Mode</label>
                    <select id="scoring_style" class="w-full bg-cyan-50 border-4 border-black p-4 rounded-2xl text-xl font-black uppercase italic outline-none cursor-pointer">
                        <option value="AMERICANO">Americano (Accumulative to 32)</option>
                        <option value="TRADITIONAL">Traditional Padel (0 - 15 - 30 - 40 - Game)</option>
                    </select>
                </div>

                <%-- 2. PLAYER REGISTRATION POOL (BAGIAN ATAS) --%>
                <div class="border-4 border-black rounded-3xl p-6 bg-yellow-50/50 space-y-6">
                    <span class="text-sm font-black uppercase tracking-wider bg-black text-white px-3 py-1 rounded">1. Player Registration Pool</span>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <c:forEach var="i" begin="1" end="4">
                            <div class="p-4 border-2 border-black bg-white rounded-2xl space-y-3 shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
                                <div class="flex justify-between items-center">
                                    <label class="text-xs font-black uppercase text-gray-500">Slot Player ${i}</label>

                                    <div class="flex items-center gap-1 bg-gray-100 p-1 border border-black rounded-lg text-[9px] font-bold">
                                        <button type="button" onclick="toggleInputMode(${i}, 'db')" id="btn-db-${i}" class="px-2 py-0.5 bg-black text-white rounded">DB</button>
                                        <button type="button" onclick="toggleInputMode(${i}, 'manual')" id="btn-manual-${i}" class="px-2 py-0.5 rounded text-gray-500">MANUAL</button>
                                    </div>
                                </div>

                                <div id="wrapper-db-${i}">
                                    <select id="pool-db-${i}" onchange="syncPoolToTeams()" class="pool-select w-full border-2 border-black p-2 rounded-xl font-bold text-sm bg-white outline-none">
                                        <option value="" data-name="">-- SELECT REGISTERED USER --</option>
                                        <c:forEach var="user" items="${playerList}">
                                            <option value="${user.id}" data-name="${user.username}">${user.username}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div id="wrapper-manual-${i}" class="hidden">
                                    <input type="text" id="pool-manual-${i}" oninput="syncPoolToTeams()" placeholder="ENTER GUEST NAME" class="pool-input w-full border-2 border-black p-2 rounded-xl font-bold text-sm uppercase outline-none">
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <%-- 3. TEAM ALLOCATION & SHUFFLE (BAGIAN BAWAH) --%>
                <div class="border-4 border-black rounded-3xl p-6 bg-gray-50 space-y-6">
                    <div class="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
                        <span class="text-sm font-black uppercase tracking-wider bg-black text-white px-3 py-1 rounded w-fit">2. Team Allocation</span>

                        <button type="button" onclick="shuffleTeams()" class="bg-yellow-400 border-2 border-black px-4 py-2 rounded-xl font-black text-xs uppercase italic tracking-wider shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-0.5 hover:translate-y-0.5 transition-all flex items-center gap-2">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M16 3h5v5M4 20L21 3M21 16v5h-5M4 4l5 5M15 15l6 6"/></svg>
                            Shuffle Pairs Randomly
                        </button>
                    </div>

                    <form id="matchForm" action="${pageContext.request.contextPath}/view/scoring/score.jsp" method="GET" onsubmit="return finalValidation();" class="grid grid-cols-1 md:grid-cols-2 gap-8 pt-2">
                        <input type="hidden" name="booking_id" value="${param.booking_id != null ? param.booking_id : 1}">
                        <input type="hidden" name="scoring_style" id="form_scoring_style">

                        <input type="hidden" name="is_guest_p1" id="is_guest_p1" value="false">
                        <input type="hidden" name="is_guest_p2" id="is_guest_p2" value="false">
                        <input type="hidden" name="is_guest_p3" id="is_guest_p3" value="false">
                        <input type="hidden" name="is_guest_p4" id="is_guest_p4" value="false">

                        <div class="p-4 border-2 border-black bg-cyan-50/50 rounded-2xl space-y-4">
                            <span class="text-xs font-black uppercase tracking-widest text-cyan-600 block border-b border-cyan-200 pb-1">Team 1</span>
                            <div>
                                <label class="text-[9px] font-bold uppercase opacity-50 block mb-1">Player A</label>
                                <select name="p1_tim1" id="team-p1" class="w-full border-2 border-black p-3 rounded-xl font-bold bg-white outline-none" required>
                                    <option value="">-- SELECT FROM POOL --</option>
                                </select>
                            </div>
                            <div>
                                <label class="text-[9px] font-bold uppercase opacity-50 block mb-1">Player B</label>
                                <select name="p2_tim1" id="team-p2" class="w-full border-2 border-black p-3 rounded-xl font-bold bg-white outline-none" required>
                                    <option value="">-- SELECT FROM POOL --</option>
                                </select>
                            </div>
                        </div>

                        <div class="p-4 border-2 border-black bg-white rounded-2xl space-y-4">
                            <span class="text-xs font-black uppercase tracking-widest text-gray-500 block border-b border-gray-200 pb-1">Team 2</span>
                            <div>
                                <label class="text-[9px] font-bold uppercase opacity-50 block mb-1">Player C</label>
                                <select name="p1_tim2" id="team-p3" class="w-full border-2 border-black p-3 rounded-xl font-bold bg-white outline-none" required>
                                    <option value="">-- SELECT FROM POOL --</option>
                                </select>
                            </div>
                            <div>
                                <label class="text-[9px] font-bold uppercase opacity-50 block mb-1">Player D</label>
                                <select name="p2_tim2" id="team-p4" class="w-full border-2 border-black p-3 rounded-xl font-bold bg-white outline-none" required>
                                    <option value="">-- SELECT FROM POOL --</option>
                                </select>
                            </div>
                        </div>

                        <button type="submit" class="md:col-span-2 w-full bg-black text-cyan-400 font-black uppercase tracking-wider py-4 rounded-2xl border-4 border-black shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] hover:shadow-none hover:translate-x-1 hover:translate-y-1 transition-all italic text-lg">
                            Enter Scoring Board →
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <%-- ENGINE SCRIPT INTERAKTIF --%>
        <script>
            let poolData = [
                {id: "", name: "", isManual: false},
                {id: "", name: "", isManual: false},
                {id: "", name: "", isManual: false},
                {id: "", name: "", isManual: false}
            ];

            function toggleInputMode(index, mode) {
                const idx = index - 1;
                // Menggunakan tanda kutip tunggal dan concatenation + agar aman dari JSP
                const btnDb = document.getElementById('btn-db-' + index);
                const btnManual = document.getElementById('btn-manual-' + index);
                const wrapDb = document.getElementById('wrapper-db-' + index);
                const wrapManual = document.getElementById('wrapper-manual-' + index);

                if (mode === 'db') {
                    btnDb.className = "px-2 py-0.5 bg-black text-white rounded";
                    btnManual.className = "px-2 py-0.5 rounded text-gray-500";
                    wrapDb.classList.remove('hidden');
                    wrapManual.classList.add('hidden');
                    document.getElementById('pool-manual-' + index).value = "";
                    poolData[idx].isManual = false;
                } else {
                    btnManual.className = "px-2 py-0.5 bg-black text-white rounded";
                    btnDb.className = "px-2 py-0.5 rounded text-gray-500";
                    wrapManual.classList.remove('hidden');
                    wrapDb.classList.add('hidden');
                    document.getElementById('pool-db-' + index).value = "";
                    poolData[idx].isManual = true;
                }
                syncPoolToTeams();
            }

            function syncPoolToTeams() {
                for (let i = 1; i <= 4; i++) {
                    const idx = i - 1;
                    if (!poolData[idx].isManual) {
                        const select = document.getElementById('pool-db-' + i);
                        const selectedOption = select.options[select.selectedIndex];
                        poolData[idx].id = select.value;
                        poolData[idx].name = selectedOption.getAttribute('data-name') || "";
                    } else {
                        const inputVal = document.getElementById('pool-manual-' + i).value.trim();
                        poolData[idx].id = inputVal;
                        poolData[idx].name = inputVal;
                    }
                }

                const teamSelects = ['team-p1', 'team-p2', 'team-p3', 'team-p4'];
                teamSelects.forEach(function (selectId) {
                    const el = document.getElementById(selectId);
                    const currentSavedVal = el.value;

                    let optionsHtml = '<option value="">-- SELECT FROM POOL --</option>';
                    for (let pIdx = 0; pIdx < poolData.length; pIdx++) {
                        let player = poolData[pIdx];
                        if (player.name !== "") {
                            // Concatenation manual untuk menghindari konflik JSP
                            optionsHtml += '<option value="' + player.id + '" data-idx="' + pIdx + '">' +
                                    player.name.toUpperCase() + (player.isManual ? ' (GUEST)' : '') + '</option>';
                        }
                    }
                    el.innerHTML = optionsHtml;
                    el.value = currentSavedVal;
                });
            }

            function shuffleTeams() {
                let activePlayers = poolData.filter(function (p) {
                    return p.name !== "";
                });

                if (activePlayers.length < 4) {
                    alert("Harap daftarkan keempat pemain di pool atas terlebih dahulu!");
                    return;
                }

                for (let i = activePlayers.length - 1; i > 0; i--) {
                    const j = Math.floor(Math.random() * (i + 1));
                    let temp = activePlayers[i];
                    activePlayers[i] = activePlayers[j];
                    activePlayers[j] = temp;
                }

                syncPoolToTeams();
                document.getElementById('team-p1').value = activePlayers[0].id;
                document.getElementById('team-p2').value = activePlayers[1].id;
                document.getElementById('team-p3').value = activePlayers[2].id;
                document.getElementById('team-p4').value = activePlayers[3].id;
            }

            function finalValidation() {
                const p1 = document.getElementById("team-p1").value;
                const p2 = document.getElementById("team-p2").value;
                const p3 = document.getElementById("team-p3").value;
                const p4 = document.getElementById("team-p4").value;

                if (!p1 || !p2 || !p3 || !p4) {
                    alert("Harap lengkapi semua posisi pemain di Team 1 dan Team 2!");
                    return false;
                }

                document.getElementById('form_scoring_style').value = document.getElementById('scoring_style').value;

                let teamIds = ['team-p1', 'team-p2', 'team-p3', 'team-p4'];
                for (let i = 0; i < teamIds.length; i++) {
                    const el = document.getElementById(teamIds[i]);
                    const pIdx = el.options[el.selectedIndex].getAttribute('data-idx');
                    document.getElementById('is_guest_p' + (i + 1)).value = poolData[pIdx].isManual;
                }
                return true;
            }
        </script>
    </body>
</html>