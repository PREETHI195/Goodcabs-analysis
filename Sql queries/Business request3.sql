WITH RepeatTripCounts AS (
    -- Aggregate repeat passenger counts by city and trip count
    SELECT 
        dc.city_name,
        dtd.trip_count,
        SUM(dtd.repeat_passenger_count) AS passenger_count
    FROM trips_db.dim_repeat_trip_distribution dtd
    JOIN trips_db.dim_city dc ON dtd.city_id = dc.city_id
    WHERE dtd.trip_count BETWEEN 2 AND 10  -- Consider only 2-10 trip categories
    GROUP BY dc.city_name, dtd.trip_count
),
TotalRepeatPassengers AS (
    -- Compute total repeat passengers per city
    SELECT 
        city_name,
        SUM(passenger_count) AS total_repeat_passengers
    FROM RepeatTripCounts
    GROUP BY city_name
),
PivotedData AS (
    -- Pivot trip counts into columns
    SELECT 
        rtc.city_name,
        SUM(CASE WHEN rtc.trip_count = 2 THEN rtc.passenger_count ELSE 0 END) AS `2-Trips`,
        SUM(CASE WHEN rtc.trip_count = 3 THEN rtc.passenger_count ELSE 0 END) AS `3-Trips`,
        SUM(CASE WHEN rtc.trip_count = 4 THEN rtc.passenger_count ELSE 0 END) AS `4-Trips`,
        SUM(CASE WHEN rtc.trip_count = 5 THEN rtc.passenger_count ELSE 0 END) AS `5-Trips`,
        SUM(CASE WHEN rtc.trip_count = 6 THEN rtc.passenger_count ELSE 0 END) AS `6-Trips`,
        SUM(CASE WHEN rtc.trip_count = 7 THEN rtc.passenger_count ELSE 0 END) AS `7-Trips`,
        SUM(CASE WHEN rtc.trip_count = 8 THEN rtc.passenger_count ELSE 0 END) AS `8-Trips`,
        SUM(CASE WHEN rtc.trip_count = 9 THEN rtc.passenger_count ELSE 0 END) AS `9-Trips`,
        SUM(CASE WHEN rtc.trip_count = 10 THEN rtc.passenger_count ELSE 0 END) AS `10-Trips`
    FROM RepeatTripCounts rtc
    GROUP BY rtc.city_name
)
-- Final report with percentage distribution
SELECT 
    pd.city_name,
    ROUND((pd.`2-Trips` * 100.0 / NULLIF(tp.total_repeat_passengers, 0)), 2) AS `2-Trips (%)`,
    ROUND((pd.`3-Trips` * 100.0 / NULLIF(tp.total_repeat_passengers, 0)), 2) AS `3-Trips (%)`,
    ROUND((pd.`4-Trips` * 100.0 / NULLIF(tp.total_repeat_passengers, 0)), 2) AS `4-Trips (%)`,
    ROUND((pd.`5-Trips` * 100.0 / NULLIF(tp.total_repeat_passengers, 0)), 2) AS `5-Trips (%)`,
    ROUND((pd.`6-Trips` * 100.0 / NULLIF(tp.total_repeat_passengers, 0)), 2) AS `6-Trips (%)`,
    ROUND((pd.`7-Trips` * 100.0 / NULLIF(tp.total_repeat_passengers, 0)), 2) AS `7-Trips (%)`,
    ROUND((pd.`8-Trips` * 100.0 / NULLIF(tp.total_repeat_passengers, 0)), 2) AS `8-Trips (%)`,
    ROUND((pd.`9-Trips` * 100.0 / NULLIF(tp.total_repeat_passengers, 0)), 2) AS `9-Trips (%)`,
    ROUND((pd.`10-Trips` * 100.0 / NULLIF(tp.total_repeat_passengers, 0)), 2) AS `10-Trips (%)`
FROM PivotedData pd
JOIN TotalRepeatPassengers tp ON pd.city_name = tp.city_name
ORDER BY pd.city_name;
