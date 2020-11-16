SELECT done::date, count(*)*2 as approx_num_api_requests 
FROM `data-warehouse-289815.salesforce._fivetran_query` group by done::date