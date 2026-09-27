package com.rohith.fastgo.servlet;

import com.rohith.fastgo.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        request.getRequestDispatcher("/payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Auto-login Guest User if not logged in
        if (user == null) {
            String guestName = request.getParameter("name");
            String guestPhone = request.getParameter("phone");
            String guestAddress = request.getParameter("address");

            user = new User();
            user.setId(1);
            user.setName(guestName != null && !guestName.trim().isEmpty() ? guestName : "Rohith Kumar");
            user.setPhone(guestPhone != null ? guestPhone : "9876543210");
            user.setAddress(guestAddress != null ? guestAddress : "Plot 45, Jubilee Hills, Hyderabad");
            session.setAttribute("user", user);
        }

        String deliveryAddress = request.getParameter("address");
        if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
            deliveryAddress = user.getAddress();
        }

        session.setAttribute("checkoutAddress", deliveryAddress);

        // Forward to the dedicated interactive Payment Gateway page (Paytm, PhonePe, GPay, Card, COD)
        request.getRequestDispatcher("/payment_gateway.jsp").forward(request, response);
    }
}
