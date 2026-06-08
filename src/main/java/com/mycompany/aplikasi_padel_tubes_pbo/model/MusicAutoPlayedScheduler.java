package com.mycompany.aplikasi_padel_tubes_pbo.model;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Scheduler otomatis: lagu yang sedang diputar (status 'Playing') akan
 * otomatis berpindah ke history (status 'Played') setelah SONG_DURATION_SECONDS
 * berlalu sejak lagu mulai diputar (started_at).
 */
@WebListener
public class MusicAutoPlayedScheduler implements ServletContextListener {

    // Durasi lagu dalam detik (default: 4 menit = 240 detik)
    private static final int SONG_DURATION_SECONDS = 240;

    // Interval pengecekan scheduler (setiap 30 detik)
    private static final int CHECK_INTERVAL_SECONDS = 30;

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "MusicAutoPlayed-Scheduler");
            t.setDaemon(true); // Thread daemon agar mati otomatis saat server dimatikan
            return t;
        });

        // Mulai scheduler: delay awal 15 detik, lalu cek setiap CHECK_INTERVAL_SECONDS
        scheduler.scheduleAtFixedRate(
            this::autoMarkPlayedSongs,
            15,
            CHECK_INTERVAL_SECONDS,
            TimeUnit.SECONDS
        );

        System.out.println("[MusicScheduler] Auto-played scheduler dimulai. " +
            "Pengecekan setiap " + CHECK_INTERVAL_SECONDS + " detik. " +
            "Durasi lagu: " + SONG_DURATION_SECONDS + " detik.");
    }

    /**
     * Task yang dijalankan scheduler: cari semua lagu berstatus 'Playing'
     * yang sudah melebihi durasi sejak started_at, lalu tandai sebagai 'Played'.
     */
    private void autoMarkPlayedSongs() {
        try (Connection conn = Koneksi.getConnection()) {

            // Cek berapa lagu yang akan diupdate (untuk logging)
            String countSql = "SELECT COUNT(*) FROM music_requests " +
                              "WHERE status = 'Playing' " +
                              "AND started_at IS NOT NULL " +
                              "AND TIMESTAMPDIFF(SECOND, started_at, NOW()) >= duration_seconds";
            int count = 0;
            try (PreparedStatement ps = conn.prepareStatement(countSql)) {
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        count = rs.getInt(1);
                    }
                }
            }

            if (count > 0) {
                // Update semua lagu Playing yang sudah melewati durasi -> Played
                String updateSql = "UPDATE music_requests " +
                                   "SET status = 'Played', played_at = NOW() " +
                                   "WHERE status = 'Playing' " +
                                   "AND started_at IS NOT NULL " +
                                   "AND TIMESTAMPDIFF(SECOND, started_at, NOW()) >= duration_seconds";
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    int updated = ps.executeUpdate();
                    System.out.println("[MusicScheduler] " + updated +
                        " lagu otomatis dipindahkan ke history (Played).");
                }
            }

        } catch (Exception e) {
            System.err.println("[MusicScheduler] Error saat menjalankan auto-played task: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdown();
            try {
                // Tunggu maksimal 5 detik agar task yang sedang berjalan selesai
                if (!scheduler.awaitTermination(5, TimeUnit.SECONDS)) {
                    scheduler.shutdownNow();
                }
            } catch (InterruptedException e) {
                scheduler.shutdownNow();
                Thread.currentThread().interrupt();
            }
            System.out.println("[MusicScheduler] Auto-played scheduler dihentikan.");
        }
    }
}
