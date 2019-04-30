 -- (1)

 SELECT *
 FROM survey
 LIMIT 10; 

 -- (2)

SELECT question, 
	COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1; 

-- (4)

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

 -- (5)
 
SELECT q.user_id,
	h.user_id IS NOT NULL AS 'is_home_try_on',
	h.number_of_pairs,
	p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = h.user_id
LIMIT 10;

 -- Overall Conversion Rate (6)
 
WITH purchase_funnel AS (
SELECT DISTINCT q.user_id,
 	h.user_id IS NOT NULL AS 'is_home_try_on',
  	h.number_of_pairs,
  	p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = h.user_id)
SELECT COUNT (*) AS 'quiz_participants',
	SUM (is_purchase) AS ‘total_purchases'
FROM purchase_funnel; 

-- Purchase Funnel Overview (6)
 
WITH purchase_funnel AS (
SELECT DISTINCT q.user_id,
 		h.user_id IS NOT NULL AS 'is_home_try_on',
  	h.number_of_pairs,
  	p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = h.user_id)
SELECT COUNT (*) AS 'quiz_participants',
	SUM (is_home_try_on) AS 'total_users_tried_on',
	SUM (is_purchase) AS 'total_purchases'
FROM purchase_funnel; 


-- A/B Test Result pt.1 (6)

SELECT DISTINCT number_of_pairs,
       COUNT(DISTINCT CASE
            WHEN number_of_pairs = '3 pairs' THEN user_id
            END) AS '3 Pair Test',
       COUNT(DISTINCT CASE
            WHEN number_of_pairs = '5 pairs' THEN user_id
            END) AS '5 Pair Test'
FROM home_try_on
GROUP BY 1 
ORDER BY 1; 

-- A/B Test Result pt.2 (6)

SELECT DISTINCT home_try_on.number_of_pairs,
       COUNT(DISTINCT CASE
            WHEN home_try_on.number_of_pairs = '3 pairs' AND purchase.user_id = home_try_on.user_id THEN home_try_on.user_id
            END) AS '3 Pair Purchase',
       COUNT(DISTINCT CASE
            WHEN home_try_on.number_of_pairs = '5 pairs' AND purchase.user_id = home_try_on.user_id THEN home_try_on.user_id
            END) AS '5 Pair Purchase'
FROM home_try_on
LEFT JOIN purchase
	ON purchase.user_id = home_try_on.user_id
GROUP BY 1 
ORDER BY 1; 

-- Quiz Results and Purchase (6)

SELECT COUNT(DISTINCT CASE 
            WHEN q.style = 'Women''s Styles' THEN q.user_id
            END) AS 'Quiz Womens',
       COUNT(DISTINCT CASE 
            WHEN p.style = 'Women''s Styles' THEN p.user_id
            END) AS 'Purchase Womens',
       COUNT(DISTINCT CASE 
            WHEN q.style = 'Men''s Styles' THEN q.user_id
            END) AS 'Quiz Mens',
       COUNT(DISTINCT CASE 
            WHEN p.style = 'Men''s Styles' THEN p.user_id
            END) AS 'Purchase Mens'
FROM quiz AS 'q'
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id;

-- Common Quiz Results - style (6)

SELECT COUNT(*),
COUNT(DISTINCT CASE
      WHEN style = 'Women''s Styles' 
      THEN user_id
      END) AS 'W',
COUNT(DISTINCT CASE 
      WHEN style = 'Men''s Styles' 
      THEN user_id	
      END) AS 'M'
FROM quiz;

-- Common Quiz Results - fit (6)

SELECT COUNT(*),
COUNT(DISTINCT CASE
      WHEN fit='Medium'
      THEN user_id
      END) AS 'M’,
COUNT(DISTINCT CASE 
      WHEN fit='Narrow' 
      THEN user_id	
       END) AS 'N’,
COUNT(DISTINCT CASE 
       WHEN fit ='Wide'
      THEN user_id	
       END) AS 'W'
FROM quiz;

-- Common Quiz Results - shape (6)

SELECT COUNT(shape IS NOT NULL),
COUNT(DISTINCT CASE
      WHEN shape='Rectangular'
      THEN user_id
      END) AS 'Rec’,
COUNT(DISTINCT CASE 
      WHEN shape='Round' 
      THEN user_id	
      END) AS 'Rou',
COUNT(DISTINCT CASE 
      WHEN shape='Square'
      THEN user_id	
       END) AS 'Squ'
FROM quiz;

-- Common Quiz Results - color (6)

SELECT SUM(color = 'Tortoise'),
               SUM(color = 'Black'),
               SUM(color = 'Two-Tone'),
               SUM(color = 'Crystal'),
               SUM(color = 'Neutral')
FROM quiz;

-- Further Statistics

SELECT ROUND(AVG(price),2)
FROM purchase;

-- Further Statistics

SELECT SUM(price)
FROM purchase;

-- Further Statistics

SELECT DISTINCT model_name, COUNT(user_id)
FROM purchase
GROUP BY model_name
ORDER BY model_name; 

-- Further Statistics

SELECT DISTINCT price, COUNT(user_id)
FROM purchase
GROUP BY price
ORDER BY price; 

-- Further Statistics

SELECT DISTINCT color, COUNT(user_id)
FROM purchase
GROUP BY color
ORDER BY color; 

-- Further Statistics

SELECT MIN(price)
FROM purchase;

-- Further Statistics

SELECT MAX(price)
FROM purchase;





