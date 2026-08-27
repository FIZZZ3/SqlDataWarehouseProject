create database DataWarehouse
use DataWarehouse
create schema bronze;
create schema silver;
create schema gold;


DROP TABLE IF EXISTS bronze.crm_cust_info;
create table bronze.crm_cust_info(
cst_id int,
cst_key varchar(50),
cst_firstname varchar(50),
cst_lastname varchar(50),
cst_material_status varchar(50),
cst_gndr varchar(50),
cst_create_date date
)


drop table if exists bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info
(
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt datetime,
    prd_end_dt datetime
);

DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

drop table if exists bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
    cid VARCHAR,
    cntry VARCHAR
);

drop table if exists bronze.erp_cust_az12 ;
CREATE TABLE bronze.erp_cust_az12 (
    cid VARCHAR,
    bdate DATE,
    gen VARCHAR
);

drop table if exists bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
);


select * from bronze.crm_sales_details

TRUNCATE TABLE bronze.crm_cust_info;

BULK INSERT bronze.crm_cust_info
FROM 'D:\SQL_Project\source_crm\cust_info.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"'
);

select * from bronze.crm_cust_info

-- CRM Product Information
TRUNCATE TABLE bronze.crm_prd_info;

BULK INSERT bronze.crm_prd_info
FROM 'D:\SQL_Project\source_crm\prd_info.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"'
);
select * from bronze.crm_prd_info

-- CRM Sales Details
TRUNCATE TABLE bronze.crm_sales_details;

BULK INSERT bronze.crm_sales_details
FROM 'D:\SQL_Project\source_crm\sales_details.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"'
);
select * from bronze.crm_sales_details

-- ERP Customer
TRUNCATE TABLE bronze.erp_cust_az12;

BULK INSERT bronze.erp_cust_az12
FROM 'D:\SQL_Project\source_erp\CUST_AZ12.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"'
);
select * from bronze.erp_cust_az12



sp_help 'bronze.erp_cust_az12';

SELECT TOP 10 *
FROM bronze.erp_cust_az12;

ALTER TABLE bronze.erp_cust_az12
ALTER COLUMN cid VARCHAR(50);

ALTER TABLE bronze.erp_cust_az12
ALTER COLUMN gen VARCHAR(10);

TRUNCATE TABLE bronze.erp_loc_a101;

BULK INSERT bronze.erp_loc_a101
FROM 'D:\SQL_Project\source_erp\LOC_A101.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"'
);

ALTER TABLE bronze.erp_loc_a101
ALTER COLUMN cid VARCHAR(50);

alter table bronze.erp_loc_a101
alter column cntry varchar(50)

select * from bronze.erp_loc_a101

-- ERP Product Category
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

BULK INSERT bronze.erp_px_cat_g1v2
FROM 'D:\SQL_Project\source_erp\PX_CAT_G1V2.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"'
);
select * from bronze.erp_px_cat_g1v2

SELECT 'crm_cust_info' AS table_name, COUNT(*) AS row_count
FROM bronze.crm_cust_info

UNION ALL

SELECT 'crm_prd_info', COUNT(*)
FROM bronze.crm_prd_info

UNION ALL

SELECT 'crm_sales_details', COUNT(*)
FROM bronze.crm_sales_details

UNION ALL

SELECT 'erp_cust_az12', COUNT(*)
FROM bronze.erp_cust_az12

UNION ALL

SELECT 'erp_loc_a101', COUNT(*)
FROM bronze.erp_loc_a101

UNION ALL

SELECT 'erp_px_cat_g1v2', COUNT(*)
FROM bronze.erp_px_cat_g1v2;


CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        PRINT '========================================';
        PRINT 'Loading Bronze Layer';
        PRINT '========================================';


        -- CRM: Customer Information
        PRINT 'Loading bronze.crm_cust_info...';

        TRUNCATE TABLE bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM 'D:\SQL_Project\source_crm\cust_info.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"'
        );


        -- CRM: Product Information
        PRINT 'Loading bronze.crm_prd_info...';

        TRUNCATE TABLE bronze.crm_prd_info;

        BULK INSERT bronze.crm_prd_info
        FROM 'D:\SQL_Project\source_crm\prd_info.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"'
        );


        -- CRM: Sales Details
        PRINT 'Loading bronze.crm_sales_details...';

        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM 'D:\SQL_Project\source_crm\sales_details.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"'
        );


        -- ERP: Customer
        PRINT 'Loading bronze.erp_cust_az12...';

        TRUNCATE TABLE bronze.erp_cust_az12;

        BULK INSERT bronze.erp_cust_az12
        FROM 'D:\SQL_Project\source_erp\CUST_AZ12.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"'
        );


        -- ERP: Location
        PRINT 'Loading bronze.erp_loc_a101...';

        TRUNCATE TABLE bronze.erp_loc_a101;

        BULK INSERT bronze.erp_loc_a101
        FROM 'D:\SQL_Project\source_erp\LOC_A101.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"'
        );


        -- ERP: Product Category
        PRINT 'Loading bronze.erp_px_cat_g1v2...';

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'D:\SQL_Project\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"'
        );


        PRINT '========================================';
        PRINT 'Bronze Layer loaded successfully!';
        PRINT '========================================';

    END TRY

    BEGIN CATCH

        PRINT '========================================';
        PRINT 'ERROR OCCURRED WHILE LOADING BRONZE';
        PRINT '========================================';

        PRINT ERROR_MESSAGE();

    END CATCH
END;
GO

EXEC bronze.load_bronze;

SELECT 'crm_cust_info' AS table_name, COUNT(*) AS row_count
FROM bronze.crm_cust_info

UNION ALL

SELECT 'crm_prd_info', COUNT(*)
FROM bronze.crm_prd_info

UNION ALL

SELECT 'crm_sales_details', COUNT(*)
FROM bronze.crm_sales_details

UNION ALL

SELECT 'erp_cust_az12', COUNT(*)
FROM bronze.erp_cust_az12

UNION ALL

SELECT 'erp_loc_a101', COUNT(*)
FROM bronze.erp_loc_a101

UNION ALL

SELECT 'erp_px_cat_g1v2', COUNT(*)
FROM bronze.erp_px_cat_g1v2;


DECLARE @StartTime DATETIME2 = SYSDATETIME();

EXEC bronze.load_bronze;

SELECT 
    DATEDIFF(MILLISECOND, @StartTime, SYSDATETIME()) AS ExecutionTimeMs,
    DATEDIFF(SECOND, @StartTime, SYSDATETIME()) AS ExecutionTimeSeconds;
