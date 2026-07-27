SELECT '===============================================';

SELECT '================ GOLD LAYER ===================';

SELECT '===============================================';

SELECT '================ CREATE SCHEMA ================';

SELECT '===============================================';

DROP SCHEMA IF EXISTS gold;

CREATE SCHEMA gold;

-- ================================
-- CREATE & LOAD TABLE dim_customer
-- ================================

SET @time1 = CURRENT_TIME();

SELECT '==================== CREATING gold.dim_customer';

DROP TABLE IF EXISTS gold.dim_customer;

CREATE TABLE gold.dim_customer (
    customer_key INT PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    gender VARCHAR(20),
    age INT,
    age_group VARCHAR(20),
    marital_status VARCHAR(20),
    country VARCHAR(20),
    birthdate DATE,
    created_at DATE
);

SELECT '=========== LOADING DATA INTO gold.dim_customer';

TRUNCATE TABLE gold.dim_customer;

INSERT INTO
    gold.dim_customer (
        customer_key,
        first_name,
        last_name,
        gender,
        age,
        age_group,
        marital_status,
        country,
        birthdate,
        created_at
    )
SELECT
    SUBSTRING(cst_key, 6),
    cst_firstname,
    cst_lastname,
    CASE
        WHEN cst_gndr = 'N/A' THEN IF(gen IS NULL, 'N/A', gen)
        ELSE cst_gndr
    END AS cst_gndr,
    TIMESTAMPDIFF(
        YEAR,
        bdate,
        DATE('2014-02-01')
    ) AS Age,
    CASE
        WHEN TIMESTAMPDIFF(
            YEAR,
            bdate,
            DATE('2014-02-01')
        ) BETWEEN 0 AND 12  THEN 'Child'
        WHEN TIMESTAMPDIFF(
            YEAR,
            bdate,
            DATE('2014-02-01')
        ) BETWEEN 13 AND 19  THEN 'Teen'
        WHEN TIMESTAMPDIFF(
            YEAR,
            bdate,
            DATE('2014-02-01')
        ) BETWEEN 20 AND 35  THEN 'Young Adult'
        WHEN TIMESTAMPDIFF(
            YEAR,
            bdate,
            DATE('2014-02-01')
        ) BETWEEN 36 AND 59  THEN 'Adult'
        WHEN TIMESTAMPDIFF(
            YEAR,
            bdate,
            DATE('2014-02-01')
        ) > 60 THEN 'Senior'
        ELSE NULL
    END AS age_group,
    cst_marital_status,
    cntry,
    bdate,
    cst_create_date AS created_at
FROM silver.cust_info
    LEFT JOIN silver.cust_loc ON silver.cust_info.cst_key = silver.cust_loc.cid
    LEFT JOIN silver.cust_per_info ON silver.cust_info.cst_key = silver.cust_per_info.cid;

SET @time2 = CURRENT_TIME();

SELECT DATE_FORMAT(
        TIMEDIFF(@time2, @time1), '%i:%s'
    ) AS 'TABLE LOADING TIME';

-- ===============================
-- CREATE & LOAD TABLE dim_product
-- ===============================

SET @time1 = CURRENT_TIME();

SELECT '===================== CREATING gold.dim_product';

DROP TABLE IF EXISTS gold.dim_product;

CREATE TABLE gold.dim_product (
    product_key VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    product_line VARCHAR(20),
    maintenance VARCHAR(20),
    cost FLOAT,
    added_date DATE
);

SELECT '============ LOADING DATA INTO gold.dim_product';

TRUNCATE TABLE gold.dim_product;

INSERT INTO
    gold.dim_product (
        product_key,
        product_name,
        category,
        subcategory,
        product_line,
        maintenance,
        cost,
        added_date
    )
SELECT
    prd_key,
    prd_nm,
    cat,
    subcat,
    prd_line,
    maintenance,
    prd_cost,
    prd_added_dt
FROM silver.prd_info
    LEFT JOIN silver.prd_cate ON silver.prd_info.prd_cate_key = silver.prd_cate.id;

SET @time2 = CURRENT_TIME();

SELECT DATE_FORMAT(
        TIMEDIFF(@time2, @time1), '%i:%s'
    ) AS 'TABLE LOADING TIME';

-- ==============================
-- CREATE & LOAD TABLE fact_sales
-- ==============================

SET @time1 = CURRENT_TIME();

SELECT '====================== CREATING gold.fact_sales';

DROP TABLE IF EXISTS gold.fact_sales;

CREATE TABLE gold.fact_sales (
    sales_key INT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(20),
    product_key VARCHAR(20),
    customer_key INT,
    date_key INT,
    order_date DATE,
    ship_date DATE,
    delivery_date DATE,
    price FLOAT,
    quantity INT,
    amount FLOAT,
    FOREIGN KEY (product_key) REFERENCES dim_product (product_key) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (customer_key) REFERENCES dim_customer (customer_key) ON DELETE CASCADE ON UPDATE CASCADE
);

SELECT '============= LOADING DATA INTO gold.fact_sales';

TRUNCATE TABLE gold.fact_sales;

INSERT INTO
    gold.fact_sales (
        order_number,
        product_key,
        customer_key,
        date_key,
        order_date,
        ship_date,
        delivery_date,
        price,
        quantity,
        amount
    )
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    date_format(sls_order_dt, '%Y%m%d'),
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_price,
    sls_quantity,
    sls_sales
FROM silver.sales_details
WHERE
    sls_order_dt IS NOT NULL
    AND sls_sales IS NOT NULL;

SET @time2 = CURRENT_TIME();

SELECT DATE_FORMAT(
        TIMEDIFF(@time2, @time1), '%i:%s'
    ) AS 'TABLE LOADING TIME';

SELECT '===============================================';

SELECT '============ GOLD LAYER COMPLETED =============';

SELECT '===============================================';

SELECT ' ';