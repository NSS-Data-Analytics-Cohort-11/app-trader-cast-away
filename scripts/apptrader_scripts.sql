--All from app_store_apps
SELECT *
FROM app_store_apps;

--All from play_store_apps
SELECT *
FROM play_store_apps;

--Intersect NAME
SELECT name
FROM app_store_apps
INTERSECT
SELECT name
FROM play_store_apps

--Type of app app_store
SELECT DISTINCT primary_genre,
FROM app_store_apps;

--Type of app play_store
SELECT DISTINCT category
FROM play_store_apps;

--Unique PRICE in app_store_apps; 36 different costs; highest $300
SELECT DISTINCT MONEY(price)
FROM app_store_apps

--Unique PRICE in play_store_apps; 92 differnt costs; highest $400
SELECT DISTINCT MONEY(price),
FROM play_store_apps

--Unique PRICE grouped by app_store_apps category
SELECT DISTINCT MONEY(price),
		primary_genre	
FROM app_store_apps
GROUP BY primary_genre, price

--Unique PRICE grouped by play_store_apps category
SELECT DISTINCT MONEY(price),
		category
FROM play_store_apps
GROUP BY category, price

--Unique PRICE grouped by app_store_apps category, cost LESS than $10
SELECT DISTINCT MONEY(price),
		primary_genre	
FROM app_store_apps
GROUP BY primary_genre, price
HAVING price < 10


SELECT category,
		rating,
		price
FROM play_store_apps
WHERE price  1;
