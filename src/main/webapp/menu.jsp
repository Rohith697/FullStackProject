<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.rohith.fastgo.model.Restaurant" %>
<%@ page import="com.rohith.fastgo.model.MenuItem" %>
<%@ include file="header.jsp" %>

<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<MenuItem> menuItems = (List<MenuItem>) request.getAttribute("menuItems");
    Map<String, List<MenuItem>> categorizedItems = (Map<String, List<MenuItem>>) request.getAttribute("categorizedItems");
    String cartMessage = (String) session.getAttribute("cartMessage");
    if (cartMessage != null) {
        session.removeAttribute("cartMessage");
    }
%>

<div class="main-wrapper">
    <% if (cartMessage != null) { %>
        <div style="background-color: #f0fdf4; border: 1px solid var(--veg-color); color: var(--veg-color); padding: 12px 20px; border-radius: var(--radius-sm); margin-bottom: 20px; font-weight: 700; display: flex; align-items: center; justify-content: space-between;">
            <span><i class="fa-solid fa-circle-check"></i> <%= cartMessage %></span>
            <a href="${pageContext.request.contextPath}/cart" style="color: var(--veg-color); text-decoration: underline;">View Cart & Checkout &rarr;</a>
        </div>
    <% } %>

    <% if (restaurant != null) { %>
        <!-- Restaurant Detail Header Card -->
        <div class="restaurant-detail-header">
            <img src="<%= restaurant.getImageUrl() %>" alt="<%= restaurant.getName() %>" class="restaurant-header-img">
            <div style="flex: 1; display: flex; flex-direction: column; justify-content: center; gap: 8px;">
                <h1 style="font-size: 2rem; font-weight: 800; color: var(--text-dark);"><%= restaurant.getName() %></h1>
                <p style="color: var(--text-muted); font-size: 1rem;"><i class="fa-solid fa-utensils"></i> <%= restaurant.getCuisine() %></p>
                <p style="color: var(--text-muted); font-size: 0.9rem;"><i class="fa-solid fa-location-dot"></i> <%= restaurant.getAddress() %></p>

                <div style="display: flex; gap: 20px; margin-top: 8px; font-weight: 700; font-size: 0.95rem;">
                    <span style="background: var(--rating-star); color: white; padding: 4px 10px; border-radius: 6px; display: flex; align-items: center; gap: 4px;">
                        <i class="fa-solid fa-star"></i> <%= String.format("%.1f", restaurant.getRating()) %>
                    </span>
                    <span style="color: var(--text-dark);"><i class="fa-solid fa-clock" style="color: var(--primary);"></i> <%= restaurant.getDeliveryTime() %></span>
                    <span style="color: var(--text-dark);"><i class="fa-solid fa-indian-rupee-sign" style="color: var(--primary);"></i> ₹<%= restaurant.getPriceForTwo() %> for two</span>
                </div>
            </div>
        </div>

        <div class="section-header">
            <h2 class="section-title">Menu (<%= menuItems != null ? menuItems.size() : 0 %> Items)</h2>
        </div>

        <!-- Menu Categories & Food Items Grid -->
        <% if (categorizedItems != null && !categorizedItems.isEmpty()) { %>
            <% for (Map.Entry<String, List<MenuItem>> entry : categorizedItems.entrySet()) { %>
                <div style="margin-bottom: 32px;">
                    <h3 style="font-size: 1.3rem; font-weight: 800; border-bottom: 2px solid var(--border-color); padding-bottom: 8px; margin-bottom: 20px; color: var(--primary);">
                        <%= entry.getKey() %> (<%= entry.getValue().size() %>)
                    </h3>

                    <div class="menu-items-grid">
                        <% for (MenuItem item : entry.getValue()) { %>
                            <div class="menu-card">
                                <div class="menu-item-info">
                                    <div style="display: flex; align-items: center; gap: 8px;">
                                        <% if (item.isVeg()) { %>
                                            <span class="veg-icon" title="Vegetarian"></span>
                                        <% } else { %>
                                            <span class="nonveg-icon" title="Non-Vegetarian"></span>
                                        <% } %>
                                        <h4 class="menu-item-name"><%= item.getName() %></h4>
                                    </div>
                                    <div class="menu-item-price">₹<%= (int) item.getPrice() %></div>
                                    <p class="menu-item-desc"><%= item.getDescription() %></p>
                                </div>

                                <div class="menu-item-img-box">
                                    <img src="<%= item.getImageUrl() %>" alt="<%= item.getName() %>" class="menu-item-img">
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                        <input type="hidden" name="redirectUrl" value="${pageContext.request.contextPath}/menu?id=<%= restaurant.getId() %>">
                                        <button type="submit" class="btn-add-cart">ADD +</button>
                                    </form>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <p>No menu items available for this restaurant yet.</p>
        <% } %>

    <% } else { %>
        <p>Restaurant not found.</p>
    <% } %>
</div>

<%@ include file="footer.jsp" %>
