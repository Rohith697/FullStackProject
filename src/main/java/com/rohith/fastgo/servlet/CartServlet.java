package com.rohith.fastgo.servlet;

import com.rohith.fastgo.dao.MenuItemDAO;
import com.rohith.fastgo.dao.RestaurantDAO;
import com.rohith.fastgo.model.Cart;
import com.rohith.fastgo.model.MenuItem;
import com.rohith.fastgo.model.Restaurant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final MenuItemDAO menuItemDAO = new MenuItemDAO();
    private final RestaurantDAO restaurantDAO = new RestaurantDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        if ("add".equalsIgnoreCase(action)) {
            try {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                int quantity = 1;
                try {
                    quantity = Integer.parseInt(request.getParameter("quantity"));
                } catch (Exception ignored) {}

                MenuItem menuItem = menuItemDAO.getById(itemId);
                if (menuItem != null) {
                    Restaurant r = restaurantDAO.getById(menuItem.getRestaurantId());
                    String rName = r != null ? r.getName() : "Restaurant";
                    cart.addItem(menuItem, quantity, rName);
                    session.setAttribute("cartMessage", "Added '" + menuItem.getName() + "' to cart!");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            String redirectUrl = request.getParameter("redirectUrl");
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                response.sendRedirect(redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
            return;

        } else if ("update".equalsIgnoreCase(action)) {
            try {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cart.updateQuantity(itemId, quantity);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;

        } else if ("remove".equalsIgnoreCase(action)) {
            try {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                cart.removeItem(itemId);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;

        } else if ("clear".equalsIgnoreCase(action)) {
            cart.clear();
            response.sendRedirect(request.getContextPath() + "/cart");
            return;

        } else if ("coupon".equalsIgnoreCase(action)) {
            String code = request.getParameter("couponCode");
            if (code != null) {
                code = code.trim().toUpperCase();
                if ("FASTGO50".equals(code) || "WELCOME50".equals(code)) {
                    cart.setCouponCode(code);
                    cart.setDiscountPercentage(50.0); // 50% off
                    session.setAttribute("couponMessage", "Coupon FASTGO50 applied! 50% discount unlocked.");
                } else if ("FASTGO20".equals(code) || "ZOMATO20".equals(code)) {
                    cart.setCouponCode(code);
                    cart.setDiscountPercentage(20.0);
                    session.setAttribute("couponMessage", "Coupon FASTGO20 applied! 20% discount unlocked.");
                } else {
                    session.setAttribute("couponError", "Invalid coupon code. Try 'FASTGO50' or 'FASTGO20'.");
                }
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
