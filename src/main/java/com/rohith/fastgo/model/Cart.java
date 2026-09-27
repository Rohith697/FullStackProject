package com.rohith.fastgo.model;

import java.util.ArrayList;
import java.util.List;

public class Cart {
    private int restaurantId = -1;
    private String restaurantName = "";
    private List<CartItem> items = new ArrayList<>();
    private String couponCode = "";
    private double discountPercentage = 0.0;

    public Cart() {}

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }

    public List<CartItem> getItems() { return items; }

    public String getCouponCode() { return couponCode; }
    public void setCouponCode(String couponCode) { this.couponCode = couponCode; }

    public double getDiscountPercentage() { return discountPercentage; }
    public void setDiscountPercentage(double discountPercentage) { this.discountPercentage = discountPercentage; }

    public void addItem(MenuItem menuItem, int quantity, String rName) {
        if (restaurantId != -1 && restaurantId != menuItem.getRestaurantId()) {
            // Cart belongs to another restaurant, reset cart for new restaurant
            items.clear();
        }
        this.restaurantId = menuItem.getRestaurantId();
        this.restaurantName = rName;

        for (CartItem item : items) {
            if (item.getMenuItem().getId() == menuItem.getId()) {
                item.setQuantity(item.getQuantity() + quantity);
                return;
            }
        }
        items.add(new CartItem(menuItem, quantity));
    }

    public void updateQuantity(int menuItemId, int quantity) {
        if (quantity <= 0) {
            removeItem(menuItemId);
            return;
        }
        for (CartItem item : items) {
            if (item.getMenuItem().getId() == menuItemId) {
                item.setQuantity(quantity);
                return;
            }
        }
    }

    public void removeItem(int menuItemId) {
        items.removeIf(item -> item.getMenuItem().getId() == menuItemId);
        if (items.isEmpty()) {
            restaurantId = -1;
            restaurantName = "";
            couponCode = "";
            discountPercentage = 0.0;
        }
    }

    public void clear() {
        items.clear();
        restaurantId = -1;
        restaurantName = "";
        couponCode = "";
        discountPercentage = 0.0;
    }

    public int getTotalItemCount() {
        int count = 0;
        for (CartItem item : items) {
            count += item.getQuantity();
        }
        return count;
    }

    public double getSubtotal() {
        double sub = 0.0;
        for (CartItem item : items) {
            sub += item.getTotalPrice();
        }
        return sub;
    }

    public double getTaxAmount() {
        return getSubtotal() * 0.05; // 5% GST
    }

    public double getDeliveryFee() {
        return getSubtotal() > 0 ? (getSubtotal() > 500 ? 0.0 : 40.0) : 0.0;
    }

    public double getDiscountAmount() {
        return (getSubtotal() * discountPercentage) / 100.0;
    }

    public double getGrandTotal() {
        double total = getSubtotal() + getTaxAmount() + getDeliveryFee() - getDiscountAmount();
        return Math.max(0, total);
    }
}
