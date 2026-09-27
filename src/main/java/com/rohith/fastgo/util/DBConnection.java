package com.rohith.fastgo.util;

import java.sql.*;

public class DBConnection {
    private static final String HOST = "localhost";
    private static final String PORT = "3306";
    private static final String DB_NAME = "fastgo_db";
    private static final String USER = "root";
    // We will test password options (rohith@123, then empty string)
    private static String passwordToUse = "rohith@123";
    private static boolean initialized = false;

    public static synchronized Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found!", e);
        }

        if (!initialized) {
            initializeDatabase();
            initialized = true;
        }

        String dbUrl = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DB_NAME + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        try {
            return DriverManager.getConnection(dbUrl, USER, passwordToUse);
        } catch (SQLException e) {
            // Try fallback password ""
            passwordToUse = "";
            return DriverManager.getConnection(dbUrl, USER, passwordToUse);
        }
    }

    private static void initializeDatabase() {
        String baseUrl = "jdbc:mysql://" + HOST + ":" + PORT + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(baseUrl, USER, "rohith@123");
            passwordToUse = "rohith@123";
        } catch (SQLException e) {
            try {
                conn = DriverManager.getConnection(baseUrl, USER, "");
                passwordToUse = "";
            } catch (SQLException ex) {
                System.err.println("Could not connect to MySQL Server: " + ex.getMessage());
                return;
            }
        }

        try (Statement stmt = conn.createStatement()) {
            // Create database
            stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS " + DB_NAME);
            stmt.executeUpdate("USE " + DB_NAME);

            // Create Tables
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(100) NOT NULL, " +
                    "email VARCHAR(100) NOT NULL UNIQUE, " +
                    "password VARCHAR(255) NOT NULL, " +
                    "phone VARCHAR(20), " +
                    "address TEXT, " +
                    "role VARCHAR(20) DEFAULT 'USER', " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS restaurants (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(100) NOT NULL, " +
                    "description TEXT, " +
                    "cuisine VARCHAR(100), " +
                    "rating DOUBLE DEFAULT 4.5, " +
                    "delivery_time VARCHAR(50), " +
                    "price_for_two INT, " +
                    "address VARCHAR(255), " +
                    "image_url TEXT, " +
                    "is_active BOOLEAN DEFAULT TRUE)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS menu_items (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "restaurant_id INT NOT NULL, " +
                    "name VARCHAR(100) NOT NULL, " +
                    "description TEXT, " +
                    "price DOUBLE NOT NULL, " +
                    "category VARCHAR(50), " +
                    "is_veg BOOLEAN DEFAULT TRUE, " +
                    "image_url TEXT, " +
                    "rating DOUBLE DEFAULT 4.5, " +
                    "FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS orders (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "restaurant_id INT NOT NULL, " +
                    "total_amount DOUBLE NOT NULL, " +
                    "delivery_address TEXT, " +
                    "payment_method VARCHAR(50), " +
                    "payment_status VARCHAR(50), " +
                    "order_status VARCHAR(50) DEFAULT 'Placed', " +
                    "order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (user_id) REFERENCES users(id), " +
                    "FOREIGN KEY (restaurant_id) REFERENCES restaurants(id))");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS order_items (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "order_id INT NOT NULL, " +
                    "menu_item_id INT NOT NULL, " +
                    "item_name VARCHAR(100), " +
                    "quantity INT NOT NULL, " +
                    "price DOUBLE NOT NULL, " +
                    "FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE)");

            // Check if default Admin user exists
            ResultSet rsUser = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE email='admin@fastgo.com'");
            if (rsUser.next() && rsUser.getInt(1) == 0) {
                stmt.executeUpdate("INSERT INTO users (name, email, password, phone, address, role) VALUES " +
                        "('FastGo Admin', 'admin@fastgo.com', 'admin123', '9876543210', 'Headquarters, Tech City', 'ADMIN'), " +
                        "('Rohith Kumar', 'rohith@user.com', 'user123', '9123456789', 'Plot 45, Jubilee Hills, Hyderabad', 'USER')");
            }

            // Check if restaurants exist, seed 10 restaurants and 100 menu items if empty
            ResultSet rsRest = stmt.executeQuery("SELECT COUNT(*) FROM restaurants");
            if (rsRest.next() && rsRest.getInt(1) == 0) {
                seedDatabase(stmt);
            }

            System.out.println(">>> FastGo MySQL Database Initialized Successfully!");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception ignored) {}
            }
        }
    }

    private static void seedDatabase(Statement stmt) throws SQLException {
        // Seed 10 Restaurants
        String[] restSqls = {
            "INSERT INTO restaurants (id, name, description, cuisine, rating, delivery_time, price_for_two, address, image_url) VALUES " +
            "(1, 'The Royal Biryani House', 'Authentic Hyderabadi Dum Biryani cooked with fragrant spices and slow dum method.', 'Hyderabadi, Mughlai', 4.8, '25-30 min', 450, 'Gachibowli Main Rd, Hyderabad', 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=800&q=80')",

            "INSERT INTO restaurants (id, name, description, cuisine, rating, delivery_time, price_for_two, address, image_url) VALUES " +
            "(2, 'Pizza Express & Craft', 'Hand-tossed woodfired artisanal pizzas topped with fresh mozzarella & herbs.', 'Italian, Pizza', 4.7, '30-35 min', 550, 'Jubilee Hills Rd 36, Hyderabad', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=800&q=80')",

            "INSERT INTO restaurants (id, name, description, cuisine, rating, delivery_time, price_for_two, address, image_url) VALUES " +
            "(3, 'Burger Club & Grill', 'Juicy gourmet smash burgers served with seasoned fries and house dipping sauces.', 'American, Fast Food', 4.6, '20-25 min', 400, 'Banjara Hills Rd 12, Hyderabad', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=800&q=80')",

            "INSERT INTO restaurants (id, name, description, cuisine, rating, delivery_time, price_for_two, address, image_url) VALUES " +
            "(4, 'Dragon Wok Express', 'Authentic Pan-Asian stir-fry noodles, Schezwan fried rice & chili dumplings.', 'Chinese, Asian', 4.5, '30-35 min', 500, 'Hitech City Phase 2, Hyderabad', 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?auto=format&fit=crop&w=800&q=80')",

            "INSERT INTO restaurants (id, name, description, cuisine, rating, delivery_time, price_for_two, address, image_url) VALUES " +
            "(5, 'Spice Route Curry House', 'Rich North Indian curries, butter naans, and thalis crafted with royal recipes.', 'North Indian, Thali', 4.9, '25-30 min', 600, 'Kondapur Main Rd, Hyderabad', 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?auto=format&fit=crop&w=800&q=80')",

            "INSERT INTO restaurants (id, name, description, cuisine, rating, delivery_time, price_for_two, address, image_url) VALUES " +
            "(6, 'Taco & Burrito Fiesta', 'Sizzling Mexican burritos, cheesy quesadillas, loaded nachos & fresh salsa.', 'Mexican, Wraps', 4.4, '20-30 min', 450, 'Madhapur Cyber Towers, Hyderabad', 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?auto=format&fit=crop&w=800&q=80')",

            "INSERT INTO restaurants (id, name, description, cuisine, rating, delivery_time, price_for_two, address, image_url) VALUES " +
            "(7, 'Tokyo Sushi & Ramen Bar', 'Steaming hot authentic ramen bowls, fresh sushi rolls & crisp vegetable tempura.', 'Japanese, Asian', 4.8, '35-40 min', 800, 'Financial District, Nanakramguda, Hyderabad', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=800&q=80')",

            "INSERT INTO restaurants (id, name, description, cuisine, rating, delivery_time, price_for_two, address, image_url) VALUES " +
            "(8, 'Sweet Treats Bakery & Cafe', 'Freshly baked belgian waffles, cupcakes, brownies, and specialty cold brews.', 'Bakery, Desserts', 4.9, '15-20 min', 350, 'Ameerpet Metro Station, Hyderabad', 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=800&q=80')",

            "INSERT INTO restaurants (id, name, description, cuisine, rating, delivery_time, price_for_two, address, image_url) VALUES " +
            "(9, 'Green Bowl Healthy Cafe', 'Nutritious quinoa bowls, avocado salads, fresh detox juices & protein bowls.', 'Healthy, Salads', 4.7, '20-25 min', 500, 'Kukatpally Housing Board, Hyderabad', 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80')",

            "INSERT INTO restaurants (id, name, description, cuisine, rating, delivery_time, price_for_two, address, image_url) VALUES " +
            "(10, 'South Flavors Dosa Junction', 'Crispy ghee podi dosas, fluffy idlis, vada, and piping hot filter coffee.', 'South Indian', 4.8, '20-25 min', 300, 'Secunderabad Station Rd, Hyderabad', 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=800&q=80')"
        };

        for (String sql : restSqls) {
            stmt.executeUpdate(sql);
        }

        // Seed 10 Menu Items per Restaurant (Total 100 Menu Items)
        String[] itemSqls = {
            // Restaurant 1: The Royal Biryani House
            "INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, image_url, rating) VALUES " +
            "(1, 'Hyderabadi Chicken Dum Biryani', 'Slow dum cooked chicken with basmati rice, saffron, and aromatic spices.', 290.0, 'Main Course', false, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(1, 'Mutton Special Dum Biryani', 'Tender mutton pieces layered with seasoned basmati rice and fried onions.', 360.0, 'Main Course', false, 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(1, 'Chicken Tikka Kebab', 'Char-grilled chicken marinated in yogurt and tikka spices.', 260.0, 'Starters', false, 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(1, 'Paneer Butter Masala', 'Soft cottage cheese cubes in rich creamy tomato cashew gravy.', 240.0, 'Main Course', true, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=500&q=80', 4.6), " +
            "(1, 'Garlic Butter Naan', 'Clay oven baked Indian bread topped with roasted garlic & fresh butter.', 50.0, 'Breads', true, 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(1, 'Chicken 65', 'Deep-fried spicy chicken morsels tossed with curry leaves and green chilies.', 250.0, 'Starters', false, 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(1, 'Veg Dum Biryani', 'Fragrant rice cooked with mixed vegetables, paneer, and authentic biryani masala.', 220.0, 'Main Course', true, 'https://images.unsplash.com/photo-1543339308-43e59d6b73a6?auto=format&fit=crop&w=500&q=80', 4.5), " +
            "(1, 'Mirchi Ka Salan', 'Traditional Hyderabadi spicy chili and peanut sesame curry.', 120.0, 'Sides', true, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=500&q=80', 4.4), " +
            "(1, 'Shahi Tukda', 'Deep-fried bread soaked in saffron rabri and topped with dry fruits.', 130.0, 'Desserts', true, 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(1, 'Double Ka Meetha', 'Traditional Hyderabadi bread pudding enriched with condensed milk & almonds.', 140.0, 'Desserts', true, 'https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=500&q=80', 4.8)",

            // Restaurant 2: Pizza Express & Craft
            "INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, image_url, rating) VALUES " +
            "(2, 'Farmhouse Special Pizza', 'Loaded with capsicum, onion, tomato, grilled mushroom, and 100% mozzarella.', 380.0, 'Pizza', true, 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(2, 'Pepperoni Feast Pizza', 'Classic Italian pepperoni slices over rich tomato sauce and melted cheese.', 450.0, 'Pizza', false, 'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(2, 'Cheesy Garlic Breadsticks', 'Oven-baked breadsticks coated with garlic butter & stringy mozzarella.', 180.0, 'Sides', true, 'https://images.unsplash.com/photo-1573140247632-f8fd74997d5c?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(2, 'Classic Margherita Pizza', 'Simplicity at its best: San Marzano tomato sauce, fresh basil & fior di latte.', 290.0, 'Pizza', true, 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?auto=format&fit=crop&w=500&q=80', 4.6), " +
            "(2, 'Creamy Alfredo Pasta', 'Penne pasta tossed in rich parmesan garlic cream sauce with garden vegetables.', 320.0, 'Pasta', true, 'https://images.unsplash.com/photo-1621996346565-e3def6164286?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(2, 'Spicy Arrabbiata Pasta', 'Penne pasta in fiery red tomato sauce infused with chili flakes & olives.', 310.0, 'Pasta', true, 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=500&q=80', 4.5), " +
            "(2, 'Paneer Supreme Pizza', 'Spicy tandoori paneer, red paprika, onion, and fresh cilantro.', 390.0, 'Pizza', true, 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(2, 'Stuffed Crust Cheese Pizza', 'Golden pizza crust filled with liquid cheddar cheese & herbs.', 420.0, 'Pizza', true, 'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(2, 'Chocolate Lava Cake', 'Warm chocolate cake with molten chocolate core served piping hot.', 150.0, 'Desserts', true, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(2, 'Italian Tiramisu', 'Classic coffee-soaked savoiardi biscuits layered with mascarpone cream.', 220.0, 'Desserts', true, 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?auto=format&fit=crop&w=500&q=80', 4.8)",

            // Restaurant 3: Burger Club & Grill
            "INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, image_url, rating) VALUES " +
            "(3, 'Double Cheese Smash Burger', 'Two seared beef patties, double cheddar cheese, pickles & secret sauce.', 290.0, 'Burgers', false, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(3, 'Crispy Zinger Chicken Burger', 'Golden fried chicken breast, mayo, iceberg lettuce in toasted brioche bun.', 250.0, 'Burgers', false, 'https://images.unsplash.com/photo-1625813506062-0aeb1d7a094b?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(3, 'Veggie Supreme Burger', 'Crispy potato & herb patty with melted cheese, lettuce & chipotle mayo.', 190.0, 'Burgers', true, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=500&q=80', 4.5), " +
            "(3, 'Loaded Cheese Fries', 'Crispy French fries smothered in liquid cheddar, jalapenos & chives.', 160.0, 'Sides', true, 'https://images.unsplash.com/photo-1585109649139-366815a0d713?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(3, 'BBQ Chicken Wings', 'Crispy chicken wings tossed in smoky honey BBQ sauce (6 pcs).', 240.0, 'Starters', false, 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(3, 'Onion Rings Basket', 'Beer-battered golden onion rings served with garlic mayo dip.', 130.0, 'Sides', true, 'https://images.unsplash.com/photo-1639024471283-03518883512d?auto=format&fit=crop&w=500&q=80', 4.4), " +
            "(3, 'Classic Beef Cheeseburger', 'Single grilled beef patty, american cheese, onion rings & ketchup.', 260.0, 'Burgers', false, 'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?auto=format&fit=crop&w=500&q=80', 4.6), " +
            "(3, 'Peri Peri Chicken Burger', 'Spicy peri-peri marinated chicken breast with fiery habanero spread.', 270.0, 'Burgers', false, 'https://images.unsplash.com/photo-1619216083420-6e54b895f730?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(3, 'Chocolate Milkshake', 'Thick creamy milkshake made with rich chocolate gelato & whipped cream.', 140.0, 'Beverages', true, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(3, 'Salted Caramel Sundae', 'Vanilla ice cream topped with warm salted caramel sauce and pecans.', 160.0, 'Desserts', true, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=500&q=80', 4.9)",

            // Restaurant 4: Dragon Wok Express
            "INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, image_url, rating) VALUES " +
            "(4, 'Chicken Hakka Noodles', 'Wok-tossed noodles with shredded chicken, bell peppers, soy & sesame.', 240.0, 'Main Course', false, 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(4, 'Schezwan Fried Rice', 'Spicy wok fried jasmine rice tossed with schezwan paste & spring onions.', 220.0, 'Main Course', true, 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&w=500&q=80', 4.6), " +
            "(4, 'Crispy Chili Chicken', 'Deep-fried chicken strips tossed with onions, green chili & garlic soya sauce.', 270.0, 'Starters', false, 'https://images.unsplash.com/photo-1525755662778-989d0524087e?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(4, 'Vegetable Spring Rolls', 'Crispy pastry rolls filled with shredded cabbage, carrots & glass noodles.', 180.0, 'Starters', true, 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=500&q=80', 4.5), " +
            "(4, 'Dim Sum Veg Dumplings', 'Steamed oriental dumplings filled with mushrooms & Chinese cabbage.', 210.0, 'Starters', true, 'https://images.unsplash.com/photo-1496116218417-1a781b1c416c?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(4, 'Kung Pao Chicken', 'Classic Sichuan wok chicken with roasted peanuts, chilies & dark soy.', 290.0, 'Main Course', false, 'https://images.unsplash.com/photo-1525755662778-989d0524087e?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(4, 'Chili Garlic Noodles', 'Spicy wok-tossed noodles infused with crushed garlic and dried red chilies.', 210.0, 'Main Course', true, 'https://images.unsplash.com/photo-1612927601601-6638404737ce?auto=format&fit=crop&w=500&q=80', 4.5), " +
            "(4, 'Manchurian Gravy (Veg)', 'Deep-fried veggie balls simmered in tangy soy ginger garlic sauce.', 230.0, 'Main Course', true, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=500&q=80', 4.4), " +
            "(4, 'Hot & Sour Chicken Soup', 'Hearty soup spiced with white pepper, vinegar, chicken & bamboo shoots.', 160.0, 'Soups', false, 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=500&q=80', 4.6), " +
            "(4, 'Honey Chili Potato', 'Crispy potato fingers glazed with sweet chili honey sauce and sesame.', 190.0, 'Starters', true, 'https://images.unsplash.com/photo-1585109649139-366815a0d713?auto=format&fit=crop&w=500&q=80', 4.7)",

            // Restaurant 5: Spice Route Curry House
            "INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, image_url, rating) VALUES " +
            "(5, 'Butter Chicken Special', 'Tender tandoori chicken cooked in velvety tomato, butter & cream gravy.', 340.0, 'Main Course', false, 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(5, 'Dal Makhani Signature', 'Black lentils slow-cooked overnight with cream, butter and aromatic spices.', 260.0, 'Main Course', true, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(5, 'Kadai Paneer', 'Fresh cottage cheese stir-fried with capsicum, onion & freshly ground spices.', 280.0, 'Main Course', true, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(5, 'Malai Kofta Curry', 'Soft paneer-potato dumplings served in rich cashew nut onion gravy.', 290.0, 'Main Course', true, 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(5, 'Tandoori Roti Basket', 'Assorted clay oven tandoori rotis, butter naans, and missi rotis.', 150.0, 'Breads', true, 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=500&q=80', 4.6), " +
            "(5, 'Jeera Rice & Dal Tadka', 'Fragrant cumin rice paired with yellow lentil tadka cooked in desi ghee.', 220.0, 'Main Course', true, 'https://images.unsplash.com/photo-1596797038530-2c107229654b?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(5, 'Chicken Amritsari', 'Punjabi style boneless chicken fry flavored with carom seeds & spices.', 310.0, 'Starters', false, 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(5, 'Paneer Tikka Masala', 'Charcoal-grilled paneer cubes cooked in spicy onion tomato masala.', 290.0, 'Main Course', true, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(5, 'Gulab Jamun (2 Pcs)', 'Soft milk solid balls fried golden and dipped in warm cardamom sugar syrup.', 90.0, 'Desserts', true, 'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(5, 'Rasmalai (2 Pcs)', 'Soft cottage cheese patties soaked in chilled saffron rabri & pistachio.', 120.0, 'Desserts', true, 'https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=500&q=80', 4.9)",

            // Restaurant 6: Taco & Burrito Fiesta
            "INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, image_url, rating) VALUES " +
            "(6, 'Cheesy Chicken Burrito', 'Flour tortilla stuffed with grilled chicken, Mexican rice, beans & melted cheese.', 280.0, 'Burritos', false, 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(6, 'Loaded Beef Tacos', 'Hard shell corn tacos filled with seasoned beef, pico de gallo & sour cream.', 260.0, 'Tacos', false, 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(6, 'Crispy Veg Quesadilla', 'Folded tortilla grilled with bell peppers, corn, jalapenos & Monterey Jack cheese.', 220.0, 'Main Course', true, 'https://images.unsplash.com/photo-1618040996337-56904b7850b9?auto=format&fit=crop&w=500&q=80', 4.5), " +
            "(6, 'Nachos Supreme with Cheese Dip', 'Crispy tortilla chips topped with warm cheese sauce, guacamole & salsa.', 190.0, 'Sides', true, 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?auto=format&fit=crop&w=500&q=80', 4.6), " +
            "(6, 'Mexican Fiesta Rice Bowl', 'Spiced rice bowl topped with black beans, corn, grilled paneer & salsa.', 240.0, 'Main Course', true, 'https://images.unsplash.com/photo-1543339308-43e59d6b73a6?auto=format&fit=crop&w=500&q=80', 4.6), " +
            "(6, 'Grilled Chicken Fajita Wrap', 'Smoky chicken strips, grilled onions, peppers & avocado wrapped in tortilla.', 270.0, 'Wraps', false, 'https://images.unsplash.com/photo-1509722747041-616f39b57569?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(6, 'Spicy Bean Burrito', 'Pinto beans, cilantro lime rice, jalapenos & chipotle salsa in flour tortilla.', 210.0, 'Burritos', true, 'https://images.unsplash.com/photo-1584208124888-3a20b9c799e2?auto=format&fit=crop&w=500&q=80', 4.4), " +
            "(6, 'Jalapeno Cheese Poppers', 'Deep-fried jalapenos stuffed with cream cheese served with ranch dip.', 170.0, 'Sides', true, 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?auto=format&fit=crop&w=500&q=80', 4.5), " +
            "(6, 'Cinnamon Churros', 'Golden fried churros dusted with cinnamon sugar served with chocolate fudge.', 150.0, 'Desserts', true, 'https://images.unsplash.com/photo-1624371414361-e670edf4898d?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(6, 'Mango Salsa & Chips', 'Freshly fried tortilla chips served with zesty mango tomato salsa.', 130.0, 'Sides', true, 'https://images.unsplash.com/photo-1570461225916-24e64f1bc0f1?auto=format&fit=crop&w=500&q=80', 4.4)",

            // Restaurant 7: Tokyo Sushi & Ramen Bar
            "INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, image_url, rating) VALUES " +
            "(7, 'Chicken Shoyu Ramen', 'Rich soy broth ramen with braised chicken, soft-boiled egg & nori.', 420.0, 'Ramen', false, 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(7, 'Salmon Nigiri Sushi (4 Pcs)', 'Fresh Atlantic salmon slices pressed over seasoned sushi rice.', 450.0, 'Sushi', false, 'https://images.unsplash.com/photo-1611143669185-af224c5e3252?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(7, 'California Roll (6 Pcs)', 'Crabstick, avocado, cucumber roll rolled in toasted sesame seeds.', 380.0, 'Sushi', false, 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(7, 'Vegetable Tempura', 'Crispy light batter-fried seasonal vegetables served with dashi dipping sauce.', 280.0, 'Starters', true, 'https://images.unsplash.com/photo-1615361200141-f45040f367be?auto=format&fit=crop&w=500&q=80', 4.6), " +
            "(7, 'Chicken Teriyaki Bowl', 'Pan-seared chicken glazed in sweet soy teriyaki over steamed jasmine rice.', 390.0, 'Main Course', false, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(7, 'Spicy Tuna Roll', 'Fresh tuna rolled with chili mayo, sriracha & crisp scallions.', 410.0, 'Sushi', false, 'https://images.unsplash.com/photo-1617196034796-73dfa7b1fd56?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(7, 'Miso Soup Special', 'Traditional Japanese dashi broth with tofu, wakame seaweed & spring onion.', 180.0, 'Soups', true, 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=500&q=80', 4.6), " +
            "(7, 'Prawn Tempura Roll', 'Crispy fried jumbo prawn wrapped in nori & sushi rice topped with unagi glaze.', 460.0, 'Sushi', false, 'https://images.unsplash.com/photo-1617196034796-73dfa7b1fd56?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(7, 'Edamame Beans', 'Steamed young soybeans sprinkled with pink Himalayan sea salt.', 190.0, 'Starters', true, 'https://images.unsplash.com/photo-1564834744159-ff0ea41ba4b9?auto=format&fit=crop&w=500&q=80', 4.5), " +
            "(7, 'Matcha Ice Cream', 'Authentic Japanese green tea ice cream served with red bean paste.', 210.0, 'Desserts', true, 'https://images.unsplash.com/photo-1505394033641-40c6ad1178d7?auto=format&fit=crop&w=500&q=80', 4.8)",

            // Restaurant 8: Sweet Treats Bakery & Cafe
            "INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, image_url, rating) VALUES " +
            "(8, 'Belgian Chocolate Waffle', 'Warm golden waffle smothered in Belgian dark chocolate sauce & banana.', 210.0, 'Desserts', true, 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(8, 'Red Velvet Cupcake', 'Moist cocoa cupcake topped with cream cheese frosting & cake crumbs.', 110.0, 'Bakery', true, 'https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(8, 'Blueberry Cheesecake', 'Classic New York style baked cheesecake topped with blueberry compote.', 240.0, 'Desserts', true, 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(8, 'Iced Hazelnut Latte', 'Espresso poured over ice, milk, and roasted hazelnut syrup.', 180.0, 'Beverages', true, 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(8, 'Cappuccino Premium', 'Double shot espresso topped with thick velvety steamed milk foam.', 150.0, 'Beverages', true, 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(8, 'Chocolate Brownie with Fudge', 'Warm fudgy chocolate brownie topped with hot chocolate drizzle.', 160.0, 'Bakery', true, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(8, 'Mango Smoothie Bowl', 'Chilled mango smoothie topped with chia seeds, coconut flakes & berries.', 220.0, 'Beverages', true, 'https://images.unsplash.com/photo-1546039907-7fa05f864c02?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(8, 'Salted Caramel Donut', 'Fluffy glazed doughnut filled with creamy salted caramel custard.', 120.0, 'Bakery', true, 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(8, 'Macaron Box (Assorted)', 'French almond macarons in pistachio, raspberry & vanilla flavors (4 pcs).', 260.0, 'Bakery', true, 'https://images.unsplash.com/photo-1569864358642-9d1684040f43?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(8, 'Cold Brew Coffee', 'Steeped for 18 hours, smooth low-acidity refreshing cold coffee.', 170.0, 'Beverages', true, 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?auto=format&fit=crop&w=500&q=80', 4.6)",

            // Restaurant 9: Green Bowl Healthy Cafe
            "INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, image_url, rating) VALUES " +
            "(9, 'Mediterranean Quinoa Bowl', 'Quinoa, chickpeas, cucumber, cherry tomatoes, olives & feta cheese.', 280.0, 'Salads', true, 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(9, 'Avocado Toast & Seeds', 'Sourdough toast topped with smashed avocado, pumpkin seeds & microgreens.', 240.0, 'Breakfast', true, 'https://images.unsplash.com/photo-1588137378633-dea1336ce1e2?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(9, 'Grilled Chicken Caesar Salad', 'Crispy romaine lettuce, grilled chicken breast, croutons & Caesar dressing.', 310.0, 'Salads', false, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(9, 'Acai Berry Smoothie Bowl', 'Organic acai puree blended with banana, topped with granola & berries.', 290.0, 'Breakfast', true, 'https://images.unsplash.com/photo-1590301157890-4810ed352733?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(9, 'Falafel Wrap with Hummus', 'Crispy chickpea falafels wrapped in pita bread with tahini & pickles.', 230.0, 'Wraps', true, 'https://images.unsplash.com/photo-1509722747041-616f39b57569?auto=format&fit=crop&w=500&q=80', 4.6), " +
            "(9, 'Protein Power Veg Bowl', 'Edamame, tofu, sweet potato, broccoli & brown rice with peanut dressing.', 270.0, 'Main Course', true, 'https://images.unsplash.com/photo-1543339308-43e59d6b73a6?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(9, 'Salmon Avocado Poke Bowl', 'Raw sushi grade salmon, avocado, edamame & sushi rice bowl.', 440.0, 'Main Course', false, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(9, 'Fresh Berry Detox Juice', 'Cold pressed juice with pomegranate, strawberry, beet & mint.', 160.0, 'Beverages', true, 'https://images.unsplash.com/photo-1613478223719-2ab802602423?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(9, 'Roasted Beetroot Salad', 'Roasted beetroot, goat cheese, walnuts & arugula tossed in balsamic glaze.', 260.0, 'Salads', true, 'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?auto=format&fit=crop&w=500&q=80', 4.5), " +
            "(9, 'Chia Seed Pudding', 'Coconut milk chia pudding layered with mango puree & berries.', 180.0, 'Desserts', true, 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?auto=format&fit=crop&w=500&q=80', 4.8)",

            // Restaurant 10: South Flavors Dosa Junction
            "INSERT INTO menu_items (restaurant_id, name, description, price, category, is_veg, image_url, rating) VALUES " +
            "(10, 'Masala Dosa Supreme', 'Crispy golden crepe filled with spiced potato masala served with 3 chutneys.', 140.0, 'Dosa', true, 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(10, 'Mysuru Cheese Masala Dosa', 'Spicy red garlic chutney spread inside dosa loaded with potato & cheese.', 180.0, 'Dosa', true, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(10, 'Rava Onion Dosa', 'Crispy semolina crepe studded with chopped onions, green chilies & cumin.', 160.0, 'Dosa', true, 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(10, 'Steamed Idli Sambar (4 Pcs)', 'Soft pillowy rice cakes served with piping hot piping lentil sambar.', 110.0, 'Breakfast', true, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=500&q=80', 4.8), " +
            "(10, 'Medu Vada (2 Pcs)', 'Crispy savory lentil donuts served with coconut chutney & spicy sambar.', 100.0, 'Breakfast', true, 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(10, 'Ghee Roast Paper Dosa', 'Ultra thin long crispy dosa roasted in pure desi ghee.', 170.0, 'Dosa', true, 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(10, 'Paneer Butter Dosa', 'Dosa stuffed with spiced cottage cheese bhurji served with sambar.', 190.0, 'Dosa', true, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=500&q=80', 4.7), " +
            "(10, 'Hyderabadi Uttapam', 'Thick rice pancake topped with onions, tomatoes & coriander.', 150.0, 'Dosa', true, 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=500&q=80', 4.6), " +
            "(10, 'South Indian Filter Coffee', 'Authentic frothed decoction coffee brewed with milk in brass davara.', 60.0, 'Beverages', true, 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?auto=format&fit=crop&w=500&q=80', 4.9), " +
            "(10, 'Coconut & Rava Halwa', 'Traditional sweet roasted semolina pudding with fresh coconut & cashews.', 110.0, 'Desserts', true, 'https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=500&q=80', 4.8)"
        };

        for (String sql : itemSqls) {
            stmt.executeUpdate(sql);
        }

        System.out.println(">>> FastGo Seed Data Inserted: 10 Restaurants & 100 Menu Items!");
    }
}
