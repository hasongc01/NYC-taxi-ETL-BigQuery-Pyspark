# Project Overview

This repository implements an end-to-end ETL and benchmarking workflow for NYC TLC Yellow Taxi Trip Record Data (Jan–Dec 2024) using PySpark on GCP Dataproc and Google BigQuery. The pipeline ingests Parquet trip files from Google Cloud Storage (GCS), performs data cleaning and enrichment, engineers analytical features, writes partitioned outputs, loads curated data to BigQuery (via the Spark BigQuery connector), and runs matched queries in BigQuery vs. Spark SQL to compare execution performance across partitioning strategies.

Core objectives:

- Ingest and consolidate monthly Parquet files into a single Spark DataFrame
- Clean invalid / low-quality records (missing values, negative fares, zero/invalid durations)
- Enrich trips with geographic labels via NYC Taxi Zone lookup
- Engineer time, efficiency, and unit-economics features for downstream analysis
- Benchmark write and query performance for different partitioning approaches (e.g., hour-of-day, zone)

# Project Value

This project is useful because it mirrors a common real-world analytics workflow: ingesting large, semi-structured datasets, producing reliable curated tables, and enabling fast downstream analysis in a cloud data warehouse.
- **Demonstrates an end-to-end cloud pipeline**
  - Covers ingestion (GCS), distributed transformation (Dataproc + PySpark), and warehouse analytics (BigQuery), reflecting how production data platforms are typically built on GCP.
- **Improves data reliability for analytics**
  - Cleaning invalid trips (missing values, negative fares, zero duration) and normalizing timestamps ensures that aggregates and KPI reporting are not distorted by data quality issues.
- **Creates business-ready features**
  - Feature engineering turns raw trip logs into interpretable operational and unit-economics metrics (duration, speed, revenue per mile/minute, tip rate) that support decision-making.
- **Quantifies performance tradeoffs**
  - Partitioning and execution-time comparisons between Spark SQL and BigQuery provide practical guidance on when to use each engine and how to structure data for cost-effective speed at scale.
- **Provides a foundation for near-real-time systems**
  - The same ETL design can be extended into a streaming or incremental ingestion workflow (new file arrivals → transform → BigQuery) for continuously updated dashboards and monitoring.

# Data Description
**1) NYC Taxi & Limousine Commission (TLC) Yellow Taxi Trip Record Data**

Primary dataset: NYC TLC Yellow Taxi Trip Record Data for January–December 2024, sourced from the TLC trip record publication. Files are provided in Parquet format.
Grain: one row per completed trip (trip-level).

Dataset scale used in this project: 41,169,720 rows

Core fields (schema observed in Spark):
- Trip identifiers and vendor metadata: VendorID
- Trip timestamps: tpep_pickup_datetime, tpep_dropoff_datetime
-   Defined by TLC as meter engaged/disengaged timestamps
- Trip attributes: passenger_count, trip_distance, RatecodeID, store_and_fwd_flag
- Geography (zone IDs): PULocationID, DOLocationID (pickup/dropoff taxi zone IDs)
- Payment and fare components: payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount,
improvement_surcharge, total_amount, congestion_surcharge, airport_fee

**2) NYC Taxi Zone Lookup**

Secondary dataset: NYC taxi zone lookup table, used to translate pickup/dropoff location IDs into geographic labels.
Grain: one row per taxi zone.

Fields: LocationID, Borough, Zone, service_zone

Join logic: 
- PULocationID and DOLocationID from trip records join to LocationID in the lookup table
- Enriched attributes produced:
  - pickup borough / zone / service zone
  - dropoff borough / zone / service zone

This enrichment enables aggregations and performance comparisons by geography (borough/zone) in both Spark SQL and BigQuery.

# Sample Queries
Sample results from the queries is in BigQuery Results excel file, and sample queries are in run sample queries.sql file.
1. Average fare per day of week
2. Average fare per time of day
3. Average trip duration per day of week
4. Average trip duration by hour of day
5. Fare distribution by hour of day

# References
https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
https://github.com/GoogleCloudDataproc/spark-bigquery-connector
