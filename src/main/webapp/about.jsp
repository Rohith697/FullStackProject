<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<div class="main-wrapper">
    <div style="background: linear-gradient(135deg, var(--primary), var(--accent)); color: white; border-radius: var(--radius-lg); padding: 50px 30px; text-align: center; margin-bottom: 36px; box-shadow: var(--shadow-md);">
        <h1 style="font-size: 2.8rem; font-weight: 900; margin-bottom: 12px;">About FastGo</h1>
        <p style="font-size: 1.2rem; max-width: 700px; margin: 0 auto; opacity: 0.95;">
            FastGo is a full-stack Zomato-inspired food delivery platform engineered with Java Servlets, JSP, JDBC, and MySQL.
        </p>
    </div>

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 32px; margin-bottom: 36px;">
        <div class="card-box" style="padding: 30px;">
            <h2 style="font-size: 1.5rem; margin-bottom: 16px; color: var(--primary);"><i class="fa-solid fa-bullseye"></i> Our Mission</h2>
            <p style="color: var(--text-muted); font-size: 0.95rem; line-height: 1.7;">
                Our mission is to connect hungry foodies with top-rated local restaurants through a seamless 30-minute delivery pipeline. FastGo brings 10+ authentic kitchens and over 100+ gourmet dishes straight to your doorstep with zero hassle.
            </p>
        </div>

        <div class="card-box" style="padding: 30px;">
            <h2 style="font-size: 1.5rem; margin-bottom: 16px; color: var(--accent);"><i class="fa-solid fa-code"></i> Pure Java Tech Stack</h2>
            <p style="color: var(--text-muted); font-size: 0.95rem; line-height: 1.7;">
                FastGo is built strictly according to Java Enterprise specifications using Core Java 17, JEE Servlets, JSP templates, JDBC Connection pooling, MySQL 8.0, and Vanilla HTML5/CSS3.
            </p>
        </div>
    </div>

    <!-- Tech Architecture Summary Box -->
    <div class="card-box" style="padding: 30px; margin-bottom: 36px;">
        <h2 style="font-size: 1.5rem; margin-bottom: 20px;"><i class="fa-solid fa-layer-group" style="color: #6366f1;"></i> Architecture Overview</h2>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px;">
            <div style="background: #f8f9fa; border: 1px solid var(--border-color); padding: 18px; border-radius: 8px;">
                <h4 style="color: var(--primary); font-size: 1.1rem; margin-bottom: 6px;">1. Presentation (JSP)</h4>
                <p style="font-size: 0.85rem; color: var(--text-muted);">Dynamic JSP pages with modular header/footer inclusions and responsive CSS Box Model styling.</p>
            </div>

            <div style="background: #f8f9fa; border: 1px solid var(--border-color); padding: 18px; border-radius: 8px;">
                <h4 style="color: var(--accent); font-size: 1.1rem; margin-bottom: 6px;">2. Controller (Servlets)</h4>
                <p style="font-size: 0.85rem; color: var(--text-muted);">JEE Servlets (`HomeServlet`, `MenuServlet`, `CartServlet`, `CheckoutServlet`, `AdminServlet`) routing HTTP requests.</p>
            </div>

            <div style="background: #f8f9fa; border: 1px solid var(--border-color); padding: 18px; border-radius: 8px;">
                <h4 style="color: var(--veg-color); font-size: 1.1rem; margin-bottom: 6px;">3. Data Access (JDBC)</h4>
                <p style="font-size: 0.85rem; color: var(--text-muted);">Clean DAO pattern with `PreparedStatement` and transactional batch order processing in MySQL.</p>
            </div>

            <div style="background: #f8f9fa; border: 1px solid var(--border-color); padding: 18px; border-radius: 8px;">
                <h4 style="color: #6366f1; font-size: 1.1rem; margin-bottom: 6px;">4. Database (MySQL)</h4>
                <p style="font-size: 0.85rem; color: var(--text-muted);">Normalized database schema (`users`, `restaurants`, `menu_items`, `orders`, `order_items`).</p>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
