package com.mycompany.aplikasi_padel_tubes_pbo.model;

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

    public float updateBMI(float weight, float height) {
        if (height <= 0) {
            this.bmi = 0;
            return 0;
        }
        float heightInMeters = height / 100.0f;
        this.bmi = weight / (heightInMeters * heightInMeters);
        return this.bmi;
    }
}
