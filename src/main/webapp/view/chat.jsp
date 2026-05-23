<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="id">

<head>

    <meta charset="UTF-8">
    <title>Padel Community Chat</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <style>

        body{
            font-family: Arial, sans-serif;
        }

        ::-webkit-scrollbar{
            width: 6px;
        }

        ::-webkit-scrollbar-thumb{
            background: #cfcfcf;
            border-radius: 10px;
        }

    </style>

</head>

<body class="bg-[#f3f3f3] overflow-hidden">

<div class="flex h-screen">

    <!-- SIDEBAR -->
    <div class="w-[340px] bg-white border-r border-[#dddddd] flex flex-col">

        <!-- LOGO -->
        <div class="p-7 border-b border-[#dddddd]">

            <h1 class="text-5xl font-black leading-none">
                <span class="text-black">PADEL</span>
                <span class="text-[#6EA8FF]">APP</span>
            </h1>

            <p class="text-gray-500 mt-2 tracking-wide">
                COMMUNITY CHAT
            </p>

        </div>

        <!-- BACK BUTTON -->
        <div class="p-5">

            <a href="../index.jsp">

                <button class="w-full bg-black text-white py-4 rounded-full font-bold hover:scale-105 transition">
                    ← Back To Dashboard
                </button>

            </a>

        </div>

        <!-- TITLE -->
        <div class="px-5">

            <h2 class="text-5xl font-black">
                Pesan
            </h2>

        </div>

        <!-- SEARCH -->
        <div class="px-5 mt-6">

            <input
                type="text"
                placeholder="Cari percakapan..."
                class="w-full bg-[#f5f5f5] border border-[#dddddd] rounded-full px-5 py-4 outline-none"
            >

        </div>

        <!-- FILTER -->
        <div class="flex gap-3 px-5 mt-5">

            <button class="bg-[#B6FF2D] text-black px-5 py-2 rounded-full font-bold">
                Semua
            </button>

            <button class="bg-[#f3f3f3] px-5 py-2 rounded-full">
                Grup
            </button>

            <button class="bg-[#f3f3f3] px-5 py-2 rounded-full">
                Belum Dibaca
            </button>

        </div>

        <!-- CHAT LIST -->
        <div class="flex-1 overflow-y-auto p-5">

            <!-- CHAT USER -->
            <div class="bg-[#f7f7f7] border border-[#e5e5e5] rounded-3xl p-4 shadow-sm">

                <div class="flex items-center gap-4">

                    <img
                        src="../img/izul.png"
                        class="w-16 h-16 rounded-full object-cover"
                    >

                    <div class="flex-1">

                        <div class="flex justify-between items-center">

                            <h3 class="font-black text-2xl">
                                Faizul
                            </h3>

                            <span class="text-sm text-gray-400">
                                10:45
                            </span>

                        </div>

                        <p class="text-[#9FE62E] font-semibold mt-1">
                            Gas main jam 7 malam ini?
                        </p>

                    </div>

                </div>

            </div>

        </div>

    </div>





    <!-- CHAT AREA -->
    <div class="flex-1 flex flex-col bg-[#f5f5f5]">

        <!-- HEADER -->
        <div class="bg-white border-b border-[#dddddd] px-10 py-5 flex items-center">

            <img
                src="../img/izul.png"
                class="w-16 h-16 rounded-full object-cover border-2 border-[#B6FF2D]"
            >

            <div class="ml-5">

                <h2 class="text-3xl font-black">
                    Faizul
                </h2>

                <p class="text-[#9FE62E] font-semibold">
                    ● ONLINE
                </p>

            </div>

        </div>





        <!-- CHAT CONTENT -->
        <div class="flex-1 overflow-y-auto px-10 py-8 space-y-10">

            <!-- MESSAGE LEFT -->
            <div class="flex items-end gap-3">

                <img
                    src="../img/izul.png"
                    class="w-10 h-10 rounded-full object-cover"
                >

                <div class="bg-white border border-[#dddddd] rounded-[25px] px-6 py-5 max-w-[450px] shadow-sm">

                    <p class="text-lg leading-relaxed">
                        Oiii besok mau sparing ga nih? 
                        Biar makin jago buat turnamen minggu depan 🔥
                    </p>

                    <span class="text-gray-400 text-sm mt-3 block">
                        10:42
                    </span>

                </div>

            </div>





            <!-- MESSAGE RIGHT -->
            <div class="flex justify-end">

                <div class="bg-[#B6FF2D] rounded-[25px] px-6 py-5 max-w-[500px] shadow-sm">

                    <p class="text-lg leading-relaxed text-black">
                        Wahh boleh banget! Aku juga lagi cari partner sparing 😆
                    </p>

                    <span class="text-black/60 text-sm mt-3 block">
                        10:44
                    </span>

                </div>

            </div>





            <!-- MESSAGE LEFT -->
            <div class="flex items-end gap-3">

                <img
                    src="../img/izul.png"
                    class="w-10 h-10 rounded-full object-cover"
                >

                <div class="bg-white border border-[#dddddd] rounded-[25px] px-6 py-5 max-w-[450px] shadow-sm">

                    <p class="text-lg leading-relaxed">
                        Gas main jam 7 malam ini?
                    </p>

                    <span class="text-gray-400 text-sm mt-3 block">
                        10:45
                    </span>

                </div>

            </div>





            <!-- MESSAGE RIGHT -->
            <div class="flex justify-end">

                <div class="bg-[#B6FF2D] rounded-[25px] px-6 py-5 max-w-[500px] shadow-sm">

                    <p class="text-lg leading-relaxed text-black">
                        Siappp, nanti share lokasi ya 🔥
                    </p>

                    <span class="text-black/60 text-sm mt-3 block">
                        10:46
                    </span>

                </div>

            </div>





            <!-- MESSAGE LEFT -->
            <div class="flex items-end gap-3">

                <img
                    src="../img/izul.png"
                    class="w-10 h-10 rounded-full object-cover"
                >

                <div class="bg-white border border-[#dddddd] rounded-[25px] px-6 py-5 max-w-[450px] shadow-sm">

                    <p class="text-lg leading-relaxed">
                        Oke siap brooo 😎
                    </p>

                    <span class="text-gray-400 text-sm mt-3 block">
                        10:47
                    </span>

                </div>

            </div>

        </div>





        <!-- INPUT -->
        <div class="bg-white border-t border-[#dddddd] p-5">

            <form class="flex items-center gap-4">

                <input
                    type="text"
                    placeholder="Type your message..."
                    class="flex-1 bg-[#f5f5f5] border border-[#dddddd] rounded-full px-8 py-5 outline-none text-lg"
                >

                <button
                    type="submit"
                    class="w-[90px] h-[70px] rounded-full bg-[#6EA8FF] hover:scale-105 transition text-white text-xl font-black"
                >
                    SEND
                </button>

            </form>

        </div>

    </div>

</div>

</body>
</html>