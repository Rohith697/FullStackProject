<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rohith.fastgo.model.Cart" %>
<%@ page import="com.rohith.fastgo.model.CartItem" %>
<%@ include file="header.jsp" %>

<%
    Cart cart = (Cart) session.getAttribute("cart");
    String couponMessage = (String) session.getAttribute("couponMessage");
    String couponError = (String) session.getAttribute("couponError");
    if (couponMessage != null) session.removeAttribute("couponMessage");
    if (couponError != null) session.removeAttribute("couponError");
%>

<div class="main-wrapper">
    <h1 class="section-title" style="margin-bottom: 24px;"><i class="fa-solid fa-cart-shopping" style="color: var(--primary);"></i> Your Food Cart</h1>

    <% if (cart != null && !cart.getItems().isEmpty()) { %>
        <div class="cart-checkout-grid">
            <!-- Left: Cart Items List -->
            <div>
                <div class="card-box">
                    <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--border-color); padding-bottom: 14px; margin-bottom: 16px;">
                        <div>
                            <h2 style="font-size: 1.3rem; font-weight: 800;"><%= cart.getRestaurantName() %></h2>
                            <span style="font-size: 0.85rem; color: var(--text-muted);"><%= cart.getItems().size() %> items in cart</span>
                        </div>
                        <form action="${pageContext.request.contextPath}/cart" method="post">
                            <input type="hidden" name="action" value="clear">
                            <button type="submit" style="background: none; border: none; color: var(--primary); font-weight: 700; cursor: pointer;"><i class="fa-solid fa-trash-can"></i> Clear Cart</button>
                        </form>
                    </div>

                    <% for (CartItem item : cart.getItems()) { %>
                        <div class="cart-item-row">
                            <div style="display: flex; align-items: center; gap: 12px; flex: 1;">
                                <% if (item.getMenuItem().isVeg()) { %>
                                    <span class="veg-icon"></span>
                                <% } else { %>
                                    <span class="nonveg-icon"></span>
                                <% } %>
                                <div>
                                    <h4 style="font-size: 1rem; font-weight: 700;"><%= item.getMenuItem().getName() %></h4>
                                    <span style="font-size: 0.85rem; color: var(--text-muted);">₹<%= (int) item.getMenuItem().getPrice() %> each</span>
                                </div>
                            </div>

                            <div style="display: flex; align-items: center; gap: 24px;">
                                <div class="qty-control">
                                    <form action="${pageContext.request.contextPath}/cart" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="itemId" value="<%= item.getMenuItem().getId() %>">
                                        <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>">
                                        <button type="submit" class="qty-btn">-</button>
                                    </form>

                                    <span class="qty-val"><%= item.getQuantity() %></span>

                                    <form action="${pageContext.request.contextPath}/cart" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="itemId" value="<%= item.getMenuItem().getId() %>">
                                        <input type="hidden" name="quantity" value="<%= item.getQuantity() + 1 %>">
                                        <button type="submit" class="qty-btn">+</button>
                                    </form>
                                </div>

                                <div style="font-weight: 800; font-size: 1.05rem; min-width: 70px; text-align: right;">
                                    ₹<%= String.format("%.0f", item.getTotalPrice()) %>
                                </div>
                            </div>
                        </div>
                    <% } %>

                    <div style="margin-top: 20px; text-align: right;">
                        <a href="${pageContext.request.contextPath}/menu?id=<%= cart.getRestaurantId() %>" style="color: var(--primary); font-weight: 700; text-decoration: none;">+ Add More Items</a>
                    </div>
                </div>

                <!-- Delivery Address Form -->
                <div class="card-box">
                    <h3 style="margin-bottom: 16px;"><i class="fa-solid fa-location-dot" style="color: var(--primary);"></i> Delivery Address</h3>
                    <div class="form-group">
                        <label class="form-label">Full Address</label>
                        <textarea id="cart-address" class="form-control" rows="3" placeholder="Enter house no, street, landmark, city..."><%= currentUser != null && currentUser.getAddress() != null ? currentUser.getAddress() : "Plot 45, Jubilee Hills, Hyderabad" %></textarea>
                    </div>
                </div>
            </div>

            <!-- Right: Bill Summary & Coupon Code -->
            <div>
                <!-- Coupon Box -->
                <div class="card-box">
                    <h3 style="font-size: 1.1rem; margin-bottom: 12px;"><i class="fa-solid fa-tags" style="color: var(--accent);"></i> Apply Promo Coupon</h3>
                    <% if (couponMessage != null) { %>
                        <div style="background-color: #f0fdf4; color: var(--veg-color); padding: 8px 12px; border-radius: 6px; font-size: 0.85rem; font-weight: 700; margin-bottom: 12px;"><%= couponMessage %></div>
                    <% } %>
                    <% if (couponError != null) { %>
                        <div style="background-color: #fff0f1; color: var(--primary); padding: 8px 12px; border-radius: 6px; font-size: 0.85rem; font-weight: 700; margin-bottom: 12px;"><%= couponError %></div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/cart" method="post" style="display: flex; gap: 8px;">
                        <input type="hidden" name="action" value="coupon">
                        <input type="text" name="couponCode" class="form-control" placeholder="Enter coupon (e.g. FASTGO50)" value="<%= cart.getCouponCode() %>" style="text-transform: uppercase;">
                        <button type="submit" class="btn-primary" style="width: auto; padding: 0 16px; font-size: 0.9rem;">APPLY</button>
                    </form>
                    <div style="font-size: 0.78rem; color: var(--text-muted); margin-top: 8px;">
                        Available coupons: <code>FASTGO50</code> (50% OFF) or <code>FASTGO20</code> (20% OFF)
                    </div>
                </div>

                <!-- Bill Details -->
                <div class="card-box">
                    <h3 style="font-size: 1.2rem; margin-bottom: 16px;">Bill Details</h3>

                    <div class="bill-row">
                        <span>Item Total</span>
                        <span>₹<%= String.format("%.2f", cart.getSubtotal()) %></span>
                    </div>

                    <div class="bill-row">
                        <span>Delivery Fee</span>
                        <% if (cart.getDeliveryFee() == 0) { %>
                            <span style="color: var(--veg-color); font-weight: 700;">FREE</span>
                        <% } else { %>
                            <span>₹<%= String.format("%.2f", cart.getDeliveryFee()) %></span>
                        <% } %>
                    </div>

                    <div class="bill-row">
                        <span>Govt Taxes & GST (5%)</span>
                        <span>₹<%= String.format("%.2f", cart.getTaxAmount()) %></span>
                    </div>

                    <% if (cart.getDiscountAmount() > 0) { %>
                        <div class="bill-row" style="color: var(--veg-color); font-weight: 700;">
                            <span>Discount (<%= (int) cart.getDiscountPercentage() %>%)</span>
                            <span>-₹<%= String.format("%.2f", cart.getDiscountAmount()) %></span>
                        </div>
                    <% } %>

                    <div class="bill-row bill-total">
                        <span>To Pay</span>
                        <span>₹<%= String.format("%.2f", cart.getGrandTotal()) %></span>
                    </div>

                    <a href="${pageContext.request.contextPath}/checkout" class="btn-primary" style="display: block; text-align: center; text-decoration: none; margin-top: 20px;">
                        PROCEED TO PAYMENT &rarr;
                    </a>
                </div>
            </div>
        </div>
    <% } else { %>
        <div class="card-box" style="text-align: center; padding: 60px 20px;">
            <i class="fa-solid fa-cart-arrow-down" style="font-size: 4rem; color: var(--text-muted); margin-bottom: 16px;"></i>
            <h2>Your Cart is Empty</h2>
            <p style="color: var(--text-muted); margin-bottom: 24px;">Good food is always calling! Explore top restaurants and add delicious items to your cart.</p>
            <a href="${pageContext.request.contextPath}/restaurants" class="btn-primary" style="display: inline-block; width: auto; padding: 12px 32px;">Browse Restaurants</a>
        </div>
    <% } %>
</div>

<%@ include file="footer.jsp" %>
