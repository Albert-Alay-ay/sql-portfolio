


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