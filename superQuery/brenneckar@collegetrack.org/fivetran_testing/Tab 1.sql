SELECT done::date, count(*)*2 as approx_num_api_requests 
FROM salesforce._fivetran_query group by done::date