package com.rohith.fastgo.model;

public class Restaurant {
    private int id;
    private String name;
    private String description;
    private String cuisine;
    private double rating;
    private String deliveryTime;
    private int priceForTwo;
    private String address;
    private String imageUrl;
    private boolean active;

    public Restaurant() {}

    public Restaurant(int id, String name, String description, String cuisine, double rating, String deliveryTime, int priceForTwo, String address, String imageUrl, boolean active) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.cuisine = cuisine;
        this.rating = rating;
        this.deliveryTime = deliveryTime;
        this.priceForTwo = priceForTwo;
        this.address = address;
        this.imageUrl = imageUrl;
        this.active = active;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCuisine() { return cuisine; }
    public void setCuisine(String cuisine) { this.cuisine = cuisine; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getDeliveryTime() { return deliveryTime; }
    public void setDeliveryTime(String deliveryTime) { this.deliveryTime = deliveryTime; }

    public int getPriceForTwo() { return priceForTwo; }
    public void setPriceForTwo(int priceForTwo) { this.priceForTwo = priceForTwo; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
