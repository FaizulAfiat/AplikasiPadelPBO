/*
 * Model class untuk User Achievement (Track achievement yang sudah di-unlock user)
 * @author Muhammad Alfian
 */
package com.mycompany.aplikasi_padel_tubes_pbo.model;

import java.sql.Timestamp;

public class UserAchievement {
    private int userAchievementId;
    private int userId;
    private int achievementId;
    private Timestamp unlockedAt;
    
    // Tambahan: untuk display achievement detail
    private String achievementName;
    private String achievementIcon;
    private String badgeColor;
    private String description;

    // Constructor default
    public UserAchievement() {}

    // Constructor dengan parameter basic
    public UserAchievement(int userId, int achievementId, Timestamp unlockedAt) {
        this.userId = userId;
        this.achievementId = achievementId;
        this.unlockedAt = unlockedAt;
    }

    // Constructor dengan parameter lengkap (untuk display)
    public UserAchievement(int userAchievementId, int userId, int achievementId, 
                          Timestamp unlockedAt, String achievementName, String achievementIcon, 
                          String badgeColor, String description) {
        this.userAchievementId = userAchievementId;
        this.userId = userId;
        this.achievementId = achievementId;
        this.unlockedAt = unlockedAt;
        this.achievementName = achievementName;
        this.achievementIcon = achievementIcon;
        this.badgeColor = badgeColor;
        this.description = description;
    }

    // Getter & Setter
    public int getUserAchievementId() {
        return userAchievementId;
    }

    public void setUserAchievementId(int userAchievementId) {
        this.userAchievementId = userAchievementId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getAchievementId() {
        return achievementId;
    }

    public void setAchievementId(int achievementId) {
        this.achievementId = achievementId;
    }

    public Timestamp getUnlockedAt() {
        return unlockedAt;
    }

    public void setUnlockedAt(Timestamp unlockedAt) {
        this.unlockedAt = unlockedAt;
    }

    public String getAchievementName() {
        return achievementName;
    }

    public void setAchievementName(String achievementName) {
        this.achievementName = achievementName;
    }

    public String getAchievementIcon() {
        return achievementIcon;
    }

    public void setAchievementIcon(String achievementIcon) {
        this.achievementIcon = achievementIcon;
    }

    public String getBadgeColor() {
        return badgeColor;
    }

    public void setBadgeColor(String badgeColor) {
        this.badgeColor = badgeColor;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "UserAchievement{" +
                "userAchievementId=" + userAchievementId +
                ", userId=" + userId +
                ", achievementId=" + achievementId +
                ", achievementName='" + achievementName + '\'' +
                ", unlockedAt=" + unlockedAt +
                '}';
    }
}
