# Employee-Attrition-Analysis-High-Risk-Segmentation---SQL-POWER-BI

**Executive Summary**

This project analyze employee attrition to identify key drivers of turnover and detect high-risk employee groups. Using SQL for data transformation and Power BI for visualization, the analysis reveals that distance from workplace, lack of promotion and department-level factors significantly impact attrition. The project provide actionable recommendations to improve employee retention and reduce business costs.

**Business Problem**

The organization is facing high employee attrition that is 48%, leading to:

- Increased hiring & training costs
- Lose of experienced employees
- Reduced productivity

Key questions:

- Which employees are most likely to leave?
- What factors drive attrition?
- How can we reduce employee churn?

**Tools Used**

- SQL- Subquery, CTE, Windows Functions, Aggregations.
- Excel
- Power BI - DAX measures, Interactive Dashboard

---

---

**Methodology**

Data Processing & Transformation

- Data Cleaning & Handled null values and inconsistencies.
- Created derived fields- Distance bucket, Salary bucket.
- Built CTE to identify high-risk employees
- Used temporary tables for reusable aggregations.

SQL-Analysis

High Risk Employee Identification

```sql
with high_risk_group as ( 
select *,
case when training_hours >30 then 'high'
     when training_hours between 10 and 30 then 'medium' else 'low' end as training_bucket 
from base_attrition
)
select education_level,
       training_bucket,
       promotion,
sum(attrition_no) as left_employes,
round(sum(attrition_no)*100/count(*),2) as attrition_rate
  from high_risk_group
group by education_level, training_bucket, promotion
order by attrition_rate desc;

```

Department Ranking

```sql
select department, attrition_rate,
rank() over(order by attrition_rate desc) as rank_dept
from(
select department,
round(sum(attrition_no)*100/count(*),2) as attrition_rate
from base_attrition
group by department) t;

```

Attrition By Distance

```sql
select 
case when distance_from_work < 5 then 'Very_close'
     when distance_from_work <15 then 'Near'
     when distance_from_work <25 then 'Moderate'
     when distance_from_work <35 then 'Far' else 'Very_far' 
     end as distance_bucket,
count(*) as total_employee,
sum(attrition_no) as left_empoloyee,
round(sum(attrition_no)*100/count(*),2) as attrition_rate
from base_attrition
group by distance_bucket
order by attrition_rate;

```

**Skills Demonstrated**

- SQL- CTE, Window Functions, Aggregations, Temporary Table
- Data Cleaning & Transformation
- Power BI- Data Visualization, Dax
- Business Analysis & Insight Generation
- Problem Solving

---

**Results** 

1. Overall Attrition Analysis-

The analysis began by evaluating the overall attrition rate, which was found to be approximately 48.46%. This immediately highlighted a critical issues- nearly half of the workforce is leaving the organization. This prompted a deeper investigation into where and why employees are leaving.

- The overall attrition rate is approximately 48.46%, indicating a significant workforce retention issue.
- Nearly 1 in 2 employees are leaving the organization, which can heavily impact business continuity and costs.

1. Department Analysis-

The next step was to break down attrition across departments. The analysis revealed that attrition is not evenly distributed.

- Departments such as  Sales(56.7%) and HR(54.8%) showed significantly highest attrition rates compared to others like Operations and IT.
- This suggest that certain work environments may be more stressful or lacking engagement. This insight indicates the need for targeted interventions at the department level.


This indicates that attrition is not uniform and is concentrated in specific departments.

1. Attrition by Distance from Workplace-


One of the most striking findings emerged when analyzing attrition based on distance from the work place.

- Employees living very far from the office showed attrition rates close to 98%, while those living nearby had significantly lower attrition (11%).
- This clearly indicates that commute distance is one of the strongest predictors of attrition. Long travel times lead to fatigue, poor work-life balance, and dissatisfaction.

1.  Promotion Analysis-

Further analysis focused on promotion status, revealing that employees who had not received promotions were significantly more likely to leave.

- This highlights the importance of career progression and recognition. Employees who feel stagnant in their roles are more likely to seek opportunities elsewhere

1. Education &Training Analysis-

Training and development also emerged as a key factor. Employees with lower training hours showed higher attrition rates.

This suggest that employees who are not engaged in continous learning may feel undervalued or lack growth opportunities.

**Business Recommendations**

1. Workforce Strategy 
- Action: Improve workload balance and employee programs
1. Location-Based Retention
- Action: Provide remote/hybrid work options
               Offer relocation or travel benefits
1. Promotion & Career Growth
- Action: Introduce clear promotion cycles 
               Provide career growth paths
1. Training & Development 
- Action: Increase learning & development programs
1. Compensation & Satisfaction
- Action: Improve salary structure & benefits
               Focus on work-life balance initiatives

**Next Steps**

- Build attrition prediction model (ML)
- Conduct employee surveys for deeper insights
- Track KPI’s after implementing recommendations

---
