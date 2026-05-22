/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.model;

/**
 *
 * @author Faizul Afiat
 */
public class Product {
    private int id;
    private String name;
    private String category;
    private String type;
    private int price;
    private int stock;
    private String image;
    private String description;
    private double rating;

    public int getId() {
        return id; 
    }
    public void setId(int id) {
        this.id = id; 
    }
    
    public String getName() {
        return name; 
    }
    public void setName(String name) {
        this.name = name; 
    }
    
    public String getType() {
        return type; 
    }
    public void setType(String type) {
        this.type = type; 
    }
    
    public int getPrice() {
        return price; 
    }
    public void setPrice(int price) {
        this.price = price; 
    }
    
    public String getImage() {
        return image; 
    }
    public void setImage(String image) {
        this.image = image; 
    }
    
    public String getCategory() {
        return category; 
    }
    public void setCategory(String category) {
        this.category = category; 
    }
    
    public int getStock() {
        return stock; 
    }
    public void setStock(int stock) {
        this.stock = stock; 
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public double getRating() {
        return rating;
    }
    public void setRating(double rating) {
        this.rating = rating;
    }
}
