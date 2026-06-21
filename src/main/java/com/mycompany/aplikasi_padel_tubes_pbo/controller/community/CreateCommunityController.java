package com.mycompany.aplikasi_padel_tubes_pbo.controller.community;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "CreateCommunityController", urlPatterns = {"/CreateCommunityController"})
public class CreateCommunityController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null && session.getAttribute("user_id") == null) {
            response.sendRedirect("view/Login.html");
            return;
        }
        request.getRequestDispatcher("view/create_community.jsp").forward(request, response);
    }
}
