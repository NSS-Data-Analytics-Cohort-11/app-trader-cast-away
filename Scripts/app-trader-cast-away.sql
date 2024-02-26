SELECT *
FROM app_store_apps
WHERE NAME LIKE 'Cytus';

SELECT *
FROM play_store_apps;


SELECT name, content_rating, primary_genre AS genres
FROM app_store_apps
UNION
SELECT name, content_rating, genres
FROM play_store_apps;

SELECT name
FROM app_store_apps
INTERSECT
SELECT name
FROM play_store_apps
ORDER BY name ASC;

SELECT name, price, rating, primary_genre, CAST(review_count AS int),
CASE
 	WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
 	ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
END AS profitability
FROM app_store_apps
ORDER BY profitability DESC, review_count DESC
LIMIT 50;

--

SELECT name, CAST(price AS int), rating, genres, CAST(review_count AS int),
CASE
 	WHEN CAST(price AS int) = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
 	ELSE ((1*60000)*(1+rating/.5))-((10000 *CAST(price AS int) + (12000*(1+rating/.5)))) 
FROM play_store_apps
ORDER BY profitability DESC, review_count DESC
LIMIT 20;

--

SELECT name
FROM app_store_apps
ORDER BY name ASC;


