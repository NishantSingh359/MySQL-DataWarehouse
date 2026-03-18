
SELECT '===============================================';
SELECT '================== BORNZE LAYER ===============';
SELECT '===============================================';

SELECT '================ CREATE SCHEMA ================';
DROP SCHEMA IF EXISTS bronze;
CREATE SCHEMA bronze;


SELECT '-----------------------------------------------';
SELECT '========== CREATE & LOAD CRM TABLES ===========';
SELECT '-----------------------------------------------';

SET @crm_time1 = CURRENT_TIME();

-- =================================
-- CREATE & LOAD TABLE cust_info
-- =================================

SET @time1 = CURRENT_TIME();

SELECT '=========================== CREATING cust_info';
DROP TABLE IF EXISTS bronze.cust_info;

CREATE TABLE bronze.cust_info(
    cst_id VARCHAR(20),
    cst_key VARCHAR(20),
    cst_firstname VARCHAR(20),
    cst_lastname VARCHAR(20),
    cst_marital_status VARCHAR(5),
    cst_gndr VARCHAR(5),
    cst_create_date VARCHAR(15)
);

SELECT '=================== LOADING DATA INTO cust_info';
TRUNCATE TABLE bronze.cust_info;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
INTO TABLE bronze.cust_info
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

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

-- ================================
-- CREATE & LOAD TABLE prd_info
-- ================================

SET @time1 = CURRENT_TIME();

SELECT '=========================== CREATING cust_info';
DROP TABLE IF EXISTS bronze.prd_info;

CREATE TABLE bronze.prd_info (
    prd_id INT,
    prd_key VARCHAR(20),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(5),
    prd_start_dt TEXT,
    prd_end_dt TEXT
);

SELECT '==================== LOADING DATA INTO prd_info';
TRUNCATE TABLE bronze.prd_info;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
INTO TABLE bronze.prd_info
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

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

-- =====================================
-- CREATE & LOAD TABLE sales_details
-- =====================================

SET @time1 = CURRENT_TIME();

SELECT '======================= CREATING sales_details';
DROP TABLE IF EXISTS bronze.sales_details; 


CREATE TABLE bronze.sales_details (
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

SELECT '=============== LOADING DATA INTO sales_details';
TRUNCATE TABLE bronze.sales_details;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
INTO TABLE bronze.sales_details
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

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

SET @crm_time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@crm_time2, @crm_time1), '%i:%s') AS 'CRM TABLES LOADING TIME';


SELECT '-----------------------------------------------';
SELECT '========== CREATE & LOAD ERP TABLES ===========';
SELECT '-----------------------------------------------';

SET @erp_time1 = CURRENT_TIME();

-- ================================
-- CREATE & LOAD TABLE prd_cate
-- ================================

SET @time1 = CURRENT_TIME();

SELECT '============================ CREATING prd_cate';
DROP TABLE IF EXISTS bronze.prd_cate;

CREATE TABLE bronze.prd_cate(
    id VARCHAR(10),
    cat VARCHAR(20),
    subcat VARCHAR(20),
    maintenance VARCHAR(10)
);

SELECT '==================== LOADING DATA INTO prd_cate';
TRUNCATE TABLE bronze.prd_cate;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_cate.csv'
INTO TABLE bronze.prd_cate
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

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

-- ================================
-- CREATE & LOAD TABLE cust_loc
-- ================================

SET @time1 = CURRENT_TIME();

SELECT '============================ CREATING cust_loc';
DROP TABLE IF EXISTS bronze.cust_loc;

CREATE TABLE bronze.cust_loc(
    cid VARCHAR(20),
    cntry VARCHAR(20)
);

SELECT '==================== LOADING DATA INTO cust_loc';
TRUNCATE TABLE bronze.cust_loc;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_loc.csv'
INTO TABLE bronze.cust_loc
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cid, @cntry)
SET
cid = NULLIF(@cid,''),
cntry = NULLIF(@cntry,'');

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

-- =====================================
-- CREATE & LOAD TABLE cust_per_info
-- =====================================

SET @time1 = CURRENT_TIME();

SELECT '======================= CREATING cust_per_info';
DROP TABLE IF EXISTS bronze.cust_per_info;

CREATE TABLE bronze.cust_per_info (
    cid VARCHAR(20),
    bdate DATE,
    gen VARCHAR(10)
);

SELECT '=============== LOADING DATA INTO cust_per_info';
TRUNCATE TABLE bronze.cust_per_info;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_per_info.csv'
INTO TABLE bronze.cust_per_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cid, @bdate, @gen)
SET
cid = NULLIF(@cid,''),
bdate = NULLIF(@bdate,''),
gen = NULLIF(@gen,'');

SET @time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@time2, @time1),'%i:%s') AS 'TABLE LOADING TIME';

SET @erp_time2 = CURRENT_TIME();
SELECT DATE_FORMAT(TIMEDIFF(@erp_time2, @erp_time1), '%i:%s') AS 'ERP TABLES LOADING TIME';

SELECT '===============================================';
SELECT '=========== BORNZE LAYER COMPLETED ============';
SELECT '===============================================';
SELECT '                                               '; 