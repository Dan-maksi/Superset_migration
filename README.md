# ✅ Superset Migration Project – Getting Started

**Repo:** [https://github.com/Dan-maksi/Superset\_migration](https://github.com/Dan-maksi/Superset_migration)

This project sets up:

* Trino as a SQL query engine
* Hive Metastore
* MinIO as object storage
* Two Superset instances
* A pipeline for migrating dashboards between Superset instances

---

## Prerequisites

* Docker and Docker Compose installed
* A SQL client (e.g. [DBeaver](https://dbeaver.io/))
* (Optional) Python knowledge if modifying migration logic

---

## 1. Launch Docker Compose

From your repo root, run:

```bash
docker compose up --build
```

This starts:

* PostgreSQL (for Hive Metastore)
* Hive Metastore
* Trino
* MinIO
* Two Superset instances

---

## 2. Connect DBeaver to Trino

Use DBeaver (or your preferred SQL client) to connect to Trino:

1. Open DBeaver
2. Create a new **Project**
3. Inside your project:

   * Right-click → **New Connection**
4. Search for **Trino** and select it
5. Connection settings:

   * **Host:** `localhost`
   * **Port:** `8080`
   * **User:** any name you choose (Trino does not allow anonymous connections)
6. Click **Finish**

Your Trino connection should now show as connected.

---

## 3. Verify Catalogs

After connecting, you should see several catalogs under your Trino connection.

At Invent, we primarily use **Iceberg.** Iceberg is a table format optimized for analytics and fast querying.

---

## 4. Create Schema in Hive

In DBeaver:

* Expand the **hive** catalog
* Press `F3` to open a new SQL script
* Run:

```sql
CREATE SCHEMA hive.demo;
```

---

## 5. Create Hive External Tables

Next, create external tables in Hive that point to the MinIO bucket and the folders where your data resides.

Example SQL:

```sql
CREATE EXTERNAL TABLE hive.demo.currencyexchange (
    date STRING,
    fromcurrency STRING,
    tocurrency STRING,
    exchange STRING
)
STORED AS PARQUET
LOCATION 's3a://demo/currencyexchange/';
```

Repeat similar statements for:

* customer
* date
* product
* sales
* store

**Note:**

* The MinIO bucket is named `demo`.
* Folder names match your subdirectories in MinIO.

---

## 6. Create Iceberg Tables from Hive Data

Now create Iceberg tables in the same schema, casting values into proper data types.

Example:

```sql
CREATE TABLE iceberg.demo.stg_currencyexchange AS
SELECT
    CAST(date AS DATE) AS date,
    fromcurrency,
    tocurrency,
    CAST(exchange AS DOUBLE) AS exchange
FROM hive.demo.currencyexchange;
```

Repeat this for each table you want to migrate.
Tables prefixed with **`stg_`** will become your working tables for analysis and migration.

---

## 7. Verify Your Data

Test your Iceberg tables:

```sql
SELECT * FROM iceberg.demo.stg_currencyexchange LIMIT 10;
```

If you see rows returned, your data pipeline is working!

---

## SQL Scripts Provided

If you don’t want to write all these SQL statements yourself, **SQL scripts are included in the repo**.

Look under:

```
/sql_scripts/
```

* This folder contains:

  * Hive table creation scripts
  * Iceberg table creation scripts

You can simply copy those scripts into DBeaver and execute them instead of writing them from scratch.

---

**Stop here for now.**

We’ll handle connecting Superset to Trino later.
