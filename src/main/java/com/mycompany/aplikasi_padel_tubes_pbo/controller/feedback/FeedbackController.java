package com.mycompany.aplikasi_padel_tubes_pbo.controller.feedback;

import com.mycompany.aplikasi_padel_tubes_pbo.model.Feedback;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "FeedbackController", urlPatterns = {"/FeedbackController"})
public class FeedbackController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        // Cek login
        if (session.getAttribute("user_id") == null) {
            response.sendRedirect("view/Login.html");
            return;
        }
        // Hapus flag auto-redirect jika user mengakses halaman ini secara manual maupun otomatis
        session.removeAttribute("show_feedback_popup");
        
        // Render halaman UI feedback
        request.getRequestDispatcher("view/feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        Object userIdObj = session.getAttribute("user_id");
        if (userIdObj == null) {
            response.sendRedirect("view/Login.html");
            return;
        }
        
        int userId = (int) userIdObj;
        String facilityType = request.getParameter("facility_type");
        
        if ("Lainnya".equalsIgnoreCase(facilityType)) {
            String customType = request.getParameter("facility_type_custom");
            if (customType != null && !customType.trim().isEmpty()) {
                facilityType = customType.trim();
            }
        }
        
        int rating = 0;
        try {
            rating = Integer.parseInt(request.getParameter("rating"));
        } catch (NumberFormatException e) {
            rating = 5; // default
        }
        String comments = request.getParameter("comments");

        // Gunakan Model
        Feedback feedback = new Feedback(userId, facilityType, rating, comments);
        boolean success = feedback.save();
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?feedback_status=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/FeedbackController?error=true");
        }
    }
}
