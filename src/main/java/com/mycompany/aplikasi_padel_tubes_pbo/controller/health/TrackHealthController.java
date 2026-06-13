package com.mycompany.aplikasi_padel_tubes_pbo.controller.health;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Koneksi;
import com.mycompany.aplikasi_padel_tubes_pbo.model.User;
import com.mycompany.aplikasi_padel_tubes_pbo.model.PadelSession;
import com.mycompany.aplikasi_padel_tubes_pbo.model.ActivitySummary;
import com.mycompany.aplikasi_padel_tubes_pbo.model.HealthMetric;
import com.mycompany.aplikasi_padel_tubes_pbo.model.PerformanceScore;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "TrackHealthController", urlPatterns = {"/TrackHealth"})
public class TrackHealthController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("user_id");

        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html");
            return;
        }

        Exception healthException = (Exception) session.getAttribute("health_exception");
        if (healthException != null) {
            request.setAttribute("healthExceptionMessage", healthException.toString());
            StringBuilder sb = new StringBuilder();
            for (StackTraceElement ste : healthException.getStackTrace()) {
                if (ste.getClassName().contains("com.mycompany")) {
                    sb.append("at ").append(ste.toString()).append("\n");
                }
            }
            if (sb.length() == 0) {
                int count = 0;
                for (StackTraceElement ste : healthException.getStackTrace()) {
                    sb.append("at ").append(ste.toString()).append("\n");
                    if (++count >= 10) break;
                }
            }
            request.setAttribute("healthExceptionStackTrace", sb.toString());
            session.removeAttribute("health_exception");
        }

        int userId = (Integer) userIdObj;
        User user = new User();
        user.setUserId(userId);
        
        List<PadelSession> recentSessions = new ArrayList<>();
        List<HealthMetric> recentMetrics = new ArrayList<>();
        List<PerformanceScore> recentScores = new ArrayList<>();
        
        ActivitySummary summary = new ActivitySummary();
        PerformanceScore currentScore = new PerformanceScore();

        try (Connection conn = Koneksi.getConnection()) {
            // Auto-fix users table columns
            boolean hasAge = false;
            try (ResultSet colRs = conn.getMetaData().getColumns(conn.getCatalog(), null, "users", "age")) {
                if (colRs.next()) hasAge = true;
            }
            if (!hasAge) {
                try (Statement stmt = conn.createStatement()) {
                    stmt.executeUpdate("ALTER TABLE `users` ADD COLUMN `age` INT DEFAULT 0 AFTER `role`");
                    stmt.executeUpdate("ALTER TABLE `users` ADD COLUMN `weight` FLOAT DEFAULT 0.0 AFTER `age`");
                    stmt.executeUpdate("ALTER TABLE `users` ADD COLUMN `height` FLOAT DEFAULT 0.0 AFTER `weight`");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }

            // Auto-create missing tables using CREATE TABLE IF NOT EXISTS
            try (Statement stmt = conn.createStatement()) {
                // padel_sessions
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS `padel_sessions` ("
                        + "  `session_id` INT AUTO_INCREMENT PRIMARY KEY,"
                        + "  `user_id` INT NOT NULL,"
                        + "  `start_time` DATETIME NOT NULL,"
                        + "  `end_time` DATETIME NOT NULL,"
                        + "  `duration_minutes` INT NOT NULL,"
                        + "  `calories_burned` INT NOT NULL,"
                        + "  `avg_heart_rate` FLOAT NOT NULL,"
                        + "  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE"
                        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

                // health_metrics
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS `health_metrics` ("
                        + "  `metric_id` INT AUTO_INCREMENT PRIMARY KEY,"
                        + "  `user_id` INT NOT NULL,"
                        + "  `record_date` DATE NOT NULL,"
                        + "  `resting_heart_rate` INT NOT NULL,"
                        + "  `bmi` FLOAT NOT NULL,"
                        + "  `total_steps` INT NOT NULL,"
                        + "  `calories_daily` INT NOT NULL,"
                        + "  UNIQUE KEY `user_record_date` (`user_id`, `record_date`),"
                        + "  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE"
                        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

                // activity_summaries
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS `activity_summaries` ("
                        + "  `summary_id` INT AUTO_INCREMENT PRIMARY KEY,"
                        + "  `user_id` INT NOT NULL,"
                        + "  `summary_date` DATE NOT NULL,"
                        + "  `total_sessions` INT NOT NULL,"
                        + "  `total_duration` INT NOT NULL,"
                        + "  `total_calories` INT NOT NULL,"
                        + "  UNIQUE KEY `user_summary_date` (`user_id`, `summary_date`),"
                        + "  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE"
                        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

                // performance_scores
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS `performance_scores` ("
                        + "  `score_id` INT AUTO_INCREMENT PRIMARY KEY,"
                        + "  `user_id` INT NOT NULL,"
                        + "  `calculated_date` DATE NOT NULL,"
                        + "  `fitness_score` FLOAT NOT NULL,"
                        + "  `category` VARCHAR(50) NOT NULL,"
                        + "  UNIQUE KEY `user_calculated_date` (`user_id`, `calculated_date`),"
                        + "  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE"
                        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
            } catch (SQLException ex) {
                ex.printStackTrace();
            }

            // 1. Fetch User details (including age, weight, height)
            String userSql = "SELECT username, email, role, age, weight, height FROM users WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(userSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        user.setUsername(rs.getString("username"));
                        user.setEmail(rs.getString("email"));
                        user.setRole(rs.getString("role"));
                        user.setAge(rs.getInt("age"));
                        user.setWeight(rs.getFloat("weight"));
                        user.setHeight(rs.getFloat("height"));
                    }
                }
            }

            // 2. Fetch Padel Sessions
            String sessionSql = "SELECT session_id, start_time, end_time, duration_minutes, calories_burned, avg_heart_rate " +
                                "FROM padel_sessions WHERE user_id = ? ORDER BY start_time DESC LIMIT 10";
            try (PreparedStatement ps = conn.prepareStatement(sessionSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        PadelSession padelSession = new PadelSession();
                        padelSession.setSessionId(rs.getInt("session_id"));
                        padelSession.setUserId(userId);
                        padelSession.setStartTime(rs.getTimestamp("start_time"));
                        padelSession.setEndTime(rs.getTimestamp("end_time"));
                        padelSession.setDurationMinutes(rs.getInt("duration_minutes"));
                        padelSession.setCaloriesBurned(rs.getInt("calories_burned"));
                        padelSession.setAvgHeartRate(rs.getFloat("avg_heart_rate"));
                        padelSession.setUser(user);
                        recentSessions.add(padelSession);
                    }
                }
            }

            // 3. Fetch Health Metrics
            String metricSql = "SELECT metric_id, record_date, resting_heart_rate, bmi, total_steps, calories_daily " +
                               "FROM health_metrics WHERE user_id = ? ORDER BY record_date DESC LIMIT 10";
            try (PreparedStatement ps = conn.prepareStatement(metricSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        HealthMetric metric = new HealthMetric();
                        metric.setMetricId(rs.getInt("metric_id"));
                        metric.setUserId(userId);
                        metric.setRecordDate(rs.getDate("record_date"));
                        metric.setRestingHeartRate(rs.getInt("resting_heart_rate"));
                        metric.setBmi(rs.getFloat("bmi"));
                        metric.setTotalSteps(rs.getInt("total_steps"));
                        metric.setCaloriesDaily(rs.getInt("calories_daily"));
                        recentMetrics.add(metric);
                    }
                }
            }

            // 4. Calculate Activity Summary (based on recent sessions)
            summary.setUserId(userId);
            summary.calculateSummary(recentSessions);
            
            // Persist activity summary to DB (optional, but good to have)
            String saveSummarySql = "INSERT INTO activity_summaries (user_id, summary_date, total_sessions, total_duration, total_calories) " +
                                    "VALUES (?, CURRENT_DATE(), ?, ?, ?) " +
                                    "ON DUPLICATE KEY UPDATE total_sessions = ?, total_duration = ?, total_calories = ?";
            try (PreparedStatement ps = conn.prepareStatement(saveSummarySql)) {
                ps.setInt(1, userId);
                ps.setInt(2, summary.getTotalSessions());
                ps.setInt(3, summary.getTotalDuration());
                ps.setInt(4, summary.getTotalCalories());
                ps.setInt(5, summary.getTotalSessions());
                ps.setInt(6, summary.getTotalDuration());
                ps.setInt(7, summary.getTotalCalories());
                ps.executeUpdate();
            }

            // 5. Calculate Performance Score (based on summary and latest metric)
            HealthMetric latestMetric = recentMetrics.isEmpty() ? null : recentMetrics.get(0);
            currentScore.setUserId(userId);
            currentScore.calculateScore(summary, latestMetric);

            // Persist performance score in DB
            String saveScoreSql = "INSERT INTO performance_scores (user_id, calculated_date, fitness_score, category) " +
                                  "VALUES (?, CURRENT_DATE(), ?, ?) " +
                                  "ON DUPLICATE KEY UPDATE fitness_score = ?, category = ?";
            try (PreparedStatement ps = conn.prepareStatement(saveScoreSql)) {
                ps.setInt(1, userId);
                ps.setFloat(2, currentScore.getFitnessScore());
                ps.setString(3, currentScore.getCategory());
                ps.setFloat(4, currentScore.getFitnessScore());
                ps.setString(5, currentScore.getCategory());
                ps.executeUpdate();
            }

            // 6. Fetch Performance Score history
            String scoreSql = "SELECT score_id, calculated_date, fitness_score, category " +
                              "FROM performance_scores WHERE user_id = ? ORDER BY calculated_date DESC LIMIT 10";
            try (PreparedStatement ps = conn.prepareStatement(scoreSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        PerformanceScore scoreObj = new PerformanceScore();
                        scoreObj.setScoreId(rs.getInt("score_id"));
                        scoreObj.setUserId(userId);
                        scoreObj.setCalculatedDate(rs.getDate("calculated_date"));
                        scoreObj.setFitnessScore(rs.getFloat("fitness_score"));
                        scoreObj.setCategory(rs.getString("category"));
                        recentScores.add(scoreObj);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Set attributes for the JSP view
        request.setAttribute("user", user);
        request.setAttribute("bmi", user.calculateBMI());
        request.setAttribute("recentSessions", recentSessions);
        request.setAttribute("recentMetrics", recentMetrics);
        request.setAttribute("activitySummary", summary);
        request.setAttribute("performanceScore", currentScore);
        request.setAttribute("recentScores", recentScores);

        request.getRequestDispatcher("view/trackhealth.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("user_id");

        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/view/Login.html");
            return;
        }

        int userId = (Integer) userIdObj;
        String action = request.getParameter("action");

        try (Connection conn = Koneksi.getConnection()) {
            if ("updateProfile".equalsIgnoreCase(action)) {
                int age = Integer.parseInt(request.getParameter("age"));
                float weight = Float.parseFloat(request.getParameter("weight"));
                float height = Float.parseFloat(request.getParameter("height"));

                String updateSql = "UPDATE users SET age = ?, weight = ?, height = ? WHERE user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setInt(1, age);
                    ps.setFloat(2, weight);
                    ps.setFloat(3, height);
                    ps.setInt(4, userId);
                    ps.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/TrackHealth?status=profile_updated");
                return;

            } else if ("logSession".equalsIgnoreCase(action)) {
                String startStr = request.getParameter("startTime");
                String endStr = request.getParameter("endTime");
                float avgHeartRate = Float.parseFloat(request.getParameter("avgHeartRate"));

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                Date startTime = sdf.parse(startStr);
                Date endTime = sdf.parse(endStr);

                long durationMs = endTime.getTime() - startTime.getTime();
                int durationMinutes = (int) (durationMs / (1000 * 60));

                if (durationMinutes <= 0) {
                    response.sendRedirect(request.getContextPath() + "/TrackHealth?status=invalid_time");
                    return;
                }

                // Fetch User details for weight estimation inside calculation
                User user = new User();
                String userSql = "SELECT weight FROM users WHERE user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(userSql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            user.setWeight(rs.getFloat("weight"));
                        }
                    }
                }

                PadelSession padelSession = new PadelSession();
                padelSession.setUserId(userId);
                padelSession.setStartTime(startTime);
                padelSession.setEndTime(endTime);
                padelSession.setDurationMinutes(durationMinutes);
                padelSession.setAvgHeartRate(avgHeartRate);
                padelSession.setUser(user);
                padelSession.calculateCalories();

                String insertSql = "INSERT INTO padel_sessions (user_id, start_time, end_time, duration_minutes, calories_burned, avg_heart_rate) " +
                                   "VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, userId);
                    ps.setTimestamp(2, new java.sql.Timestamp(startTime.getTime()));
                    ps.setTimestamp(3, new java.sql.Timestamp(endTime.getTime()));
                    ps.setInt(4, padelSession.getDurationMinutes());
                    ps.setInt(5, padelSession.getCaloriesBurned());
                    ps.setFloat(6, padelSession.getAvgHeartRate());
                    ps.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/TrackHealth?status=session_logged");
                return;

            } else if ("logMetric".equalsIgnoreCase(action)) {
                String recordDateStr = request.getParameter("recordDate");
                int restingHeartRate = Integer.parseInt(request.getParameter("restingHeartRate"));
                int totalSteps = Integer.parseInt(request.getParameter("totalSteps"));
                int caloriesDaily = Integer.parseInt(request.getParameter("caloriesDaily"));

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date recordDate = sdf.parse(recordDateStr);

                // Fetch weight and height to compute daily BMI
                float weight = 70.0f;
                float height = 170.0f;
                String userSql = "SELECT weight, height FROM users WHERE user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(userSql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            weight = rs.getFloat("weight");
                            height = rs.getFloat("height");
                        }
                    }
                }

                HealthMetric metric = new HealthMetric();
                metric.setUserId(userId);
                metric.setRecordDate(recordDate);
                metric.setRestingHeartRate(restingHeartRate);
                metric.setTotalSteps(totalSteps);
                metric.setCaloriesDaily(caloriesDaily);
                metric.updateBMI(weight, height);

                String insertSql = "INSERT INTO health_metrics (user_id, record_date, resting_heart_rate, bmi, total_steps, calories_daily) " +
                                   "VALUES (?, ?, ?, ?, ?, ?) " +
                                   "ON DUPLICATE KEY UPDATE resting_heart_rate = ?, bmi = ?, total_steps = ?, calories_daily = ?";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, userId);
                    ps.setDate(2, new java.sql.Date(recordDate.getTime()));
                    ps.setInt(3, metric.getRestingHeartRate());
                    ps.setFloat(4, metric.getBmi());
                    ps.setInt(5, metric.getTotalSteps());
                    ps.setInt(6, metric.getCaloriesDaily());
                    
                    // ON DUPLICATE KEY UPDATE parameters
                    ps.setInt(7, metric.getRestingHeartRate());
                    ps.setFloat(8, metric.getBmi());
                    ps.setInt(9, metric.getTotalSteps());
                    ps.setInt(10, metric.getCaloriesDaily());
                    
                    ps.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/TrackHealth?status=metric_logged");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("health_exception", e);
            response.sendRedirect(request.getContextPath() + "/TrackHealth?status=error");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/TrackHealth");
    }
}
