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
                                + "  `started_at` timestamp NULL DEFAULT NULL,"
                                + "  `played_at` timestamp NULL DEFAULT NULL,"
                                + "  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE"
                                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
                        stmt.executeUpdate(createMusicRequestsSql);
                        System.out.println("[Seeder] Tabel 'music_requests' berhasil dibuat.");
                    } catch (Exception e) {
                        System.err.println("[Seeder] Gagal membuat tabel 'music_requests': " + e.getMessage());
                        e.printStackTrace();
                    }
                } else {
                    // Cek apakah kolom 'played_at' sudah ada di tabel music_requests
                    boolean hasPlayedAt = false;
                    try (ResultSet colRs = conn.getMetaData().getColumns(null, null, "music_requests", "played_at")) {
                        if (colRs.next()) {
                            hasPlayedAt = true;
                        }
                    } catch (Exception e) {
                        // Abaikan
                    }

                    if (!hasPlayedAt) {
                        System.out.println("[Seeder] Tabel 'music_requests' membutuhkan migrasi played_at. Menjalankan ALTER...");
                        try {
                            stmt.executeUpdate("ALTER TABLE `music_requests` ADD COLUMN `played_at` timestamp NULL DEFAULT NULL AFTER `requested_at`");
                            System.out.println("[Seeder] Kolom 'played_at' berhasil ditambahkan ke tabel 'music_requests'.");
                        } catch (Exception e) {
                            System.err.println("[Seeder] Gagal melakukan migrasi played_at ke tabel 'music_requests': " + e.getMessage());
                            e.printStackTrace();
                        }
                    }

                    // Cek apakah kolom 'started_at' sudah ada di tabel music_requests
                    boolean hasStartedAt = false;
                    try (ResultSet colRs = conn.getMetaData().getColumns(null, null, "music_requests", "started_at")) {
                        if (colRs.next()) {
                            hasStartedAt = true;
                        }
                    } catch (Exception e) {
                        // Abaikan
                    }

                    if (!hasStartedAt) {
                        System.out.println("[Seeder] Tabel 'music_requests' membutuhkan migrasi started_at. Menjalankan ALTER...");
                        try {
                            stmt.executeUpdate("ALTER TABLE `music_requests` ADD COLUMN `started_at` timestamp NULL DEFAULT NULL AFTER `requested_at`");
                            System.out.println("[Seeder] Kolom 'started_at' berhasil ditambahkan ke tabel 'music_requests'.");
                        } catch (Exception e) {
                            System.err.println("[Seeder] Gagal melakukan migrasi started_at ke tabel 'music_requests': " + e.getMessage());
                            e.printStackTrace();
                        }
                    }
                }
                // Cek apakah tabel 'feedbacks' perlu dibuat
                boolean feedbacksExists = false;
                try (ResultSet rs = conn.getMetaData().getTables(null, null, "feedbacks", null)) {
                    if (rs.next()) {
                        feedbacksExists = true;
                    }
                } catch (Exception e) {
                    // Abaikan
                }

                if (!feedbacksExists) {
                    System.out.println("[Seeder] Tabel 'feedbacks' belum ada. Membuat tabel...");
                    try {
                        String createFeedbacksSql = "CREATE TABLE `feedbacks` ("
                                + "  `feedback_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,"
                                + "  `user_id` int(11) NOT NULL,"
                                + "  `facility_type` varchar(100) NOT NULL,"
                                + "  `rating` int(11) NOT NULL,"
                                + "  `comments` text DEFAULT NULL,"
                                + "  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),"
                                + "  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE"
                                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
                        stmt.executeUpdate(createFeedbacksSql);
                        System.out.println("[Seeder] Tabel 'feedbacks' berhasil dibuat.");
                    } catch (Exception e) {
                        System.err.println("[Seeder] Gagal membuat tabel 'feedbacks': " + e.getMessage());
                        e.printStackTrace();
                    }
                }

                // === START TRACK HEALTH MIGRATION ===
                // 1. Cek & Tambah kolom 'age', 'weight', 'height' di tabel 'users'
                boolean hasAge = false;
                try (ResultSet colRs = conn.getMetaData().getColumns(null, null, "users", "age")) {
                    if (colRs.next()) hasAge = true;
                } catch (Exception e) {}
                if (!hasAge) {
                    System.out.println("[Seeder] Tabel 'users' membutuhkan kolom 'age', 'weight', 'height'. Menjalankan ALTER...");
                    try {
                        stmt.executeUpdate("ALTER TABLE `users` ADD COLUMN `age` INT DEFAULT 0 AFTER `role`");
                        stmt.executeUpdate("ALTER TABLE `users` ADD COLUMN `weight` FLOAT DEFAULT 0.0 AFTER `age`");
                        stmt.executeUpdate("ALTER TABLE `users` ADD COLUMN `height` FLOAT DEFAULT 0.0 AFTER `weight`");
                        System.out.println("[Seeder] Kolom 'age', 'weight', 'height' berhasil ditambahkan ke tabel 'users'.");
                    } catch (Exception e) {
                        System.err.println("[Seeder] Gagal menambahkan kolom kesehatan ke tabel 'users': " + e.getMessage());
                    }
                }

                // 2. Buat tabel 'padel_sessions' jika belum ada
                boolean padelSessionsExist = false;
                try (ResultSet rs = conn.getMetaData().getTables(null, null, "padel_sessions", null)) {
                    if (rs.next()) padelSessionsExist = true;
                } catch (Exception e) {}
                if (!padelSessionsExist) {
                    System.out.println("[Seeder] Tabel 'padel_sessions' belum ada. Membuat tabel...");
                    try {
                        String createPadelSessionsSql = "CREATE TABLE `padel_sessions` ("
                                + "  `session_id` INT AUTO_INCREMENT PRIMARY KEY,"
                                + "  `user_id` INT NOT NULL,"
                                + "  `start_time` DATETIME NOT NULL,"
                                + "  `end_time` DATETIME NOT NULL,"
                                + "  `duration_minutes` INT NOT NULL,"
                                + "  `calories_burned` INT NOT NULL,"
                                + "  `avg_heart_rate` FLOAT NOT NULL,"
                                + "  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE"
                                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
                        stmt.executeUpdate(createPadelSessionsSql);
                        System.out.println("[Seeder] Tabel 'padel_sessions' berhasil dibuat.");
                    } catch (Exception e) {
                        System.err.println("[Seeder] Gagal membuat tabel 'padel_sessions': " + e.getMessage());
                    }
                }

                // 3. Buat tabel 'health_metrics' jika belum ada
                boolean healthMetricsExist = false;
                try (ResultSet rs = conn.getMetaData().getTables(null, null, "health_metrics", null)) {
                    if (rs.next()) healthMetricsExist = true;
                } catch (Exception e) {}
                if (!healthMetricsExist) {
                    System.out.println("[Seeder] Tabel 'health_metrics' belum ada. Membuat tabel...");
                    try {
                        String createHealthMetricsSql = "CREATE TABLE `health_metrics` ("
                                + "  `metric_id` INT AUTO_INCREMENT PRIMARY KEY,"
                                + "  `user_id` INT NOT NULL,"
                                + "  `record_date` DATE NOT NULL,"
                                + "  `resting_heart_rate` INT NOT NULL,"
                                + "  `bmi` FLOAT NOT NULL,"
                                + "  `total_steps` INT NOT NULL,"
                                + "  `calories_daily` INT NOT NULL,"
                                + "  UNIQUE KEY `user_record_date` (`user_id`, `record_date`),"
                                + "  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE"
                                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
                        stmt.executeUpdate(createHealthMetricsSql);
                        System.out.println("[Seeder] Tabel 'health_metrics' berhasil dibuat.");
                    } catch (Exception e) {
                        System.err.println("[Seeder] Gagal membuat tabel 'health_metrics': " + e.getMessage());
                    }
                }

                // 4. Buat tabel 'activity_summaries' jika belum ada
                boolean activitySummariesExist = false;
                try (ResultSet rs = conn.getMetaData().getTables(null, null, "activity_summaries", null)) {
                    if (rs.next()) activitySummariesExist = true;
                } catch (Exception e) {}
                if (!activitySummariesExist) {
                    System.out.println("[Seeder] Tabel 'activity_summaries' belum ada. Membuat tabel...");
                    try {
                        String createActivitySummariesSql = "CREATE TABLE `activity_summaries` ("
                                + "  `summary_id` INT AUTO_INCREMENT PRIMARY KEY,"
                                + "  `user_id` INT NOT NULL,"
                                + "  `summary_date` DATE NOT NULL,"
                                + "  `total_sessions` INT NOT NULL,"
                                + "  `total_duration` INT NOT NULL,"
                                + "  `total_calories` INT NOT NULL,"
                                + "  UNIQUE KEY `user_summary_date` (`user_id`, `summary_date`),"
                                + "  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE"
                                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
                        stmt.executeUpdate(createActivitySummariesSql);
                        System.out.println("[Seeder] Tabel 'activity_summaries' berhasil dibuat.");
                    } catch (Exception e) {
                        System.err.println("[Seeder] Gagal membuat tabel 'activity_summaries': " + e.getMessage());
                    }
                }

                // 5. Buat tabel 'performance_scores' jika belum ada
                boolean performanceScoresExist = false;
                try (ResultSet rs = conn.getMetaData().getTables(null, null, "performance_scores", null)) {
                    if (rs.next()) performanceScoresExist = true;
                } catch (Exception e) {}
                if (!performanceScoresExist) {
                    System.out.println("[Seeder] Tabel 'performance_scores' belum ada. Membuat tabel...");
                    try {
                        String createPerformanceScoresSql = "CREATE TABLE `performance_scores` ("
                                + "  `score_id` INT AUTO_INCREMENT PRIMARY KEY,"
                                + "  `user_id` INT NOT NULL,"
                                + "  `calculated_date` DATE NOT NULL,"
                                + "  `fitness_score` FLOAT NOT NULL,"
                                + "  `category` VARCHAR(50) NOT NULL,"
                                + "  UNIQUE KEY `user_calculated_date` (`user_id`, `calculated_date`),"
                                + "  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE"
                                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
                        stmt.executeUpdate(createPerformanceScoresSql);
                        System.out.println("[Seeder] Tabel 'performance_scores' berhasil dibuat.");
                    } catch (Exception e) {
                        System.err.println("[Seeder] Gagal membuat tabel 'performance_scores': " + e.getMessage());
                    }
                }
                // === END TRACK HEALTH MIGRATION ===

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
