package com.rohith.fastgo.dao;

import com.rohith.fastgo.model.Order;
import com.rohith.fastgo.model.OrderItem;
import com.rohith.fastgo.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int createOrder(Order order) {
        String orderSql = "INSERT INTO orders (user_id, restaurant_id, total_amount, delivery_address, payment_method, payment_status, order_status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String itemSql = "INSERT INTO order_items (order_id, menu_item_id, item_name, quantity, price) VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psOrder = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getUserId());
                psOrder.setInt(2, order.getRestaurantId());
                psOrder.setDouble(3, order.getTotalAmount());
                psOrder.setString(4, order.getDeliveryAddress());
                psOrder.setString(5, order.getPaymentMethod());
                psOrder.setString(6, order.getPaymentStatus() != null ? order.getPaymentStatus() : "PAID");
                psOrder.setString(7, "Placed");

                int affected = psOrder.executeUpdate();
                if (affected == 0) {
                    conn.rollback();
                    return -1;
                }

                int orderId = -1;
                try (ResultSet rsKey = psOrder.getGeneratedKeys()) {
                    if (rsKey.next()) {
                        orderId = rsKey.getInt(1);
                    }
                }

                if (orderId != -1) {
                    try (PreparedStatement psItem = conn.prepareStatement(itemSql)) {
                        for (OrderItem item : order.getItems()) {
                            psItem.setInt(1, orderId);
                            psItem.setInt(2, item.getMenuItemId());
                            psItem.setString(3, item.getItemName());
                            psItem.setInt(4, item.getQuantity());
                            psItem.setDouble(5, item.getPrice());
                            psItem.addBatch();
                        }
                        psItem.executeBatch();
                    }
                }

                conn.commit();
                return orderId;
            } catch (SQLException e) {
                if (conn != null) conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (Exception ignored) {}
            }
        }
        return -1;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, r.name as restaurant_name FROM orders o JOIN restaurants r ON o.restaurant_id = r.id WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapOrder(rs);
                    order.setItems(getOrderItems(orderId));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.name as restaurant_name FROM orders o JOIN restaurants r ON o.restaurant_id = r.id WHERE o.user_id = ? ORDER BY o.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapOrder(rs);
                    order.setItems(getOrderItems(order.getId()));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.name as restaurant_name FROM orders o JOIN restaurants r ON o.restaurant_id = r.id ORDER BY o.id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Order order = mapOrder(rs);
                order.setItems(getOrderItems(order.getId()));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private List<OrderItem> getOrderItems(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(new OrderItem(
                            rs.getInt("id"),
                            rs.getInt("order_id"),
                            rs.getInt("menu_item_id"),
                            rs.getString("item_name"),
                            rs.getInt("quantity"),
                            rs.getDouble("price")
                    ));
                }
            }
        }
        return items;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setRestaurantId(rs.getInt("restaurant_id"));
        try { o.setRestaurantName(rs.getString("restaurant_name")); } catch (Exception ignored) {}
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setDeliveryAddress(rs.getString("delivery_address"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setPaymentStatus(rs.getString("payment_status"));
        o.setOrderStatus(rs.getString("order_status"));
        o.setOrderDate(rs.getTimestamp("order_date"));
        return o;
    }
}
