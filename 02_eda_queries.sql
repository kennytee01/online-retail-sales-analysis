-- TOTAL REVENUE
select round(sum(quantity * unitprice), 2) as Total_Revenue
from online_retail where quantity > 0 and unitprice > 0;

-- TOTAL ORDER
select count(distinct invoiceno) as Total_Orders from online_retail
where invoiceno not like 'C%' ;

-- TOTAL CUSTOMERS
select count(distinct customerid) as Total_Customers from online_retail
where customerid is not null;

-- Top 10 products by revenue
 select description, round(sum(quantity), 2) as revenue
 from online_retail where quantity > 0
 group by description 
 order by revenue desc
 limit 10;

 -- TOP 10 PRODUCTS BY QUANTITY SOLD
  Select description, sum(quantity) as Total_Quantity from online_retail
  where quantity > 0
  group by description
  order by Total_Quantity desc
  limit 10 ;

  -- MONTHLY SALES TREND
  select date_trunc('month', invoicedate) as Month, round(sum(quantity * unitprice), 2) as revenue
from online_retail where quantity > 0
group by month
order by month;

--  REVENUE  BY COUNTRY
select country, round(sum(quantity * unitprice), 2) as revenue
from online_retail where quantity > 0
group by country
order by revenue desc;

--  TOP 10 CUSTOMERS BY REVENUE
select customerid, round(sum(quantity * unitprice), 2) as revenue
from online_retail where customerid is not null and quantity > 0 
group by customerid
order by revenue desc
limit 10;

-- CANCELLATION RATE
select count(*) filter (where invoiceno like 'C%') as Cancelled_Orders, 
count (*) filter (where invoiceno not like 'C%') as Completed_Orders
from online_retail;

-- AVERAGE ORDER VALUE
 select round(sum(quantity * unitprice) / count(distinct invoiceno), 2)
 as Average_Order_Value from online_retail where quantity > 0;
