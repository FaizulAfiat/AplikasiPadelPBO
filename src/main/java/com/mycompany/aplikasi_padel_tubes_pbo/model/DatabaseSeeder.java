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
