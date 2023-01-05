create database Project
use project
select * from login_logs;
select * from sales_orders;
select * from sales_orders_items;


exec sp_rename 'sales_orders.fk_depot_id','depot_id','column';
exec sp_rename 'sales_orders.fk_buyer_id','buyer_id','column';
exec sp_rename 'sales_orders_items.fk_product_id','product_id', 'column';
exec sp_rename 'sales_orders_items.fk_order_id','order_id', 'column';

           -- Create New columns Login_Time & Login Date

select login_log_id,user_id, convert(date,[login_time]) as login_Date,
CONVERT(varchar(15),  CAST(login_time AS TIME), 100) as login_Time1 from login_logs;

 -- View--
create view login_new as select login_log_id,user_id, convert(date,[login_time]) as login_Date,
CONVERT(varchar(15),  CAST(login_time AS TIME), 100) as login_Time1 from login_logs;


select * from login_new;

--Question 1. Make a dataset (Using SQL) named �daily_logins� which contains the number of logins on a daily basis
select login_date, count(login_log_id) as Number_of_logins 
from login_new
group by login_Date
order by login_Date;

-- Question 2. Daily trend of logins and trend of conversion rate (Number of orders placed per login)



create view number_of_login as 
select user_id,count(login_log_id) as Number_of_login from login_new group by user_id;

create view number_of_orders as 
select buyer_id,count(order_id) as Number_of_order from sales_orders group by buyer_id;


select * from number_of_login;
select * from number_of_orders;

select a.buyer_id,b.Number_of_login,a.Number_of_order from number_of_orders as a
join number_of_login as b on  a.buyer_id=b.user_id;


--Question 4. What are our top-selling products in each of the two years?
--Can you draw some insight from this?

create view sales_order_details_new as
select a.order_id,a.buyer_id,b.order_item_id,b.product_id,b.ordered_quantity,b.order_quantity_accepted,a.depot_id,a.sales_order_status,
convert(date,[creation_time]) as [creation_Date],CONVERT(varchar(15),  CAST(creation_time AS TIME), 100) as [creation_Time1],
b.rate from sales_orders as a left join sales_orders_items as b on a.order_id=b.order_id ;

select * from sales_order_details_new
---2021
select top 1 year(creation_Date) as Years,product_id,count(product_id) as number_of_selling_product
from sales_order_details_new
group by year(creation_Date),product_id
having year(creation_Date)=2021
order by number_of_selling_product desc;
--2022
select top 1 year(creation_Date) as Years,product_id,count(product_id) as number_of_selling_product
from sales_order_details_new
group by year(creation_Date),product_id
having year(creation_Date)=2022
order by number_of_selling_product desc;

	

select * from sales_order_details_new;
select login_log_id,user_id,day(login_Date)as Date,month(login_Date)as Month,year(login_Date)as year,login_Time1 from login_new;
 
select distinct login_new.user_id, day(login_Date),month(login_Date),year(login_Date),count(login_log_id) 
from login_new group by login_log_id;



select * from sales_order_details_new