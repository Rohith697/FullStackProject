<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rohith.fastgo.model.Cart" %>
<%@ page import="com.rohith.fastgo.model.CartItem" %>
<%@ include file="header.jsp" %>

<%
    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null || cart.getItems().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/cart");
        return;
    }
    String paymentError = (String) session.getAttribute("paymentError");
    if (paymentError != null) session.removeAttribute("paymentError");
%>

<div class="main-wrapper">
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px;">
        <h1 class="section-title"><i class="fa-solid fa-location-dot" style="color: var(--primary);"></i> Step 1: Delivery Address & Order Review</h1>
        <div style="font-size: 0.9rem; font-weight: 700; color: var(--text-muted);">
            Step 1 of 2: Delivery Details
        </div>
    </div>

    <% if (paymentError != null) { %>
        <div style="background-color: #fff0f1; border: 1px solid var(--primary); color: var(--primary); padding: 12px 20px; border-radius: var(--radius-sm); margin-bottom: 20px; font-weight: 700;">
            <%= paymentError %>
        </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/checkout" method="post" class="cart-checkout-grid">
        <!-- Left: Delivery Address -->
        <div>
            <div class="card-box">
                <h3 style="margin-bottom: 16px;"><i class="fa-solid fa-user-check" style="color: var(--primary);"></i> Customer & Delivery Details</h3>
                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="name" class="form-control" value="<%= currentUser != null ? currentUser.getName() : "Rohith Kumar" %>" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Mobile Phone Number</label>
                    <input type="tel" name="phone" class="form-control" value="<%= currentUser != null && currentUser.getPhone() != null ? currentUser.getPhone() : "9876543210" %>" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Delivery Address (House No, Flat, Street, Landmark, City)</label>
                    <textarea name="address" class="form-control" rows="3" required><%= currentUser != null && currentUser.getAddress() != null ? currentUser.getAddress() : "Plot 45, Jubilee Hills, Hyderabad" %></textarea>
                </div>
            </div>

            <div class="card-box" style="background: #f8f9fa;">
                <h4 style="margin-bottom: 8px;"><i class="fa-solid fa-shield-halved" style="color: var(--veg-color);"></i> FastGo Guarantee</h4>
                <p style="font-size: 0.85rem; color: var(--text-muted);">Your food will be prepared under strict hygiene standards and delivered hot within 30 minutes.</p>
            </div>
        </div>

        <!-- Right: Order Summary & Next Step Button -->
        <div>
            <div class="card-box">
                <h3 style="font-size: 1.2rem; margin-bottom: 16px;">Order Summary</h3>

                <div style="border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 14px;">
                    <div style="font-weight: 800; font-size: 1.1rem;"><%= cart.getRestaurantName() %></div>
                    <span style="font-size: 0.85rem; color: var(--text-muted);"><%= cart.getTotalItemCount() %> items in cart</span>
                </div>

                <div style="max-height: 200px; overflow-y: auto; margin-bottom: 16px;">
                    <% for (CartItem ci : cart.getItems()) { %>
                        <div style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 8px;">
                            <span><%= ci.getQuantity() %>x <%= ci.getMenuItem().getName() %></span>
                            <span style="font-weight: 700;">₹<%= (int) ci.getTotalPrice() %></span>
                        </div>
                    <% } %>
                </div>

                <div class="bill-row bill-total">
                    <span>Total Amount Payable</span>
                    <span style="color: var(--primary);">₹<%= String.format("%.2f", cart.getGrandTotal()) %></span>
                </div>

                <button type="submit" class="btn-primary" style="margin-top: 24px; padding: 16px; font-size: 1.1rem;">
                    PROCEED TO PAYMENT GATEWAY &rarr;
                </button>
            </div>
        </div>
    </form>
</div>

<%@ include file="footer.jsp" %>
