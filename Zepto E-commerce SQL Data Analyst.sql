DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto(
	sku_id SERIAL PRIMARY KEY,
	category VARCHAR(120),
	name VARCHAR(150) NOT NULL,
	mrp NUMERIC(8,2),
	discountPercent NUMERIC(5,2),
	availableQuantity INTEGER,
	discountedSellingPrice NUMERIC(8,2),
	weightInGms INTEGER,
	outOfStock BOOLEAN,
	quantity INTEGER
	);
 -- DATA EXPLORATION 

 -- COUNT THE ROWS
 SELECT COUNT(*) FROM zepto;



 -- SAMPLE DATA
 SELECT * FROM zepto
 LIMIT 10;
 
 -- NULL VALUE
 
 SELECT * FROM zepto
 WHERE name IS NULL 
 OR
 category IS NULL
 OR
 mrp IS NULL
 OR 
 discountpercent IS NULL
 OR
 discountedsellingprice IS NULL
 OR
 weightInGms IS NULL
 OR
 outOfStock IS NULL
 OR
 quantity IS NULL;

 -- DIFFERENT PRODUCT CATEGORIES

 SELECT DISTINCT category
 FROM zepto
 ORDER BY category;

 -- PRODUCTS IN STOCK VS OUT OF STOCK

 SELECT outOfStock ,COUNT(sku_id)
 FROM zepto
 GROUP BY outOfStock;

 -- PRODUCT NAMES PRESENT MULTIPLE TIMES
 SELECT name, COUNT(sku_id) as "Number of SKUs"
 FROM zepto 
 GROUP BY name 
 HAVING count(sku_id) > 1
 ORDER BY count(sku_id) DESC;

 -- DATA CLEANING 
 -- PRODUCTS WITH PRICE = 0
 SELECT * FROM zepto;
 WHERE mrp = 0 OR discountedSellingPrice = 0;
 
 DELETE FROM zepto
 WHERE mrp = 0;

 -- CONVERT PAISE TO RUPEES
 UPDATE zepto
 SET mrp = mrp/100.0,
 discountedSellingPrice = discountedSellingPrice/100.0; 

 SELECT mrp,discountedSellingPrice FROM zepto

 -- Q1. FIND THE TOP 10 BEST-VALUE PRODUCTS BASES ON THE DISCOUNT PERCENTAGE.
 SELECT DISTINCT name, mrp, discountPercent
 FROM zepto
 ORDER BY discountPercent DESC
 LIMIT 10;

 -- Q2. WHAT ARE THE PRODUCTS WITH HIGH MRP BUT OUT OF STOCK
 SELECT DISTINCT name, mrp , outofstock
 FROM zepto
 WHERE outofstock = TRUE AND mrp >300
 ORDER BY mrp DESC;

-- Q3. CALCULATE ESTIMATED REVENUE FOR EACH CATEGORY
SELECT category ,sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto
GROUP  BY category
ORDER BY total_revenue;

 -- Q4. FIND ALL PRODUCTS WHERE MRP IS GREATER THEN 500 and discount is less then 10%
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

 -- Q5. IDENTIFY THE TOP 5 CATEGORIES OFFERING THE HIGHEST AVERAGE DISCOUNT PERCENTAGE.
SELECT category,ROUND(AVG(discountpercent),2) as avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

 -- Q6. FIND THE PRICE PER GRAM FOR PRODUCTS ABOVE 100g AND SORT BY THE BEST VALUE
SELECT DISTINCT name,weightInGms,discountedSellingPrice ,
ROUND(discountedSellingPrice/weightInGms,2) as price_in_gms 
FROM zepto
WHERE weightInGms >=100
ORDER BY price_in_gms ;


-- Q7. GROUP THE PRODUCTS INTO CATEGORIES LIKE LOW, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
     WHEN weightInGms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto;	


 -- Q8 WHAT IS THE TOTAL INVENTORY WEIGHT PER CATEGORY
 SELECT category,
 SUM(weightInGms * availableQuantity) AS total_weight 
 FROM zepto
 GROUP BY category
 ORDER BY total_weight;
 