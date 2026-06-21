<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Feedback Fasilitas - PadelApp</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
    </style>
</head>
<body class="bg-[#f0f0f0] text-black min-h-screen flex items-center justify-center p-6 relative overflow-hidden">
    <!-- Decorative Elements -->
    <div class="absolute -top-20 -left-20 w-64 h-64 bg-orange-400 rounded-full blur-3xl opacity-20"></div>
    <div class="absolute -bottom-20 -right-20 w-80 h-80 bg-cyan-400 rounded-full blur-3xl opacity-20"></div>

    <div class="bg-white rounded-3xl w-full max-w-lg overflow-hidden shadow-[12px_12px_0px_0px_rgba(0,0,0,1)] border-4 border-black relative z-10">
        
        <!-- Header -->
        <div class="bg-black text-white p-8 flex justify-between items-center border-b-4 border-black">
            <div>
                <h3 class="font-black text-3xl uppercase tracking-tighter italic">Feedback</h3>
                <p class="text-xs font-bold uppercase tracking-widest text-orange-400 mt-1">Bantu kami menjadi lebih baik</p>
            </div>
            <a href="${pageContext.request.contextPath}/index.jsp" class="w-10 h-10 bg-white/10 hover:bg-white/20 rounded-full flex items-center justify-center transition-colors group">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" class="group-hover:-translate-x-1 transition-transform"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
            </a>
        </div>

        <!-- Form -->
        <form action="${pageContext.request.contextPath}/FeedbackController" method="POST" class="p-8">
            <div class="mb-6">
                <label class="block text-xs font-black uppercase tracking-widest text-gray-400 mb-2">Jenis Fasilitas</label>
                <select name="facility_type" id="facility-select" class="w-full bg-gray-50 border-2 border-black rounded-xl px-4 py-3.5 text-sm font-bold outline-none focus:bg-orange-50 transition-colors shadow-[4px_4px_0px_0px_rgba(0,0,0,0.1)] appearance-none cursor-pointer" required>
                    <option value="" disabled selected>Pilih Fasilitas...</option>
                    <option value="Lapangan">Lapangan</option>
                    <option value="Food Court">Food Court</option>
                    <option value="Toilet">Toilet</option>
                    <option value="Locker">Locker</option>
                    <option value="Shower Room">Shower Room</option>
                    <option value="Barang Sewa">Barang Sewa</option>
                    <option value="Pelayanan Staff">Pelayanan Staff</option>
                    <option value="Toko">Toko</option>
                    <option value="Lainnya">Lainnya...</option>
                </select>
                <input type="text" name="facility_type_custom" id="facility-custom-input" class="w-full bg-gray-50 border-2 border-black rounded-xl px-4 py-3.5 mt-3 text-sm font-bold outline-none focus:bg-orange-50 transition-colors shadow-[4px_4px_0px_0px_rgba(0,0,0,0.1)] hidden placeholder:text-gray-400" placeholder="Ketik jenis fasilitas...">
            </div>

            <div class="mb-8">
                <label class="block text-xs font-black uppercase tracking-widest text-gray-400 mb-2">Komentar & Saran</label>
                <textarea name="comments" rows="4" class="w-full bg-gray-50 border-2 border-black rounded-xl px-4 py-3.5 text-sm font-bold outline-none focus:bg-orange-50 transition-colors shadow-[4px_4px_0px_0px_rgba(0,0,0,0.1)] placeholder:text-gray-300 resize-none" placeholder="Ceritakan pengalaman Anda..."></textarea>
            </div>

            <div class="mb-10 bg-gray-50 p-6 rounded-2xl border-2 border-gray-200">
                <label class="block text-xs font-black uppercase tracking-widest text-center text-gray-400 mb-3">Rating Anda</label>
                <div class="flex justify-center gap-3" id="star-rating">
                    <!-- Stars -->
                    <svg data-val="1" xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linejoin="round" class="star cursor-pointer text-gray-300 hover:text-orange-400 hover:scale-110 transition-all drop-shadow-sm"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                    <svg data-val="2" xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linejoin="round" class="star cursor-pointer text-gray-300 hover:text-orange-400 hover:scale-110 transition-all drop-shadow-sm"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                    <svg data-val="3" xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linejoin="round" class="star cursor-pointer text-gray-300 hover:text-orange-400 hover:scale-110 transition-all drop-shadow-sm"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                    <svg data-val="4" xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linejoin="round" class="star cursor-pointer text-gray-300 hover:text-orange-400 hover:scale-110 transition-all drop-shadow-sm"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                    <svg data-val="5" xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linejoin="round" class="star cursor-pointer text-gray-300 hover:text-orange-400 hover:scale-110 transition-all drop-shadow-sm"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                </div>
                <input type="hidden" name="rating" id="rating-input" value="0" required>
            </div>

            <div class="flex gap-4">
                <a href="${pageContext.request.contextPath}/index.jsp" class="flex-1 bg-white text-black py-4 rounded-xl font-black uppercase tracking-widest text-xs text-center border-2 border-black hover:bg-gray-50 transition-colors">
                    Lewati
                </a>
                <button type="submit" class="flex-[2] bg-orange-400 hover:bg-orange-500 text-black py-4 rounded-xl font-black uppercase tracking-widest text-xs shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] active:translate-x-[2px] active:translate-y-[2px] active:shadow-none transition-all cursor-pointer border-2 border-black">
                    Kirim Feedback
                </button>
            </div>
        </form>
    </div>

    <script>
        // Custom Facility Logic
        const facilitySelect = document.getElementById('facility-select');
        const facilityCustomInput = document.getElementById('facility-custom-input');
        if (facilitySelect && facilityCustomInput) {
            facilitySelect.addEventListener('change', function() {
                if (this.value === 'Lainnya') {
                    facilityCustomInput.classList.remove('hidden');
                    facilityCustomInput.required = true;
                    facilityCustomInput.focus();
                } else {
                    facilityCustomInput.classList.add('hidden');
                    facilityCustomInput.required = false;
                    facilityCustomInput.value = '';
                }
            });
        }
        
        // Star Rating Logic
        const stars = document.querySelectorAll('.star');
        const ratingInput = document.getElementById('rating-input');
        stars.forEach(star => {
            star.addEventListener('click', function() {
                const val = parseInt(this.getAttribute('data-val'));
                ratingInput.value = val;
                stars.forEach(s => {
                    if(parseInt(s.getAttribute('data-val')) <= val) {
                        s.classList.remove('text-gray-300');
                        s.classList.add('text-orange-400', 'fill-orange-400');
                    } else {
                        s.classList.remove('text-orange-400', 'fill-orange-400');
                        s.classList.add('text-gray-300');
                    }
                });
            });
        });
    </script>
</body>
</html>
