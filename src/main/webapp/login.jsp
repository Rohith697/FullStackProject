<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<%
    String authError = (String) request.getAttribute("authError");
    String registerError = (String) request.getAttribute("registerError");
%>

<div class="main-wrapper" style="max-width: 500px;">
    <div class="card-box" style="padding: 36px 30px;">
        <div style="text-align: center; margin-bottom: 28px;">
            <div class="logo-badge" style="width: 54px; height: 54px; font-size: 1.8rem; margin: 0 auto 12px;">
                <i class="fa-solid fa-bolt"></i>
            </div>
            <h1 style="font-size: 1.8rem; font-weight: 800;">Welcome to FastGo</h1>
            <p style="color: var(--text-muted); font-size: 0.9rem;">Sign in to your account or register to order food</p>
        </div>

        <% if (authError != null) { %>
            <div style="background-color: #fff0f1; border: 1px solid var(--primary); color: var(--primary); padding: 10px 16px; border-radius: 6px; font-size: 0.9rem; font-weight: 700; margin-bottom: 20px;"><%= authError %></div>
        <% } %>

        <% if (registerError != null) { %>
            <div style="background-color: #fff0f1; border: 1px solid var(--primary); color: var(--primary); padding: 10px 16px; border-radius: 6px; font-size: 0.9rem; font-weight: 700; margin-bottom: 20px;"><%= registerError %></div>
        <% } %>

        <!-- Login Form -->
        <form action="${pageContext.request.contextPath}/auth" method="post" id="login-form">
            <input type="hidden" name="action" value="login">

            <div class="form-group">
                <label class="form-label"><i class="fa-solid fa-envelope"></i> Email Address</label>
                <input type="email" name="email" id="login-email" class="form-control" placeholder="e.g. rohith@user.com" required>
            </div>

            <div class="form-group">
                <label class="form-label"><i class="fa-solid fa-lock"></i> Password</label>
                <input type="password" name="password" id="login-password" class="form-control" placeholder="Enter password" required>
            </div>

            <button type="submit" class="btn-primary" style="margin-top: 10px;"><i class="fa-solid fa-right-to-bracket"></i> Sign In</button>
        </form>

        <!-- Quick 1-Click Demo Login Credentials Buttons -->
        <div style="margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--border-color); text-align: center;">
            <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 12px;">Quick 1-Click Demo Login:</p>
            <div style="display: flex; gap: 10px; justify-content: center;">
                <button type="button" onclick="fillAdminLogin()" style="background: #6366f1; color: white; border: none; padding: 8px 14px; border-radius: 6px; font-weight: 700; font-size: 0.85rem; cursor: pointer;">
                    <i class="fa-solid fa-user-shield"></i> Admin Login
                </button>
                <button type="button" onclick="fillUserLogin()" style="background: var(--veg-color); color: white; border: none; padding: 8px 14px; border-radius: 6px; font-weight: 700; font-size: 0.85rem; cursor: pointer;">
                    <i class="fa-solid fa-user"></i> Customer Login
                </button>
            </div>
        </div>

        <!-- Registration Toggle Form -->
        <div style="margin-top: 24px; text-align: center; border-top: 1px solid var(--border-color); padding-top: 20px;">
            <p style="font-size: 0.9rem; color: var(--text-muted);">
                Don't have an account? <a href="#" onclick="toggleRegisterForm(event)" style="color: var(--primary); font-weight: 700;">Create Account</a>
            </p>
        </div>

        <form action="${pageContext.request.contextPath}/auth" method="post" id="register-form" style="display: none; margin-top: 20px;">
            <input type="hidden" name="action" value="register">

            <div class="form-group">
                <label class="form-label">Full Name</label>
                <input type="text" name="name" class="form-control" placeholder="e.g. Rohith Kumar" required>
            </div>

            <div class="form-group">
                <label class="form-label">Email Address</label>
                <input type="email" name="email" class="form-control" placeholder="e.g. rohith@user.com" required>
            </div>

            <div class="form-group">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control" placeholder="Create password" required>
            </div>

            <div class="form-group">
                <label class="form-label">Phone Number</label>
                <input type="tel" name="phone" class="form-control" placeholder="e.g. 9876543210" required>
            </div>

            <div class="form-group">
                <label class="form-label">Delivery Address</label>
                <textarea name="address" class="form-control" rows="2" placeholder="Full street address..." required></textarea>
            </div>

            <button type="submit" class="btn-primary"><i class="fa-solid fa-user-plus"></i> Register & Create Account</button>
        </form>
    </div>
</div>

<script>
function fillAdminLogin() {
    document.getElementById('login-email').value = 'admin@fastgo.com';
    document.getElementById('login-password').value = 'admin123';
}

function fillUserLogin() {
    document.getElementById('login-email').value = 'rohith@user.com';
    document.getElementById('login-password').value = 'user123';
}

function toggleRegisterForm(e) {
    e.preventDefault();
    var regForm = document.getElementById('register-form');
    var loginForm = document.getElementById('login-form');
    if (regForm.style.display === 'none') {
        regForm.style.display = 'block';
        loginForm.style.display = 'none';
    } else {
        regForm.style.display = 'none';
        loginForm.style.display = 'block';
    }
}
</script>

<%@ include file="footer.jsp" %>
