{{ config(
    materialized='table'
) }}

select * from  {{ source('source_tbl3', 'raw_payments') }}
