# PizzaMania Sales Data Analysis using SQL

## Overview

This project presents a thorough analysis of PizzaMania's sales records using SQL. The aim is to uncover business insights and answer key questions using real transactional data. This README details the project's objectives, schema, queries, findings, and strategic conclusions.

## Objectives

- **Quantify Sales Metrics:** Total orders, revenue, and most popular products.
- **Identify Pricing and Product Trends:** Highest-priced items, common sizes, and top-selling pizzas.
- **Analyze Customer Behavior:** Ordering patterns by time, product category, and day.
- **Reveal Revenue Sources:** Contribution by pizza type, category, and top revenue generators.

## Dataset

Pizza sales transaction data is organized into normalized tables:

### Schema

    CREATE TABLE order_details (
      order_details_id INT PRIMARY KEY,
      order_id INT NOT NULL,
      pizza_id TEXT NOT NULL,
      quantity INT NOT NULL
    );

    CREATE TABLE orders (
      order_id INT PRIMARY KEY,
      order_date DATE NOT NULL,
      order_time TIME NOT NULL
    );

    CREATE TABLE pizza_types (
      name TEXT,
      category TEXT,
      ingredients TEXT,
      pizza_type_id TEXT PRIMARY KEY
    );

    CREATE TABLE pizzas (
      pizza_id TEXT PRIMARY KEY,
      pizza_type_id TEXT,
      size TEXT,
      price DOUBLE
    );

## Business Problems and SQL Solutions

### 1. Total Number of Orders Placed

    SELECT count(*) as total_orders FROM orders;

**Objective:** Measures customer purchase volume.

### 2. Total Revenue Generated from Pizza Sales

    SELECT 
      ROUND(SUM(od.quantity * p.price), 2) AS total_sales
    FROM order_details AS od
    JOIN pizzas AS p ON p.pizza_id = od.pizza_id;

**Objective:** Calculates overall revenue.

### 3. Highest-Priced Pizza

    SELECT 
      pt.name, 
      p.price
    FROM pizzas AS p
    JOIN pizza_types AS pt ON pt.pizza_type_id = p.pizza_type_id
    ORDER BY price DESC 
    LIMIT 1;

**Objective:** Identifies premium product.

### 4. Most Common Pizza Size Ordered

    SELECT 
      p.size, 
      COUNT(od.order_details_id) AS order_count
    FROM pizzas AS p
    JOIN order_details AS od ON od.pizza_id = p.pizza_id
    GROUP BY p.size
    ORDER BY order_count DESC;

**Objective:** Reveals customer preference for portion sizes.

### 5. Top 5 Most Ordered Pizza Types with Quantities

    SELECT 
      pt.name, 
      SUM(od.quantity) AS quantity
    FROM pizza_types AS pt
    JOIN pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
    JOIN order_details AS od ON od.pizza_id = p.pizza_id
    GROUP BY pt.name
    ORDER BY quantity DESC 
    LIMIT 5;

**Objective:** Pinpoints top sellers.

### 6. Total Quantity of Each Pizza Category Ordered

    SELECT 
      pt.category, 
      SUM(od.quantity) AS quantity
    FROM pizza_types AS pt
    JOIN pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
    JOIN order_details AS od ON od.pizza_id = p.pizza_id
    GROUP BY pt.category
    ORDER BY quantity DESC;

**Objective:** Provides insight into categorical performance.

### 7. Distribution of Orders by Hour of the Day

    SELECT 
      HOUR(order_time) AS hour, 
      COUNT(order_id) AS order_count
    FROM orders
    GROUP BY HOUR(order_time);

**Objective:** Shows peak operating hours.

### 8. Category-Wise Distribution of Pizzas

    SELECT 
      category, 
      COUNT(name) AS pizza_count
    FROM pizza_types
    GROUP BY category;

**Objective:** Analyzes menu diversity by category.

### 9. Average Number of Pizzas Ordered Per Day

    SELECT 
      ROUND(AVG(quantity), 0) AS avg_order_per_day
    FROM (
      SELECT 
        o.order_date, 
        SUM(od.quantity) AS quantity
      FROM orders AS o
      JOIN order_details AS od ON od.order_id = o.order_id
      GROUP BY o.order_date
    ) AS order_quantity;

**Objective:** Estimates daily demand.

### 10. Top 3 Most Ordered Pizza Types Based on Revenue

    SELECT 
      pt.name, 
      SUM(od.quantity * p.price) AS revenue
    FROM pizza_types AS pt
    JOIN pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
    JOIN order_details AS od ON od.pizza_id = p.pizza_id
    GROUP BY pt.name
    ORDER BY revenue DESC 
    LIMIT 3;

**Objective:** Highlights top revenue drivers.

### 11. Percentage Contribution of Each Pizza Type to Total Revenue

    SELECT 
      pt.category,
      ROUND(SUM(od.quantity * p.price) / (
        SELECT 
          ROUND(SUM(od.quantity * p.price), 2) AS total_sales
        FROM order_details AS od
        JOIN pizzas AS p ON p.pizza_id = od.pizza_id
      ) * 100, 2) AS revenue_percentage
    FROM pizza_types AS pt
    JOIN pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
    JOIN order_details AS od ON od.pizza_id = p.pizza_id
    GROUP BY pt.category
    ORDER BY revenue_percentage DESC;

**Objective:** Assesses which categories contribute the most financially.

### 12. Cumulative Revenue Generated Over Time

    SELECT 
      order_date,
      SUM(revenue) OVER(ORDER BY order_date) AS cumulative_revenue
    FROM (
      SELECT 
        o.order_date,
        SUM(od.quantity * p.price) AS revenue
      FROM order_details AS od
      JOIN pizzas AS p ON p.pizza_id = od.pizza_id
      JOIN orders AS o ON o.order_id = od.order_id
      GROUP BY o.order_date
    ) AS sales;

**Objective:** Tracks revenue accumulation over time.

### 13. Top 3 Most Ordered Pizza Types Based on Revenue for Each Pizza Category

    SELECT 
      name, 
      revenue
    FROM (
      SELECT 
        category, 
        name, 
        revenue,
        RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rn
      FROM (
        SELECT 
          pt.category, 
          pt.name,
          SUM(od.quantity * p.price) AS revenue
        FROM pizza_types AS pt
        JOIN pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
        JOIN order_details AS od ON od.pizza_id = p.pizza_id
        GROUP BY pt.category, pt.name
      ) AS a
    ) AS b 
    WHERE rn <= 3;

**Objective:** Highlights best-sellers by segment.

## Findings and Conclusion

- **Robust Order Volume:** Over 21,000 orders indicate strong brand performance.
- **Revenue Insights:** Total sales and category contributions enable focused marketing.
- **Premium Offerings:** Identification of the highest-priced pizza supports pricing strategies.
- **Customer Preferences:** Medium pizza sizes are the most popular, and a select few pizzas dominate sales.
- **Operational Peaks:** Most orders occur at specific hours, guiding promo and staffing.
- **Product Portfolio:** Clear distribution of pizzas across categories, with findings supporting a variety-driven menu.
- **Profit Focus:** A few pizzas consistently generate majority revenue, informing stock and promotions.
- **Category Revenue Impact:** Financial analysis clarifies which categories drive profitability.
- **Segmentation:** Top pizzas in each category highlight products for specialized campaigns.

This analysis provides a holistic view of PizzaMania's sales performance and informs decisions across operations, marketing, and strategy.

[Project Repository](https://github.com/AnandMukherjee2004/pizzamania_sales-analysis/tree/main)
