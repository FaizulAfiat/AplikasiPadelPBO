package com.mycompany.aplikasi_padel_tubes_pbo.model;

import java.sql.Timestamp;

/**
 * Abstract Base Class representing a generic News/Article.
 * Demonstrates Abstraction and Encapsulation in OOP.
 * 
 * @author Faizul Afiat
 */
public abstract class News {
    private int id;
    private String title;
    private String content;
    private String imageUrl;
    private Timestamp createdAt;

    // Constructors
    public News() {
    }

    public News(int id, String title, String content, String imageUrl, Timestamp createdAt) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
    }

    // Abstract Method (Polymorphism)
    public abstract String getCategory();

    // Getters and Setters (Encapsulation)
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
