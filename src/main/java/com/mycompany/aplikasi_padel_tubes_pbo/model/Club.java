/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.model;

import java.sql.Timestamp;

/**
 *
 * @author ALFIAN
 */
public class Club {

    private int id;
    private String name;
    private String description, status;
    Timestamp currenttime;

    public Club() {
    }

    public Club(String name, String description, String status, Timestamp currenttime) {
        this.name = name;
        this.description = description;
        this.status = status;
        this.currenttime = currenttime;
    }

    public Club(int club_id, String name, String description, String status, Timestamp currenttime) {
        this.id = club_id;
        this.name = name;
        this.description = description;
        this.status = status;
        this.currenttime = currenttime;
    }

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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getCurrentTime() {
        return currenttime;
    }

    public void setStatus(Timestamp currenttime) {
        this.currenttime = currenttime;
    }
}
