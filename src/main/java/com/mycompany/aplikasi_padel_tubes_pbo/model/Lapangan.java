/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.model;

/**
 *
 * @author Faizul Afiat
 */
public class Lapangan {
    private int courtId;
    private String name;
    private int pricePerHour;
    private String status;

    public Lapangan() {}

    public Lapangan(int courtId, String name, int pricePerHour, String status) {
        this.courtId = courtId;
        this.name = name;
        this.pricePerHour = pricePerHour;
        this.status = status;
    }

    public int getCourtId() {
        return courtId;
    }

    public void setCourtId(int courtId) {
        this.courtId = courtId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getPricePerHour() {
        return pricePerHour;
    }

    public void setPricePerHour(int pricePerHour) {
        this.pricePerHour = pricePerHour;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
