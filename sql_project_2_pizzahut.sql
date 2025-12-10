create database Pizzahut;
use pizzahut;

select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;

--- Basic:
--- 1 Retrieve the total number of orders placed.
	  select count(order_id) from orders;

--- 2 Calculate the total revenue generated from pizza sales.
     select sum(od.quantity * p.price) as total_revenue
    from order_details od
    join pizzas p
    on od.pizza_id = p.pizza_id;

	
--- 3 Identify the highest-priced pizza.
      SELECT 
       pizza_types.name, pizzas.price
	    FROM
        pizza_types
        JOIN
         pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        ORDER BY pizzas.price DESC
      LIMIT 3;

--- 4 Identify the most common pizza size ordered.
       select pizzas.size, count(order_details.order_details_id) as order_count
       from pizzas 
       join order_details
       on pizzas.pizza_id = order_details.pizza_id
       group by pizzas.size 
       order by order_count desc;
       
       
--- 5 List the top 5 most ordered pizza types along with their quantities.
      
      select pizza_types.name,sum( order_details.quantity) as quantity
      from pizza_types 
      join pizzas
      on pizza_types.pizza_type_id = pizzas.pizza_type_id
      join order_details
      on order_details.pizza_id = pizzas.pizza_id
      group by pizza_types.name
      order by quantity desc limit 5;


Intermediate:
--- 6 Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category,sum(od.quantity) as quantity
from pizza_types pt
join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od
on od.pizza_id = p.pizza_id
group by pt.category
order by quantity desc;

--- 7 Determine the distribution of orders by hour of the day.
      select hour(orders.time) as order_hour,
      count(order_id) as order_count
      from orders
      group by hour(orders.time)
      order by order_hour;

--- 8 Join relevant tables to find the category-wise distribution of pizzas.
       use pizzahut;
select pt.category, count(p.pizza_id) as total_pizzas
from pizza_types pt
join pizzas p
on pt.pizza_type_id = p.pizza_type_id
group by pt.category
order by total_pizzas desc;


--- 9 Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    AVG(daily_pizzas) AS avg_pizzas_per_day
FROM (
    SELECT 
        DATE(o.date) AS order_date,
        SUM(od.quantity) AS daily_pizzas
    FROM orders o
    JOIN order_details od 
        ON o.order_id = od.order_id
    GROUP BY DATE(o.date)
) t;



--- 10 Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pt.name AS pizza_type,
    SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt 
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;


--- Advanced:
--- 11 Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pt.name AS pizza_type,
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue,
    ROUND(
        (SUM(od.quantity * p.price) / 
        (SELECT SUM(od2.quantity * p2.price)
         FROM order_details od2
         JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id)
        ) * 100, 2
    ) AS revenue_percentage
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt 
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue_percentage DESC;


--- 12 Analyze the cumulative revenue generated over time.
SELECT 
    DATE(o.date) AS order_date,
    ROUND(SUM(od.quantity * p.price), 2) AS daily_revenue,
    ROUND(SUM(SUM(od.quantity * p.price)) 
          OVER (ORDER BY DATE(o.date)), 2) AS cumulative_revenue
FROM orders o
JOIN order_details od 
    ON o.order_id = od.order_id
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
GROUP BY DATE(o.date)
ORDER BY order_date;

--- 13 Determine the top 3 most ordered pizza types based on revenue for each pizza category.

WITH revenue_by_pizza AS (
    SELECT 
        pt.category,
        pt.name AS pizza_type,
        ROUND(SUM(od.quantity * p.price), 2) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY pt.category 
            ORDER BY SUM(od.quantity * p.price) DESC
        ) AS rn
    FROM order_details od
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt 
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
)
SELECT category, pizza_type, total_revenue
FROM revenue_by_pizza
WHERE rn <= 3
ORDER BY category, total_revenue DESC;

