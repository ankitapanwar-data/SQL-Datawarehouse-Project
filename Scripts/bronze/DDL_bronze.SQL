/*
***********************************************************************************
DDL Script : Create Bronze Tables 
***********************************************************************************

Script purpose:
    This script creates tables in the 'bronze' schema,dropping existing
     tables if they already exists.
    Run this script to re-define the DDL structure of 'bronze' Tables

***********************************************************************************
*/


if object_id('silver.crm_cust_info', 'u') is not null
          drop table  silver.crm_cust_info
  go    

create table silver.crm_cust_info(
                        cst_id              int,
                        cst_key             nvarchar(50),
                        cst_firstname       nvarchar(50),
                        cst_lastname        nvarchar(50),
                        cst_marital_status  nvarchar(50),
                        cst_gndr            nvarchar(50),
                        cst_create_date     date
);
 go 



 if object_id('silver.crm_prod_info', 'u') is not null
          drop table  silver.crm_prod_info
go

 create table silver.crm_prod_info(
                        prd_id         int,
                        prd_key        nvarchar(50),
                        prd_nm         nvarchar(50),
                        prd_cost       int,
                        prd_line       nvarchar(50),
                        prd_start_dt   datetime,
                        prd_end_dt     datetime  
 );
go



if object_id('silver.crm_sales_details', 'u') is not null
          drop table  silver.crm_sales_details
 go    

create table silver.crm_sales_details(
                        sls_ord_num  nvarchar(50),
                        sls_prd_key  nvarchar(50),
                        sls_cust_id  int,
                        sls_order_dt int, 
                        sls_ship_dt  int,
                        sls_due_dt   int,
                        sls_sales    int,
                        sls_quantity int,
                        sls_price    int 
);



if object_id('silver.erp_cust_country', 'u') is not null
          drop table  silver.erp_cust_country
 go 

create table silver.erp_cust_country(
                        cid   nvarchar (50),
                        cntry nvarchar (50)
 );
go



if object_id('silver.erp_cust_bdate', 'u') is not null
          drop table  silver.erp_cust_bdate
 go

  create table silver.erp_cust_bdate(
                        cid   nvarchar (50),
                        bdate date,
                        gen   nvarchar (50)
);
go



if object_id('silver.erp_prod_maint', 'u') is not null
          drop table silver.erp_prod_maint
 go

create table silver.erp_prod_maint(
                        id          nvarchar (50),
                        cat         nvarchar (50),
                        subcat      nvarchar (50),
                        maintenance nvarchar (50)
 );
go
