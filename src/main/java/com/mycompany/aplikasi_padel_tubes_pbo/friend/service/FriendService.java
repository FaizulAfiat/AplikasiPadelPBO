/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.aplikasi_padel_tubes_pbo.friend;

import com.mycompany.aplikasi_padel_tubes_pbo.friend.model.User;

public class FriendService {

    public void lihatStatusTeman(User user) {

        for (User teman : user.getFriends()) {

            System.out.println(
                    teman.getUsername()
                    + " : "
                    + teman.getStatus()
            );
        }
    }
}
