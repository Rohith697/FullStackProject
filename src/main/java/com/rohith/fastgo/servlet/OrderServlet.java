package com.rohith.fastgo.servlet;

import com.rohith.fastgo.dao.OrderDAO;
import com.rohith.fastgo.model.Order;
import com.rohith.fastgo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order order = orderDAO.getOrderById(orderId);
                if (order != null) {
                    request.setAttribute("order", order);
                    request.getRequestDispatcher("/order_success.jsp").forward(request, response);
                    return;
                }
            } catch (Exception ignored) {}
        }

        if (user != null) {
            List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
            request.setAttribute("orders", orders);
        } else {
            // Show all recent orders for demo
            List<Order> orders = orderDAO.getAllOrders();
            request.setAttribute("orders", orders);
        }

        request.getRequestDispatcher("/my_orders.jsp").forward(request, response);
    }
}
