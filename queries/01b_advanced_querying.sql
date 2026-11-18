


with RevQty6mo as (
	with maxorderdate as (
		select MAX(order_date) as mval from stg_orders
	)
	select sc.category_name, SUM(soi.line_total) as total_amt, SUM(soi.quantity) as total_units_sold
	from maxorderdate, stg_order_items soi
	join stg_products sp on sp.product_id = soi.product_id 
	join stg_categories sc  on sc.category_id  = sp.category_id 
	join stg_payments sp2 on sp2.order_id = soi.order_id 
	join stg_orders so  on so.order_id = soi.order_id
	where lower(sp2.payment_status) = 'completed'
	and so.order_date >= (maxorderdate.mval - INTERVAL '12 months')
	group by sc.category_name
	order by SUM(soi.quantity) desc
)
select * from RevQty6mo
where total_amt > 10000;


----------------------------------------------------------------------------------

with total_perCX_perMO as (
select cx.customer_id, CONCAT(CONCAT(cx.last_name, ', '), cx.first_name) as cx_name,  DATE_TRUNC('month', order_date) AS months, o.total_amount as month_total
from stg_customers as cx
join stg_orders	 as o on o.customer_id = cx.customer_id
join stg_payments as sp on sp.order_id = o.order_id
where EXTRACT("YEAR" from O.ORDER_DATE) = '2024'
and LOWER(SP.PAYMENT_STATUS) = 'completed'
group by months, cx.customer_id, o.total_amount
order by months, month_total desc)
select cx_name,  months,  month_total 
from total_perCX_perMO t1 
where (
	select COUNT(*) 
	from total_perCX_perMO t2
	where t2.months = t1.months 
	and (t2.month_total > t1.month_total or (t2.month_total = t1.month_total and t2.cx_name = t1.cx_name))
) < 4;
