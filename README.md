# 120 Years of Olympic History – SQL Server & Tableau Analytics

This project analyzes **120 years of Olympic Games history** using **SQL Server (SSMS)** for data exploration and **Tableau** for interactive dashboards.

The goal is to showcase how I can:
- Design and load a relational schema from CSV files
- Write **intermediate–advanced SQL** (joins, CTEs, window functions)
- Translate SQL outputs into **clear visual stories** for stakeholders

---

## Dataset

- Source: [120 years of Olympic history – athletes and results](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results)
- Time period: **1896 – 2016**
- Scope: Summer and Winter Olympics, all athletes and medal events

For space/licensing reasons this repo includes only:
- `data/athletes_sample.csv`
- `data/athlete_events_sample.csv`

Use the Kaggle link above to download the full dataset.

---

## Data Model (SQL Server)

I used **SQL Server / SSMS** and split the data into two core tables:

- `athletes` – athlete-level information  
- `athlete_events` – event & medal-level information (one row per athlete-event)

```mermaid
erDiagram
    athletes {
        INT id PK
        NVARCHAR name
        NVARCHAR team
        CHAR(3) noc
        CHAR(1) sex
        INT age
        INT height
        INT weight
    }

    athlete_events {
        INT athlete_event_id PK
        INT athlete_id FK
        NVARCHAR games
        INT year
        NVARCHAR season
        NVARCHAR city
        NVARCHAR sport
        NVARCHAR event
        NVARCHAR medal
    }

    athletes ||--o{ athlete_events : "participates in"
