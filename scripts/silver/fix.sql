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










--- insert the data into silver.erp_cust_az12


insert into silver.erp_cust_az12(
cid,
bdate,
gen
)
SELECT 
CASE 
 when cid like 'NAS%' then SUBSTRING(cid,4,len(cid))
 else cid
end as cid,
CASE 
 when bdate > getdate() or bdate < '1926-01-01' then null
 else bdate
end as bdate,
CASE
 when upper(trim(gen)) in ('F','FEMALE') then 'Female'
 when upper(trim(gen)) in ('M','MALE') then 'Male'
 else 'n/a'
end as gen
from bronze.erp_cust_az12;




-- inserting the data  in silver.erp_loc_a101


INSERT into silver.erp_loc_a101
(
cid,
cntry
)
select 
replace(cid,'-','') as cid,
case
 when trim(cntry) = 'DE' then 'Germany'
 when trim(cntry) in ('US','USA') then 'United States'
 when trim(cntry) = '' or cntry is null then 'n/a'
 else trim(cntry)
end as cntry
from bronze.erp_loc_a101;

select * from silver.erp_loc_a101;



-- inserting into silver.erp_px_cat_g1v2



INSERT INTO  silver.erp_px_cat_g1v2(
id,
cat,
subcat,
maintenance)
select 
id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2;
