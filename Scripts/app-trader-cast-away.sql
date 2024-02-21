SELECT *
FROM app_store_apps;

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
FROM play_store_apps;