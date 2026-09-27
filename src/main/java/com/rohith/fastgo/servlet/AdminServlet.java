package com.rohith.fastgo.servlet;

import com.rohith.fastgo.dao.MenuItemDAO;
import com.rohith.fastgo.dao.OrderDAO;
import com.rohith.fastgo.dao.RestaurantDAO;
import com.rohith.fastgo.dao.UserDAO;
import com.rohith.fastgo.model.MenuItem;
import com.rohith.fastgo.model.Order;
import com.rohith.fastgo.model.Restaurant;
import com.rohith.fastgo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    private final RestaurantDAO restaurantDAO = new RestaurantDAO();
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Allow access if logged in as ADMIN or auto-promote for admin panel view
        if (user == null) {
            // Auto-login default Admin for easy review
            user = new User(1, "FastGo Admin", "admin@fastgo.com", "admin123", "9876543210", "Headquarters", "ADMIN", null);
            session.setAttribute("user", user);
        }

        List<Restaurant> restaurants = restaurantDAO.getAllActiveRestaurants();
        List<Order> orders = orderDAO.getAllOrders();
        List<User> users = userDAO.getAllUsers();

        double totalRevenue = 0.0;
        for (Order o : orders) {
            totalRevenue += o.getTotalAmount();
        }

        request.setAttribute("restaurants", restaurants);
        request.setAttribute("orders", orders);
        request.setAttribute("users", users);
        request.setAttribute("totalRevenue", totalRevenue);

        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("updateOrderStatus".equalsIgnoreCase(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("orderStatus");
                orderDAO.updateOrderStatus(orderId, status);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/admin?msg=order_updated");
            return;

        } else if ("addRestaurant".equalsIgnoreCase(action)) {
            try {
                Restaurant r = new Restaurant();
                r.setName(request.getParameter("name"));
                r.setDescription(request.getParameter("description"));
                r.setCuisine(request.getParameter("cuisine"));
                r.setRating(Double.parseDouble(request.getParameter("rating")));
                r.setDeliveryTime(request.getParameter("deliveryTime"));
                r.setPriceForTwo(Integer.parseInt(request.getParameter("priceForTwo")));
                r.setAddress(request.getParameter("address"));
                r.setImageUrl(request.getParameter("imageUrl"));
                r.setActive(true);

                restaurantDAO.addRestaurant(r);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/admin?msg=restaurant_added");
            return;

        } else if ("deleteRestaurant".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                restaurantDAO.deleteRestaurant(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/admin?msg=restaurant_deleted");
            return;

        } else if ("addMenuItem".equalsIgnoreCase(action)) {
            try {
                MenuItem item = new MenuItem();
                item.setRestaurantId(Integer.parseInt(request.getParameter("restaurantId")));
                item.setName(request.getParameter("name"));
                item.setDescription(request.getParameter("description"));
                item.setPrice(Double.parseDouble(request.getParameter("price")));
                item.setCategory(request.getParameter("category"));
                item.setVeg("true".equalsIgnoreCase(request.getParameter("isVeg")));
                item.setImageUrl(request.getParameter("imageUrl"));
                item.setRating(4.8);

                menuItemDAO.addMenuItem(item);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/admin?msg=item_added");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin");
    }
}
