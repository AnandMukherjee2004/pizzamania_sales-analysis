```markdown
# PizzaMania Sales Data Analysis using SQL

## Overview

This project presents a thorough analysis of PizzaMania’s sales records using SQL. The aim is to uncover business insights and answer key questions using real transactional data. This README details the project's objectives, schema, queries, findings, and strategic conclusions.

---

## Objectives

- **Quantify Sales Metrics:** Total orders, revenue, and most popular products.
- **Identify Pricing and Product Trends:** Highest-priced items, common sizes, and top-selling pizzas.
- **Analyze Customer Behavior:** Ordering patterns by time, product category, and day.
- **Reveal Revenue Sources:** Contribution by pizza type, category, and top revenue generators.

---

## Dataset

Pizza sales transaction data is organized into normalized tables:

### Schema

```
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
```

---

## Business Problems and SQL Solutions

### 1. Total Number of Orders Placed

```
SELECT count(*) as total_orders FROM orders;
```
**Objective:** Measures customer purchase volume.

### 2. Total Revenue Generated from Pizza Sales

```
SELECT 
  ROUND(SUM(od.quantity * p.price), 2) AS total_sales
FROM 
  order_details AS od
  JOIN pizzas AS p ON od.pizza_id = p.pizza_id;
```
**Objective:** Calculates gross sales.

### 3. Highest-Priced Pizza

```
SELECT 
  pizza_types.name, pizzas.price
FROM 
  pizza_types
  JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;
```
**Objective:** Reveals luxury or premium offerings.

### 4. Most Common Pizza Size Ordered

```
SELECT 
  size as most_common_size, COUNT(od.order_details_id) AS quantity_ordered
FROM 
  order_details AS od
  JOIN pizzas AS p ON od.pizza_id = p.pizza_id
GROUP BY size
ORDER BY COUNT(od.order_details_id) DESC
LIMIT 1;
```
**Objective:** Guides inventory and serving strategies.

### 5. Top 5 Most Ordered Pizza Types

```
SELECT 
  pt.name, SUM(od.quantity) AS quantities
FROM 
  pizza_types AS pt
  JOIN pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
  JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY quantities DESC
LIMIT 5;
```
**Objective:** Locates high-demand products.

---

## Intermediate Analytics

### 1. Total Quantity of Each Pizza Category Ordered

```
SELECT 
  pt.category, SUM(od.quantity) AS quantity
FROM 
  pizza_types AS pt
  JOIN pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
  JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category;
```
**Objective:** Insights for category-level performance.

### 2. Distribution of Orders by Hour

```
SELECT 
  HOUR(order_time) as hour_of_the_day, COUNT(order_id) as no_of_order
FROM 
  orders
GROUP BY HOUR(order_time);
```
**Objective:** Uncovers peak business hours.

### 3. Category-wise Pizza Distribution

```
SELECT 
  category, COUNT(name)
FROM 
  pizza_types
GROUP BY category;
```
**Objective:** Portfolio balance (variety in categories).

### 4. Average Pizzas Ordered Per Day

```
SELECT 
  ROUND(AVG(quantity), 0) AS avg_pizza_ordered_per_day
FROM (
  SELECT 
    o.order_date, SUM(od.quantity) AS quantity
  FROM 
    orders AS o
    JOIN order_details AS od ON od.order_id = o.order_id
  GROUP BY o.order_date
) AS order_quantity;
```
**Objective:** Daily planning and forecasting.

### 5. Top 3 Most Ordered Pizza Types by Revenue

```
SELECT 
  pt.name, ROUND(SUM(p.price * od.quantity), 2) AS revenue
FROM 
  pizza_types AS pt
  JOIN pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
  JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;
```
**Objective:** Maximizes profit focus.

---

## Advanced Analysis

### 1. Revenue Percentage Contribution by Pizza Category

```
SELECT 
  pt.category,
  ROUND(SUM(od.quantity * p.price) / (SELECT ROUND(SUM(od.quantity * p.price), 2)
  FROM order_details AS od
  JOIN pizzas AS p ON od.pizza_id = p.pizza_id), 2) * 100 as revenue_percent
FROM 
  pizza_types AS pt
  JOIN pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
  JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category;
```
**Objective:** Ranks categories by financial impact.

### 2. Top 3 Most Ordered Pizza Types by Revenue For Each Category

```
SELECT category, name, revenue 
FROM (
  SELECT category, name, revenue,
    rank() over(partition by category order by revenue desc) as rn
  FROM (
    SELECT 
      pt.category, pt.name, SUM(p.price * od.quantity) AS revenue
    FROM 
      pizza_types AS pt
      JOIN pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
      JOIN order_details AS od ON od.pizza_id = p.pizza_id
    GROUP BY pt.category , pt.name
  ) as a
) as b 
WHERE rn <= 3
```
**Objective:** Highlights best-sellers by segment.

---

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

This analysis provides a holistic view of PizzaMania’s sales performance and informs decisions across operations, marketing, and strategy.
```

[1](https://github.com/AnandMukherjee2004/pizzamania_sales-analysis/tree/main)
