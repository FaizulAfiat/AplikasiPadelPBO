package com.mycompany.aplikasi_padel_tubes_pbo.model;

import java.util.Date;

public class PadelSession {
    private int sessionId;
    private int userId;
    private Date startTime;
    private Date endTime;
    private int durationMinutes;
    private int caloriesBurned;
    private float avgHeartRate;
    private User user; // Reference to User for weight

    public PadelSession() {
    }

    public int getSessionId() {
        return sessionId;
    }

    public void setSessionId(int sessionId) {
        this.sessionId = sessionId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public int getCaloriesBurned() {
        return caloriesBurned;
    }

    public void setCaloriesBurned(int caloriesBurned) {
        this.caloriesBurned = caloriesBurned;
    }

    public float getAvgHeartRate() {
        return avgHeartRate;
    }

    public void setAvgHeartRate(float avgHeartRate) {
        this.avgHeartRate = avgHeartRate;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public int calculateCalories() {
        float weight = (user != null && user.getWeight() > 0) ? user.getWeight() : 70.0f;
        // Padel session METs typically ranges from 7.0 to 11.0 based on intensity (avgHeartRate)
        double met = 8.0;
        if (avgHeartRate > 120) {
            met = 10.0;
        }
        if (avgHeartRate > 150) {
            met = 12.0;
        }
        // Calories = MET * 3.5 * weight_kg / 200 * duration_minutes
        this.caloriesBurned = (int) (durationMinutes * met * (weight / 70.0));
        return this.caloriesBurned;
    }
}
