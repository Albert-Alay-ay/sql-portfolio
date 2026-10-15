-- select * from stg_categories sc ;
-- select * from stg_products sp ;
-- select * from stg_order_items soi ;
-- select * from stg_payments sp ;
-- select MAX(order_date ) from stg_orders;


with RevQty6mo as (
	select sc.category_name, SUM(soi.line_total) as total_amt, SUM(soi.quantity) as total_units_sold
	from stg_order_items soi
	join stg_products sp on sp.product_id = soi.product_id 
	join stg_categories sc  on sc.category_id  = sp.category_id 
	join stg_payments sp2 on sp2.order_id = soi.order_id 
	join stg_orders so  on so.or
	where 
	and lower(sp2.payment_status) = 'completed'
	group by sc.category_name
	order by SUM(soi.quantity) desc
)
select * from RevQty6mo
where total_amt > '100000';