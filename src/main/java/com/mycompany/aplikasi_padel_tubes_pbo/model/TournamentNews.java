package com.mycompany.aplikasi_padel_tubes_pbo.model;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;

/**
 * Subclass representing Tournament News.
 * Inherits from News (Inheritance).
 * Encapsulates tournament-specific properties and logic.
 * 
 * @author Faizul Afiat
 */
public class TournamentNews extends News {
    private int courtId;
    private String courtName;
    private Date tournamentDate;
    private int maxParticipants;
    private int currentParticipants;

    // Constructors
    public TournamentNews() {
        super();
    }

    public TournamentNews(int id, String title, String content, String imageUrl, Timestamp createdAt,
                          int courtId, String courtName, Date tournamentDate, int maxParticipants, int currentParticipants) {
        super(id, title, content, imageUrl, createdAt);
        this.courtId = courtId;
        this.courtName = courtName;
        this.tournamentDate = tournamentDate;
        this.maxParticipants = maxParticipants;
        this.currentParticipants = currentParticipants;
    }

    // Implementing Abstract Method (Polymorphism)
    @Override
    public String getCategory() {
        return "Tournament";
    }

    // Business Logic Methods
    
    /**
     * Checks if the tournament is upcoming (in the future or today).
     */
    public boolean isUpcoming() {
        if (tournamentDate == null) {
            return false;
        }
        LocalDate today = LocalDate.now();
        LocalDate tDate = tournamentDate.toLocalDate();
        return !tDate.isBefore(today); // Today or in the future
    }

    /**
     * Checks if the tournament quota is full.
     */
    public boolean isFull() {
        return currentParticipants >= maxParticipants;
    }

    /**
     * Business validation rule to check if a user with a given role can register.
     */
    public boolean canRegister(String role) {
        if (role == null) {
            return false;
        }
        boolean isPremiumOrAdmin = "Premium".equalsIgnoreCase(role) || "Admin".equalsIgnoreCase(role);
        return isPremiumOrAdmin && isUpcoming() && !isFull();
    }

    // Getters and Setters
    public int getCourtId() {
        return courtId;
    }

    public void setCourtId(int courtId) {
        this.courtId = courtId;
    }

    public String getCourtName() {
        return courtName;
    }

    public void setCourtName(String courtName) {
        this.courtName = courtName;
    }

    public Date getTournamentDate() {
        return tournamentDate;
    }

    public void setTournamentDate(Date tournamentDate) {
        this.tournamentDate = tournamentDate;
    }

    public int getMaxParticipants() {
        return maxParticipants;
    }

    public void setMaxParticipants(int maxParticipants) {
        this.maxParticipants = maxParticipants;
    }

    public int getCurrentParticipants() {
        return currentParticipants;
    }

    public void setCurrentParticipants(int currentParticipants) {
        this.currentParticipants = currentParticipants;
    }
}
