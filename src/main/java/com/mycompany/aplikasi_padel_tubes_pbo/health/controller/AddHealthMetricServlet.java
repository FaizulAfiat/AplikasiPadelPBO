package com.mycompany.aplikasi_padel_tubes_pbo.health.controller;

import com.mycompany.aplikasi_padel_tubes_pbo.resources.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDate;

@WebServlet("/addHealth")
public class AddHealthMetricServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("trackhealth.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String userId = request.getParameter("userId");
        String heartRate = request.getParameter("heartRate");
        String bmi = request.getParameter("bmi");
        String steps = request.getParameter("steps");
        String calories = request.getParameter("calories");

        LocalDate today = LocalDate.now();

        try {

            Connection conn = DatabaseConnection.getConnection();

            // =========================
            // INSERT HEALTH METRICS
            // =========================
            String sql = "INSERT INTO health_metrics "
                    + "(user_id, record_date, resting_heart_rate, bmi, total_steps, calories_daily) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, Integer.parseInt(userId));
            ps.setDate(2, java.sql.Date.valueOf(today));
            ps.setInt(3, Integer.parseInt(heartRate));
            ps.setFloat(4, Float.parseFloat(bmi));
            ps.setInt(5, Integer.parseInt(steps));
            ps.setInt(6, Integer.parseInt(calories));

            ps.executeUpdate();

            // =========================
            // PERFORMANCE SCORE
            // =========================
            float score = (Float.parseFloat(bmi)
                    + Integer.parseInt(steps) / 1000f
                    + Integer.parseInt(calories) / 100f
                    + Integer.parseInt(heartRate) / 10f);

            String category;

            if (score >= 100) {
                category = "Excellent";
            } else if (score >= 70) {
                category = "Good";
            } else if (score >= 40) {
                category = "Average";
            } else {
                category = "Poor";
            }

            // =========================
            // INSERT PERFORMANCE SCORE
            // =========================
            String scoreSql = "INSERT INTO performance_scores "
                    + "(user_id, calculated_date, fitness_score, category) "
                    + "VALUES (?, ?, ?, ?)";

            PreparedStatement ps2 = conn.prepareStatement(scoreSql);

            ps2.setInt(1, Integer.parseInt(userId));
            ps2.setDate(2, java.sql.Date.valueOf(today));
            ps2.setFloat(3, score);
            ps2.setString(4, category);

            ps2.executeUpdate();

            // =========================
            // OUTPUT HTML
            // =========================
            PrintWriter out = response.getWriter();

            out.println("""
                <html>
                <head>
                    <title>Track Health</title>
                    <style>
                        body{
                            font-family: Arial;
                            background:#f3f4f6;
                            padding:40px;
                        }

                        .box{
                            background:white;
                            padding:30px;
                            border-radius:12px;
                            width:500px;
                            margin:auto;
                            box-shadow:0 0 10px rgba(0,0,0,0.1);
                        }

                        h1{
                            color:green;
                        }

                        a{
                            display:inline-block;
                            margin-top:20px;
                            background:black;
                            color:white;
                            padding:10px 20px;
                            text-decoration:none;
                        }
                    </style>
                </head>

                <body>

                    <div class='box'>

                        <h1>Data berhasil disimpan!</h1>

            """);

            out.println("<p><b>User ID:</b> " + userId + "</p>");
            out.println("<p><b>Heart Rate:</b> " + heartRate + "</p>");
            out.println("<p><b>BMI:</b> " + bmi + "</p>");
            out.println("<p><b>Steps:</b> " + steps + "</p>");
            out.println("<p><b>Calories:</b> " + calories + "</p>");

            out.println("<hr>");

            out.println("<h2>Performance Score</h2>");
            out.println("<p><b>Fitness Score:</b> " + score + "</p>");
            out.println("<p><b>Category:</b> " + category + "</p>");

            out.println("<a href='index.jsp'>Back</a>");

            out.println("""
                    </div>
                </body>
                </html>
            """);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
