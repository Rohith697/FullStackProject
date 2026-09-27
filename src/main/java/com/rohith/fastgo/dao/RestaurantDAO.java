package com.rohith.fastgo.dao;

import com.rohith.fastgo.model.Restaurant;
import com.rohith.fastgo.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantDAO {

    public List<Restaurant> getAllActiveRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        String sql = "SELECT * FROM restaurants WHERE is_active = TRUE ORDER BY rating DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRestaurant(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Restaurant> searchRestaurants(String query, String cuisine) {
        List<Restaurant> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM restaurants WHERE is_active = TRUE");

        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND (LOWER(name) LIKE ? OR LOWER(cuisine) LIKE ? OR LOWER(description) LIKE ?)");
        }
        if (cuisine != null && !cuisine.trim().isEmpty() && !"ALL".equalsIgnoreCase(cuisine)) {
            sql.append(" AND LOWER(cuisine) LIKE ?");
        }
        sql.append(" ORDER BY rating DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (query != null && !query.trim().isEmpty()) {
                String q = "%" + query.trim().toLowerCase() + "%";
                ps.setString(paramIndex++, q);
                ps.setString(paramIndex++, q);
                ps.setString(paramIndex++, q);
            }
            if (cuisine != null && !cuisine.trim().isEmpty() && !"ALL".equalsIgnoreCase(cuisine)) {
                ps.setString(paramIndex++, "%" + cuisine.trim().toLowerCase() + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRestaurant(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Restaurant getById(int id) {
        String sql = "SELECT * FROM restaurants WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRestaurant(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addRestaurant(Restaurant r) {
        String sql = "INSERT INTO restaurants (name, description, cuisine, rating, delivery_time, price_for_two, address, image_url, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setString(2, r.getDescription());
            ps.setString(3, r.getCuisine());
            ps.setDouble(4, r.getRating() > 0 ? r.getRating() : 4.5);
            ps.setString(5, r.getDeliveryTime());
            ps.setInt(6, r.getPriceForTwo());
            ps.setString(7, r.getAddress());
            ps.setString(8, r.getImageUrl());
            ps.setBoolean(9, r.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRestaurant(Restaurant r) {
        String sql = "UPDATE restaurants SET name = ?, description = ?, cuisine = ?, rating = ?, delivery_time = ?, price_for_two = ?, address = ?, image_url = ?, is_active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setString(2, r.getDescription());
            ps.setString(3, r.getCuisine());
            ps.setDouble(4, r.getRating());
            ps.setString(5, r.getDeliveryTime());
            ps.setInt(6, r.getPriceForTwo());
            ps.setString(7, r.getAddress());
            ps.setString(8, r.getImageUrl());
            ps.setBoolean(9, r.isActive());
            ps.setInt(10, r.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteRestaurant(int id) {
        String sql = "DELETE FROM restaurants WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Restaurant mapRestaurant(ResultSet rs) throws SQLException {
        Restaurant r = new Restaurant();
        r.setId(rs.getInt("id"));
        r.setName(rs.getString("name"));
        r.setDescription(rs.getString("description"));
        r.setCuisine(rs.getString("cuisine"));
        r.setRating(rs.getDouble("rating"));
        r.setDeliveryTime(rs.getString("delivery_time"));
        r.setPriceForTwo(rs.getInt("price_for_two"));
        r.setAddress(rs.getString("address"));
        r.setImageUrl(rs.getString("image_url"));
        r.setActive(rs.getBoolean("is_active"));
        return r;
    }
}
