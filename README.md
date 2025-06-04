Cricket Analytics Data Warehouse – Snowflake Project

This project demonstrates a complete end-to-end data engineering pipeline for processing and analyzing international cricket match data using **Snowflake**. The pipeline includes data ingestion, transformation, and modeling to support analytics use cases such as player performance, team comparisons, and match outcomes.

---

Project Overview

- **Source Data**: JSON files containing ICC World Cup match details (overs, deliveries, players, outcomes, etc.).
- **Tools Used**: Snowflake, SQL, SnowSQL, Streams, Tasks, External Stages.
- **Architecture**: Layered schema design (`land`, `raw`, `clean`, `consumption`) using the data lakehouse pattern.
- **Output**: A star schema powering analytical queries and potential integration with BI tools

