select * from products;
select * from reorders;
select * from shipments;
select * from stock_entries;
select * from suppliers;

-- 1. Total Suppliers
select count(*) as total_supplies from suppliers;

-- 2. Total Products
select count(*) as total_products from products;

-- 3. Total Categories Dealing
select count(distinct category) as total_categories from products;

-- 4. Total sales values made in last three months
select round(sum(abs(se.change_quantity)*p.price),2) as total_sales_values_in_last_three_months
from stock_entries as se
join products p
on p.product_id=se.product_id
where se.change_type='Sale'
and
se.entry_date>=
	(
		select date_sub(max(entry_date), interval 3 month) from stock_entries
    );

-- 5. Total restock values made in last three months
select round(sum(abs(se.change_quantity)*p.price),2) as total_restock_values_in_last_three_months
from stock_entries as se
join products p
on p.product_id=se.product_id
where se.change_type='Restock'
and
se.entry_date>=
	(
		select date_sub(max(entry_date), interval 3 month) from stock_entries
    );

-- 6. 
select count(*) from products as p where p.stock_quantity<p.reorder_level
and product_id NOT IN 
(
	select distinct product_id from reorders where status='Pending'
);