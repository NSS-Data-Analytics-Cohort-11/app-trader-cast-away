-- - app_store_apps with 7197 rows
-- - play_store_apps with 10840 rows

-- SELECTING STORE TABLES --
SELECT *
FROM play_store_apps;

SELECT *
FROM app_store_apps;

-- SELECTING STORE GENRES --
SELECT DISTINCT genres
FROM play_store_apps;

SELECT DISTINCT primary_genre
FROM app_store_apps;

SELECT genres, COUNT(genres)
FROM play_store_apps
GROUP BY genres
ORDER BY COUNT(genres) DESC
LIMIT 10;

SELECT primary_genre, COUNT(primary_genre)
FROM app_store_apps
GROUP BY primary_genre
ORDER BY COUNT(primary_genre) DESC
LIMIT 10;

-- HIGHER THAN AVG PROFITABILITY (app_store_apps) --
WITH app_profitability AS (
	SELECT 
		AVG(CASE
 		WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
 		ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
		END) AS avg_profitability
	FROM app_store_apps
						),
 proffy AS (
	SELECT name
	,	CASEWITH avg_profit AS (
  SELECT AVG(CASE
              WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
              ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
             END) AS avg_profitability, AVG(CAST(review_count AS INTEGER)) AS review
  FROM app_store_apps
),
profitability AS (
  SELECT 
    name,
    review_count,
    rating,
    primary_genre,
    CASE
      WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
      ELSE ((1*60000)*(1+rating/.5))-((10000 * price) + (12000*(1+rating/.5)))
    END AS profitability
  FROM app_store_apps
)
SELECT --selecting from CTE and joining 
  name,
  review_count,
  rating,
  primary_genre,
  profitability
FROM 
  profitability
JOIN avg_profit ON 1=1
WHERE profitability >= avg_profitability AND CAST(review_count AS INTEGER) > review AND rating = 5.0
 		WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
 		ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
		END as profitability
	FROM app_store_apps)
	
	select name, price, rating, review_count, profitability
	from app_store_apps
	join proffy using(name)
	
	where profitability >= 363689.8846741697929693


-- SECOND ATTEMPT ^^ -- 
WITH avg_profit AS (
  SELECT AVG(CASE
              WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
              ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
             END) AS avg_profitability, AVG(CAST(review_count AS INTEGER)) AS review
  FROM app_store_apps
  WHERE rating = 5.0
),
profitability AS (
  SELECT 
    name,
    review_count,
    rating,
    primary_genre,
    CASE
      WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
      ELSE ((1*60000)*(1+rating/.5))-((10000 * price) + (12000*(1+rating/.5)))
    END AS profitability
  FROM app_store_apps
)
SELECT 
  name,
  review_count,
  rating,
  primary_genre,
  profitability
FROM profitability, avg_profit
WHERE profitability >= avg_profitability AND CAST(review_count AS INTEGER) > review;

-- ALL APPS PROFITABILITY (app_store_apps) -- 
SELECT name,price,review_count,rating,primary_genre,
	CASE
		WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
		ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
	END AS profitability
FROM app_store_apps
ORDER BY profitability DESC;

-- ALL APPS PROFITABILITY (apps in both stores) -- 
SELECT name,price,review_count,rating,primary_genre,
	CASE
		WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
		ELSE ((2*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
	END AS profitability
FROM app_store_apps
	WHERE name IN(
	SELECT name
	FROM app_store_apps
	INNER JOIN play_store_apps
	USING (name))
ORDER BY profitability DESC;

-- TESTING -- 
