# 120 Years of Olympic History – SQL Server & Tableau Analytics

This project analyzes **120 years of Olympic Games history (1896–2016)** using **SQL Server (SSMS)** for data exploration and **Tableau** for interactive dashboards. 

---

## 📌 Project Highlights

- Analyzed **~270k rows / 15 columns** of Olympic data covering 1896–2016 (Summer & Winter). :contentReference[oaicite:4]{index=4}  
- Designed a **2-table star schema** (`athletes` dimension + `athlete_events` fact).  
- Wrote SQL with:
  - **Window functions** (`COUNT() OVER`, `MAX() OVER`, `RANK() OVER`)  
  - **CTEs** for readability  
  - **STRING_AGG** to handle ties  
- Built **Tableau dashboards** showing:
  - Medal trends by country and year  
  - Country-level deep dives (e.g. India)  
  - “Legend” athletes: pure gold winners, all-medal winners, 3-Olympics gold streaks  

> **Tech Stack:** SQL Server (T-SQL), SSMS, Tableau, Git/GitHub

---

## 💾 Dataset

- **Source:** [120 years of Olympic history – athletes and results](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results)  
- **Coverage:** Athens 1896 → Rio 2016  
- **Scope:** Summer & Winter Games, athlete-level participation and medal records  

For space/licensing reasons, this repo includes only:

- `data/athletes_sample.csv`
- `data/athlete_events_sample.csv`

Use the Kaggle link above to download the **full dataset** if you want to fully reproduce the project.

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
