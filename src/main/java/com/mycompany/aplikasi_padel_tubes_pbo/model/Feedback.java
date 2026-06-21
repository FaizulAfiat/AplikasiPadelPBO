package com.mycompany.aplikasi_padel_tubes_pbo.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Feedback {
    private int feedbackId;
    private int userId;
    private String username; // Used for joining with users table
    private String facilityType;
    private int rating;
    private String comments;
    private Timestamp createdAt;

    // Constructors
    public Feedback() {
    }

    public Feedback(int userId, String facilityType, int rating, String comments) {
        this.userId = userId;
        this.facilityType = facilityType;
        this.rating = rating;
        this.comments = comments;
    }

    // Getters and Setters
    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
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

    public String getFacilityType() {
        return facilityType;
    }

    public void setFacilityType(String facilityType) {
        this.facilityType = facilityType;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Database Methods

    /**
     * Saves the current feedback instance to the database.
     * @return true if successful, false otherwise.
     */
    public boolean save() {
        String sql = "INSERT INTO feedbacks (user_id, facility_type, rating, comments) VALUES (?, ?, ?, ?)";
        try (Connection conn = Koneksi.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, this.userId);
            ps.setString(2, this.facilityType);
            ps.setInt(3, this.rating);
            ps.setString(4, this.comments);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves all feedbacks joined with the user's username, ordered by latest.
     * @return List of Feedback objects.
     */
    public static List<Feedback> getAllFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.feedback_id, f.user_id, u.username, f.facility_type, f.rating, f.comments, f.created_at "
                   + "FROM feedbacks f "
                   + "JOIN users u ON f.user_id = u.user_id "
                   + "ORDER BY f.created_at DESC";
                   
        try (Connection conn = Koneksi.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackId(rs.getInt("feedback_id"));
                f.setUserId(rs.getInt("user_id"));
                f.setUsername(rs.getString("username"));
                f.setFacilityType(rs.getString("facility_type"));
                f.setRating(rs.getInt("rating"));
                f.setComments(rs.getString("comments"));
                f.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(f);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
