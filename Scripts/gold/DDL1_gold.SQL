/*
********************************************************************************************************
DDL Script : Create Gold Views
********************************************************************************************************
Script Purpose :
    This script creates views for the gold layer in the data warehouse.
	The Gold Layer represents the final dimensions and fact tables (Star Schema)
    Eaach view performs transformations and combines data from the Silver layer tp produce a 
	clean, enriched,and business-ready dataset.


Usage:
     - These views can be queried directly for analytics and reporting.

*******************************************************************************************************
*/ 



---****************************************************************************************************
 --Create Dimension : gold.dim_customers
---****************************************************************************************************

if object_id('gold_dim_customers' , 'v' )  is not null
		drop view gold.dim_customers ;
		go

create view gold_dim_customers as 
select 
row_number() over(order by cst_id) as customer_key,
ci.cst_id             as customer_id,
ci.cst_key            as customer_number,
ci.cst_firstname      as first_name,
ci.cst_lastname       as last_name,
cic.cntry             as country ,
ci.cst_marital_status as martial_status,
case when ci.cst_gndr <> 'N/A' THEN ci.cst_gndr  --CRM IS the master for gender info 
	else coalesce(cib.gen,'N/A')                --Filing the gen value into NA cell of master table
	end as gender ,                             --DATA Intregation
cib.bdate             as birthdate,
ci.cst_create_date    as  create_date
from silver.crm_cust_info ci
left join  silver.erp_cust_bdate cib
on ci.cst_key = cib.cid
left join silver.erp_cust_country cic
on ci.cst_key = cic.cid

go





---****************************************************************************************************
 --Create Dimension : gold.dim_products
---****************************************************************************************************

if object_id('gold_dim_products' , 'v' )  is not null
		drop view gold.dim_products ;
		go

create view gold_dim_products as 
select 
row_number() over(order by prd_start_dt,prd_key)
                as product_key,    ---surrogate the row_number column for after joing the table
cp.prd_id       as product_id,
cp.prd_key      as product_number,
prd_nm          as product_name,
cp.cat_id       as category_id,
ep.cat          as category,
ep.subcat       as subcategory,
ep.maintenance  as maintaenance,
cp.prd_cost     as product_cost,
cp.prd_line     as product_line,
cp.prd_start_dt as start_date 
from silver.crm_prod_info cp
left join silver.erp_prod_maint ep
on  cp.cat_id = ep.id 
where cp.prd_end_dt is null

go



---****************************************************************************************************
 --Create Fact Tables : gold.fact_sales
---****************************************************************************************************

if object_id('gold_fact_sales' , 'v' )  is not null
		drop view gold.fact_sales ;
		go

create view gold_fact_sales as 
select 
s.sls_ord_num    as order_number ,
dp.product_key,        --replace the sls_prd_key to surrogate product_key(JOINING DIM=FACT table)
dc.customer_key,       --replace the sls_cust_id to surrogate customer_key(JOINING DIM=FACT table)
s.sls_order_dt   as order_date,
s.sls_ship_dt    as shipping_date,
s.sls_due_dt     as due_date,
s.sls_sales      as sales_amount,
s.sls_quantity   as quantity,
s.sls_price      as price
from silver.crm_sales_details s
left join gold_dim_products dp
on s.sls_prd_key = dp.product_number --join with surrogate column of dim_custumers table
left join gold_dim_customers dc  --join with surrogate column of dim_products table
on s.sls_cust_id = dc.customer_id 

go



