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
