/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.health.service;

import com.mycompany.aplikasi_padel_tubes_pbo.health.model.PerformanceScore;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class PerformanceScoreService {

    private Connection conn;

    public PerformanceScoreService(Connection conn) {
        this.conn = conn;
    }

    public void saveScore(PerformanceScore score) {

        try {

            String sql = "INSERT INTO performance_scores "
                    + "(user_id, calculated_date, fitness_score, category) "
                    + "VALUES (?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, score.getUserId());
            ps.setDate(2, score.getCalculatedDate());
            ps.setFloat(3, score.getFitnessScore());
            ps.setString(4, score.getCategory());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
