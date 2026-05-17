
select * from hr_data_updated;

-- cleaning variables
update hr_data_updated
set gender= case
   when trim(gender)in ('f','female') then 'Female'
   when trim(gender) in ('m', 'male')then 'Male'
   else gender
   end;
   
-- temperory table
create temporary table base_attrition as
select *,
case when Attrition = 'Yes' then 1 else 0 end as attrition_no
from hr_data_updated;

-- Attrition Rate
select count(*) as total_employee, 
sum(attrition_no) as left_employee,
round(sum(attrition_no)*100/count(*),2) as Attrition_rate
from base_attrition
;


-- Base CTE of attrition 
with base_attrition as (
select *,
case when Attrition = 'Yes' then 1 else 0 end as attrition_no
from hr_data_updated
)

select department, count(*) as total_employee, 
sum(attrition_no) as left_employee,
round(sum(attrition_no)*100/count(*),2) as Attrition_rate
from base_attrition
group by department order by attrition_rate desc;

-- ATTRITION BY AGE SEGMENTATION
select 
case when age <30 then 'Below_30'
     when age between 30 and 40 then '30-40'
     else 'Above_40' end as age_group
, count(*) as total_employee, 
sum(attrition_no) as left_employee,
round(sum(attrition_no)/count(*)*100,2) as Attrition_rate
from base_attrition
group by age_group order by attrition_rate desc;

-- ATTRITION BY SALARY BUCKET
select 
case when salary <500000 then 'Low' 
     when salary between 500000 and 1000000 then 'Medium'
     else 'High' end as Salary_Flag
, count(*) as total_employee, 
sum(case when attrition='yes' then 1 end) as left_employee,
round(sum(case when attrition='yes' then 1 end)/count(*)*100,2) as Attrition_rate
from hr_data_updated
group by salary_flag order by attrition_rate desc;

-- ATTRITION BY OVERTIME FLAG
     
select department,
case when work_hours >40 then 'Yes'
     when work_hours <=40 then 'No'
     else 'Unknown' end as 'Overtime',
     count(*) as total_employees, 
round(sum(attrition_no)*100
/count(*),2) as Attrition_rate
from base_attrition
group by department, overtime
order by attrition_rate desc;

-- gender and promotion
select gender, promotion,
count(*) as total_employees, 
round(sum(attrition_no)*100
/count(*),2) as Attrition_rate
from base_attrition
group by gender, promotion 
order by attrition_rate desc;

-- Training

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
    
select promotion, Education_Level,
 sum(case when attrition='yes' then 1 end) as left_employee,
round(sum(case when attrition='yes' then 1 end)/count(*)*100,2) as Attrition_rate
from hr_data_updated
group by Promotion, Education_Level
order by attrition_rate desc;

select Education_Level,
 sum(case when attrition='yes' then 1 end) as left_employee,
round(sum(case when attrition='yes' then 1 end)/count(*)*100,2) as Attrition_rate
from hr_data_updated
group by Education_Level
order by attrition_rate desc;

-- attrition by distance

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

-- ranking departments by attrition
select department, attrition_rate,
rank() over(order by attrition_rate desc) as rank_dept
from(
select department,
round(sum(attrition_no)*100/count(*),2) as attrition_rate
from base_attrition
group by department) t;

-- absentism
select 
case when distance_from_work < 5 then 'Very_close'
     when distance_from_work <15 then 'Near'
     when distance_from_work <25 then 'Moderate'
     when distance_from_work <35 then 'Far' else 'Very_far' 
     end as distance_bucket,
sum(absenteeism) as absent,
count(*) as total_employee,
sum(attrition_no) as left_employee,
round(sum(attrition_no)*100/count(*),2) as attrition_rate
from base_attrition
group by distance_bucket
order by absent desc;

