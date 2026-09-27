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
    String deliveryAddress = (String) session.getAttribute("checkoutAddress");
    if (deliveryAddress == null) {
        deliveryAddress = currentUser != null ? currentUser.getAddress() : "Plot 45, Jubilee Hills, Hyderabad";
    }
    double grandTotal = cart.getGrandTotal();
%>

<div class="main-wrapper" style="max-width: 950px;">
    <!-- Gateway Header -->
    <div style="background: linear-gradient(135deg, #171a29, #2b304a); color: white; border-radius: var(--radius-md); padding: 24px 30px; margin-bottom: 28px; display: flex; align-items: center; justify-content: space-between; box-shadow: var(--shadow-md);">
        <div>
            <div style="font-size: 0.85rem; color: #a0aec0; text-transform: uppercase; font-weight: 700; letter-spacing: 1px;">FastGo Secure Payment Gateway</div>
            <h1 style="font-size: 1.8rem; font-weight: 900; margin-top: 2px;"><i class="fa-solid fa-shield-halved" style="color: var(--veg-color);"></i> Complete Your Payment</h1>
            <p style="font-size: 0.85rem; color: #cbd5e0; margin-top: 4px;"><i class="fa-solid fa-location-dot"></i> Delivering to: <%= deliveryAddress %></p>
        </div>
        <div style="text-align: right;">
            <div style="font-size: 0.85rem; color: #a0aec0;">Total Payable</div>
            <div style="font-size: 2rem; font-weight: 900; color: #48bb78;">₹<%= String.format("%.2f", grandTotal) %></div>
        </div>
    </div>

    <!-- Main Payment Form -->
    <form action="${pageContext.request.contextPath}/process-payment" method="post" id="payment-form">
        <input type="hidden" name="paymentMethod" id="payment-method-input" value="UPI">
        <input type="hidden" name="paymentApp" id="payment-app-input" value="PhonePe">

        <div class="cart-checkout-grid" style="grid-template-columns: 1fr 1.3fr;">
            <!-- Left: Payment Apps Navigation Menu -->
            <div class="card-box" style="padding: 16px;">
                <h3 style="font-size: 1rem; margin-bottom: 14px; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px;">Select Payment App</h3>

                <div style="display: flex; flex-direction: column; gap: 10px;">
                    <!-- PhonePe Button -->
                    <button type="button" class="pay-tab-btn active" onclick="selectPayApp('PhonePe', 'UPI', this)" style="border-left: 4px solid #5f259f;">
                        <div style="width: 32px; height: 32px; background: #5f259f; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.9rem;">Pe</div>
                        <div style="text-align: left; flex: 1;">
                            <div style="font-weight: 800; font-size: 1rem; color: #5f259f;">PhonePe</div>
                            <span style="font-size: 0.75rem; color: var(--text-muted);">UPI, Wallet, QR Scan</span>
                        </div>
                        <i class="fa-solid fa-chevron-right" style="color: #ccc;"></i>
                    </button>

                    <!-- Paytm Button -->
                    <button type="button" class="pay-tab-btn" onclick="selectPayApp('Paytm', 'UPI', this)" style="border-left: 4px solid #00baf2;">
                        <div style="width: 32px; height: 32px; background: #00baf2; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.8rem;">Paytm</div>
                        <div style="text-align: left; flex: 1;">
                            <div style="font-weight: 800; font-size: 1rem; color: #002e6e;">Paytm</div>
                            <span style="font-size: 0.75rem; color: var(--text-muted);">Paytm Wallet, Postpaid, UPI</span>
                        </div>
                        <i class="fa-solid fa-chevron-right" style="color: #ccc;"></i>
                    </button>

                    <!-- Google Pay Button -->
                    <button type="button" class="pay-tab-btn" onclick="selectPayApp('Google Pay', 'UPI', this)" style="border-left: 4px solid #4285f4;">
                        <div style="width: 32px; height: 32px; background: #4285f4; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.9rem;">G</div>
                        <div style="text-align: left; flex: 1;">
                            <div style="font-weight: 800; font-size: 1rem; color: #1a73e8;">Google Pay (GPay)</div>
                            <span style="font-size: 0.75rem; color: var(--text-muted);">Instant GPay Transfer</span>
                        </div>
                        <i class="fa-solid fa-chevron-right" style="color: #ccc;"></i>
                    </button>

                    <!-- BHIM / Any UPI -->
                    <button type="button" class="pay-tab-btn" onclick="selectPayApp('BHIM UPI', 'UPI', this)" style="border-left: 4px solid #ff9900;">
                        <div style="width: 32px; height: 32px; background: #ff9900; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.8rem;">UPI</div>
                        <div style="text-align: left; flex: 1;">
                            <div style="font-weight: 800; font-size: 1rem; color: var(--text-dark);">BHIM / Any UPI ID</div>
                            <span style="font-size: 0.75rem; color: var(--text-muted);">Enter Virtual Payment Addr</span>
                        </div>
                        <i class="fa-solid fa-chevron-right" style="color: #ccc;"></i>
                    </button>

                    <!-- Credit / Debit Card -->
                    <button type="button" class="pay-tab-btn" onclick="selectPayApp('Card', 'Card', this)" style="border-left: 4px solid var(--primary);">
                        <div style="width: 32px; height: 32px; background: var(--primary); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.9rem;"><i class="fa-solid fa-credit-card"></i></div>
                        <div style="text-align: left; flex: 1;">
                            <div style="font-weight: 800; font-size: 1rem; color: var(--text-dark);">Credit / Debit Card</div>
                            <span style="font-size: 0.75rem; color: var(--text-muted);">Visa, Mastercard, RuPay</span>
                        </div>
                        <i class="fa-solid fa-chevron-right" style="color: #ccc;"></i>
                    </button>

                    <!-- Net Banking -->
                    <button type="button" class="pay-tab-btn" onclick="selectPayApp('Net Banking', 'NetBanking', this)" style="border-left: 4px solid #6366f1;">
                        <div style="width: 32px; height: 32px; background: #6366f1; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.9rem;"><i class="fa-solid fa-building-columns"></i></div>
                        <div style="text-align: left; flex: 1;">
                            <div style="font-weight: 800; font-size: 1rem; color: var(--text-dark);">Net Banking</div>
                            <span style="font-size: 0.75rem; color: var(--text-muted);">HDFC, ICICI, SBI, Axis</span>
                        </div>
                        <i class="fa-solid fa-chevron-right" style="color: #ccc;"></i>
                    </button>

                    <!-- Cash on Delivery (COD) -->
                    <button type="button" class="pay-tab-btn" onclick="selectPayApp('Cash on Delivery', 'COD', this)" style="border-left: 4px solid var(--veg-color);">
                        <div style="width: 32px; height: 32px; background: var(--veg-color); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.9rem;"><i class="fa-solid fa-money-bill-wave"></i></div>
                        <div style="text-align: left; flex: 1;">
                            <div style="font-weight: 800; font-size: 1rem; color: var(--text-dark);">Cash on Delivery</div>
                            <span style="font-size: 0.75rem; color: var(--text-muted);">Pay cash/UPI upon arrival</span>
                        </div>
                        <i class="fa-solid fa-chevron-right" style="color: #ccc;"></i>
                    </button>
                </div>
            </div>

            <!-- Right: Dynamic Selected App Payment Panel -->
            <div class="card-box" id="pay-detail-box" style="padding: 24px;">
                <div id="phonepe-panel" class="pay-panel">
                    <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 16px;">
                        <div style="width: 44px; height: 44px; background: #5f259f; color: white; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-weight: 900; font-size: 1.2rem;">Pe</div>
                        <div>
                            <h3 style="font-size: 1.2rem; font-weight: 800; color: #5f259f;">PhonePe Payment</h3>
                            <span style="font-size: 0.85rem; color: var(--text-muted);">Pay using PhonePe App or QR Code</span>
                        </div>
                    </div>

                    <div style="text-align: center; background: #f8f9fa; border: 1px solid var(--border-color); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                        <img src="https://api.qrserver.com/v1/create-qr-code/?size=160x160&data=upi://pay?pa=fastgo.phonepe@ybl&pn=FastGo&am=<%= String.format("%.2f", grandTotal) %>" alt="PhonePe QR" style="width: 140px; height: 140px; border: 2px solid #5f259f; border-radius: 8px; padding: 4px; background: white;">
                        <p style="font-size: 0.85rem; color: var(--text-muted); margin-top: 10px;">Scan QR with PhonePe app to pay <strong>₹<%= String.format("%.2f", grandTotal) %></strong></p>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Or enter your PhonePe VPA / Mobile Number</label>
                        <input type="text" class="form-control" placeholder="9876543210@ybl" value="<%= currentUser != null && currentUser.getPhone() != null ? currentUser.getPhone() + "@ybl" : "9876543210@ybl" %>">
                    </div>

                    <button type="submit" class="btn-primary" style="background: #5f259f; padding: 14px; font-size: 1.05rem;">
                        <i class="fa-solid fa-lock"></i> PAY ₹<%= String.format("%.0f", grandTotal) %> WITH PHONEPE
                    </button>
                </div>

                <!-- Paytm Panel -->
                <div id="paytm-panel" class="pay-panel" style="display: none;">
                    <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 16px;">
                        <div style="width: 44px; height: 44px; background: #00baf2; color: white; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-weight: 900; font-size: 0.9rem;">Paytm</div>
                        <div>
                            <h3 style="font-size: 1.2rem; font-weight: 800; color: #002e6e;">Paytm Wallet & UPI</h3>
                            <span style="font-size: 0.85rem; color: var(--text-muted);">Pay using Paytm Wallet balance or Paytm UPI</span>
                        </div>
                    </div>

                    <div style="text-align: center; background: #f8f9fa; border: 1px solid var(--border-color); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                        <img src="https://api.qrserver.com/v1/create-qr-code/?size=160x160&data=upi://pay?pa=fastgo.paytm@paytm&pn=FastGo&am=<%= String.format("%.2f", grandTotal) %>" alt="Paytm QR" style="width: 140px; height: 140px; border: 2px solid #00baf2; border-radius: 8px; padding: 4px; background: white;">
                        <p style="font-size: 0.85rem; color: var(--text-muted); margin-top: 10px;">Scan QR code using Paytm App</p>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Paytm Mobile Number / UPI ID</label>
                        <input type="text" class="form-control" placeholder="9876543210@paytm" value="<%= currentUser != null && currentUser.getPhone() != null ? currentUser.getPhone() + "@paytm" : "9876543210@paytm" %>">
                    </div>

                    <button type="submit" class="btn-primary" style="background: #00baf2; color: #002e6e; padding: 14px; font-size: 1.05rem;">
                        <i class="fa-solid fa-lock"></i> PAY ₹<%= String.format("%.0f", grandTotal) %> WITH PAYTM
                    </button>
                </div>

                <!-- Google Pay Panel -->
                <div id="gpay-panel" class="pay-panel" style="display: none;">
                    <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 16px;">
                        <div style="width: 44px; height: 44px; background: #4285f4; color: white; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-weight: 900; font-size: 1.2rem;">G</div>
                        <div>
                            <h3 style="font-size: 1.2rem; font-weight: 800; color: #1a73e8;">Google Pay (GPay)</h3>
                            <span style="font-size: 0.85rem; color: var(--text-muted);">Instant direct payment via Google Pay</span>
                        </div>
                    </div>

                    <div style="text-align: center; background: #f8f9fa; border: 1px solid var(--border-color); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                        <img src="https://api.qrserver.com/v1/create-qr-code/?size=160x160&data=upi://pay?pa=fastgo.gpay@okaxis&pn=FastGo&am=<%= String.format("%.2f", grandTotal) %>" alt="GPay QR" style="width: 140px; height: 140px; border: 2px solid #4285f4; border-radius: 8px; padding: 4px; background: white;">
                        <p style="font-size: 0.85rem; color: var(--text-muted); margin-top: 10px;">Scan QR with Google Pay App</p>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Google Pay UPI ID</label>
                        <input type="text" class="form-control" placeholder="name@okaxis" value="rohith.kumar@okaxis">
                    </div>

                    <button type="submit" class="btn-primary" style="background: #4285f4; padding: 14px; font-size: 1.05rem;">
                        <i class="fa-solid fa-lock"></i> PAY ₹<%= String.format("%.0f", grandTotal) %> VIA GOOGLE PAY
                    </button>
                </div>

                <!-- Generic Card Panel -->
                <div id="card-panel" class="pay-panel" style="display: none;">
                    <h3 style="font-size: 1.2rem; font-weight: 800; margin-bottom: 16px;"><i class="fa-solid fa-credit-card" style="color: var(--primary);"></i> Credit / Debit Card Details</h3>

                    <div class="form-group">
                        <label class="form-label">Cardholder Name</label>
                        <input type="text" class="form-control" placeholder="e.g. Rohith Kumar" value="<%= currentUser != null ? currentUser.getName() : "Rohith Kumar" %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Card Number</label>
                        <input type="text" class="form-control" placeholder="4532 XXXX XXXX 8910">
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                        <div class="form-group">
                            <label class="form-label">Expiry (MM/YY)</label>
                            <input type="text" class="form-control" placeholder="12/28">
                        </div>
                        <div class="form-group">
                            <label class="form-label">CVV</label>
                            <input type="password" class="form-control" placeholder="123" maxlength="4">
                        </div>
                    </div>

                    <button type="submit" class="btn-primary" style="padding: 14px; font-size: 1.05rem;">
                        <i class="fa-solid fa-lock"></i> PAY ₹<%= String.format("%.0f", grandTotal) %> SECURELY VIA CARD
                    </button>
                </div>

                <!-- COD Panel -->
                <div id="cod-panel" class="pay-panel" style="display: none;">
                    <div style="text-align: center; padding: 20px;">
                        <div style="width: 70px; height: 70px; background: #f0fdf4; color: var(--veg-color); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.2rem; margin: 0 auto 16px;">
                            <i class="fa-solid fa-money-bill-wave"></i>
                        </div>
                        <h3 style="font-size: 1.3rem; font-weight: 800; margin-bottom: 8px;">Cash on Delivery</h3>
                        <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 20px;">Pay cash or scan rider's QR code when your food order arrives.</p>

                        <button type="submit" class="btn-primary" style="background: var(--veg-color); padding: 14px; font-size: 1.05rem;">
                            CONFIRM CASH ON DELIVERY ORDER (₹<%= String.format("%.0f", grandTotal) %>)
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<style>
.pay-tab-btn {
    width: 100%;
    background: white;
    border: 1px solid var(--border-color);
    padding: 12px 14px;
    border-radius: var(--radius-sm);
    display: flex;
    align-items: center;
    gap: 12px;
    cursor: pointer;
    transition: all 0.2s ease;
}

.pay-tab-btn:hover {
    background: #f8f9fa;
    border-color: #bbb;
}

.pay-tab-btn.active {
    background: #f0f4ff;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}
</style>

<script>
function selectPayApp(appName, methodType, btnElement) {
    document.getElementById('payment-method-input').value = methodType;
    document.getElementById('payment-app-input').value = appName;

    // Update active button UI
    var buttons = document.querySelectorAll('.pay-tab-btn');
    buttons.forEach(b => b.classList.remove('active'));
    btnElement.classList.add('active');

    // Hide all panels
    var panels = document.querySelectorAll('.pay-panel');
    panels.forEach(p => p.style.display = 'none');

    // Show selected panel
    if (appName === 'PhonePe') {
        document.getElementById('phonepe-panel').style.display = 'block';
    } else if (appName === 'Paytm') {
        document.getElementById('paytm-panel').style.display = 'block';
    } else if (appName === 'Google Pay') {
        document.getElementById('gpay-panel').style.display = 'block';
    } else if (appName === 'Card') {
        document.getElementById('card-panel').style.display = 'block';
    } else if (appName === 'Cash on Delivery') {
        document.getElementById('cod-panel').style.display = 'block';
    } else {
        document.getElementById('phonepe-panel').style.display = 'block';
    }
}
</script>

<%@ include file="footer.jsp" %>
