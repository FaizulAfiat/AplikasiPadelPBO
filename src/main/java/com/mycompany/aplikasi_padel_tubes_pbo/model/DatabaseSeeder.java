package com.mycompany.aplikasi_padel_tubes_pbo.model;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

@WebListener
public class DatabaseSeeder implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== SYSTEM: MEMULAI DATABASE SEEDER ===");
        
        // 1. Pastikan Database 'aplikasi_padel' sudah terbuat di MySQL lokal
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String rawUrl = "jdbc:mysql://localhost:3306/";
            String user = "root";
            String pass = "";
            
            try (Connection rawConn = DriverManager.getConnection(rawUrl, user, pass);
                 Statement rawStmt = rawConn.createStatement()) {
                rawStmt.executeUpdate("CREATE DATABASE IF NOT EXISTS aplikasi_padel");
                System.out.println("[Seeder] Database 'aplikasi_padel' berhasil dipastikan ada.");
            }
        } catch (Exception e) {
            System.err.println("[Seeder] Gagal memastikan database 'aplikasi_padel' ada: " + e.getMessage());
        }

        // 2. Cek apakah tabel 'users' sudah ada (jika sudah ada, lewati import)
        try (Connection conn = Koneksi.getConnection();
             Statement stmt = conn.createStatement()) {
            
            boolean dbInitialized = false;
            try (ResultSet rs = conn.getMetaData().getTables(null, null, "users", null)) {
                if (rs.next()) {
                    dbInitialized = true;
                }
            } catch (Exception e) {
                // Abaikan jika query metadata gagal
            }

            if (dbInitialized) {
                System.out.println("[Seeder] Tabel 'users' sudah ada. Proses seeding dilewati.");
                
                // Cek apakah tabel 'transaction' perlu migrasi (apakah kolom product_id belum ada)
                boolean needsMigration = false;
                try (ResultSet colRs = conn.getMetaData().getColumns(null, null, "transaction", "product_id")) {
                    if (!colRs.next()) {
                        needsMigration = true;
                    }
                } catch (Exception e) {
                    // Abaikan jika tabel belum ada atau terjadi error
                }
                
                if (needsMigration) {
                    System.out.println("[Seeder] Tabel 'transaction' membutuhkan migrasi schema. Menjalankan ALTER...");
                    try {
                        // Drop FK constraint yang bergantung pada user_id unik
                        try {
                            stmt.executeUpdate("ALTER TABLE `transaction` DROP FOREIGN KEY `transaction_ibfk_1`");
                        } catch (Exception e) {
                            System.out.println("[Seeder] Peringatan saat drop FK: " + e.getMessage());
                        }
                        
                        // Drop UNIQUE index
                        try {
                            stmt.executeUpdate("ALTER TABLE `transaction` DROP INDEX `user_id`");
                        } catch (Exception e) {
                            System.out.println("[Seeder] Peringatan saat drop index: " + e.getMessage());
                        }
                        
                        // Tambah kolom-kolom baru
                        stmt.executeUpdate("ALTER TABLE `transaction` ADD COLUMN `product_id` int(11) NOT NULL AFTER `user_id`");
                        stmt.executeUpdate("ALTER TABLE `transaction` ADD COLUMN `quantity` int(11) NOT NULL DEFAULT 1 AFTER `product_id`");
                        stmt.executeUpdate("ALTER TABLE `transaction` ADD COLUMN `type` enum('Sale','Rent') NOT NULL AFTER `quantity`");
                        
                        // Re-create user_id index & constraint, dan add product_id index & constraint
                        stmt.executeUpdate("ALTER TABLE `transaction` ADD KEY `user_id` (`user_id`)");
                        stmt.executeUpdate("ALTER TABLE `transaction` ADD KEY `product_id` (`product_id`)");
                        stmt.executeUpdate("ALTER TABLE `transaction` ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE");
                        stmt.executeUpdate("ALTER TABLE `transaction` ADD CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON UPDATE CASCADE");
                        
                        System.out.println("[Seeder] Tabel 'transaction' berhasil dimigrasi.");
                    } catch (Exception e) {
                        System.err.println("[Seeder] Gagal melakukan migrasi tabel 'transaction': " + e.getMessage());
                        e.printStackTrace();
                    }
                }
                
                // Cek apakah tabel 'products' perlu migrasi (apakah kolom description belum ada)
                boolean productsNeedMigration = false;
                try (ResultSet colRs = conn.getMetaData().getColumns(null, null, "products", "description")) {
                    if (!colRs.next()) {
                        productsNeedMigration = true;
                    }
                } catch (Exception e) {
                    // Abaikan jika terjadi error
                }
                
                if (productsNeedMigration) {
                    System.out.println("[Seeder] Tabel 'products' membutuhkan migrasi schema. Menjalankan ALTER...");
                    try {
                        stmt.executeUpdate("ALTER TABLE `products` ADD COLUMN `description` TEXT NULL AFTER `image`");
                        stmt.executeUpdate("ALTER TABLE `products` ADD COLUMN `rating` DECIMAL(3,1) NOT NULL DEFAULT 4.5 AFTER `description`");
                        System.out.println("[Seeder] Kolom 'description' dan 'rating' berhasil ditambahkan ke tabel 'products'.");
                        
                        // Mengisi deskripsi & rating default untuk produk awal
                        stmt.executeUpdate("UPDATE `products` SET `description` = 'Overgrip premium dengan daya cengkeram maksimal dan penyerapan keringat yang luar biasa.', `rating` = 4.8 WHERE `product_id` = 1");
                        stmt.executeUpdate("UPDATE `products` SET `description` = 'Raket padel tingkat profesional dengan kontrol presisi tinggi dan sweetspot yang luas.', `rating` = 4.9 WHERE `product_id` = 2");
                        stmt.executeUpdate("UPDATE `products` SET `description` = 'Raket padel ringan khusus anak-anak untuk kenyamanan dan kemudahan belajar.', `rating` = 4.7 WHERE `product_id` = 3");
                        stmt.executeUpdate("UPDATE `products` SET `description` = 'Tas padel fungsional dengan kompartemen raket termal dan kantong aksesoris luas.', `rating` = 4.6 WHERE `product_id` = 4");
                        stmt.executeUpdate("UPDATE `products` SET `description` = 'Raket padel berkecepatan tinggi dengan transfer energi maksimal untuk pukulan bertenaga.', `rating` = 4.8 WHERE `product_id` = 5");
                        stmt.executeUpdate("UPDATE `products` SET `description` = 'Produk percobaan untuk testing sistem toko.', `rating` = 4.0 WHERE `product_id` = 13");
                        stmt.executeUpdate("UPDATE `products` SET `description` = 'Produk sewa percobaan untuk testing sistem rental.', `rating` = 4.2 WHERE `product_id` = 14");
                        System.out.println("[Seeder] Data awal produk berhasil diperbarui dengan deskripsi dan rating.");
                    } catch (Exception e) {
                        System.err.println("[Seeder] Gagal melakukan migrasi tabel 'products': " + e.getMessage());
                        e.printStackTrace();
                    }
                }
                
                // Cek apakah tabel 'rentals' perlu dibuat
                boolean rentalsExists = false;
                try (ResultSet rs = conn.getMetaData().getTables(null, null, "rentals", null)) {
                    if (rs.next()) {
                        rentalsExists = true;
                    }
                } catch (Exception e) {
                    // Abaikan
                }
                
                 if (!rentalsExists) {
                    System.out.println("[Seeder] Tabel 'rentals' belum ada. Membuat tabel...");
                    try {
                        String createRentalsSql = "CREATE TABLE `rentals` ("
                                + "  `rental_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,"
                                + "  `transaction_id` int(11) NOT NULL,"
                                + "  `booking_id` int(11) DEFAULT NULL,"
                                + "  `user_id` int(11) NOT NULL,"
                                + "  `product_id` int(11) NOT NULL,"
                                + "  `quantity` int(11) NOT NULL DEFAULT 1,"
                                + "  `rental_date` date NOT NULL,"
                                + "  `due_date` date NOT NULL,"
                                + "  `return_date` date DEFAULT NULL,"
                                + "  `status` enum('Active','Returned','Overdue') NOT NULL DEFAULT 'Active',"
                                + "  FOREIGN KEY (`transaction_id`) REFERENCES `transaction` (`transaction_id`) ON DELETE CASCADE,"
                                + "  FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE SET NULL ON UPDATE CASCADE,"
                                + "  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,"
                                + "  FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON UPDATE CASCADE"
                                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
                        stmt.executeUpdate(createRentalsSql);
                        System.out.println("[Seeder] Tabel 'rentals' berhasil dibuat.");
                    } catch (Exception e) {
                        System.err.println("[Seeder] Gagal membuat tabel 'rentals': " + e.getMessage());
                        e.printStackTrace();
                    }
                } else {
                    // Cek apakah kolom booking_id sudah ada di tabel rentals
                    boolean hasBookingId = false;
                    try (ResultSet colRs = conn.getMetaData().getColumns(null, null, "rentals", "booking_id")) {
                        if (colRs.next()) {
                            hasBookingId = true;
                        }
                    } catch (Exception e) {
                        // Abaikan
                    }
                    
                    if (!hasBookingId) {
                        System.out.println("[Seeder] Tabel 'rentals' membutuhkan migrasi booking_id. Menjalankan ALTER...");
                        try {
                            stmt.executeUpdate("ALTER TABLE `rentals` ADD COLUMN `booking_id` int(11) DEFAULT NULL AFTER `transaction_id`");
                            stmt.executeUpdate("ALTER TABLE `rentals` ADD KEY `booking_id` (`booking_id`)");
                            stmt.executeUpdate("ALTER TABLE `rentals` ADD CONSTRAINT `rentals_ibfk_4` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE SET NULL ON UPDATE CASCADE");
                            System.out.println("[Seeder] Kolom 'booking_id' berhasil ditambahkan ke tabel 'rentals'.");
                        } catch (Exception e) {
                            System.err.println("[Seeder] Gagal melakukan migrasi booking_id ke tabel 'rentals': " + e.getMessage());
                            e.printStackTrace();
                        }
                    }
                }

                // Cek apakah tabel 'music_requests' perlu dibuat
                boolean musicRequestsExists = false;
                try (ResultSet rs = conn.getMetaData().getTables(null, null, "music_requests", null)) {
                    if (rs.next()) {
                        musicRequestsExists = true;
                    }
                } catch (Exception e) {
                    // Abaikan
                }

                if (!musicRequestsExists) {
                    System.out.println("[Seeder] Tabel 'music_requests' belum ada. Membuat tabel...");
                    try {
                        String createMusicRequestsSql = "CREATE TABLE `music_requests` ("
                                + "  `request_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,"
                                + "  `user_id` int(11) NOT NULL,"
                                + "  `song_title` varchar(255) NOT NULL,"
                                + "  `artist` varchar(255) NOT NULL,"
                                + "  `status` enum('Pending','Playing','Played','Cancelled') NOT NULL DEFAULT 'Pending',"
                                + "  `requested_at` timestamp NOT NULL DEFAULT current_timestamp(),"
                                + "  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE"
                                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
                        stmt.executeUpdate(createMusicRequestsSql);
                        System.out.println("[Seeder] Tabel 'music_requests' berhasil dibuat.");
                    } catch (Exception e) {
                        System.err.println("[Seeder] Gagal membuat tabel 'music_requests': " + e.getMessage());
                        e.printStackTrace();
                    }
                }
                return;
            }

            System.out.println("[Seeder] Tabel belum ada. Memulai impor database dari aplikasi_padel.sql...");
            
            // 3. Baca file SQL dari resource classpath dan eksekusi query-nya
            try (InputStream is = DatabaseSeeder.class.getClassLoader().getResourceAsStream("aplikasi_padel.sql")) {
                if (is == null) {
                    System.err.println("[Seeder] File 'aplikasi_padel.sql' tidak ditemukan di folder resources!");
                    return;
                }
                
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                    StringBuilder sql = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        String trimmedLine = line.trim();
                        // Abaikan baris kosong dan komentar
                        if (trimmedLine.isEmpty() || trimmedLine.startsWith("--") || trimmedLine.startsWith("/*")) {
                            continue;
                        }
                        
                        sql.append(line).append("\n");
                        
                        // Jalankan jika mendeteksi akhir dari query (semicolon)
                        if (trimmedLine.endsWith(";")) {
                            String query = sql.toString().trim();
                            // Hapus semicolon di ujung query karena tidak dibutuhkan oleh JDBC execute
                            if (query.endsWith(";")) {
                                query = query.substring(0, query.length() - 1);
                            }
                            
                            if (!query.isEmpty()) {
                                stmt.execute(query);
                            }
                            sql.setLength(0); // Reset buffer
                        }
                    }
                    System.out.println("[Seeder] Impor database aplikasi_padel.sql berhasil diselesaikan!");
                }
            }

        } catch (Exception e) {
            System.err.println("[Seeder] Gagal melakukan seeding database: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("=== SYSTEM: DATABASE SEEDER SELESAI ===");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Dipanggil ketika aplikasi dimatikan
    }
}
