Copy-paste the block below directly into **`README.md`**.
It’s fully Markdown-formatted for GitHub.


# Superset Migration Sandbox

Spin up a complete analytics lab with **Trino + Iceberg**, **Apache Superset**, **Hive Metastore**, and **MinIO**.  
Use it to practise SQL-Lab queries, create charts, and test dashboard migration between two Superset instances.

---

## Stack Overview

| Service      | Purpose                                           | Port(s) |
|--------------|---------------------------------------------------|---------|
| **Trino**        | SQL/query engine                                 | `8080` |
| **Hive Metastore** | Catalog / metadata for Iceberg tables            | `9083` |
| **MinIO**        | S3-compatible object storage (sample data)       | `9000` (API) · `9001` (console) |
| **Superset #1**  | Primary BI instance                              | `8088` |
| **Superset #2**  | Secondary instance for migration tests           | `8089` |
| **PostgreSQL**   | Metastore DB (internal to Hive)                  | `5432` |

### Trino catalogs

| Catalog      | Notes                                       |
|--------------|---------------------------------------------|
| `iceberg`    | Main analytics tables (external Hive)       |
| `migration`  | Same connector config, blank for experiments |

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

> **First run:**
> MinIO loads sample CSVs into bucket `demo`, Hive external tables are created, and Iceberg staging tables (`stg_*`) are materialised.

---

## 2  Superset Login

| Instance    | URL                                            | Username | Password |
| ----------- | ---------------------------------------------- | -------- | -------- |
| Superset #1 | [http://localhost:8088](http://localhost:8088) | `admin`  | `admin`  |
| Superset #2 | [http://localhost:8089](http://localhost:8089) | `admin`  | `admin`  |

---

## 3  Connect Trino → Superset #1

1. **Settings ▸ Data ▸ Databases ▸ + Database**

2. Choose **Trino**

3. **SQLAlchemy URI**

   ```text
   trino://<username>@trino:8080/iceberg
   ```

   Replace `<username>` with any name (Trino blocks anonymous logins).

4. **Test Connection** ▸ **Add**

You now see catalog **`iceberg`**, schema **`demo`**, and all tables beginning with `stg_`.

---

## 4  Create a Dataset

* **Data ▸ Datasets ▸ + Dataset**

  * **Database**  Trino connection you just added
  * **Schema**    `demo`
  * **Table**     e.g. `stg_sales`
* **Add Dataset** ▸ **Explore**

---

## 5  Sample Chart Ideas

| Purpose                        | Dataset(s) / Join(s)         | Suggested Chart |
| ------------------------------ | ---------------------------- | --------------- |
| Revenue trend by day           | `stg_sales` ＋ `stg_date`     | Line            |
| Avg product margin by category | `stg_product`                | Bar             |
| Age-cohort revenue             | `stg_sales` ＋ `stg_customer` | Bar (age bins)  |
| Exchange-rate volatility       | `stg_currencyexchange`       | Bar             |
| Store size vs sales            | `stg_sales` ＋ `stg_store`    | Scatter         |

---

## 6  SQL-Lab Practice Tasks

A saved list of advanced SQL-Lab exercises (joins, aggregations, date logic) is in the project discussion.
Each task is designed to produce a result set you can turn into a Superset chart.

---

## 7  Data Persistence

| Component                      | Where it lives                                   |
| ------------------------------ | ------------------------------------------------ |
| Superset metadata & dashboards | Named volumes `superset1_data`, `superset2_data` |
| MinIO sample data              | Local folder `./data/`                           |

---

## 8  MinIO Credentials

| Console URL                                    | Access Key | Secret Key    |
| ---------------------------------------------- | ---------- | ------------- |
| [http://localhost:9001](http://localhost:9001) | `s3key`    | `s3keysecret` |

Bucket: **`demo`**

---

## House-Keeping

```bash
# Stop containers, keep volumes
docker compose down

# Remove containers AND volumes (full reset)
docker compose down -v
docker compose up --build -d
```

---

Happy exploring!
Create datasets from `stg_` tables, write custom SQL in SQL Lab, turn queries into powerful visualisations, and practise dashboard migration between the two Superset instances.

```

*Everything above is standard GitHub Markdown—just save it as `README.md`.*
```
