SELECT *
FROM `data-warehouse-289815.salesforce.fivetran_audit`
WHERE rows_updated_or_inserted > 500 AND done > '2021-04-06'