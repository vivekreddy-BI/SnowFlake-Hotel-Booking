CREATE DATABASE HOTEL_BOOKINGS_DB;

CREATE OR REPLACE FILE FORMAT HB_CSV
    TYPE = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER = 1
    NULL_IF = ('null', 'NULL', '' )

CREATE OR REPLACE STAGE STG_HOTEL_BOOKINGS

CREATE TABLE BRONZE_HB (
booking_id STRING,
hotel_id STRING,
hotel_city STRING,
customer_id	STRING,
customer_name STRING,
customer_email STRING,
check_in_date STRING,
check_out_date STRING,
room_type STRING,
num_guests STRING,
total_amount STRING,
currency STRING,
booking_status STRING
);

COPY INTO BRONZE_HB
FROM @STG_HOTEL_BOOKINGS
FILE_FORMAT =(FORMAT_NAME = HB_CSV)
ON_ERROR = 'CONTINUE';

SELECT * FROM BRONZE_HB;

CREATE TABLE SILVER_HB(
    booking_id VARCHAR,
    hotel_id VARCHAR,
    hotel_city VARCHAR,
    customer_id	VARCHAR,
    customer_name VARCHAR,
    customer_email VARCHAR,
    check_in_date DATE,
    check_out_date DATE,
    room_type VARCHAR,
    num_guests INTEGER,
    total_amount FLOAT,
    currency VARCHAR,
    booking_status VARCHAR
);

--Issues in raw data
--1) Invalid Email address
SELECT customer_email 
FROM BRONZE_HB
WHERE NOT (customer_email LIKE '%@%.%')
        OR customer_email IS NULL;
        
--2) Negative total_amount
SELECT total_amount 
FROM BRONZE_HB
WHERE total_amount < 0;

--3) check_in_date greater than check_out_date
SELECT check_in_date, check_out_date
FROM BRONZE_HB
WHERE TRY_TO_DATE(check_in_date) > TRY_TO_DATE(check_out_date);

--4) Typo errors
SELECT DISTINCT booking_status
FROM BRONZE_HB;

--5) Duplicate Bookings
SELECT booking_id, hotel_id, count(*) AS cnt
FROM SILVER_HB --BRONZE_HB
GROUP BY booking_id, hotel_id
HAVING cnt > 1;

INSERT INTO SILVER_HB
SELECT
    booking_id,
    hotel_id,
    INITCAP(TRIM(hotel_city)) AS hotel_city,
    customer_id,
    INITCAP(TRIM(customer_name)) AS customer_name,
    CASE
        WHEN customer_email LIKE '%@%.%' THEN LOWER(TRIM(customer_email))
        ELSE NULL
    END AS customer_email,
    TRY_TO_DATE(NULLIF(check_in_date, '')) AS check_in_date,
    TRY_TO_DATE(NULLIF(check_out_date, '')) AS check_out_date,
    room_type,
    num_guests,
    ABS(TRY_TO_NUMBER(total_amount)) AS total_amount,
    currency,
    CASE
        WHEN LOWER(booking_status) IN ('confirmeeed', 'confirmed') THEN 'Confirmed'
        WHEN LOWER(booking_status) IN ('cancelled', 'no-show') THEN 'Cancelled'
        ELSE booking_status
    END AS booking_status
FROM BRONZE_HB
WHERE 
    TRY_TO_DATE(check_in_date) IS NOT NULL 
    AND TRY_TO_DATE(check_out_date) IS NOT NULL 
    AND TRY_TO_DATE(check_out_date) >= TRY_TO_DATE(check_in_date)
QUALIFY ROW_NUMBER() OVER (PARTITION BY booking_id,hotel_id ORDER BY TRY_TO_DATE(check_in_date) DESC) = 1;

SELECT * FROM SILVER_HB --LIMIT 50;

CREATE TABLE GOLD_AGG_DAILY_BOOKINGS AS
SELECT
    check_in_date AS date,
    COUNT(*) AS total_bookings,
    SUM(total_amount) AS total_revenue
FROM SILVER_HB
GROUP BY check_in_date
ORDER BY check_in_date;

CREATE TABLE GOLD_AGG_HOTEL_CITY_SALES AS
SELECT
    hotel_city,
    SUM(total_amount) AS total_revenue
FROM SILVER_HB
GROUP BY hotel_city
ORDER BY total_revenue DESC;

CREATE TABLE GOLD_HOTEL_BOOKING_CLEAN AS 
SELECT    
    booking_id,
    hotel_id,
    hotel_city,
    customer_id,
    customer_name,
    customer_email,
    check_in_date,
    check_out_date,
    room_type,
    num_guests,
    total_amount,
    currency,
    booking_status
FROM SILVER_HB;

