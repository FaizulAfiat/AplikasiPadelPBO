/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.health.model;

import java.util.Date;
import java.util.List;

public class ActivitySummary {

    private int summaryId;
    private Date summaryDate;
    private int totalSessions;
    private int totalDuration;
    private int totalCalories;

    public ActivitySummary() {
    }

    // METHOD UML
    public void calculateSummary(List<PadelSession> sessions) {

        totalSessions = sessions.size();

        totalDuration = 0;
        totalCalories = 0;

        for (PadelSession s : sessions) {

            totalDuration += s.getDurationMinutes();

            totalCalories += s.getCaloriesBurned();
        }
    }

    // GETTER SETTER
    public int getSummaryId() {
        return summaryId;
    }

    public void setSummaryId(int summaryId) {
        this.summaryId = summaryId;
    }

    public Date getSummaryDate() {
        return summaryDate;
    }

    public void setSummaryDate(Date summaryDate) {
        this.summaryDate = summaryDate;
    }

    public int getTotalSessions() {
        return totalSessions;
    }

    public void setTotalSessions(int totalSessions) {
        this.totalSessions = totalSessions;
    }

    public int getTotalDuration() {
        return totalDuration;
    }

    public void setTotalDuration(int totalDuration) {
        this.totalDuration = totalDuration;
    }

    public int getTotalCalories() {
        return totalCalories;
    }

    public void setTotalCalories(int totalCalories) {
        this.totalCalories = totalCalories;
    }
}
