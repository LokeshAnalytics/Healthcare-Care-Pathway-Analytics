# Healthcare Care Pathway Analytics

## Project Overview
This project analyzes a synthetic healthcare dataset to understand member engagement, care pathway activity, authorization performance, provider utilization, and member demographics.

The goal is to transform raw healthcare data into actionable business insights using SQL and Power BI.

## Business Objectives
- Understand overall member and employer enrollment.
- Analyze member engagement across different care journey stages.
- Evaluate authorization approval, rejection, and pending rates.
- Identify monthly member engagement trends.
- Compare engagement across benefit plans.
- Analyze provider authorization requests.
- Understand member demographics by age group.

## Tools & Technologies
- **MySQL** – Data cleaning and exploratory data analysis (EDA).
- **Power BI** – Data modeling, DAX measures, and interactive dashboard development.
- **SQL** – Joins, CTEs, aggregations, subqueries, and date functions.
- **GitHub** – Project documentation and version control.

## Dataset Description
The project uses a synthetic healthcare dataset containing five tables:

| Table | Description |
|---|---|
| Members | Member enrollment and demographic information |
| Employers | Employer information |
| Providers | Healthcare provider information |
| Member Events | Member interactions and care journey events |
| Authorizations | Authorization requests and their outcomes |

**Note:** All data used in this project is synthetic and does not represent real patients, employers, or healthcare providers.

## Data Cleaning
Data cleaning was performed using MySQL.

Key activities:
- Created staging tables to preserve the original data.
- Checked for duplicate records.
- Identified and handled NULL and blank values.
- Standardized inconsistent data.
- Corrected date data types.
- Validated data quality after cleaning.

## Exploratory Data Analysis
SQL was used to investigate:
- Overall business performance.
- Member engagement.
- Authorization performance.
- Care pathway activity.
- Provider performance.
- Employer and benefit plan analysis.
- Member demographics.

## Power BI Dashboard

The interactive dashboard includes five key performance indicators:

1. Total Members
2. Total Employers
3. Total Providers
4. Total Authorization Requests
5. Authorization Approval Rate

### Dashboard Visualizations
- Member Care Journey Funnel
- Authorization Status Distribution
- Monthly Member Engagement Trend
- Member Engagement by Benefit Plan
- Top 10 Providers by Authorization Requests
- Member Demographics by Age Group

## Key Findings
- The dataset contains 5,000 members, 100 employers, and 200 providers.
- A total of 3,091 authorization requests were recorded.
- 80.78% of authorization requests were approved.
- 9.74% were rejected.
- 9.48% remained pending.

These findings describe the synthetic dataset used for this project.

## Business Recommendations
- Monitor authorization rejection rates to identify areas requiring further review.
- Track pending authorization requests to understand potential processing delays.
- Monitor monthly member engagement to identify changes in utilization.
- Compare engagement across benefit plans to understand differences in member activity.
- Review provider authorization volumes to support operational planning.

## Project Structure

```text
Healthcare_Care_Pathway_Analytics/
│
├── data/
│
├── sql/
│   ├── data cleaning.sql
│   └── exploratory data analysis.sql
│
├── dashboard/
│   ├── Healthcare_Care_Pathway_Analytics.pbix
│   └── screenshots/
│       └── dashboard_screenshot.png
│
└── README.md
```

## Skills Demonstrated
- SQL Data Cleaning
- Exploratory Data Analysis
- Data Modeling
- DAX Measures
- Power BI Dashboard Development
- Business Analysis
- Data Visualization
- Insight Communication