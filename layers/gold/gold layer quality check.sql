
SELECT '';
SELECT '======== GOLD LAYER DATA QUALITY CHECK =======';
SELECT '';
SELECT '================ QUALITY CHECK IN dim_customer';

SELECT '';
SELECT 
    IF(
        (SELECT COUNT(*)
        FROM(SELECT 
        CHAR_LENGTH(fname) AS one,
        CHAR_LENGTH(TRIM(fname)) AS two
        FROM gold.dim_customer
        HAVING one != two
        ) AS A
        ) = 0,
        'No Unwanted or Hidden Spaces',
        '---- Unwanted or Hidden Spaces Found ----'
) AS '==== First Name';

SELECT '';
SELECT 
    IF(
        (SELECT COUNT(*)
        FROM(SELECT 
        CHAR_LENGTH(lname) AS one,
        CHAR_LENGTH(TRIM(lname)) AS two
        FROM gold.dim_customer
        HAVING one != two
        ) AS A
        ) = 0,
        'No Unwanted or Hidden Spaces',
        '---- Unwanted or Hidden Spaces Found ----'
) AS '==== Last Name';

SELECT '';
SELECT 
    IF(
        (SELECT COUNT(*) 
        FROM(
            SELECT
            DISTINCT gender
            FROM gold.dim_customer
        ) AS A) = 3,
        'No Invalid Data or Unwanted Space Found',
        '---- Invalid Data or Unwanted Space Found ----'
) AS '===== Gender';

SELECT '';
SELECT 
    IF(
        (SELECT COUNT(*)
        FROM(
        SELECT
        DISTINCT marital_status
        FROM gold.dim_customer
        ) AS A) = 3,
        'No Invalid Data or Unwanted Space Found',
        '---- Invalid Data or Unwanted Space Found ----'
) AS '===== Marital Status';

SELECT '';
SELECT
    DISTINCT country AS '==== Country'
FROM gold.dim_customer;

SELECT '';
SELECT 
    IF(
        (SELECT COUNT(*) FROM gold.dim_customer
        WHERE birthdate < '1900-01-01' OR birthdate > CURRENT_DATE()) = 0,
        'No Invailid Birthdate Found',
        '---- Invailid Birthdate Found ----'
) AS '==== Birthdate';


SELECT '';
SELECT '================== QUALITY CHECK IN dim_product';

SELECT '';
SELECT 
    IF(
        (SELECT COUNT(*)
        FROM(SELECT 
        CHAR_LENGTH(product_name) AS one,
        CHAR_LENGTH(TRIM(product_name)) AS two
        FROM gold.dim_product
        HAVING one != two
        ) AS A
        ) = 0,
        'No Unwanted or Hidden Spaces',
        '---- Unwanted or Hidden Spaces Found ----'
) AS '==== Product Name';

SELECT '';
SELECT 
    IF(
        (SELECT COUNT(*)
        FROM(SELECT 
        CHAR_LENGTH(subcategory) AS one,
        CHAR_LENGTH(TRIM(subcategory)) AS two
        FROM gold.dim_product
        HAVING one != two
        ) AS A
        ) = 0,
        'No Unwanted or Hidden Spaces Found',
        '---- Unwanted or Hidden Spaces Found ----'
) AS '==== Subcategory';

SELECT '';
SELECT 
    IF(
        (SELECT COUNT(*)
        FROM(SELECT 
        CHAR_LENGTH(Category) AS one,
        CHAR_LENGTH(TRIM(Category)) AS two
        FROM gold.dim_product
        HAVING one != two
        ) AS A
        ) = 0,
        'No Unwanted or Hidden Spaces Found',
        'Unwanted or Hidden Spaces Found'
) AS '==== Category';

SELECT '';
SELECT DISTINCT product_line AS '==== Product line'
FROM gold.dim_product;

SELECT '';
SELECT DISTINCT maintenance AS '==== maintenance'
FROM gold.dim_product;

SELECT '';
SELECT IF(
    (SELECT COUNT(*)
    FROM (
        SELECT launch_date
        FROM gold.dim_product
        WHERE launch_date > last_order_date OR
        launch_date < '2000-01-01' OR launch_date > CURRENT_DATE()
    ) AS A) = 0,
    'No Invalid Date Found',
    '---- Invalid Date Found ----'
) AS '==== Product Launch Date';

SELECT '';
SELECT IF(
    (SELECT COUNT(*)
    FROM (
        SELECT last_order_date
        FROM gold.dim_product
        WHERE last_order_date < launch_date OR
        last_order_date > CURRENT_DATE()
    ) AS A) = 0,
    'No Invalid Date Found',
    '---- Invalid Date Found ----'
) AS '==== Product Last Order Date';


SELECT '';
SELECT '================== QUALITY CHECK IN fact_sales';

SELECT '';
SELECT IF(
    (SELECT COUNT(*)
    FROM (
        SELECT product_id
        FROM gold.fact_sales
        WHERE product_id NOT IN (SELECT product_id FROM gold.dim_product)
    )AS A) = 0,
    'No Invalid Product Id Found',
    '---- Invalid Product Id Found ----'
) AS '==== Product Id';

SELECT '';
SELECT IF(
    (SELECT COUNT(*)
    FROM (
        SELECT customer_id
        FROM gold.fact_sales
        WHERE customer_id NOT IN (SELECT customer_id FROM gold.dim_customer)
    )AS A) = 0,
    'No Invalid Product Id Found',
    '---- Invalid Product Id Found ----'
) AS '==== Product Id';

SELECT '';
SELECT IF(
    (SELECT COUNT(*)
    FROM (
        SELECT order_date
        FROM gold.fact_sales
        WHERE order_date > ship_date OR
        order_date < '2000-01-01' OR
        order_date > CURRENT_DATE()
    ) AS A) = 0,
    'No Invalid Date Found',
    '---- Invalid Date Found ----'
) AS '==== Order Date';

SELECT '';
SELECT IF(
    (SELECT COUNT(*)
    FROM (
        SELECT ship_date
        FROM gold.fact_sales
        WHERE ship_date > delivery_date OR
        ship_date < '2000-01-01' OR
        ship_date > CURRENT_DATE()
    ) AS A) = 0,
    'No Invalid Date Found',
    '---- Invalid Date Found ----'
) AS '==== Order Date';

SELECT '';
SELECT IF(
    (SELECT COUNT(*)
    FROM (
        SELECT ship_date
        FROM gold.fact_sales
        WHERE ship_date > delivery_date OR
        ship_date < '2000-01-01' OR
        ship_date > CURRENT_DATE()
    ) AS A) = 0,
    'No Invalid Date',
    '---- Invalid Date Found ----'
) AS '==== Order Date Found ';

SELECT '';
SELECT IF (
    (SELECT COUNT(*)
    FROM (
        SELECT price
        FROM gold.fact_sales
        WHERE price <= 0
    ) AS A) = 0,
    'No Invalid Data Found',
    '---- Invalid Data Found ----'
) AS '==== Price';

SELECT '';
SELECT IF (
    (SELECT COUNT(*)
    FROM (
        SELECT quantity
        FROM gold.fact_sales
        WHERE quantity <= 0
    ) AS A) = 0,
    'No Invalid Data Found',
    '---- Invalid Data Found ----'
) AS '==== Quantity';

SELECT '';
SELECT IF (
    (SELECT COUNT(*)
    FROM (
        SELECT sales
        FROM gold.fact_sales
        WHERE sales <= 0
    ) AS A) = 0,
    'No Invalid Data Found',
    '---- Invalid Data Found ----'
) AS '==== Sales';

