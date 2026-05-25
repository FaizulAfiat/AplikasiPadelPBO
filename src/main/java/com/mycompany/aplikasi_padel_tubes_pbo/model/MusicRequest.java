package com.mycompany.aplikasi_padel_tubes_pbo.model;

import java.sql.Timestamp;

public class MusicRequest {
    private int requestId;
    private int userId;
    private String username;
    private Integer courtId;
    private String courtName;
    private String trackName;
    private String artist;
    private String platform;
    private String trackUrl;
    private String status;
    private Timestamp requestedAt;

    public MusicRequest() {
    }

    public MusicRequest(int requestId, int userId, String username, Integer courtId, String courtName,
                        String trackName, String artist, String platform, String trackUrl, 
                        String status, Timestamp requestedAt) {
        this.requestId = requestId;
        this.userId = userId;
        this.username = username;
        this.courtId = courtId;
        this.courtName = courtName;
        this.trackName = trackName;
        this.artist = artist;
        this.platform = platform;
        this.trackUrl = trackUrl;
        this.status = status;
        this.requestedAt = requestedAt;
    }

    // Getters and Setters
    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Integer getCourtId() {
        return courtId;
    }

    public void setCourtId(Integer courtId) {
        this.courtId = courtId;
    }

    public String getCourtName() {
        return courtName;
    }

    public void setCourtName(String courtName) {
        this.courtName = courtName;
    }

    public String getTrackName() {
        return trackName;
    }

    public void setTrackName(String trackName) {
        this.trackName = trackName;
    }

    public String getArtist() {
        return artist;
    }

    public void setArtist(String artist) {
        this.artist = artist;
    }

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public String getTrackUrl() {
        return trackUrl;
    }

    public void setTrackUrl(String trackUrl) {
        this.trackUrl = trackUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(Timestamp requestedAt) {
        this.requestedAt = requestedAt;
    }
}
