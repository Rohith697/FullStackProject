package com.rohith.fastgo.servlet;

import com.rohith.fastgo.dao.RestaurantDAO;
import com.rohith.fastgo.model.Restaurant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/restaurants")
public class RestaurantServlet extends HttpServlet {

    private final RestaurantDAO restaurantDAO = new RestaurantDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        String cuisine = request.getParameter("cuisine");

        List<Restaurant> restaurants = restaurantDAO.searchRestaurants(search, cuisine);

        request.setAttribute("restaurants", restaurants);
        request.setAttribute("searchQuery", search != null ? search : "");
        request.setAttribute("selectedCuisine", cuisine != null ? cuisine : "ALL");

        request.getRequestDispatcher("/restaurants.jsp").forward(request, response);
    }
}
