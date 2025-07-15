
# Superset Migration Sandbox

Spin up a complete analytics lab with **Trino + Iceberg**, **Apache Superset**, **Hive Metastore**, and **MinIO**.  
Use it to practise SQL-Lab queries, create charts, and test dashboard migration between two Superset instances.

---

## Stack Overview

| Service       | Purpose                                               | Port(s) |
|---------------|-------------------------------------------------------|---------|
| **Trino**     | SQL/query engine                                      | `8080` |
| **Hive Metastore** | Catalog / metadata for Iceberg tables                | `9083` |
| **MinIO**     | S3-compatible object store (sample data)              | `9000` (API) · `9001` (console) |
| **Superset #1** | Primary BI instance                                  | `8088` |
| **Superset #2** | Secondary instance for migration tests               | `8089` |
| **PostgreSQL**  | Metastore DB (internal to Hive)                      | `5432` |

### Trino catalogs

| Catalog     | Notes                                       |
|-------------|---------------------------------------------|
| `iceberg`   | Main analytics tables (external Hive)       |
| `migration` | Same connector config, blank for experiments|

---

## Prerequisites

* Docker Engine & Docker Compose  
* (Optional) a SQL client, e.g. [DBeaver](https://dbeaver.io/)

---

## 1  Launch the Stack

```bash
git clone https://github.com/Dan-maksi/Superset_migration.git
cd Superset_migration
docker compose up --build -d
````

---

## 2  Load Tables (Hive → Iceberg)

After containers are up, open your SQL client (DBeaver, Superset SQL Lab, etc.) and run **both** scripts in this folder:

```
SQL Scripts/
  ├─ 00_create_hive_external_tables.sql
  └─ 01_create_iceberg_staging_tables.sql
```

1. **00\_create\_hive\_external\_tables.sql**
   *Creates external Hive tables that point to CSV files in MinIO.*

2. **01\_create\_iceberg\_staging\_tables.sql**
   *Casts each column to the correct data type and saves the results as Iceberg tables (`stg_*`).*

After the second script finishes, the Iceberg catalog (`iceberg.demo`) contains all analysis-ready `stg_` tables.

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

   Replace `<username>` with any name (Trino blocks anonymous logins).
4. **Test Connection** ▸ **Add**

You now see catalog **`iceberg`**, schema **`demo`**, and all `stg_` tables.

---

## 5  Create Datasets & Charts

1. **Data ▸ Datasets ▸ + Dataset**
2. Select schema **`demo`** and a table such as `stg_sales`.
3. **Add Dataset** ▸ **Explore** to build charts.

Example chart ideas:

| Purpose                        | Dataset(s) / Join(s)         | Suggested Chart |
| ------------------------------ | ---------------------------- | --------------- |
| Revenue trend by day           | `stg_sales` + `stg_date`     | Line            |
| Avg product margin by category | `stg_product`                | Bar             |
| Age-cohort revenue             | `stg_sales` + `stg_customer` | Bar (age bins)  |
| Exchange-rate volatility       | `stg_currencyexchange`       | Bar             |
| Store size vs sales            | `stg_sales` + `stg_store`    | Scatter         |

---

## 6  SQL-Lab Practice Tasks

See the project discussion for advanced SQL-Lab tasks that each produce chart-ready result sets.

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
