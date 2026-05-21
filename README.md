# Aplikasi Padel PBO (Tubes PBO Semester 4)

Aplikasi manajemen Padel yang dibangun menggunakan Java Enterprise Web (Servlet/JSP) dengan menerapkan prinsip Pemrograman Berorientasi Objek (PBO).

Panduan ini dibuat sangat detail untuk pemula agar Anda dan teman kelompok Anda bisa menjalankan proyek ini tanpa kendala coding sama sekali.

---

## 🛠️ BAGIAN 1: Persiapan Software (Instalasi Awal)

Sebelum memulai, pastikan laptop Anda sudah terinstal software berikut:

1.  **Git** (Untuk mengambil dan mengirim kode ke GitHub):
    *   [Download Git untuk Windows](https://git-scm.com/download/win)
    *   *Catatan saat instalasi:* Klik **Next** terus sampai selesai. Pastikan opsi "Add to PATH" tercentang.
2.  **XAMPP** (Untuk server database MySQL):
    *   [Download XAMPP](https://www.apachefriends.org/download.html) (Pilih versi PHP 8.x ke atas).
3.  **Java JDK 17** (Bahasa pemrograman utama proyek ini):
    *   [Download JDK 17 dari Azul](https://www.azul.com/downloads/?version=java-17-lts&package=jdk#download-openjdk) (Pilih installer `.msi` agar instalasi otomatis).
4.  **NetBeans IDE** (Aplikasi editor untuk mempermudah menjalankan proyek):
    *   [Download Apache NetBeans](https://netbeans.apache.org/front/main/download/) (Pilih versi terbaru, misal versi 20 atau 21).

---

## 🚀 BAGIAN 2: Cara Mengambil & Mengembangkan Proyek (Git Workflow & Branching)

Agar kode program utama tetap aman dan tidak saling menimpa kerjaan teman kelompok, gunakan alur kerja berikut:

### 1. Mengunduh Proyek Pertama Kali (Clone)
1.  Buka **File Explorer** di komputer Anda, lalu masuk ke folder tempat Anda ingin menyimpan proyek (misal: `D:\Kuliah`).
2.  Klik kanan di area kosong, lalu pilih **Open Git Bash Here** (atau buka Command Prompt/CMD lalu ketik `cd D:\Kuliah`).
3.  Jalankan perintah ini:
    ```bash
    git clone https://github.com/FaizulAfiat/AplikasiPadelPBO.git
    ```
4.  Setelah selesai, folder proyek bernama `AplikasiPadelPBO` akan muncul. Masuk ke dalam folder tersebut melalui terminal:
    ```bash
    cd AplikasiPadelPBO
    ```

### 2. Mengambil Kode Terbaru Sebelum Mulai Mengoding (Pull)
**PENTING:** Setiap kali Anda ingin mulai mengoding atau membuka proyek, selalu jalankan perintah ini di Git Bash/CMD agar kode Anda tersinkronisasi dengan update dari teman kelompok:
```bash
git checkout main
git pull origin main
```

### 3. Alur Kerja Menggunakan Branch (Sangat Direkomendasikan!)
Jangan langsung melakukan push ke branch `main`. Buatlah **branch baru** setiap kali Anda ingin menambah fitur baru atau memperbaiki eror.

#### Langkah 1: Buat dan Masuk ke Branch Baru Anda
Tentukan nama branch sesuai fitur yang dikerjakan (contoh: `fitur-logout`, `fitur-scoring`, dll):
```bash
git checkout -b nama-branch-baru
```
*(Perintah `-b` otomatis membuat branch baru dan memindahkan Anda ke branch tersebut).*

#### Langkah 2: Lakukan Coding & Simpan Perubahan (Commit)
Setelah selesai menulis kode di laptop Anda, simpan perubahannya ke Git:
```bash
git add .
git commit -m "Deskripsi singkat apa yang Anda ubah"
```

#### Langkah 3: Push Branch Anda ke GitHub
Kirim branch Anda ke repositori online (bukan ke main):
```bash
git push origin nama-branch-baru
```

#### Langkah 4: Gabungkan via Pull Request (PR) di GitHub
1.  Buka halaman GitHub proyek Anda di browser.
2.  Anda akan melihat tombol hijau bertuliskan **Compare & pull request** untuk branch yang baru saja di-push. Klik tombol tersebut.
3.  Tulis pesan singkat, lalu klik **Create pull request**.
4.  Jika kode dirasa sudah aman dan tidak ada bentrok (*conflict*), klik tombol **Merge pull request** lalu **Confirm merge**. Sekarang fitur Anda resmi masuk ke branch `main`.

#### Langkah 5: Sinkronkan Kembali Laptop Anda
Setelah digabungkan di GitHub, kembalikan posisi Git laptop Anda ke branch `main` dan ambil update terbaru hasil penggabungan tadi:
```bash
git checkout main
git pull origin main
```

---

## 🗄️ BAGIAN 3: Pengaturan Database MySQL (XAMPP)

Aplikasi ini menggunakan konfigurasi koneksi default (dapat dilihat di file [Koneksi.java](file:///src/main/java/com/mycompany/aplikasi_padel_tubes_pbo/model/Koneksi.java)):
*   **Database Host:** `localhost` (port `3306`)
*   **Nama Database:** `aplikasi_padel`
*   **Username:** `root`
*   **Password:** `""` (kosong / tidak pakai password)

### Langkah Setup Database:
1.  Buka aplikasi **XAMPP Control Panel** di laptop Anda.
2.  Klik tombol **Start** pada baris **MySQL** (dan Apache jika diperlukan) sampai indikator berwarna hijau.
3.  **Selesai!** Aplikasi ini memiliki **Database Seeder otomatis** (`DatabaseSeeder.java`). Ketika Anda menjalankan aplikasi pertama kali, database `aplikasi_padel` beserta seluruh tabel dan data default-nya akan terbuat otomatis tanpa Anda perlu melakukan impor manual.

### Cara Manual (Jika Mengalami Eror saat Setup Otomatis):
Jika ingin mengimpor database secara manual lewat phpMyAdmin:
1.  Buka browser dan masuk ke [http://localhost/phpmyadmin/](http://localhost/phpmyadmin/).
2.  Klik menu **New** di kolom kiri, beri nama database **`aplikasi_padel`**, lalu klik **Create**.
3.  Klik nama database `aplikasi_padel` yang baru dibuat di sebelah kiri.
4.  Pilih tab **Import** di bagian atas.
5.  Klik tombol **Choose File** / **Browse**, lalu arahkan ke file SQL di dalam folder proyek Anda:
    *   Tautan file: [SQLDatabase/aplikasi_padel.sql](file:///SQLDatabase/aplikasi_padel.sql)
6.  Scroll ke bawah, lalu klik tombol **Import** (atau **Go**).

---

## 💻 BAGIAN 4: Cara Menjalankan Aplikasi

Anda memiliki dua pilihan cara untuk menjalankan aplikasi ini:

### 🌟 CARA A: Menggunakan NetBeans IDE (Sangat Direkomendasikan & Mudah)
1.  Buka **Apache NetBeans**.
2.  Pilih menu **File** -> **Open Project...**
3.  Arahkan ke folder proyek `AplikasiPadelPBO`, lalu klik **Open Project** (NetBeans akan mendeteksi ikon proyek Maven).
4.  Klik kanan pada nama proyek di panel kiri, pilih **Clean and Build** (Tunggu sampai status di bawah bertuliskan *BUILD SUCCESS*).
5.  Untuk menjalankannya:
    *   Klik kanan pada nama proyek -> pilih **Run**.
    *   *Atau jika ingin menjalankan lewat Cargo:* Klik kanan proyek -> pilih **Custom** -> **Goals...** -> Ketik `cargo:run` pada kolom Goal, lalu klik **OK**.
6.  Buka browser Anda dan akses halaman login:
    *   [http://localhost:8082/Aplikasi_Padel_Tubes_PBO/view/login](http://localhost:8082/Aplikasi_Padel_Tubes_PBO/view/login)

---

### CARA B: Menggunakan Command Prompt (CMD) / Terminal
1.  Buka CMD/Terminal di dalam direktori folder proyek `AplikasiPadelPBO`.
2.  Jalankan perintah berikut:
    ```bash
    mvn clean package cargo:run
    ```
3.  Tunggu hingga proses selesai dan muncul teks:
    ```text
    [INFO] Tomcat 10.x Embedded started on port [8082]
    [INFO] Press Ctrl-C to stop the container...
    ```
4.  Buka browser dan ketik:
    *   [http://localhost:8082/Aplikasi_Padel_Tubes_PBO/view/login](http://localhost:8082/Aplikasi_Padel_Tubes_PBO/view/login)
5.  Untuk menghentikan server, tekan tombol `Ctrl + C` di CMD/Terminal Anda.

---

## ⚠️ BAGIAN 5: Solusi Mengatasi Eror yang Sering Muncul (Troubleshooting)

### 1. Eror Git: `"Your local changes to the following files would be overwritten by merge"`
*   **Kenapa terjadi?** Teman Anda mengubah file yang sama dengan yang pernah Anda edit di laptop Anda, sehingga Git bingung menggabungkannya.
*   **Solusi A (Jika ingin membuang semua perubahan Anda dan menyamakan persis dengan GitHub):**
    ```bash
    git restore .
    git pull origin main
    ```
*   **Solusi B (Jika ingin menyimpan sementara kerjaan Anda, lalu pull kode baru):**
    ```bash
    git stash
    git pull origin main
    git stash pop
    ```

### 2. Eror Database: `"Communications link failure"` atau `"Access denied"`
*   **Communications link failure:** Berarti XAMPP MySQL Anda belum di-Start. Buka XAMPP Control Panel dan pastikan MySQL sudah menyala (warna hijau).
*   **Access denied for user 'root'@'localhost':** Berarti MySQL Anda menggunakan password. Anda harus menyamakan password di proyek Anda:
    1. Buka file `src/main/java/com/mycompany/aplikasi_padel_tubes_pbo/model/Koneksi.java`.
    2. Cari baris `private static final String PASS = "";`.
    3. Ubah tanda kutip kosong sesuai password MySQL laptop Anda (contoh: `"root"`, `"admin"`, atau `"12345"`).
    4. Jalankan ulang proyek (`mvn clean package cargo:run`).

### 3. Eror CMD: `"mvn is not recognized as an internal or external command"`
*   **Kenapa terjadi?** Laptop Anda belum dipasang Maven, atau Path Maven di Windows belum disetting.
*   **Solusi paling cepat:** Gunakan **Cara A (NetBeans)** karena NetBeans sudah memiliki Maven bawaan di dalamnya sehingga Anda tidak perlu repot menyetting PATH Windows Anda.

### 4. Eror Server: `"Address already in use"` (Port 8082 Bentrok)
*   **Kenapa terjadi?** Ada aplikasi lain di laptop Anda yang sedang menggunakan port `8082`, atau Anda tidak sengaja menjalankan server Tomcat dua kali sekaligus.
*   **Solusi:**
    1. Pastikan Anda sudah mematikan server sebelumnya dengan menekan `Ctrl + C` di terminal CMD lama Anda.
    2. Jika masih bentrok, Anda bisa mengubah port default aplikasi di file [pom.xml](file:///pom.xml) pada baris:
       `<cargo.servlet.port>8082</cargo.servlet.port>` ubah `8082` menjadi port lain (contoh: `8085` atau `8090`).
       *Tautan baru setelah diubah:* `http://localhost:8085/Aplikasi_Padel_Tubes_PBO/view/login`

---

## 🔑 BAGIAN 6: Akun Uji Coba Default (Untuk Demo)

Setelah aplikasi terbuka di browser, Anda bisa masuk menggunakan data uji coba berikut:
*   **Akun Administrator (Untuk Kelola Produk/Lapangan):**
    *   Username: `admin`
    *   Password: `admin`
*   **Akun User Biasa:**
    *   Username: `user`
    *   Password: `user`
