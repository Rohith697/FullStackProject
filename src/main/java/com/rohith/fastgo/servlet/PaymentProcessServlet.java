package com.rohith.fastgo.servlet;

import com.rohith.fastgo.dao.OrderDAO;
import com.rohith.fastgo.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/process-payment")
public class PaymentProcessServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/cart");
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

        if (user == null) {
            user = new User(1, "Rohith Kumar", "rohith@user.com", "user123", "9876543210", "Plot 45, Jubilee Hills, Hyderabad", "USER", null);
            session.setAttribute("user", user);
        }

        String deliveryAddress = (String) session.getAttribute("checkoutAddress");
        if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
            deliveryAddress = request.getParameter("address");
            if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
                deliveryAddress = user.getAddress();
            }
        }

        String paymentMethod = request.getParameter("paymentMethod");
        String paymentApp = request.getParameter("paymentApp");

        String fullPaymentDetail = paymentMethod != null ? paymentMethod : "UPI";
        if (paymentApp != null && !paymentApp.trim().isEmpty()) {
            fullPaymentDetail = paymentApp + " (" + fullPaymentDetail + ")";
        }

        Order order = new Order();
        order.setUserId(user.getId());
        order.setRestaurantId(cart.getRestaurantId());
        order.setRestaurantName(cart.getRestaurantName());
        order.setTotalAmount(cart.getGrandTotal());
        order.setDeliveryAddress(deliveryAddress);
        order.setPaymentMethod(fullPaymentDetail);
        order.setPaymentStatus("PAID");
        order.setOrderStatus("Placed");

        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem ci : cart.getItems()) {
            OrderItem oi = new OrderItem();
            oi.setMenuItemId(ci.getMenuItem().getId());
            oi.setItemName(ci.getMenuItem().getName());
            oi.setQuantity(ci.getQuantity());
            oi.setPrice(ci.getMenuItem().getPrice());
            orderItems.add(oi);
        }
        order.setItems(orderItems);

        int orderId = orderDAO.createOrder(order);

        if (orderId != -1) {
            order.setId(orderId);
            cart.clear(); // Clear cart after payment complete
            session.removeAttribute("checkoutAddress");
            session.setAttribute("lastOrder", order);
            response.sendRedirect(request.getContextPath() + "/orders?id=" + orderId + "&success=true");
        } else {
            session.setAttribute("paymentError", "Payment transaction failed. Please try again.");
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }
}
