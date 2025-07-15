

CREATE TABLE iceberg.demo.stg_date AS
SELECT
    CAST(date AS DATE) AS date,
    CAST(datekey AS BIGINT) AS datekey,
    CAST(year AS INTEGER) AS year,
    yearquarter,
    CAST(yearquarternumber AS BIGINT) AS yearquarternumber,
    quarter,
    yearmonth,
    yearmonthshort,
    CAST(yearmonthnumber AS BIGINT) AS yearmonthnumber,
    month,
    monthshort,
    CAST(monthnumber AS INTEGER) AS monthnumber,
    dayofweek,
    dayofweekshort,
    CAST(dayofweeknumber AS INTEGER) AS dayofweeknumber,
    CAST(workingday AS BOOLEAN) AS workingday,
    CAST(workingdaynumber AS INTEGER) AS workingdaynumber
FROM hive.demo.date;

CREATE TABLE iceberg.demo.stg_currencyexchange AS
SELECT
    CAST(date AS DATE) AS date,
    fromcurrency,
    tocurrency,
    CAST(exchange AS DOUBLE) AS exchange
FROM hive.demo.currencyexchange;

CREATE TABLE iceberg.demo.stg_customer AS
SELECT
    CAST(customerkey AS BIGINT) AS customerkey,
    CAST(geoareakey AS BIGINT) AS geoareakey,
    CAST(startdt AS DATE) AS startdt,
    CAST(enddt AS DATE) AS enddt,
    continent,
    gender,
    title,
    givenname,
    middleinitial,
    surname,
    streetaddress,
    city,
    state,
    statefull,
    zipcode,
    country,
    countryfull,
    CAST(birthday AS DATE) AS birthday,
    CAST(age AS INTEGER) AS age,
    occupation,
    company,
    vehicle,
    CAST(latitude AS DOUBLE) AS latitude,
    CAST(longitude AS DOUBLE) AS longitude
FROM hive.demo.customer;


CREATE TABLE iceberg.demo.stg_product AS
SELECT
    CASE 
        WHEN TRIM(productkey) = '' THEN NULL
        ELSE CAST(productkey AS BIGINT)
    END AS productkey,
    productcode,
    productname,
    manufacturer,
    brand,
    color,
    weightunit,
    CASE 
        WHEN TRIM(weight) = '' THEN NULL
        ELSE CAST(weight AS DOUBLE)
    END AS weight,
    CASE 
        WHEN TRIM(cost) = '' THEN NULL
        ELSE CAST(cost AS DOUBLE)
    END AS cost,
    CASE 
        WHEN TRIM(price) = '' THEN NULL
        ELSE CAST(price AS DOUBLE)
    END AS price,
    CASE 
        WHEN TRIM(categorykey) = '' THEN NULL
        ELSE CAST(categorykey AS BIGINT)
    END AS categorykey,
    categoryname,
    CASE 
        WHEN TRIM(subcategorykey) = '' THEN NULL
        ELSE CAST(subcategorykey AS BIGINT)
    END AS subcategorykey,
    subcategoryname
FROM hive.demo.product;

CREATE TABLE iceberg.demo.stg_sales AS
SELECT
    CAST(orderkey AS BIGINT) AS orderkey,
    CAST(linenumber AS INTEGER) AS linenumber,
    CAST(orderdate AS DATE) AS orderdate,
    CAST(deliverydate AS DATE) AS deliverydate,
    CAST(customerkey AS BIGINT) AS customerkey,
    CAST(storekey AS BIGINT) AS storekey,
    CAST(productkey AS BIGINT) AS productkey,
    CAST(quantity AS INTEGER) AS quantity,
    CAST(unitprice AS DOUBLE) AS unitprice,
    CAST(netprice AS DOUBLE) AS netprice,
    CAST(unitcost AS DOUBLE) AS unitcost,
    currencycode,
    CAST(exchangerate AS DOUBLE) AS exchangerate
FROM hive.demo.sales;

CREATE TABLE iceberg.demo.stg_store AS
SELECT
    CAST(storekey AS BIGINT) AS storekey,
    storecode,
    CAST(geoareakey AS BIGINT) AS geoareakey,
    countrycode,
    countryname,
    state,
    -- handle empty strings for opendate
    CASE 
        WHEN TRIM(opendate) = '' THEN NULL
        ELSE CAST(opendate AS DATE)
    END AS opendate,
    -- handle empty strings for closedate
    CASE 
        WHEN TRIM(closedate) = '' THEN NULL
        ELSE CAST(closedate AS DATE)
    END AS closedate,
    description,
    -- handle empty strings for squaremeters
    CASE 
        WHEN TRIM(squaremeters) = '' THEN NULL
        ELSE CAST(squaremeters AS INTEGER)
    END AS squaremeters,
    status
FROM hive.demo.store;



