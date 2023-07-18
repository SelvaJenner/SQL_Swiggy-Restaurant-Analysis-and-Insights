CREATE database SWIGGY;

USE SWIGGY;

SELECT * FROM swiggy;

-- Q1 HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?

SELECT count(DISTINCT restaurant_name) as top_rated 
FROM swiggy
WHERE rating > 4.5;

-- Q2 WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?

SELECT city, count(DISTINCT restaurant_name) as no_of_restaurants 
FROM swiggy
GROUP BY city
ORDER BY no_of_restaurants DESC
LIMIT 1;

SELECT city, no_of_restaurants
FROM (
  SELECT city, COUNT(DISTINCT restaurant_name) AS no_of_restaurants,
    RANK() OVER (ORDER BY COUNT(DISTINCT restaurant_name) DESC) AS rankis
  FROM swiggy
  GROUP BY city
) subquery
WHERE rankis = 1;

-- Q3 HOW MANY RESTAURANTS HAVE THE WORD "PIZZA" IN THEIR NAME?

SELECT count(DISTINCT restaurant_name) as Pizza_Restaurants
FROM swiggy
WHERE restaurant_name LIKE '%PIZZA%';

-- Q4 WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?

SELECT cuisine,count(*) as most_common FROM swiggy
GROUP BY cuisine
ORDER BY most_common DESC
LIMIT 1;

SELECT cuisine, most_common
FROM (
  SELECT cuisine,count(*) as most_common ,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rankis
  FROM swiggy
  GROUP BY cuisine
) sq
WHERE rankis = 1;

-- Q5 WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?

SELECT city,AVG(rating) as AvgRating
FROM swiggy
GROUP BY city;

-- Q6 WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED MENU CATEGORY FOR EACH RESTAURANT?

SELECT restaurant_name, max(price) as Highest_Price
FROM swiggy 
WHERE menu_category = "Recommended"
GROUP BY restaurant_name
ORDER BY Highest_Price DESC;

-- Q7 FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE.

SELECT * FROM swiggy;

SELECT DISTINCT restaurant_name, cost_per_person
FROM swiggy
WHERE cuisine != 'Indian'
ORDER BY cost_per_person DESC
LIMIT 5; 

SELECT restaurant_name,cost_per_person	FROM (
SELECT DISTINCT restaurant_name, cost_per_person, dense_rank() OVER(order by cost_per_person DESC) as pricerank
FROM swiggy
WHERE cuisine != 'Indian'
ORDER BY cost_per_person DESC) ap 
WHERE pricerank <=5; 

-- Q8 FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL RESTAURANTS TOGETHER.

SELECT DISTINCT restaurant_name AS Rest_name, cost_per_person
FROM swiggy
WHERE cost_per_person > (
  SELECT AVG(Priceavg) 
  FROM (
    SELECT DISTINCT restaurant_name, AVG(cost_per_person) AS Priceavg 
    FROM swiggy
    GROUP BY restaurant_name
  ) AS devtable
);

-- Q9 RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.

SELECT distinct t1.restaurant_name ,t1.city
FROM swiggy t1
JOIN swiggy t2
ON t1.restaurant_name = t2.restaurant_name AND t1.city != t2.city ;	

-- Q10 WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE MAIN COURSE' CATEGORY

SELECT DISTINCT restaurant_name,menu_category, count(item) as no_of_items FROM swiggy
WHERE menu_category = 'MAIN COURSE'
GROUP BY restaurant_name,menu_category
ORDER BY no_of_items DESC
LIMIT 1;

select restaurant_name, menu_category ,no_of_items FROM  ( 
SELECT DISTINCT restaurant_name,menu_category, count(item) as no_of_items ,
rank() over(order by count(item) DESC) as rankitem
FROM swiggy
WHERE menu_category = 'MAIN COURSE'
GROUP BY restaurant_name,menu_category) as devtable
WHERE rankitem = 1;

-- Q11 LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME.

SELECT DISTINCT restaurant_name,veg_or_nonveg
FROM swiggy
WHERE veg_or_nonveg = 'Veg'
ORDER BY restaurant_name;

-- Q12 WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?

SELECT DISTINCT
    restaurant_name, AVG(price) AS Priceavg
FROM
    swiggy
GROUP BY restaurant_name
ORDER BY priceavg ASC
LIMIT 1;

-- Q13 WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?

select restaurant_name, no_of_cat  FROM  ( 
SELECT DISTINCT restaurant_name,count( DISTINCT menu_category) as no_of_cat,
rank() over(order by count( DISTINCT menu_category) DESC) as rankitem
FROM swiggy
GROUP BY restaurant_name) as devtable
WHERE rankitem <= 5;

-- Q14 WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?

SELECT DISTINCT restaurant_name , 
(COUNT( CASE  WHEN veg_or_nonveg = 'Non-Veg' THEN 1 END )/ COUNT(*)) * 100 as non_veg_perc
FROM swiggy
GROUP BY restaurant_name
HAVING non_veg_perc <> 0
ORDER BY non_veg_perc DESC
LIMIT 1;

SELECT restaurant_name, non_veg_perc
FROM (
  SELECT DISTINCT restaurant_name,
    COUNT(CASE WHEN veg_or_nonveg = 'Non-Veg' THEN 1 END) * 100 / COUNT(*) AS non_veg_perc,
    RANK() OVER (ORDER BY  (COUNT(CASE WHEN veg_or_nonveg = 'Non-Veg' THEN 1 END) * 100 / COUNT(*)) DESC)  AS rankis
  FROM swiggy
  GROUP BY restaurant_name
) subquery
WHERE non_veg_perc <> 0 AND rankis = 1;

