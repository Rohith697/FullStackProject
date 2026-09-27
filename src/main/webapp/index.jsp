<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rohith.fastgo.model.Restaurant" %>
<%@ include file="header.jsp" %>

<%
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
    if (restaurants == null) {
        restaurants = new com.rohith.fastgo.dao.RestaurantDAO().getAllActiveRestaurants();
    }
    String searchQuery = (String) request.getAttribute("searchQuery");
    String selectedCuisine = (String) request.getAttribute("selectedCuisine");
%>

<div class="main-wrapper">
    <!-- Hero Banner & Search -->
    <div class="hero-banner">
        <h1 class="hero-title">Delicious Food Delivered Fast</h1>
        <p class="hero-subtitle">Order from 10+ top-rated restaurants with over 100+ mouthwatering dishes</p>

        <form action="${pageContext.request.contextPath}/home" method="get" class="hero-search-box">
            <input type="text" name="search" class="hero-search-input" placeholder="Search for biryani, pizza, burgers, sushi or restaurant name..." value="<%= searchQuery != null ? searchQuery : "" %>">
            <button type="submit" class="hero-search-btn"><i class="fa-solid fa-magnifying-glass"></i> Search</button>
        </form>
    </div>

    <!-- Cuisine Category Pills -->
    <div class="category-strip">
        <a href="${pageContext.request.contextPath}/home" class="category-card <%= "ALL".equals(selectedCuisine) ? "active" : "" %>">
            <i class="fa-solid fa-border-all"></i> All Cuisines
        </a>
        <a href="${pageContext.request.contextPath}/home?cuisine=Hyderabadi" class="category-card <%= "Hyderabadi".equals(selectedCuisine) ? "active" : "" %>">
            <i class="fa-solid fa-bowl-rice"></i> Biryani & Mughlai
        </a>
        <a href="${pageContext.request.contextPath}/home?cuisine=Italian" class="category-card <%= "Italian".equals(selectedCuisine) ? "active" : "" %>">
            <i class="fa-solid fa-pizza-slice"></i> Italian & Pizza
        </a>
        <a href="${pageContext.request.contextPath}/home?cuisine=American" class="category-card <%= "American".equals(selectedCuisine) ? "active" : "" %>">
            <i class="fa-solid fa-burger"></i> Burgers & Grill
        </a>
        <a href="${pageContext.request.contextPath}/home?cuisine=Chinese" class="category-card <%= "Chinese".equals(selectedCuisine) ? "active" : "" %>">
            <i class="fa-solid fa-bowl-food"></i> Chinese & Asian
        </a>
        <a href="${pageContext.request.contextPath}/home?cuisine=North Indian" class="category-card <%= "North Indian".equals(selectedCuisine) ? "active" : "" %>">
            <i class="fa-solid fa-fire-burner"></i> North Indian & Naan
        </a>
        <a href="${pageContext.request.contextPath}/home?cuisine=Mexican" class="category-card <%= "Mexican".equals(selectedCuisine) ? "active" : "" %>">
            <i class="fa-solid fa-pepper-hot"></i> Mexican Tacos
        </a>
        <a href="${pageContext.request.contextPath}/home?cuisine=Japanese" class="category-card <%= "Japanese".equals(selectedCuisine) ? "active" : "" %>">
            <i class="fa-solid fa-fish"></i> Japanese Sushi
        </a>
        <a href="${pageContext.request.contextPath}/home?cuisine=Bakery" class="category-card <%= "Bakery".equals(selectedCuisine) ? "active" : "" %>">
            <i class="fa-solid fa-cake-candles"></i> Desserts & Waffles
        </a>
        <a href="${pageContext.request.contextPath}/home?cuisine=Healthy" class="category-card <%= "Healthy".equals(selectedCuisine) ? "active" : "" %>">
            <i class="fa-solid fa-carrot"></i> Healthy & Vegan
        </a>
        <a href="${pageContext.request.contextPath}/home?cuisine=South Indian" class="category-card <%= "South Indian".equals(selectedCuisine) ? "active" : "" %>">
            <i class="fa-solid fa-leaf"></i> South Indian Dosa
        </a>
    </div>

    <!-- Restaurants Grid -->
    <div class="section-header">
        <h2 class="section-title"><i class="fa-solid fa-store" style="color: var(--primary);"></i> Top Restaurants in Town</h2>
        <a href="${pageContext.request.contextPath}/restaurants" style="color: var(--primary); font-weight: 700; text-decoration: none;">View All Restaurants <i class="fa-solid fa-arrow-right"></i></a>
    </div>

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
                        <p class="restaurant-cuisine"><i class="fa-solid fa-utensils"></i> <%= r.getCuisine() %></p>
                        <p style="font-size: 0.85rem; color: var(--text-muted);"><%= r.getDescription() %></p>
                        <div class="restaurant-meta">
                            <span><i class="fa-solid fa-clock"></i> <%= r.getDeliveryTime() %></span>
                            <span><i class="fa-solid fa-indian-rupee-sign"></i> ₹<%= r.getPriceForTwo() %> for two</span>
                        </div>
                    </div>
                </a>
            <% } %>
        </div>
    <% } else { %>
        <div class="card-box" style="text-align: center; padding: 40px;">
            <i class="fa-solid fa-utensils" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 12px;"></i>
            <h3>No Restaurants Found</h3>
            <p style="color: var(--text-muted);">Try searching for another restaurant or cuisine category.</p>
            <a href="${pageContext.request.contextPath}/home" class="btn-primary" style="display: inline-block; width: auto; margin-top: 16px;">Reset Search</a>
        </div>
    <% } %>

    <!-- FastGo Highlights Section -->
    <div style="margin-top: 40px; margin-bottom: 40px;">
        <h2 class="section-title" style="text-align: center; margin-bottom: 30px;">Why Order from FastGo?</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 24px;">
            <div class="card-box" style="text-align: center; padding: 30px 20px;">
                <div style="width: 60px; height: 60px; background: #fff0f1; color: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; margin: 0 auto 16px;">
                    <i class="fa-solid fa-bolt"></i>
                </div>
                <h3>30 Min Delivery</h3>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 8px;">Supercharged delivery network bringing hot fresh meals directly to your doorstep.</p>
            </div>

            <div class="card-box" style="text-align: center; padding: 30px 20px;">
                <div style="width: 60px; height: 60px; background: #fff7ed; color: var(--accent); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; margin: 0 auto 16px;">
                    <i class="fa-solid fa-shield-halved"></i>
                </div>
                <h3>Top Hygiene Standards</h3>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 8px;">All partner kitchens undergo strict health inspections & tamper-proof packaging.</p>
            </div>

            <div class="card-box" style="text-align: center; padding: 30px 20px;">
                <div style="width: 60px; height: 60px; background: #f0fdf4; color: var(--veg-color); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; margin: 0 auto 16px;">
                    <i class="fa-solid fa-tags"></i>
                </div>
                <h3>Best Price & Coupons</h3>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 8px;">Enjoy up to 50% discount with promo codes <code>FASTGO50</code> and <code>FASTGO20</code>.</p>
            </div>

            <div class="card-box" style="text-align: center; padding: 30px 20px;">
                <div style="width: 60px; height: 60px; background: #eef2ff; color: #6366f1; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; margin: 0 auto 16px;">
                    <i class="fa-solid fa-location-dot"></i>
                </div>
                <h3>Live Order Tracking</h3>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 8px;">Track your order status live from kitchen preparation to delivery rider dispatch.</p>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
