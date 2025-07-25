
# Superset Migration Sandbox

Spin up a complete analytics lab with **Trino + Iceberg**, **Apache Superset**, **Hive Metastore**, and **MinIO**.  
Use it to practise SQL-Lab queries, create charts, and test dashboard migration between two Superset instances.

---

## Stack Overview

| Service            | Purpose                                            | Port(s) |
|--------------------|----------------------------------------------------|---------|
| **Trino**          | SQL/query engine                                   | `8080` |
| **Hive Metastore** | Catalog / metadata for Iceberg tables              | `9083` |
| **MinIO**          | S3-compatible object store (sample data)           | `9000` (API) · `9001` (console) |
| **Superset #1**    | Primary BI instance                                | `8088` |
| **Superset #2**    | Secondary instance for migration tests             | `8089` |
| **PostgreSQL**     | Metastore DB (internal to Hive)                    | `5432` |

### Trino catalogs

| Catalog     | Notes                                       |
|-------------|---------------------------------------------|
| `iceberg`   | Main analytics tables (external Hive)       |
| `migration` | Same connector config, blank for experiments|

---

## Prerequisites

* Docker Engine & Docker Compose  
* (Optional) a SQL client such as [DBeaver](https://dbeaver.io/)

---

## 1  Launch the Stack

```bash
git clone https://github.com/Dan-maksi/Superset_migration.git
cd Superset_migration
docker compose up --build -d
````

---

## 2  Load Tables (Hive → Iceberg)

### 2·a  Connect DBeaver to Trino

1.  **Project** – create a project.
2. **Database ▸ New Connection** – search for **Trino** and select it.
3. Connection settings

   * **Host:** `localhost`
   * **Port:** `8080`
   * **Username:** any non-empty value (e.g. `demo`) – Trino rejects anonymous users.
4. **Finish** – the connection opens; you should see catalogs such as `iceberg`, `migration`, `hive`, `system`.

### 2·b  Run the setup scripts

Run **both** SQL files located in `SQL Scripts/`:

```
SQL Scripts/
  00_create_hive_external_tables.sql
  01_create_iceberg_staging_tables.sql
```

* **00\_create\_hive\_external\_tables.sql** – external Hive tables pointing to CSVs in MinIO.
* **01\_create\_iceberg\_staging\_tables.sql** – casts columns and saves results as Iceberg tables (`stg_*`).

After script #2 finishes, the Iceberg catalog (`iceberg.demo`) contains analysis-ready `stg_` tables.

---

## 3  Superset Login

| Instance    | URL                                            | Username | Password |
| ----------- | ---------------------------------------------- | -------- | -------- |
| Superset #1 | [http://localhost:8088](http://localhost:8088) | `admin`  | `admin`  |
| Superset #2 | [http://localhost:8089](http://localhost:8089) | `admin`  | `admin`  |

---

## 4  Connect Trino → Superset #1

1. **Settings ▸ Data ▸ Databases ▸ + Database**
2. Choose **Trino**
3. **SQLAlchemy URI**

   ```text
   trino://<username>@trino:8080/iceberg
   ```

   Replace `<username>` with any non-empty name.
4. **Test Connection** ▸ **Add**

You now see catalog **`iceberg`**, schema **`demo`**, and all `stg_` tables.

---

## 5  Create Datasets & Charts

1. **Data ▸ Datasets ▸ + Dataset**
2. Schema **`demo`**, table e.g. **`stg_sales`**
3. **Add Dataset** ▸ **Explore**

Sample chart ideas:

Below is a **new, five-level task set** (easy → challenging) built strictly from the columns in your `stg_` tables.
Each task tells you what to query in Superset SQL Lab and which chart to build

---

## Task 1 · Customer Gender Split *(Easy)*

| Item         | Details                                                                |
| ------------ | ---------------------------------------------------------------------- |
| **Table(s)** | `stg_customer`                                                         |
| **Goal**     | Count customers per `gender`.                                          |
| **Chart**    | **Pie Chart** (or Bar) • *Slice / X* = `gender` • *Metric* = COUNT(\*) |

---

## Task 2 · Monthly Average Exchange Rate by Currency Pair *(Moderate)*

| Item         | Details                                                                                                                               |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------- |
| **Table(s)** | `stg_currencyexchange`                                                                                                                |
| **Goal**     | For every `fromcurrency → tocurrency` pair, compute average `exchange` **per month**.                                                 |
| **Chart**    | **Multi-Line Chart** • *Time* = `date` (month grain) • *Line (by)* = concat(`fromcurrency`,`tocurrency`) • *Metric* = AVG(`exchange`) |

---

## Task 3 · Monthly Revenue by Continent *(Intermediate)*

| Item         | Details                                                                                                          |
| ------------ | ---------------------------------------------------------------------------------------------------------------- |
| **Table(s)** | `stg_sales`, `stg_customer`, `stg_date`                                                                          |
| **Joins**    | `stg_sales.customerkey = stg_customer.customerkey`<br>`stg_sales.orderdate = stg_date.date`                      |
| **Goal**     | For each **month** and **continent**, sum `netprice`.                                                            |
| **Chart**    | **Stacked Area Chart** • *Time* = `orderdate` (month grain) • *Stack* = `continent` • *Metric* = SUM(`netprice`) |

---

## Task 4 · Product Profit Margin by Category *(Advanced)*

| Item         | Details                                                                                                                    |
| ------------ | -------------------------------------------------------------------------------------------------------------------------- |
| **Table(s)** | `stg_sales`, `stg_product`                                                                                                 |
| **Join**     | `stg_sales.productkey = stg_product.productkey`                                                                            |
| **Goal**     | For each `categoryname`, compute **average profit margin** where margin = `(netprice – (quantity × unitcost)) / netprice`. |
| **Chart**    | **Bar Chart** • *X* = `categoryname` • *Metric* = AVG(margin %)                                                            |

---

## Task 5 · Revenue Heat-Map: Working Days vs. Day-of-Week *(Challenging)*

| Item         | Details                                                                                                 |
| ------------ | ------------------------------------------------------------------------------------------------------- |
| **Table(s)** | `stg_sales`, `stg_date`                                                                                 |
| **Join**     | `stg_sales.orderdate = stg_date.date`                                                                   |
| **Goal**     | Build a grid showing SUM(`netprice`) for each combination of `workingday` (true/false) and `dayofweek`. |
| **Chart**    | **Heatmap** • *X* = `dayofweek` • *Y* = `workingday` • *Metric* = SUM(`netprice`)                       |

---

Use SQL Lab to write each query, run it, **save as a dataset**, then switch to **Explore** to build the specified chart type.


---

## 6  SQL-Lab Practice Tasks

A saved list of advanced SQL-Lab exercises is available in the project discussion. Each produces chart-ready result sets.

---

## 7  Persistence

| Component                    | Storage location                                 |
| ---------------------------- | ------------------------------------------------ |
| Superset dashboards/metadata | Named volumes `superset1_data`, `superset2_data` |
| MinIO sample data            | Local folder `./data/`                           |

---

## 8  MinIO Credentials

| Console URL                                    | Access Key | Secret Key    |
| ---------------------------------------------- | ---------- | ------------- |
| [http://localhost:9001](http://localhost:9001) | `s3key`    | `s3keysecret` |

Bucket: **`demo`**

---

### Cleaning Up

```bash
# Stop containers, keep volumes
docker compose down

# Remove containers AND volumes (full reset)
docker compose down -v
docker compose up --build -d
```
