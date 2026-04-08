-- File 02_analysis.sql
-- Purpose: Analyze ride patterns between casual riders and annual members

-- ======================
-- ANALYSIS
-- ======================

-- Analyze the ride length, ride count and percent of people using electric or classic rideables
CREATE TABLE `cyclistic-capstone-492221.Cyclistic_Data_2025.tripdata_2025_ride_type` AS
SELECT
  member_casual,
  rideable_type,
  COUNT(*) AS ride_count,
  ROUND(
    100 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY member_casual),
    2
  ) AS pct_of_group_rides,
  ROUND(AVG(ride_length_seconds), 2) AS avg_ride_length_seconds
FROM `cyclistic-capstone-492221.Cyclistic_Data_2025.tripdata_2025_clean_filtered`
GROUP BY member_casual, rideable_type
ORDER BY member_casual, ride_count DESC;

-- Analyze ride length and count by month
CREATE TABLE `cyclistic-capstone-492221.Cyclistic_Data_2025.tripdata_2025_rides_by_month` AS
SELECT
  member_casual,
  EXTRACT(MONTH FROM started_at) AS ride_month,
  COUNT(*) AS ride_count,
  ROUND(AVG(ride_length_seconds), 2) AS avg_ride_length_seconds
FROM `cyclistic-capstone-492221.Cyclistic_Data_2025.tripdata_2025_clean_filtered`
GROUP BY member_casual, ride_month

-- Analyze ride length and count by day of the week
SELECT
  member_casual,
  day_of_week_number,
  day_of_week_name,
  COUNT(*) AS ride_count,
  ROUND(AVG(ride_length_seconds), 2) AS avg_ride_length_seconds,
FROM `cyclistic-capstone-492221.Cyclistic_Data_2025.tripdata_2025_clean_filtered`
GROUP BY member_casual, day_of_week_number, day_of_week_name
ORDER BY member_casual, day_of_week_number;  
ORDER BY member_casual, ride_month;
