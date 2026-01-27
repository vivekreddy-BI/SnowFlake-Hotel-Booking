--KPI Total Bookings
SELECT COUNT(*) AS total_bookings
FROM GOLD_HOTEL_BOOKING_CLEAN;

--KPI Total Guests
SELECT SUM(num_guests) AS Total_Guests
FROM GOLD_HOTEL_BOOKING_CLEAN;

--AVG booking value
SELECT AVG(total_amount) AS avg_Booking_value
FROM GOLD_HOTEL_BOOKING_CLEAN;

--Total Revenue
SELECT SUM(total_amount) AS total_revenue
FROM GOLD_HOTEL_BOOKING_CLEAN;

--Line Chart Montly bookings
SELECT date, total_bookings
FROM GOLD_AGG_DAILY_BOOKINGS
ORDER BY date

--Line Chart Monthly Revenue
SELECT date, total_revenue
FROM GOLD_AGG_DAILY_BOOKINGS
ORDER BY date;


--Bar Chart Top cities by revenue
SELECT hotel_city, total_revenue
FROM GOLD_AGG_HOTEL_CITY_SALES
WHERE total_revenue is NOT NULL
ORDER BY total_revenue DESC
LIMIT 5;

--Bar Chart Booking by Status
SELECT booking_status, COUNT(*) AS total_bookings
FROM GOLD_HOTEL_BOOKING_CLEAN
GROUP BY booking_status
ORDER BY total_bookings DESC;

--Bar Chart booking by RoomType
SELECT room_type, COUNT(*) AS total_bookings
FROM GOLD_HOTEL_BOOKING_CLEAN
GROUP BY room_type
ORDER BY total_bookings DESC;




