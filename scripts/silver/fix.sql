--fix crm_cust_info

INSERT INTO silver.crm_cust_info(
cst_id             ,
    cst_key            ,
    cst_firstname      ,
    cst_lastname       ,
    cst_marital_status ,
    cst_gndr          ,
    cst_create_date   
    )
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname,
TRIM(cst_lastname) as cst_lastname,
CASE 
  when trim(upper(cst_marital_status)) = 'S' then 'Single'
  when trim(upper(cst_marital_status)) = 'M' then 'Married'
else 'n/a'
end as cst_marital_status,
CASE
  when trim(upper(cst_gndr)) = 'M' then 'Male'
  when trim(upper(cst_gndr)) = 'F' then 'Female'
else 'n/a'
end as cst_gndr,
cst_create_date
FROM
(
SELECT 
*,
ROW_NUMBER() over(
partition by cst_id
order by cst_create_date desc) as flag_last
from bronze.crm_cust_info
) as T
where flag_last = 1 and cst_id is not null;


-- query for silver.crm_prd_info


insert into silver.crm_prd_info(
cat_id,
prd_key,
prd_id,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)

SELECT
REPLACE( SUBSTRING(prd_key,1,5),'-','_') as cat_id,
SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
prd_id,
prd_nm,
ISNULL(prd_cost,0) as prd_cost,
CASE
  when UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
  when UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
  when UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
  when UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
else 'n/a'
END as prd_line,
cast (prd_start_dt as date) as prd_start_dt,
CAST(lead(prd_start_dt) over ( partition by prd_key order by prd_start_dt) -1 as DATE)
as PRD_END_dt
FROM bronze.crm_prd_info;





---query for silver.crm_sales_info

INSERT into silver.crm_sales_details(
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
case 
  when sls_order_dt = 0 or len(sls_order_dt) !=8 then NULL
  ELSE CAST(CAST(sls_order_dt as varchar) as DATE)
end as sls_order_dt,
case 
  when sls_ship_dt = 0 or len(sls_ship_dt) !=8 then NULL
  ELSE CAST(CAST(sls_ship_dt as varchar) as DATE)
end as sls_ship_dt,
case 
  when sls_due_dt = 0 or len(sls_due_dt) !=8 then NULL
  ELSE CAST(CAST(sls_due_dt as varchar) as DATE)
end as sls_due_dt,
CASE 
 when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity *ABS(sls_price) 
 then sls_quantity * ABS(sls_price)
else sls_sales
end as sls_sales,
sls_quantity,
CASE
 when sls_price is null or sls_price <=0
 then sls_sales/sls_quantity
else sls_price
end as sls_price
from bronze.crm_sales_details;


