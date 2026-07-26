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

-- lets check values in maritalstatus column
select 
distinct cst_marital_status 
from silver.crm_cust_info
