with 

source as (

    select * from {{ source('staging', 'car_sales') }}

),

renamed as (

    select
        year,
        replace(upper(case 
            when make is null then 'UNKNOWN' 
            else make
        end), 'TK', 'TRUCK') as make,
        model,
        trim,
        body,
        transmission,
        vin,
        state,
        condition,
        odometer,
        color,
        interior,
        seller,
        mmr,
        sellingprice,
        case 
            when saledate is null then '2014-03-01'
            else saledate
        end as saledate

    from source

)

select * from renamed
