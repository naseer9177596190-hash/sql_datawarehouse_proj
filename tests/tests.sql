-- Queriesto tesr silver.crm_cust_info

select 
cst_id,
count(*)
from silver.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

-- check for the unwanted spaces first name
SELECT cst_firstname from silver.crm_cust_info
where cst_firstname != trim(cst_firstname)

-- check for the unwanted spaces from last name
SELECT cst_lastname from silver.crm_cust_info
where cst_lastname != trim(cst_lastname)

-- check for the unwanted spaces in gender
SELECT cst_gndr from silver.crm_cust_info
where cst_gndr != trim(cst_gndr)

-- lets check values in gender column
select 
distinct cst_gndr 
from silver.crm_cust_info



  -- Test for silver.crm.prd_info 







--- checking if prd_id has any null or duplicates
SELECT prd_id,
count(*) as prd_id_count from bronze.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null;


-- Check if prd_nm has any unwanted spaces

SELECT prd_nm
from bronze.crm_prd_info
where prd_nm != Trim(prd_nm)

-- Check of prd_cost has any null 

SELECT prd_cost
from bronze.crm_prd_info
where prd_cost IS NULL;



-- Lets check if the start date is less than end date


SELECT * from bronze.crm_prd_info
where prd_start_dt < prd_end_dt;

-- lets check values in maritalstatus column
select 
distinct cst_marital_status 
from silver.crm_cust_info



 -- tests for silver.crm_sales_info

-- check for invalid dates for order date
SELECT 
sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <=0 or len(sls_order_dt) !=8 or sls_ord_num is null

-- check for invalid dates for shipped date
SELECT 
sls_ship_dt
from bronze.crm_sales_details
where sls_ship_dt <=0 or len(sls_ship_dt) !=8 or sls_ord_num is null

-- check for invalid dates for due date
SELECT 
sls_due_dt
from bronze.crm_sales_details
where sls_due_dt <=0 or len(sls_due_dt) !=8 or sls_ord_num is null
-- check the sales values are null

SELECT * from bronze.crm_sales_details
where sls_sales is null or sls_sales != sls_quantity* sls_price;

SELECT * from bronze.crm_sales_details
where sls_price is null or sls_price != sls_sales/ sls_quantity;

SELECT * from bronze.crm_sales_details
where sls_quantity is null or sls_quantity != sls_sales/ sls_price;
