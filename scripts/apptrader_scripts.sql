--All from app_store_apps--
SELECT *
FROM app_store_apps;


--All from play_store_apps--
SELECT *
FROM play_store_apps;


--Intersect NAME--
SELECT name
FROM app_store_apps
INTERSECT
SELECT name
FROM play_store_apps


--Type of app app_store--
SELECT DISTINCT primary_genre,
FROM app_store_apps;

--Type of app play_store
SELECT DISTINCT category
FROM play_store_apps;


--Unique PRICE in app_store_apps; 36 different costs; highest $300--
SELECT DISTINCT MONEY(price)
FROM app_store_apps


--Unique PRICE in play_store_apps; 92 differnt costs; highest $400--
SELECT DISTINCT MONEY(price),
FROM play_store_apps


--Unique PRICE grouped by app_store_apps category--
SELECT DISTINCT MONEY(price),
		primary_genre	
FROM app_store_apps
GROUP BY primary_genre, price


--Unique PRICE grouped by play_store_apps category--
SELECT DISTINCT MONEY(price),
		category
FROM play_store_apps
GROUP BY category, price


--Unique PRICE grouped by app_store_apps category, cost LESS than $10--
SELECT DISTINCT MONEY(price),
		primary_genre	
FROM app_store_apps
GROUP BY primary_genre, price
HAVING price < 10



--Unique PRICE grouped by play_store_apps category, cost LESS than $10--
SELECT DISTINCT MONEY(price),
		category	
FROM play_store_apps
GROUP BY category, price
HAVING price < 10


---Top 10 apps with low cost, low rating in app_store_apps-
SELECT primary_genre,
	name,
	rating,
	price
FROM app_store_apps
WHERE primary_genre = 'Travel'
ORDER BY price ASC




--Profitability app_store_apps--
-- = ([1 or 2 stores]) * $60k/yr) MINUS ($10k*[Price of App]v+ ($12k/yr * 1 yr+Floor([Rating/.5])))
SELECT name,
	price,
	rating,
	primary_genre,
	review_count,
	CASE 
		WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000)+(12000*(1+rating/.5)))
	ELSE ((1*60000)*(1+rating/.5))-((10000*price)+(12000*(1+rating/.5))) END AS profitability
FROM app_store_apps
ORDER BY CAST(review_count AS INTEGER) DESC;

--Apps with Profitability above the avg. APP_STORE_APPS--
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

-------******UNION ALL App_store_apps AND play_store_apps profitability----
WITH avg_profit AS (
  SELECT AVG(CASE
              WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
              ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
             END) AS avg_profitability
  FROM
	(SELECT price, rating, CAST(review_count AS integer)
	FROM app_store_apps
	UNION ALL
	SELECT CAST(TRIM(REPLACE(price,'$','')) AS NUMERIC), rating, review_count
	FROM play_store_apps) AS union_all
  WHERE rating >= 4.0
),
profitability_app AS (
  SELECT
    name, review_count,
    rating,
    CASE
      WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
      ELSE ((1*60000)*(1+rating/.5))-((10000 * price) + (12000*(1+rating/.5)))
    END AS prof_app
  FROM app_store_apps
	WHERE rating >= 4.0
),
profitability_play AS (
  SELECT
    name, review_count,
    rating,
    CASE
      WHEN CAST(TRIM(REPLACE(price,'$','')) AS NUMERIC) = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
      ELSE ((1*60000)*(1+rating/.5))-((10000 * CAST(TRIM(REPLACE(price,'$','')) AS NUMERIC)) + (12000*(1+rating/.5)))
    END AS prof_play
  FROM play_store_apps
	WHERE rating >= 4.0
) 
SELECT
  name, CAST(review_count AS INTEGER),
  rating,
  prof_app AS profitability_both
FROM profitability_app, avg_profit
WHERE prof_app >= avg_profitability
UNION
SELECT
  name, CAST(review_count AS INTEGER),
  rating,
  prof_play
FROM profitability_play, avg_profit
WHERE prof_play >= avg_profitability

-------******UNION ALL App_store_apps AND play_store_apps profitability DISTINCT count------
WITH avg_profit AS (
  SELECT AVG(CASE
              WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
              ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
             END) AS avg_profitability
  FROM
	(SELECT price, rating, CAST(review_count AS integer)
	FROM app_store_apps
	UNION ALL
	SELECT CAST(TRIM(REPLACE(price,'$','')) AS NUMERIC), rating, review_count
	FROM play_store_apps) AS union_all
  WHERE rating >= 4.0
),
profitability_app AS (
  SELECT
    name, review_count,
    rating,
    CASE
      WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
      ELSE ((1*60000)*(1+rating/.5))-((10000 * price) + (12000*(1+rating/.5)))
    END AS prof_app
  FROM app_store_apps
	WHERE rating >= 4.0
),
profitability_play AS (
  SELECT
    name, review_count,
    rating,
    CASE
      WHEN CAST(TRIM(REPLACE(price,'$','')) AS NUMERIC) = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
      ELSE ((1*60000)*(1+rating/.5))-((10000 * CAST(TRIM(REPLACE(price,'$','')) AS NUMERIC)) + (12000*(1+rating/.5)))
    END AS prof_play
  FROM play_store_apps
	WHERE rating >= 4.0
) SELECT name, COUNT(DISTINCT app_store_flag)
FROM
(SELECT
  name, CAST(review_count AS INTEGER),
  rating,
  prof_app AS profitability_both, 'app_store' AS app_store_flag
FROM profitability_app, avg_profit
WHERE prof_app >= avg_profitability
UNION
SELECT
  name, CAST(review_count AS INTEGER),
  rating,
  prof_play, 'play_store' AS app_store_flag
FROM profitability_play, avg_profit
WHERE prof_play >= avg_profitability) as a
GROUP BY name
HAVING COUNT(DISTINCT app_store_flag) > 1

------MAX PROFITABILITY by Review Count for apps in BOTH STORES-----
WITH avg_profit AS (
  SELECT AVG(CASE
              WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
              ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
             END) AS avg_profitability
  FROM
	(SELECT price, rating, CAST(review_count AS integer)
	FROM app_store_apps
	UNION ALL
	SELECT CAST(TRIM(REPLACE(price,'$','')) AS NUMERIC), rating, review_count
	FROM play_store_apps) AS union_all
  WHERE rating >= 4.3
),
profitability_app AS (
  SELECT
    name, review_count,
    rating,
    CASE
      WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
      ELSE ((1*60000)*(1+rating/.5))-((10000 * price) + (12000*(1+rating/.5)))
    END AS prof_app
  FROM app_store_apps
	WHERE rating >= 4.0
),
profitability_play AS (
   SELECT
    DISTINCT name, review_count,
    rating,
    CASE
      WHEN CAST(TRIM(REPLACE(price,'$','')) AS NUMERIC) = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
      ELSE ((1*60000)*(1+rating/.5))-((10000 * CAST(TRIM(REPLACE(price,'$','')) AS NUMERIC)) + (12000*(1+rating/.5)))
    END AS prof_play
  FROM play_store_apps
	WHERE rating >= 4.0
) SELECT name, MAX(CAST(review_count AS INTEGER)), COUNT(DISTINCT app_store_flag), MAX(profitability_both)*2
FROM
(SELECT
  name, CAST(review_count AS INTEGER),
  rating,
  prof_app AS profitability_both, 'app_store' AS app_store_flag
FROM profitability_app, avg_profit
WHERE prof_app >= avg_profitability
UNION
SELECT
  name, CAST(review_count AS INTEGER),
  rating,
  prof_play, 'play_store' AS app_store_flag
FROM profitability_play, avg_profit
WHERE prof_play >= avg_profitability) as a
GROUP BY name
HAVING COUNT(DISTINCT app_store_flag) > 1
ORDER BY MAX(profitability_both) DESC;

--Final--
