<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rohith.fastgo.model.Restaurant" %>
<%@ page import="com.rohith.fastgo.model.Order" %>
<%@ page import="com.rohith.fastgo.model.User" %>
<%@ include file="header.jsp" %>

<%
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    List<User> users = (List<User>) request.getAttribute("users");
    Double totalRevenue = (Double) request.getAttribute("totalRevenue");
    if (totalRevenue == null) totalRevenue = 0.0;
%>

<div class="main-wrapper">
    <div style="background: linear-gradient(135deg, #171a29, #2d3748); color: white; padding: 24px 30px; border-radius: var(--radius-md); margin-bottom: 32px; display: flex; align-items: center; justify-content: space-between;">
        <div>
            <h1 style="font-size: 2rem; font-weight: 800;"><i class="fa-solid fa-user-shield" style="color: var(--accent);"></i> FastGo Admin Control Panel</h1>
            <p style="color: #cbd5e0; margin-top: 4px;">Manage orders, update order delivery statuses, and add/edit restaurants & menu items.</p>
        </div>
        <div style="background: rgba(255,255,255,0.1); padding: 8px 16px; border-radius: 20px; font-weight: 700; font-size: 0.9rem;">
            <i class="fa-solid fa-circle" style="color: #48bb78; font-size: 0.7rem;"></i> System Live
        </div>
    </div>

    <!-- Analytics Dashboard Cards -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 36px;">
        <div class="card-box" style="display: flex; align-items: center; gap: 16px; padding: 20px;">
            <div style="width: 50px; height: 50px; background: #ebf8ff; color: #3182ce; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                <i class="fa-solid fa-bag-shopping"></i>
            </div>
            <div>
                <span style="font-size: 0.85rem; color: var(--text-muted); font-weight: 600;">Total Orders</span>
                <h3 style="font-size: 1.6rem; font-weight: 800;"><%= orders != null ? orders.size() : 0 %></h3>
            </div>
        </div>

        <div class="card-box" style="display: flex; align-items: center; gap: 16px; padding: 20px;">
            <div style="width: 50px; height: 50px; background: #f0fdf4; color: var(--veg-color); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                <i class="fa-solid fa-indian-rupee-sign"></i>
            </div>
            <div>
                <span style="font-size: 0.85rem; color: var(--text-muted); font-weight: 600;">Total Sales</span>
                <h3 style="font-size: 1.6rem; font-weight: 800;">₹<%= String.format("%.0f", totalRevenue) %></h3>
            </div>
        </div>

        <div class="card-box" style="display: flex; align-items: center; gap: 16px; padding: 20px;">
            <div style="width: 50px; height: 50px; background: #fff0f1; color: var(--primary); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                <i class="fa-solid fa-store"></i>
            </div>
            <div>
                <span style="font-size: 0.85rem; color: var(--text-muted); font-weight: 600;">Active Restaurants</span>
                <h3 style="font-size: 1.6rem; font-weight: 800;"><%= restaurants != null ? restaurants.size() : 0 %></h3>
            </div>
        </div>

        <div class="card-box" style="display: flex; align-items: center; gap: 16px; padding: 20px;">
            <div style="width: 50px; height: 50px; background: #f3e8ff; color: #a855f7; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                <i class="fa-solid fa-users"></i>
            </div>
            <div>
                <span style="font-size: 0.85rem; color: var(--text-muted); font-weight: 600;">Registered Users</span>
                <h3 style="font-size: 1.6rem; font-weight: 800;"><%= users != null ? users.size() : 0 %></h3>
            </div>
        </div>
    </div>

    <!-- Live Order Management Section -->
    <div class="card-box" style="margin-bottom: 36px;">
        <h2 style="font-size: 1.3rem; margin-bottom: 16px;"><i class="fa-solid fa-list-check" style="color: var(--primary);"></i> Order Management & Status Updates</h2>

        <% if (orders != null && !orders.isEmpty()) { %>
            <div style="overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse; font-size: 0.9rem;">
                    <thead>
                        <tr style="background: #f8f9fa; border-bottom: 2px solid var(--border-color); text-align: left;">
                            <th style="padding: 12px;">Order ID</th>
                            <th style="padding: 12px;">Restaurant</th>
                            <th style="padding: 12px;">Amount</th>
                            <th style="padding: 12px;">Payment</th>
                            <th style="padding: 12px;">Current Status</th>
                            <th style="padding: 12px;">Update Status Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Order o : orders) { %>
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 12px; font-weight: 700;">#FG-<%= o.getId() %></td>
                                <td style="padding: 12px;"><%= o.getRestaurantName() %></td>
                                <td style="padding: 12px; font-weight: 700; color: var(--primary);">₹<%= String.format("%.2f", o.getTotalAmount()) %></td>
                                <td style="padding: 12px;"><%= o.getPaymentMethod() %></td>
                                <td style="padding: 12px;">
                                    <span style="background: <%= "Delivered".equals(o.getOrderStatus()) ? "var(--veg-color)" : "var(--accent)" %>; color: white; padding: 4px 10px; border-radius: 12px; font-size: 0.8rem; font-weight: 700;">
                                        <%= o.getOrderStatus() %>
                                    </span>
                                </td>
                                <td style="padding: 12px;">
                                    <form action="${pageContext.request.contextPath}/admin" method="post" style="display: flex; gap: 8px;">
                                        <input type="hidden" name="action" value="updateOrderStatus">
                                        <input type="hidden" name="orderId" value="<%= o.getId() %>">
                                        <select name="orderStatus" class="form-control" style="padding: 6px 10px; font-size: 0.85rem; width: auto;">
                                            <option value="Placed" <%= "Placed".equals(o.getOrderStatus()) ? "selected" : "" %>>Placed</option>
                                            <option value="Preparing" <%= "Preparing".equals(o.getOrderStatus()) ? "selected" : "" %>>Kitchen Preparing</option>
                                            <option value="Out for Delivery" <%= "Out for Delivery".equals(o.getOrderStatus()) ? "selected" : "" %>>Out for Delivery</option>
                                            <option value="Delivered" <%= "Delivered".equals(o.getOrderStatus()) ? "selected" : "" %>>Delivered</option>
                                        </select>
                                        <button type="submit" class="btn-primary" style="width: auto; padding: 6px 14px; font-size: 0.85rem;">Update</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } else { %>
            <p style="color: var(--text-muted);">No orders placed yet.</p>
        <% } %>
    </div>

    <!-- Restaurant & Food Item Management -->
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 28px;">
        <!-- Add New Restaurant Form -->
        <div class="card-box">
            <h3 style="font-size: 1.2rem; margin-bottom: 16px;"><i class="fa-solid fa-plus-circle" style="color: var(--primary);"></i> Add New Restaurant</h3>
            <form action="${pageContext.request.contextPath}/admin" method="post">
                <input type="hidden" name="action" value="addRestaurant">

                <div class="form-group">
                    <label class="form-label">Restaurant Name</label>
                    <input type="text" name="name" class="form-control" placeholder="e.g. Royal Curry Palace" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Cuisine Type</label>
                    <input type="text" name="cuisine" class="form-control" placeholder="e.g. North Indian, Thali" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Description</label>
                    <input type="text" name="description" class="form-control" placeholder="Brief tagline..." required>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div class="form-group">
                        <label class="form-label">Rating (1-5)</label>
                        <input type="number" step="0.1" name="rating" class="form-control" value="4.8" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Price for Two (₹)</label>
                        <input type="number" name="priceForTwo" class="form-control" value="500" required>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Delivery Time</label>
                    <input type="text" name="deliveryTime" class="form-control" value="25-30 min" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Address</label>
                    <input type="text" name="address" class="form-control" placeholder="e.g. Hitech City, Hyderabad" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Unsplash Image URL</label>
                    <input type="text" name="imageUrl" class="form-control" value="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=80" required>
                </div>

                <button type="submit" class="btn-primary"><i class="fa-solid fa-floppy-disk"></i> Add Restaurant</button>
            </form>
        </div>

        <!-- Add New Food Item Form -->
        <div class="card-box">
            <h3 style="font-size: 1.2rem; margin-bottom: 16px;"><i class="fa-solid fa-utensils" style="color: var(--accent);"></i> Add Food Item to Restaurant</h3>
            <form action="${pageContext.request.contextPath}/admin" method="post">
                <input type="hidden" name="action" value="addMenuItem">

                <div class="form-group">
                    <label class="form-label">Select Restaurant</label>
                    <select name="restaurantId" class="form-control" required>
                        <% if (restaurants != null) { for (Restaurant r : restaurants) { %>
                            <option value="<%= r.getId() %>"><%= r.getName() %> (<%= r.getCuisine() %>)</option>
                        <% } } %>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Item Name</label>
                    <input type="text" name="name" class="form-control" placeholder="e.g. Cheese Burst Pizza" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Description</label>
                    <input type="text" name="description" class="form-control" placeholder="Short food description..." required>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div class="form-group">
                        <label class="form-label">Price (₹)</label>
                        <input type="number" step="0.5" name="price" class="form-control" placeholder="290.0" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Category</label>
                        <input type="text" name="category" class="form-control" placeholder="Main Course / Pizza / Starters" required>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Dietary Preference</label>
                    <select name="isVeg" class="form-control">
                        <option value="true">Vegetarian (Green Icon)</option>
                        <option value="false">Non-Vegetarian (Red Icon)</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Unsplash Food Image URL</label>
                    <input type="text" name="imageUrl" class="form-control" value="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=500&q=80" required>
                </div>

                <button type="submit" class="btn-primary" style="background: var(--accent);"><i class="fa-solid fa-plus"></i> Add Food Item</button>
            </form>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
