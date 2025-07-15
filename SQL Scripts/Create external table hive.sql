create schema hive.demo;

CREATE TABLE hive.demo.currencyexchange (
    date VARCHAR,
    fromcurrency VARCHAR,
    tocurrency VARCHAR,
    exchange VARCHAR
)
WITH (
    format = 'CSV',
    external_location = 's3a://demo/data/currencyexchange/',
    skip_header_line_count = 1,
    csv_quote = '"',
    csv_escape = '"'
);
CREATE TABLE hive.demo.customer (
    customerkey VARCHAR,
    geoareakey VARCHAR,
    startdt VARCHAR,
    enddt VARCHAR,
    continent VARCHAR,
    gender VARCHAR,
    title VARCHAR,
    givenname VARCHAR,
    middleinitial VARCHAR,
    surname VARCHAR,
    streetaddress VARCHAR,
    city VARCHAR,
    state VARCHAR,
    statefull VARCHAR,
    zipcode VARCHAR,
    country VARCHAR,
    countryfull VARCHAR,
    birthday VARCHAR,
    age VARCHAR,
    occupation VARCHAR,
    company VARCHAR,
    vehicle VARCHAR,
    latitude VARCHAR,
    longitude VARCHAR
)
WITH (
    format = 'CSV',
    external_location = 's3a://demo/data/customer/',
    skip_header_line_count = 1,
    csv_quote = '"',
    csv_escape = '"'
);
CREATE TABLE hive.demo.date (
    date VARCHAR,
    datekey VARCHAR,
    year VARCHAR,
    yearquarter VARCHAR,
    yearquarternumber VARCHAR,
    quarter VARCHAR,
    yearmonth VARCHAR,
    yearmonthshort VARCHAR,
    yearmonthnumber VARCHAR,
    month VARCHAR,
    monthshort VARCHAR,
    monthnumber VARCHAR,
    dayofweek VARCHAR,
    dayofweekshort VARCHAR,
    dayofweeknumber VARCHAR,
    workingday VARCHAR,
    workingdaynumber VARCHAR
)
WITH (
    format = 'CSV',
    external_location = 's3a://demo/data/date/',
    skip_header_line_count = 1,
    csv_quote = '"',
    csv_escape = '"'
);
CREATE TABLE hive.demo.product (
    productkey VARCHAR,
    productcode VARCHAR,
    productname VARCHAR,
    manufacturer VARCHAR,
    brand VARCHAR,
    color VARCHAR,
    weightunit VARCHAR,
    weight VARCHAR,
    cost VARCHAR,
    price VARCHAR,
    categorykey VARCHAR,
    categoryname VARCHAR,
    subcategorykey VARCHAR,
    subcategoryname VARCHAR
)
WITH (
    format = 'CSV',
    external_location = 's3a://demo/data/product/',
    skip_header_line_count = 1,
    csv_quote = '"',
    csv_escape = '"'
);
CREATE TABLE hive.demo.sales (
    orderkey VARCHAR,
    linenumber VARCHAR,
    orderdate VARCHAR,
    deliverydate VARCHAR,
    customerkey VARCHAR,
    storekey VARCHAR,
    productkey VARCHAR,
    quantity VARCHAR,
    unitprice VARCHAR,
    netprice VARCHAR,
    unitcost VARCHAR,
    currencycode VARCHAR,
    exchangerate VARCHAR
)
WITH (
    format = 'CSV',
    external_location = 's3a://demo/data/sales/',
    skip_header_line_count = 1,
    csv_quote = '"',
    csv_escape = '"'
);
CREATE TABLE hive.demo.store (
    storekey VARCHAR,
    storecode VARCHAR,
    geoareakey VARCHAR,
    countrycode VARCHAR,
    countryname VARCHAR,
    state VARCHAR,
    opendate VARCHAR,
    closedate VARCHAR,
    description VARCHAR,
    squaremeters VARCHAR,
    status VARCHAR
)
WITH (
    format = 'CSV',
    external_location = 's3a://demo/data/store/',
    skip_header_line_count = 1,
    csv_quote = '"',
    csv_escape = '"'
);
