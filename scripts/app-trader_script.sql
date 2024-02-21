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

-- PROFITABILITY --

-- GENRES BREAKDOWN --
