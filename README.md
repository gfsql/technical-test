# Technical Test

## Overview of the ELT Pipeline

### Technical Test Objectives

The primary objectives of this project are to:
- Extract data from Excel files in CSV format into any data warehouse
- Transform the data to create models that can answer key business questions:
  - Top 10 stores per transaction amount.
  - Top 10 products sold.
  - Average transacted amount per store typology and country.
  - Percentage of transactions per device type.
  - Average time for a store to adopt devices based on its first five transactions.

### Assumptions

 - We will be using a data warehouse from supported SQLAlchemy dialects or any maintained external dialects.
 - We will be using a data warehouse which supports an OVER clause
 - store.xlsx created_at provides the date any device is installed in this store

### Design Considerations

- ETL vs. ELT: The project follows an ELT approach, where data is loaded into the database first and then transformed using SQL and DBT.
- Performance Optimization
  - intermediate materialized table is used to potentially large datasets. Views stacked on top of other views, are slow to query
  - use of indexing on key columns to speed up queries
  - leveraging SQL features like window functions for efficient aggregations

### Implementation Details

#### Data Extraction
Data is extracted from CSV files using a Python script `source/extract.py`. Database tables are created within script.
Single function `load_excel_to_db` is used to populate tables **staging_device**, **staging_store** and **staging_transactions**.

#### DBT SQL Models
- `models/staging/stg_device.sql` this model pulls data from the staging_device table
- `models/staging/stg_store.sql` this model pulls data from the staging_store table
- `models/staging/stg_transactions.sql` this model pulls data from the staging_transaction table

#### Transform - Intermediate Data Models

`models/intermediate/fct_transactions.sql` create intermediate model to join and aggregate data for further analysis

#### Answer the Business Questions with DBT Models

1. Top 10 Stores per Transaction Amount `models/mart/top_10_stores.sql`
2. Top 10 products Sold `models/mart/top_10_products.sql`
3. Average Transaction Amount per Store Typology and Country `models/mart/avg_transaction_amount.sql`
4. Percentage of Transactions per Device Type `models/mart/percentage_transactions_by_device.sql`
5. Average Time for a Store to Perform its First 5 Transactions `models/mart/avg_time_first_5_transactions.sql`

