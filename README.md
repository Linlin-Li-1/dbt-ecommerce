# dbt Ecommerce Analytics

A beginner-friendly analytics engineering project built with **dbt Core** and **DuckDB**. The project demonstrates a typical dbt workflow from raw data to tested, business-ready analytics models.

## Project Overview

This project uses ecommerce order data to build customer- and order-level analytics models.

The workflow follows a layered dbt architecture:

```text
Raw Seeds
   ↓
Sources
   ↓
Staging
   ↓
Intermediate
   ↓
Marts
```

The project also demonstrates:

* `source()` and `ref()`
* dbt model dependencies and lineage
* Staging / Intermediate / Mart layers
* Data quality tests
* Model documentation
* Incremental models
* Jinja and `is_incremental()`
* `unique_key`
* Lookback-window incremental processing
* `dbt build`
* Git / GitHub workflow

## Data

The project uses four CSV seed files:

* `raw_customers.csv`
* `raw_orders.csv`
* `raw_items.csv`
* `raw_products.csv`

The main order dataset contains:

* Order ID
* Customer ID
* Order timestamp
* Store ID
* Subtotal
* Tax
* Order total

## Data Model

### Staging

**`stg_orders`**

Cleans and standardizes the raw orders data.

Key transformations include:

* Renaming `id` → `order_id`
* Renaming `customer` → `customer_id`
* Selecting relevant order-level fields

### Intermediate

**`int_customer_orders`**

Aggregates order activity at the customer level.

Metrics include:

* `order_count`
* `total_revenue`

### Marts

**`fct_customer_summary`**

A customer-level analytics table containing order counts and total revenue.

**`fct_orders`**

An order-level incremental model containing the cleaned order data.

## Incremental Model

`fct_orders` is configured as an incremental model.

The model uses the maximum existing `ordered_at` value as a watermark to identify newly arrived orders:

```sql
{% if is_incremental() %}
where ordered_at > (
    select max(ordered_at)
    from {{ this }}
)
{% endif %}
```

The model also demonstrates the use of a `unique_key` based on `order_id` for scenarios where records may need to be updated.

For datasets with late-arriving or recently modified records, a lookback window can be used instead of relying only on a timestamp watermark.

## Data Quality

The project includes dbt schema tests on the final customer summary model.

Current tests include:

* `customer_id` is not null
* `customer_id` is unique

The tests help validate the expected grain and basic data integrity of the final model.

## Project Structure

```text
dbt_ecommerce/
├── models/
│   ├── staging/
│   │   ├── sources.yml
│   │   ├── schema.yml
│   │   └── stg_orders.sql
│   ├── intermediate/
│   │   ├── schema.yml
│   │   └── int_customer_orders.sql
│   └── marts/
│       ├── fct_customer_summary.sql
│       ├── fct_orders.sql
│       └── schema.yml
├── seeds/
│   ├── raw_customers.csv
│   ├── raw_items.csv
│   ├── raw_orders.csv
│   └── raw_products.csv
├── tests/
├── macros/
├── analyses/
├── snapshots/
├── dbt_project.yml
└── README.md
```

## How to Run

Install the required dbt adapter and create the DuckDB profile, then run:

```bash
dbt seed
dbt build
```

To run a specific model:

```bash
dbt run --select fct_orders
```

To run the model from scratch:

```bash
dbt run --select fct_orders --full-refresh
```

To run tests:

```bash
dbt test
```

To generate documentation:

```bash
dbt docs generate
dbt docs serve
```

## Tech Stack

* **dbt Core 1.12.5**
* **DuckDB**
* **Python 3.11**
* **SQL**
* **Jinja**
* **Git / GitHub**
