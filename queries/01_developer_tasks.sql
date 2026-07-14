

-- Activity 1: Queries run against staging tables (stg_ prefix).
-- Data has not yet been cleaned or migrated to production.







-- Task 1: List all active products with category and brand
-- Requested by: Operations Manager
-- Date: 2026-07-13

select * from stg_products where is_active = true;


-- Task 2: List top 20 high value customers by the total amount of all their delivered orders.
-- Requested by: Marketing Manager
-- Date: 2026-07-13

select CONCAT(CONCAT(c.first_name, ' '), c.last_name) as customer_name, c.email, c.city, SUM(o.total_amount) as total_spend 
from stg_customers c
join stg_orders o on o.customer_id = c.customer_id
group by c.customer_id
order by total_spend desc
limit 20;



-- Task 3: List the monthly sales summary across the last 12 months of data.
-- Requested by: Finance Manager
-- Date: 2026-07-13

select EXTRACT(year from o.order_date) as oyear, EXTRACT(month from o.order_date) as omonth, count(o.*) as orders_per_mo, sum(o.total_amount) as total_revenue_per_mo, ROUND(avg(o.total_amount), 2) as avg_order_val_per_mo 
from stg_orders o
where o.order_date >= (select MAX(order_date) - interval '12 month' from stg_orders) 
and o.order_status != 'Cancelled'
group by oyear, omonth
order by oyear desc, omonth desc; --i have to include year cause there's DEC2024 and DEC2023

/*
select EXTRACT(year from o.order_date) as  oyear, EXTRACT(month from o.order_date) as omonth, count(o.*), sum(o.total_amount) as total_revenue, avg(o.total_amount) from stg_orders o
where o.order_date between now() - interval '36 month' and now()
group by oyear, omonth
order by oyear desc, omonth desc;
*/


-- Task 4: List the products with low inventory (<= reorder point)
-- Requested by: Warehouse Manager
-- Date: 2026-07-13

select sp.product_name, sp.brand, si.quantity_on_hand current_stock, si.reorder_point 
from stg_products sp join stg_inventory si on si.product_id = sp.product_id 
where si.quantity_on_hand <= si.reorder_point;

-- Task 5: List all orders with no payment records.
-- Requested by: Finance Manager
-- Date: 2026-07-13

select so.order_id, CONCAT(CONCAT(sc.first_name, ''), sc.last_name) as CUSTOMER_NAME,  so.order_date, so.total_amount 
from stg_customers sc join stg_orders so on so.customer_id = sc.customer_id 
where so.order_id not in (select distinct sp.order_id from stg_payments sp );


-- Task 6: Show the breakdown of revenue with total items sold by product category
-- Requested by: Business Analyst
-- Date: 2026-07-13

select sc.category_name, sum(soi.quantity) as total_items_sold, sum(soi.line_total) as total_revenue, ROUND(avg(soi.line_total / soi.quantity ), 2) as average_selling_price
from stg_categories sc 
join stg_products sp on sp.category_id = sc.category_id  
join stg_order_items soi on soi.product_id = sp.product_id 
group by sc.category_name 
order by total_revenue desc;


-- Task 7: List the customers who return the product frequently
-- Requested by: Customer Experience Manager
-- Date: 2026-07-13

select CONCAT(sc.first_name, CONCAT(' ', sc.last_name)) as customer_name, sc.email, COUNT(sr.return_id) as returns,  sc.customer_segment 
from stg_customers sc 
join stg_orders so on so.customer_id = sc.customer_id 
join stg_order_items soi on soi.order_id = so.order_id
join stg_returns sr on sr.order_item_id = soi.order_item_id
group by customer_name, sc.email, sc.customer_segment
having COUNT(sr.return_id)> 2;