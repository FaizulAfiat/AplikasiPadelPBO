/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.model;

/**
 *
 * @author Faizul Afiat
 */
public class User {
    private int userId;
    private String username;
    private String password;
    private String role;
    private String email;
    private int age;
    private float weight;
    private float height;

    public User() {
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

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password; 
    }
    public void setPassword(String password) {
        this.password = password; 
    }

    public String getRole() {
        return role; 
    }
    public void setRole(String role) {
        this.role = role; 
    }

    public int getAge() {
        return age;
    }
    public void setAge(int age) {
        this.age = age;
    }

    public float getWeight() {
        return weight;
    }
    public void setWeight(float weight) {
        this.weight = weight;
    }

    public float getHeight() {
        return height;
    }
    public void setHeight(float height) {
        this.height = height;
    }

    public float calculateBMI() {
        if (height <= 0) {
            return 0;
        }
        float heightInMeters = height / 100.0f;
        return weight / (heightInMeters * heightInMeters);
    }
}
