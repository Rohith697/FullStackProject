<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rohith.fastgo.model.Restaurant" %>
<%@ include file="header.jsp" %>

<%
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
    String searchQuery = (String) request.getAttribute("searchQuery");
    String selectedCuisine = (String) request.getAttribute("selectedCuisine");
%>

<div class="main-wrapper">
    <div class="section-header" style="margin-bottom: 12px;">
        <div>
            <h1 class="section-title"><i class="fa-solid fa-utensils" style="color: var(--primary);"></i> Explore All Restaurants</h1>
            <p style="color: var(--text-muted);">Choose from 10 top-rated partner kitchens offering authentic cuisines</p>
        </div>
    </div>

    <!-- Filter & Search Bar -->
    <div class="card-box" style="padding: 16px 20px; margin-bottom: 28px;">
        <form action="${pageContext.request.contextPath}/restaurants" method="get" style="display: flex; gap: 16px; flex-wrap: wrap;">
            <div style="flex: 1; min-width: 250px;">
                <input type="text" name="search" class="form-control" placeholder="Search by restaurant name or cuisine..." value="<%= searchQuery != null ? searchQuery : "" %>">
            </div>

            <div style="width: 200px;">
                <select name="cuisine" class="form-control" onchange="this.form.submit()">
                    <option value="ALL" <%= "ALL".equals(selectedCuisine) ? "selected" : "" %>>All Cuisines</option>
                    <option value="Hyderabadi" <%= "Hyderabadi".equals(selectedCuisine) ? "selected" : "" %>>Hyderabadi & Mughlai</option>
                    <option value="Italian" <%= "Italian".equals(selectedCuisine) ? "selected" : "" %>>Italian & Pizza</option>
                    <option value="American" <%= "American".equals(selectedCuisine) ? "selected" : "" %>>American Burgers</option>
                    <option value="Chinese" <%= "Chinese".equals(selectedCuisine) ? "selected" : "" %>>Chinese & Asian</option>
                    <option value="North Indian" <%= "North Indian".equals(selectedCuisine) ? "selected" : "" %>>North Indian Thali</option>
                    <option value="Mexican" <%= "Mexican".equals(selectedCuisine) ? "selected" : "" %>>Mexican Tacos</option>
                    <option value="Japanese" <%= "Japanese".equals(selectedCuisine) ? "selected" : "" %>>Japanese Sushi</option>
                    <option value="Bakery" <%= "Bakery".equals(selectedCuisine) ? "selected" : "" %>>Desserts & Bakery</option>
                    <option value="Healthy" <%= "Healthy".equals(selectedCuisine) ? "selected" : "" %>>Healthy & Salads</option>
                    <option value="South Indian" <%= "South Indian".equals(selectedCuisine) ? "selected" : "" %>>South Indian Dosa</option>
                </select>
            </div>

            <button type="submit" class="btn-primary" style="width: auto; padding: 0 24px;"><i class="fa-solid fa-filter"></i> Apply Filter</button>
        </form>
    </div>

    <!-- Restaurants Grid -->
    <% if (restaurants != null && !restaurants.isEmpty()) { %>
        <div class="restaurant-grid">
            <% for (Restaurant r : restaurants) { %>
                <a href="${pageContext.request.contextPath}/menu?id=<%= r.getId() %>" class="restaurant-card">
                    <div class="restaurant-img-wrapper">
                        <img src="<%= r.getImageUrl() %>" alt="<%= r.getName() %>" class="restaurant-img">
                        <div class="restaurant-rating-badge">
                            <i class="fa-solid fa-star"></i> <%= String.format("%.1f", r.getRating()) %>
                        </div>
                    </div>
                    <div class="restaurant-info">
                        <h3 class="restaurant-name"><%= r.getName() %></h3>
                        <p class="restaurant-cuisine"><i class="fa-solid fa-location-dot" style="color: var(--primary);"></i> <%= r.getAddress() %></p>
                        <p class="restaurant-cuisine"><%= r.getCuisine() %></p>
                        <p style="font-size: 0.85rem; color: var(--text-muted); flex: 1;"><%= r.getDescription() %></p>
                        <div class="restaurant-meta">
                            <span><i class="fa-solid fa-clock"></i> <%= r.getDeliveryTime() %></span>
                            <span><i class="fa-solid fa-indian-rupee-sign"></i> ₹<%= r.getPriceForTwo() %> for two</span>
                        </div>
                    </div>
                </a>
            <% } %>
        </div>
    <% } else { %>
        <div class="card-box" style="text-align: center; padding: 50px;">
            <i class="fa-solid fa-store-slash" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 12px;"></i>
            <h3>No Restaurants Match Your Filter</h3>
            <p style="color: var(--text-muted);">Try clearing your search query or selecting a different cuisine filter.</p>
            <a href="${pageContext.request.contextPath}/restaurants" class="btn-primary" style="display: inline-block; width: auto; margin-top: 16px;">View All 10 Restaurants</a>
        </div>
    <% } %>
</div>

<%@ include file="footer.jsp" %>
