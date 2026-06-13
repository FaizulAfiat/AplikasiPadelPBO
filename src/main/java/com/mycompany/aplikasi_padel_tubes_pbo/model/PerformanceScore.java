package com.mycompany.aplikasi_padel_tubes_pbo.model;

import java.util.Date;

public class PerformanceScore {
    private int scoreId;
    private int userId;
    private Date calculatedDate;
    private float fitnessScore;
    private String category;

    public PerformanceScore() {
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

    public float calculateScore(ActivitySummary summary, HealthMetric metric) {
        float restingHRPart = 70f;
        if (metric != null && metric.getRestingHeartRate() > 0) {
            int rhr = metric.getRestingHeartRate();
            // Normal resting heart rate is 60-100 bpm. Athletes lower.
            if (rhr <= 60) {
                restingHRPart = 100f;
            } else if (rhr >= 100) {
                restingHRPart = 40f;
            } else {
                restingHRPart = 100f - (rhr - 60f) * 1.5f;
            }
        }

        float stepsPart = 50f;
        if (metric != null && metric.getTotalSteps() > 0) {
            // Target is 10k steps.
            stepsPart = Math.min(100f, (metric.getTotalSteps() / 10000f) * 100f);
        }

        float sessionsPart = 0f;
        if (summary != null && summary.getTotalSessions() > 0) {
            // Target is 3 padel sessions per activity recap range.
            sessionsPart = Math.min(100f, (summary.getTotalSessions() / 3f) * 100f);
        }

        float bmiPart = 70f;
        if (metric != null && metric.getBmi() > 0) {
            float bmiVal = metric.getBmi();
            // Normal BMI range: 18.5 - 24.9
            if (bmiVal >= 18.5f && bmiVal <= 24.9f) {
                bmiPart = 100f;
            } else {
                // Deduct points based on distance from the healthy midpoint (21.7)
                bmiPart = Math.max(30f, 100f - Math.abs(bmiVal - 21.7f) * 6f);
            }
        }

        // Weighted Average of components:
        // Padel Workout Consistency (35%), Step Count (25%), Resting Heart Rate (20%), Body Weight/BMI (20%)
        this.fitnessScore = (sessionsPart * 0.35f) + (stepsPart * 0.25f) + (restingHRPart * 0.20f) + (bmiPart * 0.20f);
        this.category = getCategory(this.fitnessScore);
        this.calculatedDate = new Date();
        return this.fitnessScore;
    }

    public String getCategory(float score) {
        if (score >= 85) {
            return "Excellent";
        } else if (score >= 70) {
            return "Good";
        } else if (score >= 50) {
            return "Average";
        } else {
            return "Poor";
        }
    }
}
