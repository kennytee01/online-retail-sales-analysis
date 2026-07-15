CREATE TABLE online_retail (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(30),
    Description TEXT,
    Quantity INT,
    InvoiceDate TIMESTAMP,
    UnitPrice NUMERIC(10,2),
    CustomerID INT,
    Country VARCHAR(100)
);


-- DATA CLEANING
select count(*) as Total_Rows from online_retail;
-- i have 541,909 of data
-- i have 8 column

select * from online_retail;

-- Missing Data
select count (*) as total_rows,  count(*) filter (where InvoiceNo is null) as missing_InvoiceNo,
count(*) filter (where Stockcode is null) as missing_Stockcode, 
count(*) filter (where Description is null) as missing_Description,
count(*) filter (where Quantity is null) as missing_Quantity,
count(*) filter (where InvoiceDate is null) as missing_InvoiceDate,
count(*) filter (where UnitPrice is null) as missing_UnitPrice,
count(*) filter (where CustomerID is null) as missing_CustomerID,
count(*) filter (where Country is null) as missing_Country
from online_retail;
-- Description have 1454 missing description
-- customerid have 135080 missing ID
select * from online_retail where description is null;

select * from online_retail where customerid is null;
-- i have 133581 and all of them are from UK

-- removing missing values
delete from online_retail where description is null and unitprice = 0;

Select Count(*) as New_Total_Rows from Online_retail;

-- checking for duplicates
 select invoiceno, stockcode, description, quantity, invoicedate, unitprice, customerid, country,
 count (*) as dulpicate_count from online_retail
 group by invoiceno, stockcode, description, quantity, invoicedate, unitprice, customerid, country
 having count (*) > 1;

delete from online_retail
where ctid in ( select ctid from (
select ctid, row_number() over(
partition by invoiceno, stockcode, description, quantity, invoicedate, unitprice, customerid, country
order by ctid )
 as rn from online_retail )t where rn > 1 );

-- i have 4879 records of duplicate
-- some repeated twice, some thrice and some four times
--duplicates are removed



-- negative quantities check

select count(*) as negative_quantity_count from online_retail where quantity < 0;
-- i have 9762 negative

select * from online_retail where quantity < 0;
-- all the 9762 negative quantity are cancelled product, they have "C" at the beginning of thier invoiceno, 
-- except one that is not cancelled but the description there is " stock creditted wrongly and the customerid is null"
-- but they have valid unit price while some have zero
-- some of the customerid is  null

--CHECK FOR ZERO AND NEGATIVE UNIT PRICE

SELECT COUNT(*) AS Zero_or_negative_unit_price from online_retail where unitprice <= 0; 
-- i have 1067 ZERO AND NEGATIVE UNIT PRICE
select * from online_retail where unitprice <= 0;
-- majority of them have their cusromerid null and some of their quantity number zero


select case when unitprice < 0 then 'negative Price'
when unitprice = 0 then 'zero price' end as price_type,
count(*) as record_count from online_retail where unitprice < 0
group by price_type ;

select count (*) as zero_price from online_retail
where unitprice = 0 ;

select count (*) as negative_price from online_retail
where unitprice < 0 ;

delete from online_retail where unitprice < 0 ;
-- negative price removed


-- CHECK CANCELLED INVOICES
select Count(*) as cancelled_transactions from online_retail where invoiceno like 'C%';
-- i have 9288 records

-- CHECKING DATE RANGE
select min(invoicedate) as first_transaction, max(invoicedate) as last_transaction
from online_retail;
-- first transaction is "2010-12-01 08:26:00"
--the last transaction is "2011-12-09 12:50:00"
-- that's 1 year AND 8 days

-- Checking Countries
select country, count(*) as country_transactions from online_retail
group by country order by country desc;
-- there are 37 countries with data and one with unspecified with data as well

-- GENERAL NUMERICAL DESCRIPTIVE STATISTICS
-FOR QUANTITY
select  round(avg(quantity), 2) as mean,
percentile_cont(0.5) within group (order by quantity) as median,
 min(quantity) as minimum, max(quantity) as maximum,
 round(stddev(quantity), 2) as standard_deviation from online_retail ;

 -- FOR UNITPRICE
 select  round(avg(UNITPRICE), 2) as mean,
percentile_cont(0.5) within group (order by UNITPRICE) as median,
 min(UNITPRICE) as minimum, max(UNITPRICE) as maximum,
 round(stddev(UNITPRICE), 2) as standard_deviation from online_retail ;
