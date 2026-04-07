-- File: 01_data_cleaning
-- Purpose: Consolidate tables, check for and remove errors and bad data

-- ================================
-- DATA CLEANING
-- ================================

-- Consolidate all 12 tables into one
-- Create new columns to prepare for analysis
CREATE TABLE `cyclistic-capstone-492221.Cyclistic_Data_2025.tripdata_2025_clean` AS
SELECT
  *,
  TIMESTAMP_DIFF(ended_at, started_at, SECOND) AS ride_length_seconds,
  FORMAT_TIMESTAMP('%A', started_at) AS day_of_week_name,
  EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week_number
 FROM `cyclistic-capstone-492221.Cyclistic_Data_2025.tripdata_*`

-- Create new filtered table without rows missing start or end times
-- Filters out rows with ride times < 0 (errors)
CREATE OR REPLACE TABLE `cyclistic-capstone-492221.Cyclistic_Data_2025.tripdata_2025_clean_filtered` AS
SELECT
  *
FROM `cyclistic-capstone-492221.Cyclistic_Data_2025.tripdata_2025_clean`
WHERE ended_at IS NOT NULL
  AND started_at IS NOT NULL
  AND TIMESTAMP_DIFF(ended_at, started_at, SECOND) > 0;

-- Check rideable_type for errors
SELECT
  rideable_type,
  COUNT(*) AS row_count
FROM `cyclistic-capstone-492221.Cyclistic_Data_2025.tripdata_2025_clean_filtered`
GROUP BY rideable_type
ORDER BY row_count DESC;

-- Check lat and lng columns for errors
SELECT
  *
FROM `cyclistic-capstone-492221.Cyclistic_Data_2025.tripdata_2025_clean_filtered`
WHERE start_lat < -90 OR start_lat > 90
   OR start_lng < -180 OR start_lng > 180
   OR end_lat < -90 OR end_lat > 90
   OR end_lng < -180 OR end_lng > 180;

-- Check for dupliacate rows
SELECT
  ride_id,
  COUNT(*) AS count
FROM `cyclistic-capstone-492221.Cyclistic_Data_2025.tripdata_2025_clean_filtered`
GROUP BY ride_id
HAVING count > 1;
