SELECT 
    c.city_name,
    COUNT(t.trip_id) AS total_trips,
    ROUND(AVG(t.fare_amount / NULLIF(t.distance_travelled_km, 0)), 2) AS avg_fare_per_km,
    ROUND(AVG(t.fare_amount), 2) AS avg_fare_per_trip,
    ROUND((COUNT(t.trip_id) / (SELECT COUNT(*) FROM fact_trips)) * 100, 2) AS `%_contribution_to_total_trips`
FROM fact_trips t
JOIN dim_city c ON t.city_id = c.city_id
GROUP BY c.city_name
ORDER BY total_trips DESC;



