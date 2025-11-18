
SELECT '===============================================';
SELECT '=============== SILVER LAYER ==================';
SELECT '===============================================';

SELECT '================ CREATE SCHEMA ================';
DROP SCHEMA IF EXISTS silver;
CREATE SCHEMA silver;

SELECT '-----------------------------------------------';
SELECT '========== CREATE & LOAD CRM TABLES ===========';
SELECT '-----------------------------------------------';

-- =================================
-- CREATE & LOAD TABLE crm_cust_info
-- =================================

SET @time1 = CURRENT_TIME();

SELECT '======================= CREATEING crm_cust_info';
DROP TABLE IF EXISTS silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info(
    cst_id VARCHAR(20),
    cst_key VARCHAR(20),
    cst_firstname VARCHAR(20),
    cst_lastname VARCHAR(20),
    cst_marital_status VARCHAR(10),
    cst_gndr VARCHAR(10),
    cst_create_date VARCHAR(15)
);

SELECT '=============== LOADING DATA INTO crm_cust_info';
TRUNCATE TABLE silver.crm_cust_info;

INSERT INTO silver.crm_cust_info(
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr, 
cst_create_date
)
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE
    WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
    WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
    ELSE 'N/A'
END AS cst_marital_status,
CASE
    WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
    WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
    ELSE 'N/A'
END AS cst_gndr,
cst_create_date
FROM (
    SELECT *,
    CASE
    WHEN cst_id >1 THEN 1
    ELSE 0
    END AS flag_one,
    ROW_NUMBER() OVER(PARTITION BY cst_id ) AS flag_two
    FROM bronze.crm_cust_info
)AS A
WHERE flag_one = 1 AND flag_two = 1;

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

-- ================================
-- CREATE & LOAD TABLE crm_prd_info
-- ================================

SET @time1 = CURRENT_TIME();
SET @days = (SELECT ROUND(AVG(days)) FROM (SELECT DATEDIFF(sls_ship_dt,CAST(sls_order_dt AS DATE)) AS days FROM bronze.crm_sales_details) AS A);

SELECT '======================== CREATEING crm_prd_info';

CREATE TABLE silver.crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(20),
    prd_cate_key VARCHAR(20),
    prd_nm VARCHAR(40),
    prd_cost INT,
    prd_line VARCHAR(20),
    prd_launch_dt DATE,
    prd_last_ord_dt DATE
);

SELECT '================ LOADING DATA INTO crm_prd_info';
TRUNCATE TABLE silver.crm_prd_info;

INSERT INTO silver.crm_prd_info (
    prd_id,
    prd_key,
    prd_cate_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_launch_dt,
    prd_last_ord_dt
)
SELECT 
prd_id,
SUBSTRING(prd_key,7) AS prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS prd_cate_key,
TRIM(prd_nm) AS prd_nm,
IFNULL(prd_cost,0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
    WHEN 'M' THEN 'Mountain'
    WHEN 'R' THEN 'Road'
    WHEN 'T' THEN 'Touring'
    WHEN 'S' THEN 'Other Sales'
    ELSE 'N/A'
END AS prd_line,
CASE 
    WHEN prd_launch_dt IS NULL THEN STR_TO_DATE(prd_start_dt, '%d/%m/%Y')
    ELSE prd_launch_dt
END AS prd_launch_dt,
prd_last_ord_dt
FROM (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY SUBSTRING(prd_key,7)) as flag_one
    FROM bronze.crm_prd_info
    LEFT JOIN (
            SELECT sls_prd_key,
            DATE_SUB(MIN(sls_ship_dt), INTERVAL @days DAY) AS prd_launch_dt,
            DATE_SUB(MAX(sls_ship_dt), INTERVAL @days DAY) AS prd_last_ord_dt
            FROM bronze.crm_sales_details
            GROUP BY sls_prd_key
        ) AS A
    ON SUBSTRING(prd_key,7) = A.sls_prd_key
) AS A
WHERE flag_one = 1;

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

-- =====================================
-- CREATE & LOAD TABLE crm_sales_details
-- =====================================

SET @time1 = CURRENT_TIME();

SELECT '=================== CREATEING crm_sales_details';
DROP TABLE IF EXISTS silver.crm_sales_details; 

CREATE TABLE silver.crm_sales_details (
    sls_ord_num VARCHAR(15),
    sls_prd_key VARCHAR(15),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales FLOAT,
    sls_quantity INT,
    sls_price FLOAT
);

SELECT '=========== LOADING DATA INTO crm_sales_details';
TRUNCATE TABLE silver.crm_sales_details;

INSERT INTO silver.crm_sales_details (
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)
SELECT 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE 
        WHEN sls_order_dt IS NULL OR sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8  THEN 
        DATE_SUB(
            sls_ship_dt, INTERVAL @days DAY
        )
        ELSE CAST(sls_order_dt AS DATE) 
    END AS sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    CASE 
        WHEN sls_sales != sls_quantity * ABS(CAST(sls_price AS FLOAT)) OR
            sls_sales <= 0 OR
            sls_sales IS NULL 
        THEN IF((sls_quantity * ABS(sls_price)) = 0, NULL, sls_quantity * ABS(sls_price))
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE 
        WHEN sls_price = 0 THEN NULL
        ELSE ABS(CAST(sls_price AS FLOAT))
    END AS sls_price
FROM bronze.crm_sales_details;

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

SELECT '-----------------------------------------------';
SELECT '========== CREATE & LOAD ERP TABLES ===========';
SELECT '-----------------------------------------------';

-- ================================
-- CREATE & LOAD TABLE erp_prd_cate
-- ================================

SET @time1 = CURRENT_TIME();

SELECT '======================== CREATEING erp_prd_cate';
DROP TABLE IF EXISTS silver.erp_prd_cate;

CREATE TABLE silver.erp_prd_cate(
    id VARCHAR(10),
    cat VARCHAR(20),
    subcat VARCHAR(20),
    maintenance VARCHAR(10)
);

SELECT '================ LOADING DATA INTO erp_prd_cate';
TRUNCATE TABLE silver.erp_prd_cate;

INSERT INTO silver.erp_prd_cate(
id,
cat,
subcat,
maintenance
)
SELECT 
id,
TRIM(cat) AS cat,
TRIM(subcat) AS subcat,
CASE 
    WHEN maintenance IS NULL THEN 'N/A'
    ELSE TRIM(REPLACE(maintenance,'\r',''))
END AS maintenance
FROM bronze.erp_prd_cate;

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

-- ================================
-- CREATE & LOAD TABLE erp_cust_loc
-- ================================

SET @time1 = CURRENT_TIME();

SELECT '======================== CREATEING erp_cust_loc';
DROP TABLE IF EXISTS silver.erp_cust_loc;

CREATE TABLE silver.erp_cust_loc(
    cid VARCHAR(20),
    cntry VARCHAR(20)
);

SELECT '================ LOADING DATA INTO erp_cust_loc';
TRUNCATE TABLE silver.erp_cust_loc;

INSERT INTO silver.erp_cust_loc(
cid,
cntry
)
SELECT
REPLACE(cid,'-','') AS cid,
CASE REPLACE(TRIM(cntry),'\r','')
    WHEN 'USA' THEN 'United States'
    WHEN 'US' THEN 'United States'
    WHEN 'DE' THEN 'United States'
    WHEN '' THEN 'N/A'
    ELSE REPLACE(TRIM(cntry),'\r','')
END AS cntry
FROM bronze.erp_cust_loc;

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

-- =====================================
-- CREATE & LOAD TABLE erp_cust_per_info
-- =====================================

SET @time1 = CURRENT_TIME();

SELECT '=================== CREATEING erp_cust_per_info';
DROP TABLE IF EXISTS silver.erp_cust_per_info;

CREATE TABLE silver.erp_cust_per_info (
    cid VARCHAR(20),
    bdate DATE,
    gen VARCHAR(10)
);

SELECT '=========== LOADING DATA INTO erp_cust_per_info';
TRUNCATE TABLE silver.erp_cust_per_info;

INSERT INTO silver.erp_cust_per_info(
cid,
bdate,
gen
)
SELECT 
SUBSTRING(cid,4,CHAR_LENGTH(cid)) AS cid,
CASE
    WHEN bdate < '1900-01-01' OR bdate > CURRENT_DATE() THEN NULL
    ELSE bdate
END AS bdate,
CASE 
    WHEN gen IS NULL THEN 'N/A'
    WHEN REPLACE(REPLACE(TRIM(gen),'\r',''),' ','') = 'M' THEN 'Male'
    WHEN REPLACE(REPLACE(TRIM(gen),'\r',''),' ','') = 'F' THEN 'Female'
    WHEN REPLACE(REPLACE(TRIM(gen),'\r',''),' ','') = '' THEN 'N/A'
ELSE REPLACE(REPLACE(TRIM(gen),'\r',''),' ','')
END AS gen
FROM bronze.erp_cust_per_info;

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

SELECT '===============================================';
SELECT '=========== SILVER LAYER COMPLETED ============';
SELECT '===============================================';
SELECT '                                               ';