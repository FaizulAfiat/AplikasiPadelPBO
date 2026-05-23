/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.health.model;

import java.util.Date;

public class PadelSession {

    private int sessionId;
    private Date startTime;
    private Date endTime;
    private int durationMinutes;
    private int caloriesBurned;
    private float avgHeartRate;

    public PadelSession() {
    }

    // METHOD UML
    public int calculateCalories() {

        caloriesBurned = durationMinutes * 8;

        return caloriesBurned;
    }

    // GETTER SETTER
    public int getSessionId() {
        return sessionId;
    }

    public void setSessionId(int sessionId) {
        this.sessionId = sessionId;
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
}
