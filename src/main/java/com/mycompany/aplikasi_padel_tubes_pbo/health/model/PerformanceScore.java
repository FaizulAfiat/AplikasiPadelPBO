/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.health.model;

import java.sql.Date;

public class PerformanceScore {

    private int scoreId;
    private int userId;
    private Date calculatedDate;
    private float fitnessScore;
    private String category;

    public PerformanceScore() {
    }

    public PerformanceScore(int userId, Date calculatedDate,
            float fitnessScore, String category) {

        this.userId = userId;
        this.calculatedDate = calculatedDate;
        this.fitnessScore = fitnessScore;
        this.category = category;
    }

    public int getScoreId() {
        return scoreId;
    }

    public void setScoreId(int scoreId) {
        this.scoreId = scoreId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getCalculatedDate() {
        return calculatedDate;
    }

    public void setCalculatedDate(Date calculatedDate) {
        this.calculatedDate = calculatedDate;
    }

    public float getFitnessScore() {
        return fitnessScore;
    }

    public void setFitnessScore(float fitnessScore) {
        this.fitnessScore = fitnessScore;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}
