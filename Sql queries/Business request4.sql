WITH CityNewPassengers AS (
    -- Count total new passenger trips for each city
    SELECT 
        dc.city_name,
        COUNT(*) AS total_new_passenger_trips  -- Counting trips with 'new' passengers
    FROM fact_trips ft
    JOIN dim_city dc ON ft.city_id = dc.city_id
    WHERE ft.passenger_type = 'new'
    GROUP BY dc.city_name
), 
RankedCities AS (
    -- Rank cities based on total new passenger trips
    SELECT 
        city_name,
        total_new_passenger_trips,
        RANK() OVER (ORDER BY total_new_passenger_trips DESC) AS rank_high,
        RANK() OVER (ORDER BY total_new_passenger_trips ASC) AS rank_low
    FROM CityNewPassengers
)
-- Identify top 3 and bottom 3 cities
SELECT 
    city_name,
    total_new_passenger_trips,
    CASE 
        WHEN rank_high <= 3 THEN 'Top 3'
        WHEN rank_low <= 3 THEN 'Bottom 3'
        ELSE NULL
    END AS city_category
FROM RankedCities
WHERE rank_high <= 3 OR rank_low <= 3
ORDER BY city_category DESC, total_new_passenger_trips DESC;



