use datawarehouse;
create schema gold;

-- creating dimensions table

create view gold.dim_customers as 
select 
	ROW_NUMBER() over ( order by cst_id) as customer_key ,-- surrogate key 
	ci.cst_id							 as customer_id,
	ci.cst_key							 as customer_number,
	ci.cst_firstname					 as first_name,
	ci.cst_lastname						 as last_name,
	la.cntry							 as country,
	ci.cst_marital_status				 as marital_status,
	CASE 
	  when ci.cst_gndr != 'n/a' then ci.cst_gndr -- crm is the primary source for gender
	  else coalesce(ca.gen,'n/a')
	end									 as gender,
	ca.bdate							 as birthdate,
	ci.cst_create_date					 as create_date
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
    on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
    on ci.cst_key = la.cid;


select * from gold.dim_customers;



-- creating dimenssions table

create view gold.dim_products as 
SELECT 
	ROW_NUMBER() over (order by pn.prd_start_dt, pn.prd_key) as product_key,--su
	pn.prd_id		as product_id,
	pn.prd_key		as product_number,
	pn.prd_nm		as product_name,
	pn.cat_id		as category_id,
	pc.cat			as category,
	pc.subcat		as subcategory,
	pc.maintenance	as maintenance,
	pn.prd_cost		as cost,
	pn.prd_line		as product_line,
	pn.prd_start_dt	as start_date
from silver.crm_prd_info pn
left join silver.erp_px_cat_g1v2 pc
	on pn.cat_id=pc.id
where pn.prd_end_dt is null;


select * from gold.dim_products;


-- creating fact table

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
select * from  gold.fact_sales;
