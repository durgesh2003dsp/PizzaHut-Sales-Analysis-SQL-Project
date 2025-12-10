PizzaHut Sales Analysis – SQL Project
A complete SQL case study analyzing PizzaHut's sales performance, customer ordering patterns, revenue metrics, and product insights using relational database queries from basic to advanced SQL.
---


##  **Project Overview**

This project explores a pizza store dataset using SQL to answer business-critical questions such as:

* Total orders and revenue
* Best-selling pizzas
* Size and category trends
* Hour-wise ordering behavior
* Revenue contribution by pizza types
* Cumulative revenue over time
* Category-wise top revenue-generating pizzas

The project includes **Basic, Intermediate, and Advanced SQL queries** showcasing joins, aggregations, window functions, subqueries, and CTEs.

---

##  **Database & Tables Used**

* **orders** – order timestamps
* **order_details** – quantity of each pizza ordered
* **pizzas** – pizza ID, size, price
* **pizza_types** – category, name, ingredients

---

#  **Section 1 — Basic SQL Analysis**

###  **1. Total number of orders placed**

```sql
SELECT COUNT(order_id) FROM orders;
```

###  **2. Total revenue generated**

```sql
SELECT SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;
```

###  **3. Highest-priced pizza**

Ranks pizzas by price in descending order.

###  **4. Most common pizza size ordered**

Counts orders grouped by pizza size.

###  **5. Top 5 most-ordered pizza types**

Based on total quantity sold.

---

#  **Section 2 — Intermediate SQL Analysis**

###  **6. Total quantity ordered by pizza category**

```sql
SELECT pt.category, SUM(od.quantity) AS quantity
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY quantity DESC;
```

###  **7. Order distribution by hour**

Identifies peak ordering times.

###  **8. Category-wise pizza count**

Shows how many pizza types exist in each category.

###  **9. Average number of pizzas ordered per day**

Uses subquery + group by date.

###  **10. Top 3 pizzas by revenue**

Ranks pizza types based on revenue.

---

#  **Section 3 — Advanced SQL Analysis**

###  **11. Revenue contribution (%) of each pizza type**

Calculates revenue share for each pizza type.

###  **12. Cumulative revenue over time**

```sql
SELECT 
    DATE(o.date) AS order_date,
    SUM(od.quantity * p.price) AS daily_revenue,
    SUM(SUM(od.quantity * p.price)) 
        OVER (ORDER BY DATE(o.date)) AS cumulative_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY DATE(o.date);
```

###  **13. Category-wise Top 3 pizzas by revenue**

Uses a CTE + window functions (ROW_NUMBER).

---

#  **Key Insights & Findings**

* **Classic & Supreme pizzas** generate the highest revenue.
* **Large size pizzas** are the most frequently ordered.
* Peak ordering hours occur around **12 PM – 2 PM** and **7 PM – 9 PM**.
* A few high-priced pizzas contribute significantly to total revenue.
* Cumulative revenue increases steadily, indicating consistent business performance.
* In each category, the **top 3 pizzas** contribute the majority of revenue.

---

