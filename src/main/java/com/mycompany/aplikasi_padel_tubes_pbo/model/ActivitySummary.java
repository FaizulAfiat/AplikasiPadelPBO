package com.mycompany.aplikasi_padel_tubes_pbo.model;

import java.util.Date;
import java.util.List;

public class ActivitySummary {
    private int summaryId;
    private int userId;
    private Date summaryDate;
    private int totalSessions;
    private int totalDuration;
    private int totalCalories;

    public ActivitySummary() {
    }

    public int getSummaryId() {
        return summaryId;
    }

    public void setSummaryId(int summaryId) {
        this.summaryId = summaryId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    public void calculateSummary(List<PadelSession> sessions) {
        if (sessions == null || sessions.isEmpty()) {
            this.totalSessions = 0;
            this.totalDuration = 0;
            this.totalCalories = 0;
            this.summaryDate = new Date();
            return;
        }

        this.totalSessions = sessions.size();
        int durationSum = 0;
        int caloriesSum = 0;
        for (PadelSession s : sessions) {
            durationSum += s.getDurationMinutes();
            caloriesSum += s.getCaloriesBurned();
        }
        this.totalDuration = durationSum;
        this.totalCalories = caloriesSum;
        this.summaryDate = new Date(); // Typically represents when the recap is done
    }
}
