WITH MonthlyRevenue AS (
    -- Calculate total revenue for each city and month
    SELECT 
        dc.city_name,
        dd.month_name,
        SUM(ft.fare_amount) AS monthly_revenue
    FROM fact_trips ft
    JOIN dim_city dc ON ft.city_id = dc.city_id
    JOIN dim_date dd ON ft.date = dd.date
    GROUP BY dc.city_name, dd.month_name
),
CityTotalRevenue AS (
    -- Calculate total revenue for each city
    SELECT 
        mr.city_name,   -- Use 'mr.city_name' instead of 'city_name' to avoid ambiguity
        SUM(mr.monthly_revenue) AS total_revenue
    FROM MonthlyRevenue mr
    GROUP BY mr.city_name
),
RankedRevenue AS (
    -- Rank months based on revenue for each city
    SELECT 
        mr.city_name,
        mr.month_name AS highest_revenue_month,
        mr.monthly_revenue AS revenue,
        cr.total_revenue,
        RANK() OVER (PARTITION BY mr.city_name ORDER BY mr.monthly_revenue DESC) AS revenue_rank
    FROM MonthlyRevenue mr
    JOIN CityTotalRevenue cr ON mr.city_name = cr.city_name
)
-- Get only the highest revenue month for each city
SELECT 
    rr.city_name,
    rr.highest_revenue_month,
    rr.revenue,
    ROUND((rr.revenue * 100.0 / rr.total_revenue), 2) AS percentage_contribution
FROM RankedRevenue rr
WHERE rr.revenue_rank = 1
ORDER BY rr.city_name;
