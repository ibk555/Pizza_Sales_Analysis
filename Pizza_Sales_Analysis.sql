#checking Columns for null values
SELECT * 
FROM`data model - pizza sales`
where order_id or pizza_id is null;
#No null values for columns order_id and Pizza_id

SELECT * 
FROM`data model - pizza sales`
where quantity or order_date is null;
# No null values for column Quantity and Order_date

SELECT * 
FROM`data model - pizza sales`
where order_date or unit_price is null;
# No null values for columns Order_date and unit_price

SELECT * 
FROM`data model - pizza sales`
where total_price or pizza_size is null;
# No null values for columns total_price and pizza_size

SELECT * 
FROM`data model - pizza sales`
where pizza_category or pizza_ingredients or pizza_name is null;
#No null values for columns pizza_category, pizza_ingredients and pizza_name

#ANALYSIS
# Total Sales and Orders
SELECT sum(quantity) as Quantity, round(sum(total_price)) as Sales
FROM `data model - pizza sales`;

# Pizza Size Sales and Orders
SELECT pizza_size, sum(quantity) as Quantity, round(sum(total_price)) as Sales
FROM `data model - pizza sales`
GROUP BY pizza_size
ORDER BY Sales DESC;
   # Large pizza size sold more than others.
   
# Most Sold Pizza_Category
SELECT pizza_category, sum(quantity) as Quantity, round(sum(total_price)) as Sales
FROM `data model - pizza sales`
GROUP BY pizza_category
ORDER BY Sales DESC;
    #Classic pizza_category sold more.
    
# Top 10 Selling Pizzas
SELECT pizza_name ,round(sum(total_price)) as Sales
FROM `data model - pizza sales`
GROUP BY pizza_name
ORDER BY Sales DESC
LIMIT 10;

# Top 10 selling Pizza_Id
SELECT pizza_id ,round(sum(total_price)) as Sales
FROM `data model - pizza sales`
GROUP BY pizza_id
ORDER BY Sales DESC
LIMIT 10;

#Day with highest Orders and Sales
SELECT Dayname(order_date) as Days ,sum(quantity) as Quantity, round(sum(total_price)) as Sales
FROM `data model - pizza sales`
GROUP BY Days
ORDER BY Sales DESC;
   # Friday got more Sales
   
#month with highest Sales and Orders
SELECT monthname(order_date) as Months ,sum(quantity) as Quantity, round(sum(total_price)) as Sales
FROM `data model - pizza sales`
GROUP BY Months
ORDER BY Sales DESC;
    #July

#Monthly Sales Difference and %monthly increase
WITH monthly_sales as
      (SELECT month(order_date) as months, round(sum(total_price))as Sales
       FROM `data model - pizza sales`
       GROUP BY months)
 SELECT *,
    Lag(Sales) OVER(ORDER BY months) AS Previous_Month_Sales,
    Sales-Lag(Sales) OVER(ORDER BY months) AS Monthly_Sales_Difference
    round((Sales-Lag(Sales) OVER(ORDER BY months))/(Lag(Sales) OVER(ORDER BY months))*100,2) As Percent_monthly_increase
 FROM monthly_sales;   
    
   
# Avearge monthly Sales and months that got higher.
WITH monthly_sales AS
     (SELECT month(order_date) as months,
       round(sum(total_price))as Sales
       FROM `data model - pizza sales`
       GROUP BY months)
SELECT *
FROM monthly_sales m
JOIN(SELECT avg(Sales) AS Avg_Sales 
     FROM monthly_sales)a
 on m.sales> a.Avg_Sales;
     # months of Jan, Mar, Apr, May, Jun, Jul, Aug, Nov got higher than average monthly Sales

# month_to_month sales
WITH monthly_sales AS
     (SELECT month(order_date) as months,
       round(sum(total_price))as Sales
       FROM `data model - pizza sales`
       GROUP BY months)
       
       Select months, sales,
       sum(sales) over(order by months) as Month_to_month
       from monthly_sales
     
	
	     

#Sales and Orders By Season
WITH Seasons As
      (SELECT *,
        CASE
        WHEN month(order_date) in (12, 1 ,2) THEN 'Winter'
        WHEN month(order_date) in (3, 4, 5) THEN  'Spring'
        WHEN month(order_date) in (6, 7, 8) THEN  'Summer'
        WHEN month(order_date) in (9, 10, 11) THEN 'Autumn'
	    END As 'Season'
        FROM `data model - pizza sales`)
 SELECT Season, round(sum(total_price)) AS Sales, sum(quantity) As Quantity
 FROM Seasons
 GROUP BY Season
 ORDER BY Sales DESC
     #Spring generated the highest Sales.




    
