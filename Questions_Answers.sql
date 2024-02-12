--All questions are given below with their answers for this case study

--1. Find customers who have never ordered
--2. Find  Average Price of every dish
--3. Find the top restaurant in terms of the number of orders from May to July month
--4. Find restaurants with monthly sales greater than 1000 for july month
--5. Show all orders with order details for a customer named “Ankit” in “July” month
--6. Find restaurants with max repeated customers
--7. Month over month revenue growth of uber
--8. Find every Customer - favorite food


--1. Find customers who have never ordered

select user_id,name from uber.users
where
 user_id  not in (select user_id from uber.orders )
;



--2.Find  Average Price of every dish

SELECT F.f_id,
 f_name as Food,
avg(price) as Avg_Price 
from uber.menu M
join uber.food F
on M.f_id=F.f_id
group by f_id, F_name
;



--3. Find the top restaurant in terms of the number of orders from May to July month

select O.r_id ,
r_name,
count(order_id) as total_order
from uber.orders O
join uber.restau R
on O.r_id=R.r_id
where date between "2022-05-01" and "2022-07-31"
group by O.r_id, r_name
order by  total_order desc
;



--4. Find restaurants with monthly sales greater than 1000 for july month

select r_id,
sum(amount) as revenue
from uber.orders
where monthname(date) like "july"
group by r_id
having revenue>1000
;



--5. Show all orders with order details for a customer named “Ankit” in “July” month

select 

name,
f_name as dish,
monthname(date) as Month_,
price 

from uber.orders O
join uber.users u
on u.user_id=o.user_id
join uber.details D
on o.order_id=d.order_id
join uber.food as F
on F.f_id =D.f_id
join uber.menu as M
on M.f_id=F.f_id
where name="ankit" and monthname(date) ="july"
group by name,dish,Month_,price
;



--6. Find restaurants with max repeated customers

select * from (
select r_name,
 name,
 count(*) as Number_of_orders,
 rank() over(partition by r_name order by  count(*) desc) as rank_
from uber.orders  O
join uber.restau R
on R.r_id=O.r_id
join uber.users U
on U.user_id=O.user_id
group by r_name,name
order by r_name,name
) t1
where rank_=1
;



--7. Month over month revenue growth of uber

select month,
 
 concat(round(((revenue-old)/old)*100,2),'%') as growth_rate
 from
(
with sales as
(
select 
monthname(date) as Month,
sum(amount) as revenue
from uber.orders
group by month
)
select month, revenue,lag(revenue,1) over (order by revenue) as old from sales
) as temp
;



--8. Find every Customer - favorite food

with temp as (
select 
name,
f_name as Food,
count(f_name) as total_order
from uber.users U
join uber.orders O
on u.user_id=o.user_id
join uber.details D
on D.order_id=o.order_id
join uber.food as F
on d.f_id=f.f_id
group by food,name

order by name desc
) 
select * from temp as t1
where total_order=(select max(total_order) from temp as t2
where t1.name=t2.name)
;



