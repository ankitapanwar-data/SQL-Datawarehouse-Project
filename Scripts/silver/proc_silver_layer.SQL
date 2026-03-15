/*
****************************************************************************************************
Stored Procedure : Load Silver (Source -> Silver)

****************************************************************************************************
Script Purpose :
    This stored procedure performs the ETL (Extract,Transform,Load) process tp populate the 
    'silver' schema tables from 'bronze' schema.
   Actions Performs:
    - Truncates the silver tables.
    - Insert transformed and cleaned data ffrom Bronze into Silver tables.

Parameters :
 None.
 This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC silver.load_second_layer ;

********************************************************************************************************
*/


create or alter procedure silver.load_second_layer as
begin
    declare @start_time datetime2,
            @end_time datetime2,
            @start_batch_time datetime2,
            @end_batch_time datetime2;
begin try 
    set  @start_batch_time = getdate()
    print'**********************************************************************************'
    print 'Loading Silver Layer'
    print'**********************************************************************************'


    print'=================================================================================='
    print 'Loading CRM Tables'
    print'=================================================================================='


set @start_time = getdate();
print '>>>Truncating the Table : silver.crm_cust_info';
truncate table silver.crm_cust_info;

print '>>>Inserting Data Into : silver.crm_cust_info';
insert into silver.crm_cust_info
            (cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr
      ,cst_create_date)
select 
cst_id,
cst_key,
trim(cst_firstname) cst_firstname,
trim(cst_lastname) cst_lastname,
case when upper(trim(cst_marital_status)) = 'M' then 'Married' 
     when upper(trim(cst_marital_status)) = 'S' then 'Single'
     else 'N/A' end as cst_martial_status,
case when upper(trim(cst_gndr)) = 'F' then 'Female' 
     when upper(trim(cst_gndr)) = 'M' then 'Male'
     else 'N/A' end as cst_gndr,
cst_create_date
from 
(select *,
row_number() over ( partition by cst_id order by cst_create_date desc) flag_rank
from bronze.crm_cust_info
where cst_id is not null) t
where flag_rank =1

set @end_time = getdate()
print' Loading Duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds';


print '****************************************************************************************************'

set @start_time = getdate();
print '>>>Truncating the Table : silver.crm_prod_info';
truncate table silver.crm_prod_info;

print '>>Inserting Data Into : silver.crm_prod_info'
insert into silver.crm_prod_info(
                                prd_id,
                                cat_id,
                                prd_key,
                                prd_nm	,
                                prd_cost,
                                prd_line,
                                prd_start_dt,
                                prd_end_dt)
select 
prd_id,
replace(substring(prd_key,1,5),'-','_') as cat_id,
substring(prd_key,7,len(prd_key)) as prd_key,
prd_nm,
coalesce(prd_cost,0) as  prd_cost,
 case upper(trim(prd_line))
  when  'M' then 'Mountain'
   when  'R' then 'Road'
    when  'S' then 'Other Sales'
     when  'T' then 'Touring'
     else 'N/A'end as prd_line,
cast(prd_start_dt as date) as prd_start_dt,
cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt ) -1 as date)  as prd_end_dt
from bronze.crm_prod_info

set @end_time = getdate()
print' Loading Duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds';


print '****************************************************************************************************'

set @start_time = getdate();
print '>>>Truncating the Table : silver.crm_sales_details';
truncate table silver.crm_sales_details;

print '>>Inserting Data Into : silver.crm_sales_details'
insert into silver.crm_sales_details(
						sls_ord_num ,
                        sls_prd_key ,
                        sls_cust_id ,
                        sls_order_dt ,
                        sls_ship_dt ,
                        sls_due_dt ,
                        sls_sales ,
                        sls_quantity ,
                        sls_price )
select 
sls_ord_num,
sls_prd_key,
sls_cust_id	,
case when sls_order_dt <= 0 or len(sls_order_dt) <> 8 then null
	else cast(cast(sls_order_dt as varchar) as date) 
	end as sls_order_dt ,
case when sls_ship_dt <= 0 or len(sls_ship_dt) <> 8 then null
	else cast(cast(sls_ship_dt as varchar) as date) 
	end as sls_ship_dt ,
case when sls_due_dt <= 0 or len(sls_due_dt) <> 8 then null
	else cast(cast(sls_due_dt as varchar) as date)
	end as sls_due_dt,
case when sls_sales <=0 or sls_sales is null or sls_sales <> sls_quantity * abs(sls_price)
		then sls_quantity * abs(sls_price)
		else sls_sales 
        end as sls_sales,
sls_quantity,
case when sls_price <=0 or sls_price is null 
		then sls_sales / nullif(sls_quantity,0) 
		else sls_price 
		end as sls_price 
from bronze.crm_sales_details

set @end_time = getdate()
print' Loading Duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds';



    print'=================================================================================='
    print 'Loading ERP Tables'
    print'=================================================================================='


set @start_time = getdate();
print '>>>Truncating the Table : silver.erp_cust_bdate';
truncate table silver.erp_cust_bdate;

print '>>Inserting Data Into : silver.erp_cust_bdate'
insert into silver.erp_cust_bdate(cid ,
                                  bdate ,
                                  gen ) 

select 
case when  cid like 'NAS%' then substring(cid,4,len(cid)) 
        else cid
          end as cid ,
case when bdate > getdate() then null
        else bdate 
   end as bdate,
 case when  upper(trim(gen)) in ('F','Female')  then 'Female'  
       when upper(trim(gen)) in ('M','Male') then 'Male'  
        else 'N/A'
        end  as gen
from bronze.erp_cust_bdate 

set @end_time = getdate()
print' Loading Duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds';


print '****************************************************************************************************'


set @start_time = getdate();
print '>>>Truncating the Table : silver.erp_cust_country';
truncate table silver.erp_cust_country;

print '>>Inserting Data Into : silver.erp_cust_country'
insert into silver.erp_cust_country(cid,
									cntry)
select 
replace (cid,'-','') cid,
case when upper(trim(cntry)) = 'DE' then 'Germany'
	   when upper(trim(cntry)) IN ('USA','US') then 'United States'
	    when upper(trim(cntry)) = '' or cntry is null then 'N/A'
	     ELSE trim(cntry) 
			end  as cntry
from bronze.erp_cust_country 

set @end_time = getdate()
print' Loading Duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds';


print '****************************************************************************************************'


set @start_time = getdate();
print '>>>Truncating the Table : silver.erp_prod_maint';
truncate table silver.erp_prod_maint;

print '>>Inserting Data Into : silver.erp_prod_maint'
insert into silver.erp_prod_maint(id ,
                                       cat ,
                                         subcat ,
                                         maintenance )                    
select * from bronze.erp_prod_maint

set @end_time = getdate()
print' Loading Duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar ) + 'seconds';

set @end_batch_time = getdate();
print 'Total Load Duration:' + cast(datediff(second,@start_batch_time,@end_batch_time) as nvarchar) + 'seconds';

end try
begin catch
    print'Error Occured during Silver Layer'
    print 'Error Message' + error_message () ;
    print 'Error Number' + cast(error_number() as nvarchar);
    print 'Error Line' + cast(error_line() as nvarchar);

end catch
end 
