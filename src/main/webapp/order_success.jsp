<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rohith.fastgo.model.Order" %>
<%@ page import="com.rohith.fastgo.model.OrderItem" %>
<%@ include file="header.jsp" %>

<%
    Order order = (Order) request.getAttribute("order");
    if (order == null) {
        order = (Order) session.getAttribute("lastOrder");
    }
%>

<div class="main-wrapper" style="max-width: 850px;">
    <% if (order != null) { %>
        <div class="card-box" style="text-align: center; padding: 40px 24px;">
            <div style="width: 80px; height: 80px; background: #f0fdf4; color: var(--veg-color); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.8rem; margin: 0 auto 20px; border: 3px solid var(--veg-color);">
                <i class="fa-solid fa-circle-check"></i>
            </div>
            <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--text-dark);">Order Successfully Placed!</h1>
            <p style="color: var(--text-muted); font-size: 1.1rem; margin-top: 6px;">Order ID: <strong>#FG-<%= order.getId() %></strong> | Estimated Delivery: <strong>25-30 mins</strong></p>

            <!-- Live Order Tracking Timeline -->
            <div style="margin: 40px 0; background: #f8f9fa; padding: 24px; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
                <h3 style="font-size: 1.1rem; margin-bottom: 24px;"><i class="fa-solid fa-truck-fast" style="color: var(--primary);"></i> Live Order Status</h3>

                <div style="display: flex; justify-content: space-between; position: relative;">
                    <!-- Track Step 1 -->
                    <div style="flex: 1; text-align: center; z-index: 2;">
                        <div style="width: 40px; height: 40px; background: var(--primary); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-weight: 800;">
                            <i class="fa-solid fa-check"></i>
                        </div>
                        <div style="font-weight: 700; font-size: 0.9rem;">Order Placed</div>
                        <span style="font-size: 0.75rem; color: var(--text-muted);">Just now</span>
                    </div>

                    <!-- Track Step 2 -->
                    <div style="flex: 1; text-align: center; z-index: 2;">
                        <div style="width: 40px; height: 40px; background: var(--accent); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-weight: 800;">
                            <i class="fa-solid fa-fire"></i>
                        </div>
                        <div style="font-weight: 700; font-size: 0.9rem; color: var(--accent);">Kitchen Preparing</div>
                        <span style="font-size: 0.75rem; color: var(--text-muted);">In progress</span>
                    </div>

                    <!-- Track Step 3 -->
                    <div style="flex: 1; text-align: center; z-index: 2;">
                        <div style="width: 40px; height: 40px; background: #e0e0e0; color: #888; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-weight: 800;">
                            <i class="fa-solid fa-person-biking"></i>
                        </div>
                        <div style="font-weight: 600; font-size: 0.9rem; color: var(--text-muted);">Out for Delivery</div>
                        <span style="font-size: 0.75rem; color: var(--text-muted);">Pending</span>
                    </div>

                    <!-- Track Step 4 -->
                    <div style="flex: 1; text-align: center; z-index: 2;">
                        <div style="width: 40px; height: 40px; background: #e0e0e0; color: #888; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-weight: 800;">
                            <i class="fa-solid fa-house-chimney"></i>
                        </div>
                        <div style="font-weight: 600; font-size: 0.9rem; color: var(--text-muted);">Delivered</div>
                        <span style="font-size: 0.75rem; color: var(--text-muted);">Pending</span>
                    </div>
                </div>
            </div>

            <!-- Receipt Details -->
            <div style="text-align: left; background: white; border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 20px;">
                <h3 style="border-bottom: 1px solid var(--border-color); padding-bottom: 10px; margin-bottom: 14px;">Order Summary</h3>
                <p style="font-size: 0.95rem;"><strong>Restaurant:</strong> <%= order.getRestaurantName() %></p>
                <p style="font-size: 0.95rem;"><strong>Delivery Address:</strong> <%= order.getDeliveryAddress() %></p>
                <p style="font-size: 0.95rem;"><strong>Payment Method:</strong> <%= order.getPaymentMethod() %> (<%= order.getPaymentStatus() %>)</p>

                <table style="width: 100%; border-collapse: collapse; margin-top: 14px; font-size: 0.9rem;">
                    <thead>
                        <tr style="border-bottom: 2px solid var(--border-color); text-align: left; color: var(--text-muted);">
                            <th style="padding: 8px 0;">Item</th>
                            <th style="padding: 8px 0; text-align: center;">Qty</th>
                            <th style="padding: 8px 0; text-align: right;">Price</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (OrderItem item : order.getItems()) { %>
                            <tr style="border-bottom: 1px dashed var(--border-color);">
                                <td style="padding: 8px 0;"><%= item.getItemName() %></td>
                                <td style="padding: 8px 0; text-align: center;"><%= item.getQuantity() %></td>
                                <td style="padding: 8px 0; text-align: right;">₹<%= String.format("%.0f", item.getTotalPrice()) %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>

                <div style="display: flex; justify-content: space-between; font-weight: 800; font-size: 1.2rem; margin-top: 16px; border-top: 2px solid var(--text-dark); padding-top: 12px;">
                    <span>Total Paid</span>
                    <span style="color: var(--primary);">₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
                </div>
            </div>

            <div style="margin-top: 30px; display: flex; gap: 16px; justify-content: center;">
                <a href="${pageContext.request.contextPath}/orders" class="btn-primary" style="width: auto; text-decoration: none;">View All Orders</a>
                <a href="${pageContext.request.contextPath}/home" style="background: #f0f0f0; color: var(--text-dark); padding: 14px 28px; border-radius: var(--radius-sm); font-weight: 700; text-decoration: none;">Order More Food</a>
            </div>
        </div>
    <% } else { %>
        <p>Order not found.</p>
    <% } %>
</div>

<%@ include file="footer.jsp" %>
