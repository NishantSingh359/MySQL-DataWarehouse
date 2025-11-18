
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
    marital_status VARCHAR(20),
    country VARCHAR(20),
    birthdate DATE
);

SELECT '=========== LOADING DATA INTO gold.dim_customer';
TRUNCATE TABLE gold.dim_customer;

INSERT INTO gold.dim_customer( 
    customer_key,
    first_name,
    last_name,
    gender,
    marital_status,
    country,
    birthdate
)
SELECT
    SUBSTRING(cst_key,6),
    cst_firstname,
    cst_lastname,
    CASE 
        WHEN cst_gndr = 'N/A' THEN IF(gen IS NULL, 'N/A',gen)
        ELSE cst_gndr
    END AS cst_gndr,
    cst_marital_status,
    cntry,
    bdate
FROM silver.crm_cust_info
LEFT JOIN silver.erp_cust_loc
ON silver.crm_cust_info.cst_key = silver.erp_cust_loc.cid
LEFT JOIN silver.erp_cust_per_info
ON silver.crm_cust_info.cst_key = silver.erp_cust_per_info.cid;

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

-- ===============================
-- CREATE & LOAD TABLE dim_product
-- ===============================

SET @time1 = CURRENT_TIME();

SELECT '===================== CREATING gold.dim_product';
DROP TABLE IF EXISTS gold.dim_product;

CREATE TABLE gold.dim_product(
    product_key VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    product_line VARCHAR(20),
    maintenance VARCHAR(20),
    cost FLOAT,
    launch_date DATE,
    last_order_date DATE
);

SELECT '============ LOADING DATA INTO gold.dim_product';
TRUNCATE TABLE gold.dim_product;

INSERT INTO gold.dim_product(
    product_key,
    product_name,
    category,
    subcategory,
    product_line,
    maintenance,
    cost,
    launch_date,
    last_order_date
)
SELECT 
    prd_key,
    prd_nm,
    cat,
    subcat,
    prd_line,
    maintenance,
    prd_cost,
    prd_launch_dt,
    prd_last_ord_dt
FROM silver.crm_prd_info
LEFT JOIN silver.erp_prd_cate
ON silver.crm_prd_info.prd_cate_key = silver.erp_prd_cate.id;

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

-- ==============================
-- CREATE & LOAD TABLE fact_sales
-- ==============================

SET @time1 = CURRENT_TIME();

SELECT '====================== CREATING gold.fact_sales';
DROP TABLE IF EXISTS gold.fact_sales;

CREATE TABLE gold.fact_sales(
    sales_key INT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(20),
    product_keys VARCHAR(20), 
    customer_keys INT,
    order_date DATE,
    ship_date DATE,
    delivery_date DATE,
    price FLOAT,
    quantity INT,
    amount FLOAT,
    FOREIGN KEY (product_keys) REFERENCES dim_product(product_key)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (customer_keys) REFERENCES dim_customer(customer_key)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

SELECT '============= LOADING DATA INTO gold.fact_sales';
TRUNCATE TABLE gold.fact_sales;
INSERT INTO gold.fact_sales(
    order_number,
    product_keys,
    customer_keys,
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
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_price,
    sls_quantity,
    sls_sales
FROM silver.crm_sales_details;

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

SELECT '===============================================';
SELECT '============ GOLD LAYER COMPLETED =============';
SELECT '===============================================';
SELECT '                                               ';
