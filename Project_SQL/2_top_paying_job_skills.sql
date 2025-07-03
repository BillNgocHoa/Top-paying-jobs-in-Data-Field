/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying DA jobs from 1st query
- Add the specific skills required for these roles
-Why? It provides a detailed look at which high-paying jobs demand certain skills,
    helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        companies.name AS company_name
    FROM 
        job_postings_fact
    LEFT JOIN company_dim AS companies -- to extract comapny names
        ON job_postings_fact.company_id = companies.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
-- We care about: SKILLs associated with SALARY.  => INNER JOIN
-- We don't care about jobs that have no skill

SELECT 
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs  -- 'top_paying_jobs' = 'job_postings_fact' in this case
INNER JOIN skills_job_dim   
    ON top_paying_jobs.job_id = skills_job_dim.job_id   -- to get the "skill_id"
INNER JOIN skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    salary_year_avg DESC;

/*
Key insights from skill analysis:
- SQL (8) is the top-required skill, essential for 80% of roles.
- Python (7) and Tableau (6) are highly valued, emphasizing programming and data visualization.
- R (4) remains relevant for advanced statistical analysis.
- Cloud and data tools, such as Snowflake (3), Azure (2), and AWS (2), show demand for modern data infrastructure skills.
- Python libraries like Pandas (3) and Numpy (2) highlight the importance of data manipulation.
- Excel (3) is still widely used, even in top-paying roles.
- Collaboration tools (Bitbucket, GitLab, Confluence, Jira — all with 2 mentions each) underscore the need for teamwork and agile practices.
*/