<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.rohith.fastgo.model.Order" %>
<%@ page import="com.rohith.fastgo.model.OrderItem" %>
<%@ include file="header.jsp" %>

<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>

<div class="main-wrapper">
    <h1 class="section-title" style="margin-bottom: 24px;"><i class="fa-solid fa-bag-shopping" style="color: var(--primary);"></i> Order History</h1>

    <% if (orders != null && !orders.isEmpty()) { %>
        <div style="display: flex; flex-direction: column; gap: 20px;">
            <% for (Order o : orders) { %>
                <div class="card-box">
                    <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 14px;">
                        <div>
                            <h3 style="font-size: 1.2rem; font-weight: 800;"><%= o.getRestaurantName() %></h3>
                            <span style="font-size: 0.85rem; color: var(--text-muted);">Order #FG-<%= o.getId() %> | Date: <%= o.getOrderDate() %></span>
                        </div>
                        <div>
                            <span style="background: <%= "Delivered".equals(o.getOrderStatus()) ? "var(--veg-color)" : "var(--accent)" %>; color: white; padding: 6px 14px; border-radius: 20px; font-weight: 800; font-size: 0.85rem;">
                                <%= o.getOrderStatus() %>
                            </span>
                        </div>
                    </div>

                    <div style="margin-bottom: 14px;">
                        <% for (OrderItem item : o.getItems()) { %>
                            <div style="font-size: 0.9rem; color: var(--text-dark); margin-bottom: 4px;">
                                <strong><%= item.getQuantity() %>x</strong> <%= item.getItemName() %> (₹<%= (int) item.getPrice() %>)
                            </div>
                        <% } %>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px dashed var(--border-color); padding-top: 12px;">
                        <span style="font-size: 0.9rem; color: var(--text-muted);">Paid via <strong><%= o.getPaymentMethod() %></strong></span>
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <span style="font-weight: 800; font-size: 1.2rem; color: var(--text-dark);">Total: ₹<%= String.format("%.2f", o.getTotalAmount()) %></span>
                            <a href="${pageContext.request.contextPath}/orders?id=<%= o.getId() %>" class="btn-primary" style="width: auto; padding: 8px 16px; font-size: 0.85rem; text-decoration: none;">Track Order</a>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <div class="card-box" style="text-align: center; padding: 50px;">
            <i class="fa-solid fa-box-open" style="font-size: 3.5rem; color: var(--text-muted); margin-bottom: 16px;"></i>
            <h2>No Orders Placed Yet</h2>
            <p style="color: var(--text-muted); margin-bottom: 20px;">Hungry? Explore top restaurants and place your first food order now!</p>
            <a href="${pageContext.request.contextPath}/restaurants" class="btn-primary" style="display: inline-block; width: auto; padding: 12px 28px;">Order Food Now</a>
        </div>
    <% } %>
</div>

<%@ include file="footer.jsp" %>
