/*
****************************************************************************************************
Stored Procedure : Load Bronze (Source -> Bronze)

****************************************************************************************************
Script Purpose :
    This stored procedure loads data into the 'bronze' schema from ezternal CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the ' BULK INSERT' command to load data CSV Files to bronze tables.

Parameters :
 None.
 This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC  bronze.Load_first_layer
********************************************************************************************************
*/

create or alter procedure bronze.Load_first_layer as 
begin
     declare  @start_time datetime,
              @end_time datetime,
              @batch_s_time datetime,
              @batch_e_time datetime;
begin try
    set @batch_s_time =GETDATE();
    print'================================================';
    print 'Loading bronze Layer';
    print '===============================================';

    print '------------------------------------------------';
    print 'Loading CRM Tables';
    print '------------------------------------------------';


set  @start_time = getdate();
print'>>truncating table : bronze.crm_cust_info';
truncate table bronze.crm_cust_info

    bulk insert bronze.crm_cust_info
    from 'D:\Desktop\Excel_data_anylytics\sql-data-analytics-project-main\sql-data-analytics-project-main\datasets\csv-files\bronze.crm_customer_info.csv'
    with (
        firstrow= 2,
        fieldterminator = ',',
        tablock );
set  @end_time = getdate();
print ' >>Load duration:'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +'seconds';
print '>>-----------------------'


set @start_time = getdate();
print'>>truncating table : bronze.crm_prod_info';
truncate table bronze.crm_prod_info

        bulk insert bronze.crm_prod_info
        from 'D:\Desktop\Excel_data_anylytics\sql-data-analytics-project-main\sql-data-analytics-project-main\datasets\csv-files\bronze.crm_prd_info.csv'
        with (
            firstrow= 2,
            fieldterminator = ',',
            tablock );
set  @end_time = getdate();
print ' >>Load duration:'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +'seconds';
print '>>-----------------------'


select * from bronze.crm_prod_info



set  @start_time = getdate();
print'>>truncating table : bronze.crm_sales_details';

truncate table bronze.crm_sales_details

        bulk insert bronze.crm_sales_details
        from 'D:\Desktop\Excel_data_anylytics\sql-data-analytics-project-main\sql-data-analytics-project-main\datasets\csv-files\bronze.crm_sales_details.csv'
        with (
            firstrow= 2,
            fieldterminator = ',',
            tablock );
set @end_time = getdate();
print ' >>Load duration:'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +'seconds';
print '>>-----------------------'


select * from bronze.crm_sales_details



    print '------------------------------------------------';
    print 'Loading CRM Tables';
    print '------------------------------------------------';


set @start_time = getdate();
print'>>truncating table : bronze.erp_cust_country';

truncate table bronze.erp_cust_country

        bulk insert bronze.erp_cust_country
        from 'D:\Desktop\Excel_data_anylytics\sql-data-analytics-project-main\sql-data-analytics-project-main\datasets\csv-files\bronze.erp_loc_a101.csv'
        with (
            firstrow= 2,
            fieldterminator = ',',
            tablock );
set @end_time = getdate();
print ' >>Load duration:'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +'seconds';
print '>>-----------------------'


select * from bronze.erp_cust_country




set  @start_time = getdate();
print'>>truncating table : bronze.erp_cust_bdate';
truncate table bronze.erp_cust_bdate

        bulk insert bronze.erp_cust_bdate
        from 'D:\Desktop\Excel_data_anylytics\sql-data-analytics-project-main\sql-data-analytics-project-main\datasets\csv-files\bronze.erp_cust_az12.csv'
        with (
            firstrow= 2,
            fieldterminator = ',',
            tablock );
set  @end_time = getdate();
print ' >>Load duration:'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +'seconds';
print '>>-----------------------'

select * from bronze.erp_cust_bdate



set  @start_time = getdate();
print'>>truncating table : bronze.erp_prod_maint';
truncate table bronze.erp_prod_maint

        bulk insert bronze.erp_prod_maint
        from 'D:\Desktop\Excel_data_anylytics\sql-data-analytics-project-main\sql-data-analytics-project-main\datasets\csv-files\bronze.erp_px_cat_g1v2.csv'
        with (
            firstrow= 2,
            fieldterminator = ',',
            tablock );
set  @end_time = getdate();
print ' >>Load duration:'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +'seconds';
print '>>-----------------------'

  select * from bronze.erp_prod_maint


   set @batch_e_time =GETDATE();
   print '==================================================='
   print 'Loading bronze Layer is Completed'
   print ' ---TOTAL LOAD DURATION ' + cast(datediff(second,@batch_s_time,@batch_e_time) as nvarchar) + 'seconds';
   print '==================================================='

end try 
begin catch 
      print '===========================================';
      print 'error occured during bronze layer';
      print' error message' + error_message();
      print 'error number' + cast(error_number () as nvarchar);
      print '============================================';

end catch
end








