{{ config(
    materialized='table'
) }}

select * from  {{ source('source_tbl', 'raw_customers') }}
