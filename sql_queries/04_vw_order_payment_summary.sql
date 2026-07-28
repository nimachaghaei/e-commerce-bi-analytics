create or alter view v_order_financials as 
select 
	o.order_id,
	o.customer_id,
	o.order_status,
	o.order_purchase_timestamp,
	pay.total_order_value,
	pay.payment_method_group
from dbo.olist_orders_dataset as o
inner join(
	select order_id,
		SUM(payment_value)as total_order_value,
		case
			when max(payment_installments)>1 then 'Installments'
			else 'Cash'
		end as payment_method_group
	from dbo.olist_order_payments_dataset
	group by order_id
	) pay on o.order_id = pay.order_id