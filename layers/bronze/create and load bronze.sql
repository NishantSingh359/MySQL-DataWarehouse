
SELECT '===============================================';
SELECT '================== BORNZE LAYER ===============';
SELECT '===============================================';

SELECT '================ CREATE SCHEMA ================';
DROP SCHEMA IF EXISTS bronze;
CREATE SCHEMA bronze;

SELECT '-----------------------------------------------';
SELECT '========== CREATE & LOAD CRM TABLES ===========';
SELECT '-----------------------------------------------';

-- =================================
-- CREATE & LOAD TABLE crm_cust_info
-- =================================

SELECT '======================= CREATEING crm_cust_info';
DROP TABLE IF EXISTS bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info(
    cst_id VARCHAR(20),
    cst_key VARCHAR(20),
    cst_firstname VARCHAR(20),
    cst_lastname VARCHAR(20),
    cst_marital_status VARCHAR(5),
    cst_gndr VARCHAR(5),
    cst_create_date VARCHAR(15)
);

SELECT '=============== LOADING DATA INTO crm_cust_info';
TRUNCATE TABLE bronze.crm_cust_info;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/crm_cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cst_id, @cst_key, @cst_firstname, @cst_lastname, @cst_marital_status, @cst_gndr, @cst_create_date)
SET
cst_id = NULLIF(@cst_id, ''),
cst_key = NULLIF(@cst_key, ''),
cst_firstname = NULLIF(@cst_firstname, ''),
cst_lastname = NULLIF(@cst_lastname, ''),
cst_marital_status = NULLIF(@cst_marital_status, ''),
cst_gndr = NULLIF(@cst_gndr, ''),
cst_create_date = NULLIF(@cst_create_date, '');

-- ================================
-- CREATE & LOAD TABLE crm_prd_info
-- ================================

SELECT '======================= CREATEING crm_cust_info';
DROP TABLE IF EXISTS bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(20),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(5),
    prd_start_dt TEXT,
    prd_end_dt TEXT
);

SELECT '================ LOADING DATA INTO crm_prd_info';
TRUNCATE TABLE bronze.crm_prd_info;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/crm_prd_info.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@prd_id, @prd_key, @prd_nm, @prd_cost, @prd_line, @prd_start_dt, @prd_end_dt)
SET
prd_id = NULLIF(@prd_id,''),
prd_key = NULLIF(@prd_key,''),
prd_nm = NULLIF(@prd_nm,''),
prd_cost = NULLIF(@prd_cost,''),
prd_line = NULLIF(@prd_line,''),
prd_start_dt = NULLIF(@prd_start_dt,''),
prd_end_dt = NULLIF(@prd_end_dt,NULL);

-- =====================================
-- CREATE & LOAD TABLE crm_sales_details
-- =====================================

SELECT '=================== CREATEING crm_sales_details';
DROP TABLE IF EXISTS bronze.crm_sales_details; 


CREATE TABLE bronze.crm_sales_details (
    sls_ord_num VARCHAR(15),
    sls_prd_key VARCHAR(15),
    sls_cust_id INT,
    sls_order_dt TEXT,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales FLOAT,
    sls_quantity INT,
    sls_price TEXT
);

SELECT '=========== LOADING DATA INTO crm_sales_details';
TRUNCATE TABLE bronze.crm_sales_details;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/crm_sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@sls_ord_num, @sls_prd_key, @sls_cust_id, @sls_order_dt, @sls_ship_dt, @sls_due_dt, @sls_sales, @sls_quantity, @sls_price)
SET
sls_ord_num = NULLIF(@sls_ord_num,''),
sls_prd_key = NULLIF(@sls_prd_key,''),
sls_cust_id = NULLIF(@sls_cust_id,''),
sls_order_dt = NULLIF(@sls_order_dt,''),
sls_ship_dt = NULLIF(@sls_ship_dt,''),
sls_due_dt = NULLIF(@sls_due_dt,''),
sls_sales = NULLIF(@sls_sales,''),
sls_quantity = NULLIF(@sls_quantity,''),
sls_price = NULLIF(@sls_price,'');

SELECT '-----------------------------------------------';
SELECT '========== CREATE & LOAD ERP TABLES ===========';
SELECT '-----------------------------------------------';

-- ================================
-- CREATE & LOAD TABLE erp_prd_cate
-- ================================

SELECT '======================== CREATEING erp_prd_cate';
DROP TABLE IF EXISTS bronze.erp_prd_cate;

CREATE TABLE bronze.erp_prd_cate(
    id VARCHAR(10),
    cat VARCHAR(20),
    subcat VARCHAR(20),
    maintenance VARCHAR(10)
);

SELECT '================ LOADING DATA INTO erp_prd_cate';
TRUNCATE TABLE bronze.erp_prd_cate;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/erp_prd_cate.csv'
INTO TABLE bronze.erp_prd_cate
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@id, @cat, @subcat, @maintenance)
SET 
id = NULLIF(@id,''),
cat = NULLIF(@cat,''),
subcat = NULLIF(@subcat,''),
maintenance = NULLIF(@maintenance,'');

-- ================================
-- CREATE & LOAD TABLE erp_cust_loc
-- ================================

SELECT '======================== CREATEING erp_cust_loc';
DROP TABLE IF EXISTS bronze.erp_cust_loc;

CREATE TABLE bronze.erp_cust_loc(
    cid VARCHAR(20),
    cntry VARCHAR(20)
);

SELECT '================ LOADING DATA INTO erp_cust_loc';
TRUNCATE TABLE bronze.erp_cust_loc;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/erp_cust_loc.csv'
INTO TABLE bronze.erp_cust_loc
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cid, @cntry)
SET
cid = NULLIF(@cid,''),
cntry = NULLIF(@cntry,'');

-- =====================================
-- CREATE & LOAD TABLE erp_cust_per_info
-- =====================================

SELECT '=================== CREATEING erp_cust_per_info';
DROP TABLE IF EXISTS bronze.erp_cust_per_info;

CREATE TABLE bronze.erp_cust_per_info (
    cid VARCHAR(20),
    bdate DATE,
    gen VARCHAR(10)
);

SELECT '=========== LOADING DATA INTO erp_cust_per_info';
TRUNCATE TABLE bronze.erp_cust_per_info;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/erp_cust_per_info.csv'
INTO TABLE bronze.erp_cust_per_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cid, @bdate, @gen)
SET
cid = NULLIF(@cid,''),
bdate = NULLIF(@bdate,''),
gen = NULLIF(@gen,'');

SELECT '===============================================';
SELECT '=========== BORNZE LAYER COMPLETED ============';
SELECT '===============================================';
SELECT '                                               '; 