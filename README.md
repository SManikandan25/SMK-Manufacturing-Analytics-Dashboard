# SMK Manufacturing Analytics Dashboard
### End-to-End Manufacturing Analytics Solution | Snowflake | SQL | Power BI | DAX | Dynamic RLS

## 📌 Project Overview

The **SMK Manufacturing Analytics Dashboard** is an end-to-end Business Intelligence portfolio project designed to analyze manufacturing operations across multiple plants.

The project uses Snowflake as the data warehouse and Power BI to develop interactive dashboards that monitor production performance, product quality, machine downtime, and maintenance costs.

It also implements Dynamic Row-Level Security (RLS) to provide role-based data access.

## 🎯 Business Problem

Manufacturing organizations need centralized reporting to monitor operational performance and identify areas for improvement.

Key challenges addressed in this project include:

- Tracking planned production targets against actual output.
- Monitoring production achievement and production variance.
- Identifying quality issues and defect trends.
- Analyzing machine downtime and maintenance expenses.
- Comparing plant and machine performance.
- Restricting dashboard data access according to user roles.

## 🎯 Project Objectives

- Build a centralized manufacturing analytics solution.
- Monitor production, quality, downtime, and maintenance KPIs.
- Compare current-year and previous-year production performance.
- Analyze plant-level and machine-level performance.
- Develop interactive dashboards with filters and drill-downs.
- Implement Dynamic RLS for CEO, Regional Manager, and Plant Manager access.

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| Snowflake | Cloud data warehousing |
| SQL | Database setup, data loading, querying, and validation |
| Power BI Desktop | Interactive dashboard development |
| DAX | KPI measures and business calculations |
| Star Schema | Analytical data modeling |
| Power BI Service | Report publishing and online access |
| Dynamic RLS | Role-based data security |

## 🏗️ Solution Architecture

The project follows this end-to-end architecture:

**Manufacturing Source Data → Snowflake Database → Fact & Dimension Tables → Star Schema Data Model → Power BI Dataset → Interactive Dashboards → Business Users**

![SMK Manufacturing Solution Architecture](Images/solution-architecture.png)

## 🗄️ Data Model

The analytical model follows a **Star Schema** structure using fact and dimension tables.

### Fact Tables

- `FACT_PRODUCTION`
- `FACT_PRODUCTION_TARGET`
- `FACT_QUALITY`
- `FACT_DOWNTIME`
- `FACT_MAINTENANCE`

### Dimension Tables

- `DIM_DATE`
- `DIM_PLANT`
- `DIM_MACHINE`
- `DIM_PRODUCT`
- `DIM_SHIFT`
- `DIM_LINE`
- `DIM_USER_ACCESS`

The model supports filtering and analysis across manufacturing plants, production lines, machines, products, and dates.

![SMK Manufacturing Data Model](Images/Data%20model.png)

## 📊 Power BI Dashboard Pages

### 1. Executive Overview

Provides a consolidated view of key manufacturing KPIs, including production achievement, defect rate, maintenance cost, and downtime hours.

![Executive Overview](Images/dashboard-screenshots/1.Executive%20Overview.png)

### 2. Production Performance

Analyzes planned versus actual production, production variance, achievement percentage, plant performance, and current-year versus previous-year trends.

![Production Performance](Images/dashboard-screenshots/2.Production%20Performance.png)

### 3. Quality Analytics

Monitors total inspections, pass rate, defect rate, defect quantity, and defect patterns across manufacturing plants.

![Quality Analytics](Images/dashboard-screenshots/3.Quality%20Analytics.png)

### 4. Downtime & Maintenance Analytics

Analyzes downtime hours, downtime events, maintenance costs, and maintenance performance across plants and machine types.

![Downtime and Maintenance Analytics](Images/dashboard-screenshots/4.Downtime%20%26%20Maintenance%20Analytics.png)

### 5. Machine Analysis

Compares machine-level production, downtime, and maintenance costs to help identify performance leaders and areas requiring further investigation.

![Machine Analysis](Images/dashboard-screenshots/5.Machine%20Analsis.png)

## 📈 Key Business Insights

The dashboard presentation reports the following results:

| KPI | Reported Value |
|---|---:|
| Production Achievement | 95.42% |
| Defect Rate | 2.35% |
| Total Downtime | 4,118 hours |
| Total Maintenance Cost | 21.12M |
| Best-performing Machine | Grinding Machine |

- Production achievement is below a 100% target, indicating a production gap to investigate.
- Defect analysis helps identify quality issues that may require corrective action.
- Downtime analysis supports investigation of operational interruptions.
- Machine-level analysis helps identify equipment that may need closer performance or maintenance review.

*Reported values may change depending on the dashboard filters and the selected reporting period. Maintenance cost is shown as displayed in the project presentation.*

## 🔐 Dynamic Row-Level Security (RLS)

Dynamic RLS is implemented using `USERPRINCIPALNAME()` and the `DIM_USER_ACCESS` table.

### Access Levels

| Role | Intended Access |
|---|---|
| CEO | All plants |
| Regional Manager | Assigned region |
| Plant Manager | Assigned plant |

### Security Flow

User Login → `USERPRINCIPALNAME()` → `DIM_USER_ACCESS` → Role Validation → Plant / Region Filtering → Dashboard Access

![SMK Manufacturing Security Flow](Images/security-flow.png)

The role logic has been tested in Power BI Desktop. Power BI Service role assignment and access require separate validation before production use.

## 📂 Repository Structure

```text
SMK-Manufacturing-Analytics-Dashboard/
│
├── README.md
│
├── Documentation/
│   └── SMK_Manufacturing_Project_Documentation.docx
│
├── Presentation/
│   ├── SMK-Manufacturing-Analytics-Dashboard.pptx
│   └── SMK_Manufacturing_Analytics_Project_Presentation.pdf
│
├── PowerBI/
│   └── SMK_Manufacturing_Analytics.pbix
│
├── SQL_Scripts/
│   ├── 01_setup.sql
│   ├── 02_dimensions.sql
│   ├── 03_fact_tables.sql
│   ├── 04_load_data.sql
│   └── 05_validation.sql
│
└── Images/
    ├── solution-architecture.png
    ├── security-flow.png
    ├── Data model.png
    ├── SMK_Manufacturing_Dashboard_Images.pdf
    │
    └── dashboard-screenshots/
        ├── 1.Executive Overview.png
        ├── 2.Production Performance.png
        ├── 3.Quality Analytics.png
        ├── 4.Downtime & Maintenance Analytics.png
        └── 5.Machine Analysis.png
```

## ⚠️ Project Limitations

- This is a portfolio demonstration using sample manufacturing data.
- Live ERP integration and real-time IoT monitoring are not included.
- Predictive maintenance and machine learning forecasting are not implemented.
- Power BI Service security configuration requires separate validation.

## 🚀 Future Enhancements

- Production forecasting using machine learning.
- Predictive maintenance analytics.
- Automated alerts for production and downtime issues.
- Integration with live manufacturing data sources.

## 👨‍💻 Author

**S. Manikandan**

Data Analytics Portfolio Project

**Technologies:** Snowflake | SQL | Power BI | DAX | Dynamic RLS
