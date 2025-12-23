## average fare per day of week
SELECT  day_of_week, AVG(fare_amount) as average_fare
FROM `quiet-grail-480918-g1.tlc_trip_record_data.nyc_yellow_taxi_table` 
GROUP BY day_of_week
ORDER BY day_of_week;

## average fare per time of day
SELECT hour_of_day, AVG(fare_amount) as average_fare
FROM `quiet-grail-480918-g1.tlc_trip_record_data.nyc_yellow_taxi_table` 
GROUP BY hour_of_day
ORDER BY hour_of_day;

## average trip duration per day of week
SELECT day_of_week, AVG(duration_min) as average_duration
FROM `quiet-grail-480918-g1.tlc_trip_record_data.nyc_yellow_taxi_table` 
GROUP BY day_of_week
ORDER BY day_of_week;

## average trip duration by hour of day
SELECT hour_of_day, AVG(duration_min) as average_duration
FROM `quiet-grail-480918-g1.tlc_trip_record_data.nyc_yellow_taxi_table` 
GROUP BY hour_of_day
ORDER BY hour_of_day;

## fare distribution by hour of day
SELECT
hour_of_day,
APPROX_QUANTILES(fare_amount, 100)[OFFSET(10)] AS p10_fare,
APPROX_QUANTILES(fare_amount, 100)[OFFSET(50)] AS p50_fare,
APPROX_QUANTILES(fare_amount, 100)[OFFSET(90)] AS p90_fare,
APPROX_QUANTILES(fare_amount, 100)[OFFSET(99)] AS p99_fare,
COUNT(*) AS n_trips
FROM `quiet-grail-480918-g1.tlc_trip_record_data.nyc_yellow_taxi_table` 
GROUP BY hour_of_day
ORDER BY hour_of_day;

