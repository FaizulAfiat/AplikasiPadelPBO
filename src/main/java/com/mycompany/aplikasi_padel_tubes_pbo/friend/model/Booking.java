/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.friend.model;

import java.util.ArrayList;
import java.util.List;

public class Booking {

    private int bookingId;

    private User owner;

    private List<User> players =
            new ArrayList<>();

    private int maxPlayer;

    public Booking() {
    }

    public Booking(User owner) {
        this.owner = owner;
    }

    public boolean inviteFriend(User user) {

        if(players.size() < maxPlayer) {

            players.add(user);

            return true;
        }

        return false;
    }

    public List<User> getPlayers() {
        return players;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public User getOwner() {
        return owner;
    }

    public void setOwner(User owner) {
        this.owner = owner;
    }

    public int getMaxPlayer() {
        return maxPlayer;
    }

    public void setMaxPlayer(int maxPlayer) {
        this.maxPlayer = maxPlayer;
    }
}