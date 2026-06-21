<%-- 
    Document   : create_community
    Created on : 11 May 2026, 15.10.15
    Author     : ALFIAN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <<meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Community - PadelApp</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            .border-grid { border-color: #e5e5e5; }
            .brutalist-shadow { box-shadow: 8px 8px 0px 0px rgba(0,0,0,1); }
        </style>
    </head>
    <body class="bg-white text-black min-h-screen flex flex-col">
        <header class="flex border-b border-grid bg-white sticky top-0 z-50">
            <div class="p-4 md:p-6 border-r border-grid w-1/2 md:w-1/4">
                <h1 class="text-xl font-black tracking-tighter uppercase md:text-2xl">
                    Padel<span class="text-blue-400">App</span>
                </h1>
            </div>
            <div class="flex-1 border-r border-grid hidden md:flex items-center px-8">
                <a href="CommunityController" class="text-xs font-bold uppercase tracking-widest hover:underline">← Back</a>
            </div>
            <div class="p-4 md:p-6 w-1/2 md:w-1/4 flex items-center justify-end gap-4">
                <span class="text-[10px] font-bold uppercase tracking-widest"><%= session.getAttribute("user")%></span>
                <div class="p-2 border-2 border-black bg-white">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M22 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                </div>
            </div>
        </header>

        <main class="flex flex-col md:flex-row flex-1">
            <div class="w-full md:w-1/3 p-8 md:p-12 border-b md:border-b-0 md:border-r border-grid bg-white">
                <span class="text-xs font-bold uppercase block mb-4 opacity-50">05 / Creation</span>
                <h2 class="text-5xl md:text-7xl font-black leading-none uppercase mb-8 tracking-tighter">
                    Build Your <span class="text-lime-400">Squad.</span>
                </h2>
                <p class="text-gray-500 uppercase font-bold text-xs leading-relaxed italic">
                    Tentukan nama klub dan deskripsi unik untuk menarik anggota baru.
                </p>
            </div>

            <div class="flex-1 p-8 md:p-12 bg-white">
                <form action="${pageContext.request.contextPath}/CommunityController" method="POST" class="max-w-xl space-y-12">
                    <div class="border-b-2 border-black pb-2">
                        <label class="text-xs font-bold uppercase opacity-50 block mb-2">Club Name</label>
                        <input type="text" name="name" placeholder="E.G. BANDUNG PADEL SOCIETY" 
                               class="w-full bg-transparent text-2xl font-black outline-none uppercase" required>
                    </div>

                    <div class="border-b-2 border-black pb-2">
                        <label class="text-xs font-bold uppercase opacity-50 block mb-2">Club Description</label>
                        <textarea name="description" rows="4" placeholder="DESCRIBE YOUR COMMUNITY..." 
                                  class="w-full bg-transparent text-lg font-bold outline-none uppercase resize-none" required></textarea>
                    </div>

                    <div class="border-b-2 border-black pb-4">
                        <label class="text-xs font-bold uppercase opacity-50 block mb-4">Club Type</label>
                        <div class="flex gap-4">
                            <label class="flex-1 flex items-center gap-2 cursor-pointer border-2 border-black p-4 hover:bg-gray-100 transition-colors">
                                <input type="radio" name="type" value="PUBLIC" class="w-4 h-4 text-lime-400 focus:ring-lime-400 border-black" checked>
                                <div>
                                    <span class="font-black uppercase text-sm block">Public</span>
                                    <span class="text-[10px] font-bold uppercase opacity-50 block">Anyone can join instantly</span>
                                </div>
                            </label>
                            <label class="flex-1 flex items-center gap-2 cursor-pointer border-2 border-black p-4 hover:bg-gray-100 transition-colors">
                                <input type="radio" name="type" value="PRIVATE" class="w-4 h-4 text-red-500 focus:ring-red-500 border-black">
                                <div>
                                    <span class="font-black uppercase text-sm block">Private</span>
                                    <span class="text-[10px] font-bold uppercase opacity-50 block">Requires Admin approval</span>
                                </div>
                            </label>
                        </div>
                    </div>

                    <div class="pt-8">
                        <button type="submit" class="w-full md:w-auto bg-black text-white px-12 py-5 font-black uppercase tracking-widest text-lg hover:bg-lime-400 hover:text-black transition-all brutalist-shadow">
                            Create Community →
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </body>
</html>
