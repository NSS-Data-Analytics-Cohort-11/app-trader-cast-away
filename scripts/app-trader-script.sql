select *
FROM app_store_apps
select*
FROM play_store_apps

-- what ages have the most apps 
SELECT content_rating, count(content_rating)
FROM app_store_apps
GROUP BY content_rating
UNION
SELECT content_rating, count(content_rating)
FROM play_store_apps
GROUP BY content_rating
ORDER BY count DESC

-- what genres have the most apps
SELECT primary_genre, count(primary_genre)
FROM app_store_apps
GROUP BY primary_genre
UNION
SELECT genres, count(content_rating)
FROM play_store_apps
GROUP BY genres
ORDER BY count DESC

--ratings 
SELECT name, rating, primary_genre, price
FROM app_store_apps
WHERE rating >= 4.0
ORDER BY price DESC

--what common apps between both 
SELECT name 
FROM app_store_apps
INTERSECT
SELECT name
FROM play_store_apps

Select primary_genre, avg(primary_genre) 
FROM app_store_apps 
WHERE primary_genre= 'Games'

--profitability 
CASE
 	WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
 	ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
END AS profitability

---second attempt

WITH avg_profit AS (
  SELECT AVG(CASE
              WHEN price = 0 THEN ((1*60000)*(1+rating/.5))-((10000) + (12000*(1+rating/.5)))
              ELSE ((1*60000)*(1+rating/.5))-((10000 *price) + (12000*(1+rating/.5)))
             END) AS avg_profitability
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
SELECT 
  name,
  review_count,
  rating,
  primary_genre,
  profitability
FROM 
  profitability
JOIN avg_profit ON 1=1
WHERE profitability >= avg_profitability;


