select *
FROM app_store_apps
select*
FROM play_store_apps


SELECT content_rating, count(content_rating)
FROM app_store_apps
GROUP BY content_rating
UNION
SELECT content_rating, count(content_rating)
FROM play_store_apps
GROUP BY content_rating
ORDER BY count DESC

SELECT primary_genre, count(primary_genre)
FROM app_store_apps
GROUP BY primary_genre
UNION
SELECT genres, count(content_rating)
FROM play_store_apps
GROUP BY genres
ORDER BY count DESC


SELECT name, rating, primary_genre, price
FROM app_store_apps
WHERE rating >= 4.0
ORDER BY price DESC


SELECT name 
FROM app_store_apps
INTERSECT
SELECT name
FROM play_store_apps

