-- Intermediate:

-- 1. Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pt.category, SUM(od.quantity) AS quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category;

-- 2. Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) as hour_of_the_day, COUNT(order_id) as no_of_order
FROM
    orders
GROUP BY HOUR(order_time);

-- 3. Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- 4. Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity), 0) AS avg_pizza_ordered_per_day
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS quantity
    FROM
        orders AS o
    JOIN order_details AS od ON od.order_id = o.order_id
    GROUP BY o.order_date) AS order_quantity;

-- 5. Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.name, ROUND(SUM(p.price * od.quantity), 2) AS revenue
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;
