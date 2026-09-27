<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rohith.fastgo.model.User" %>
<%@ page import="com.rohith.fastgo.model.Cart" %>
<%
    User currentUser = (User) session.getAttribute("user");
    Cart currentCart = (Cart) session.getAttribute("cart");
    int cartCount = currentCart != null ? currentCart.getTotalItemCount() : 0;
    String currentPath = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastGo - Online Food Delivery</title>
    <!-- Google Fonts: Inter & Outfit -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- FastGo Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- Header & Navigation Bar -->
    <header class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/home" class="brand-logo">
                <div class="logo-badge"><i class="fa-solid fa-bolt"></i></div>
                <span class="brand-name">FastGo</span>
            </a>

            <nav>
                <ul class="nav-links">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/home" class="<%= currentPath.endsWith("index.jsp") || currentPath.endsWith("/home") ? "active" : "" %>">
                            <i class="fa-solid fa-house"></i> Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/restaurants" class="<%= currentPath.endsWith("restaurants.jsp") || currentPath.contains("/restaurants") ? "active" : "" %>">
                            <i class="fa-solid fa-utensils"></i> Restaurants
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/cart" class="cart-badge-container <%= currentPath.endsWith("cart.jsp") ? "active" : "" %>">
                            <i class="fa-solid fa-cart-shopping"></i> Cart
                            <% if (cartCount > 0) { %>
                                <span class="cart-badge"><%= cartCount %></span>
                            <% } %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/about" class="<%= currentPath.endsWith("about.jsp") ? "active" : "" %>">
                            <i class="fa-solid fa-circle-info"></i> About
                        </a>
                    </li>

                    <% if (currentUser != null) { %>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/orders">
                                <i class="fa-solid fa-bag-shopping"></i> My Orders
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/auth?action=logout">
                                <i class="fa-solid fa-right-from-bracket"></i> Logout (<%= currentUser.getName().split(" ")[0] %>)
                            </a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/auth?action=login">
                                <i class="fa-solid fa-user"></i> Login / Register
                            </a>
                        </li>
                    <% } %>

                    <!-- Admin Section Link -->
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin" class="admin-nav-link">
                            <i class="fa-solid fa-user-shield"></i> Admin Section
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </header>
