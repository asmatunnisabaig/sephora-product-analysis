CREATE TABLE products(
product_id varchar(50),
product_name varchar (200),
brand_id varchar (50),
brand_name varchar (50),
loves_count varchar (100),
rating varchar (15),
reviews varchar (20),
size varchar (100),
variation_type varchar (50),
variation_value varchar (100),
variation_desc varchar (200),
ingredients text,
price_usd varchar (100),
value_price_usd varchar (100),
sale_price_usd varchar (100),
limited_edition varchar (50),
new varchar (50),
online_only varchar (50),
out_of_stock varchar (50),
sephora_exclusive varchar (50),
highlights text,
primary_category varchar (50),
secondary_category varchar (50),
tertiary_category varchar (50),
child_count varchar (50),
child_max_price varchar (50),
child_min_price varchar (50)
);

SELECT * FROM products;

--1. Count products by category.
SELECT 'primary' AS category_level, primary_category AS category_name, COUNT(*) AS product_count
FROM products_clean
GROUP BY primary_category

UNION ALL

SELECT 'secondary', secondary_category, COUNT(*)
FROM products_clean
GROUP BY secondary_category

UNION ALL

SELECT 'tertiary', tertiary_category, COUNT(*)
FROM products_clean
GROUP BY tertiary_category

ORDER BY category_level, product_count DESC;

--2. Most common rating by skin type or brand tier.
SELECT primary_category, rating
FROM (
    SELECT 
        primary_category,
        rating,
        COUNT(*) AS rating_count,
        ROW_NUMBER() OVER (
            PARTITION BY primary_category
            ORDER BY COUNT(*) DESC, rating DESC
        ) AS rn
    FROM products_clean
    WHERE rating IS NOT NULL
    GROUP BY primary_category, rating
) t
WHERE rn = 1;

SELECT secondary_category, rating
FROM (
    SELECT 
        secondary_category,
        rating,
        COUNT(*) AS rating_count,
        ROW_NUMBER() OVER (
            PARTITION BY secondary_category
            ORDER BY COUNT(*) DESC, rating DESC
        ) AS rn
    FROM products_clean
    WHERE rating IS NOT NULL
    GROUP BY secondary_category, rating
) t
WHERE rn = 1;

SELECT tertiary_category, rating
FROM (
    SELECT 
        tertiary_category,
        rating,
        COUNT(*) AS rating_count,
        ROW_NUMBER() OVER (
            PARTITION BY tertiary_category
            ORDER BY COUNT(*) DESC, rating DESC
        ) AS rn
    FROM products_clean
    WHERE rating IS NOT NULL
    GROUP BY tertiary_category, rating
) t
WHERE rn = 1;

--3. Top 5 brands with most products.
SELECT 
    brand_name,
    COUNT(product_name) AS total_products
FROM products_clean
GROUP BY brand_name
ORDER BY total_products DESC
LIMIT 5;

--4. Identify the highest priced product.
SELECT product_name, brand_name, price_usd
FROM products_clean
WHERE price_usd = (SELECT MAX(price_usd) FROM products_clean);

--5. Products with more than 1000 reviews.
SELECT product_name, brand_name, reviews
FROM products_clean
WHERE reviews > 1000
ORDER BY reviews DESC;

--6. For each brand, find the average rating of their products. Return the top 5 brands with the highest average rating, considering only brands with more than 10 products.
SELECT 
    brand_name,
    ROUND(AVG(rating)::NUMERIC, 2) AS avg_rating,
    COUNT(*) AS total_products
FROM products_clean
WHERE rating IS NOT NULL
AND brand_name IS NOT NULL
GROUP BY brand_name
HAVING COUNT(*) > 10
ORDER BY avg_rating DESC
LIMIT 5;

--7. Categorise and count products based on skin concerns using keyword pattern matching on the highlights column. Identify which concern has the highest product availability on Sephora.
SELECT 
    CASE 
        WHEN highlights ILIKE '%acne%' OR highlights ILIKE '%blemish%'       THEN 'Acne'
        WHEN highlights ILIKE '%anti-aging%' OR highlights ILIKE '%wrinkle%' THEN 'Anti-Ageing'
        WHEN highlights ILIKE '%hydrat%' OR highlights ILIKE '%dry%'         THEN 'Dryness/Hydration'
        WHEN highlights ILIKE '%brighten%' OR highlights ILIKE '%glow%'      THEN 'Brightening'
        WHEN highlights ILIKE '%sensitive%'                                   THEN 'Sensitive Skin'
        WHEN highlights ILIKE '%SPF%' OR highlights ILIKE '%sun%'            THEN 'Sun Protection'
        ELSE 'General'
    END AS skin_concern,
    COUNT(*) AS product_count
FROM products_clean
GROUP BY skin_concern
ORDER BY product_count DESC;

--8. List all skincare products that are both Sephora-exclusive and limited edition, along with their brand, price, rating, and primary category. Order by rating descending.
SELECT 
    product_name,
    brand_name,
    price_usd,
    rating,
    primary_category
FROM products_clean
WHERE primary_category = 'Skincare'
AND sephora_exclusive = 1
AND limited_edition = 1
AND rating IS NOT NULL
ORDER BY rating DESC;

--9. Find all products where ingredients information is missing or incomplete (NULL, empty, or contains only whitespace). Group them by brand and category, and rank brands by the number of such products using a window function.
SELECT 
    brand_name,
    primary_category,
    COUNT(*) AS missing_ingredient_products,
    RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS brand_rank
FROM products_clean
WHERE ingredients = 'Not Available'
OR TRIM(ingredients) = ''
GROUP BY brand_name, primary_category
ORDER BY brand_rank;
