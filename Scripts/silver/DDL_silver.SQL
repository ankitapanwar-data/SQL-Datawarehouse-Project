/*
***********************************************************************************
DDL Script : Create Silver Tables 
***********************************************************************************

Script purpose:
    This script creates tables in the 'silver' schema,dropping existing
     tables if they already exists.
    Run this script to re-define the DDL structure of 'silver' Tables

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
                        cst_create_date     date,
                        dwh_create_date     datetime2 default getdate());
 go


 if object_id('silver.crm_prod_info', 'u') is not null
          drop table  silver.crm_prod_info
go
 create table silver.crm_prod_info(
                        prd_id          int null,
                        cat_id          nvarchar(50) null ,
                        prd_key         nvarchar(50) null,
                        prd_nm          nvarchar(50) null,
                        prd_cost        int null,
                        prd_line        nvarchar(50) null,
                        prd_start_dt    date null,
                        prd_end_dt      date null,
                        dwh_create_date datetime2 default getdate() null );
go



if object_id('silver.crm_sales_details', 'u') is not null
          drop table  silver.crm_sales_details
 go         
create table silver.crm_sales_details(
                        sls_ord_num     nvarchar(50) null,
                        sls_prd_key     nvarchar(50) null,
                        sls_cust_id     int null,
                        sls_order_dt    date null, 
                        sls_ship_dt     date null ,
                        sls_due_dt      date null ,
                        sls_sales       int null,
                        sls_quantity    int null,
                        sls_price       int  null  ,                    
                        dwh_create_date datetime2 default getdate());
go



if object_id('silver.erp_cust_country', 'u') is not null
          drop table  silver.erp_cust_country
go          
create table silver.erp_cust_country(
                        cid             nvarchar (50) null,
                        cntry           nvarchar (50) null, 
                        dwh_create_date datetime2 default getdate());
go




if object_id('silver.erp_cust_bdate', 'u') is not null
          drop table  silver.erp_cust_bdate
go          
  create table silver.erp_cust_bdate(
                        cid             nvarchar (50) null,
                        bdate           date null,
                        gen             nvarchar (50) null ,
                        dwh_create_date datetime2 default getdate());
go




if object_id('silver.erp_prod_maint', 'u') is not null
          drop table silver.erp_prod_maint
go          
create table silver.erp_prod_maint(
                        id              nvarchar (50),
                        cat             nvarchar (50),
                        subcat          nvarchar (50),
                        maintenance     nvarchar (50)  ,
                        dwh_create_date datetime2 default getdate());
go



