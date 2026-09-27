package com.rohith.fastgo.servlet;

import com.rohith.fastgo.dao.MenuItemDAO;
import com.rohith.fastgo.dao.RestaurantDAO;
import com.rohith.fastgo.model.MenuItem;
import com.rohith.fastgo.model.Restaurant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private final RestaurantDAO restaurantDAO = new RestaurantDAO();
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/restaurants");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(idParam);
            Restaurant restaurant = restaurantDAO.getById(restaurantId);

            if (restaurant == null) {
                response.sendRedirect(request.getContextPath() + "/restaurants");
                return;
            }

            List<MenuItem> menuItems = menuItemDAO.getItemsByRestaurantId(restaurantId);

            // Group menu items by category
            Map<String, List<MenuItem>> categorizedItems = new LinkedHashMap<>();
            Set<String> categories = new LinkedHashSet<>();

            for (MenuItem item : menuItems) {
                String cat = item.getCategory() != null ? item.getCategory() : "Main Course";
                categories.add(cat);
                categorizedItems.computeIfAbsent(cat, k -> new ArrayList<>()).add(item);
            }

            request.setAttribute("restaurant", restaurant);
            request.setAttribute("menuItems", menuItems);
            request.setAttribute("categories", categories);
            request.setAttribute("categorizedItems", categorizedItems);

            request.getRequestDispatcher("/menu.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/restaurants");
        }
    }
}
