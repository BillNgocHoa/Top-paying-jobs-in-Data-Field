/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis
*/

WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills, -- "skills" is Functional Dependant on "skill_id" => No need in GROUP BY
        COUNT(skills_job_dim.job_id) AS demand_job_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id   -- to get the "skill_id"
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id  -- to get skill names
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
), average_salary AS(
    SELECT 
        skills_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id   -- to get the "skill_id"
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id  -- to get skill names
    WHERE
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_job_count,
    avg_salary
FROM 
    skills_demand
INNER JOIN average_salary
    ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
    demand_job_count DESC, -- Prioritise order column above
    avg_salary DESC

LIMIT 25;