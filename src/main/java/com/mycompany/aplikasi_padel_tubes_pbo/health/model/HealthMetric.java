/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.health.model;

import java.util.Date;

public class HealthMetric {

    private int metricId;
    private int userId;
    private Date recordDate;
    private int restingHeartRate;
    private float bmi;
    private int totalSteps;
    private int caloriesDaily;

    public HealthMetric() {
    }

    public HealthMetric(int metricId, int userId, Date recordDate,
            int restingHeartRate, float bmi,
            int totalSteps, int caloriesDaily) {

        this.metricId = metricId;
        this.userId = userId;
        this.recordDate = recordDate;
        this.restingHeartRate = restingHeartRate;
        this.bmi = bmi;
        this.totalSteps = totalSteps;
        this.caloriesDaily = caloriesDaily;
    }

    // METHOD UML
    public float updateBMI(float weight, float height) {

        if (height <= 0) {
            return 0;
        }

        bmi = weight / (height * height);

        return bmi;
    }

    // GETTER SETTER
    public int getMetricId() {
        return metricId;
    }

    public void setMetricId(int metricId) {
        this.metricId = metricId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getRecordDate() {
        return recordDate;
    }

    public void setRecordDate(Date recordDate) {
        this.recordDate = recordDate;
    }

    public int getRestingHeartRate() {
        return restingHeartRate;
    }

    public void setRestingHeartRate(int restingHeartRate) {
        this.restingHeartRate = restingHeartRate;
    }

    public float getBmi() {
        return bmi;
    }

    public void setBmi(float bmi) {
        this.bmi = bmi;
    }

    public int getTotalSteps() {
        return totalSteps;
    }

    public void setTotalSteps(int totalSteps) {
        this.totalSteps = totalSteps;
    }

    public int getCaloriesDaily() {
        return caloriesDaily;
    }

    public void setCaloriesDaily(int caloriesDaily) {
        this.caloriesDaily = caloriesDaily;
    }
}
