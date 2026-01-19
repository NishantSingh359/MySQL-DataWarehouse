
SELECT '';
SELECT '======== GOLD LAYER DATA QUALITY CHECK =======';
SELECT '';
SELECT '================ QUALITY CHECK IN dim_customer';

SELECT '';
SELECT 
    IF(
        (SELECT COUNT(*)
        FROM(SELECT 
        CHAR_LENGTH(first_name) AS one,
        CHAR_LENGTH(TRIM(first_name)) AS two
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
        CHAR_LENGTH(last_name) AS one,
        CHAR_LENGTH(TRIM(last_name)) AS two
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
        'No Invalid Birthdate Found',
        '---- Invalid Birthdate Found ----'
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
        'No Unwanted or Hidden Spaces Found',
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
        SELECT product_keys
        FROM gold.fact_sales
        WHERE product_keys NOT IN (SELECT product_keys FROM gold.dim_product)
    )AS A) = 0,
    'No Invalid Product Keys Found',
    '---- Invalid Product Keys Found ----'
) AS '==== Product Keys';

SELECT '';
SELECT IF(
    (SELECT COUNT(*)
    FROM (
        SELECT customer_keys
        FROM gold.fact_sales
        WHERE customer_keys NOT IN (SELECT customer_keys FROM gold.dim_customer)
    )AS A) = 0,
    'No Invalid Customer Keys Found',
    '---- Invalid Customer Keys Found ----'
) AS '==== Customer Keys';

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
        ship_date > CURRENT_DATE() OR
        ship_date < order_date
    ) AS A) = 0,
    'No Invalid Date Found',
    '---- Invalid Date Found ----'
) AS '==== Ship Date';

SELECT '';
SELECT IF(
    (SELECT COUNT(*)
    FROM (
        SELECT delivery_date
        FROM gold.fact_sales
        WHERE delivery_date < ship_date  OR
        delivery_date < '2000-01-01' OR
        delivery_date > CURRENT_DATE()
    ) AS A) = 0,
    'No Invalid Date Found',
    '---- Invalid Date Found ----'
) AS '==== Deliver Date';

SELECT '';
SELECT IF (
    (SELECT COUNT(*)
    FROM (
        SELECT *
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
        SELECT amount
        FROM gold.fact_sales
        WHERE amount <= 0
    ) AS A) = 0,
    'No Invalid Data Found',
    '---- Invalid Data Found ----'
) AS '==== Amount';

