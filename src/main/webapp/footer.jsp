<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <!-- Footer Section -->
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-col">
                <div class="brand-logo" style="margin-bottom: 12px;">
                    <div class="logo-badge"><i class="fa-solid fa-bolt"></i></div>
                    <span class="brand-name" style="color: white;">FastGo</span>
                </div>
                <p>Lightning fast food delivery from top-rated 10+ local restaurants. Fresh, hot, and delivered in 30 minutes!</p>
            </div>

            <div class="footer-col">
                <h4>Quick Links</h4>
                <a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-chevron-right"></i> Home</a>
                <a href="${pageContext.request.contextPath}/restaurants"><i class="fa-solid fa-chevron-right"></i> Restaurants</a>
                <a href="${pageContext.request.contextPath}/cart"><i class="fa-solid fa-chevron-right"></i> Cart</a>
                <a href="${pageContext.request.contextPath}/about"><i class="fa-solid fa-chevron-right"></i> About Us</a>
                <a href="${pageContext.request.contextPath}/admin"><i class="fa-solid fa-chevron-right"></i> Admin Section</a>
            </div>

            <div class="footer-col">
                <h4>Top Cuisines</h4>
                <a href="${pageContext.request.contextPath}/restaurants?cuisine=Hyderabadi"><i class="fa-solid fa-utensils"></i> Hyderabadi Biryani</a>
                <a href="${pageContext.request.contextPath}/restaurants?cuisine=Italian"><i class="fa-solid fa-pizza-slice"></i> Italian Woodfired Pizza</a>
                <a href="${pageContext.request.contextPath}/restaurants?cuisine=American"><i class="fa-solid fa-burger"></i> Gourmet Burgers</a>
                <a href="${pageContext.request.contextPath}/restaurants?cuisine=Chinese"><i class="fa-solid fa-bowl-food"></i> Chinese Noodles</a>
                <a href="${pageContext.request.contextPath}/restaurants?cuisine=Japanese"><i class="fa-solid fa-fish"></i> Japanese Sushi & Ramen</a>
            </div>

            <div class="footer-col">
                <h4>Customer Care</h4>
                <p><i class="fa-solid fa-envelope"></i> support@fastgo.com</p>
                <p><i class="fa-solid fa-phone"></i> +91 1800-FASTGO (327846)</p>
                <p><i class="fa-solid fa-location-dot"></i> Cyber Towers, Hitech City, Hyderabad</p>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; <%= java.time.Year.now().getValue() %> FastGo Food Delivery Application. Crafted with Java, Servlets, JSP, JDBC & MySQL.</p>
        </div>
    </footer>

</body>
</html>
