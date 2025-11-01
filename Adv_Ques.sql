-- Advanced:

-- 1. Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.category,
    ROUND(SUM(od.quantity * p.price) / (SELECT 
                    ROUND(SUM(od.quantity * p.price), 2) AS total_sales
                FROM
                    order_details AS od
                        JOIN
                    pizzas AS p ON od.pizza_id = p.pizza_id),
            2) * 100 as revenue_percent
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category;

-- 2. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category, name, revenue from(select category, name, revenue, 
rank() over(partition by category order by revenue desc) as rn from (SELECT 
    pt.category, pt.name, SUM(p.price * od.quantity) AS revenue
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category , pt.name) as a) as b 
where rn <= 3