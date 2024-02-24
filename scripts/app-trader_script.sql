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
) SELECT name, MAX(CAST(review_count AS INTEGER)) as rev_count, COUNT(DISTINCT app_store_flag), MAX(profitability_both)*2 as profit
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


-- IGNORE --
-- app_store_apps with 7197 rows
-- play_store_apps with 10840 rows

-- -- SELECTING STORE TABLES --
-- SELECT name, price, COUNT(*)
-- FROM play_store_apps
-- GROUP BY name, price
-- HAVING COUNT(*) > 1
-- ORDER BY COUNT(*) DESC;

-- SELECT name, price, COUNT(*)
-- FROM app_store_apps
-- GROUP BY name, price
-- ORDER BY COUNT(*) DESC;
-- -- VR Roller Coaster, Mannequin Challenge

-- SELECT *
-- FROM play_store_apps
-- ORDER BY price DESC;

-- SELECT *
-- FROM app_store_apps
-- ORDER BY price DESC;

-- -- SELECTING STORE GENRES --
-- SELECT DISTINCT genres
-- FROM play_store_apps;

-- SELECT DISTINCT primary_genre
-- FROM app_store_apps;

-- SELECT genres, COUNT(genres)
-- FROM play_store_apps
-- GROUP BY genres
-- ORDER BY COUNT(genres) DESC
-- LIMIT 10;

-- SELECT primary_genre, COUNT(primary_genre)
-- FROM app_store_apps
-- GROUP BY primary_genre
-- ORDER BY COUNT(primary_genre) DESC
-- LIMIT 10;


-- -- WITH avg_profit AS (
-- --   SELECT AVG(CASE
-- --               WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
-- --               ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
-- --              END) AS avg_profitability, AVG(CAST(review_count AS INTEGER)) AS review
-- --   FROM app_store_apps
-- --   WHERE rating = 4.5

-- -- UNION -- 
-- 	(SELECT CAST(price AS money), rating, CAST(review_count AS integer)
-- FROM app_store_apps
-- UNION ALL
-- SELECT CAST(price AS money), rating, review_count
-- FROM play_store_apps)

-- --MAX(CAST(review_count AS INTEGER))
-- -- ALL APPS PROFITABILITY (app_store_apps) -- 
-- SELECT name,price,review_count,rating,primary_genre,
-- 	CASE
-- 		WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
-- 		ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
-- 	END AS profitability
-- FROM app_store_apps
-- ORDER BY profitability DESC;

-- -- ALL APPS PROFITABILITY (apps in both stores) -- 
-- SELECT name,price,review_count,rating,primary_genre,
-- 	CASE
-- 		WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
-- 		ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
-- 	END AS profitability
-- FROM app_store_apps
-- 	WHERE name IN(
-- 	SELECT name
-- 	FROM app_store_apps
-- 	INNER JOIN play_store_apps
-- 	USING (name))
-- ORDER BY profitability DESC


-- SELECT name,price, rating, (1+rating/.5), 12000*(1+rating/.5), 10000*price, ((1*60000)*(1+rating/.5)),
-- ((1*60000)*(1+rating/.5)) - ((10000*price)+12000*(1+rating/.5))
-- FROM app_store_apps
-- WHERE price != 0 AND rating >= 4.5 AND CAST(review_count AS INTEGER) >= 390001.236497545008


-- -- Notes
-- -- 
-- -- avg rvw count?
-- -- what price to use if in both tables?
-- -- multiply revenue by 2 if in both tables