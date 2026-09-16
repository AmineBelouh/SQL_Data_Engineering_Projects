USE data_jobs;

WITH company_averages AS (
    SELECT
        company_id,
        AVG(salary_year_avg) AS avg_company_salary
    FROM data_jobs.job_postings_fact jpf
    GROUP BY company_id
)

SELECT
    jpf.job_id,
    jpf.job_title_short, 
    jpf.company_id, 
    jpf.salary_year_avg,
    ca.avg_company_salary
FROM data_jobs.job_postings_fact jpf
INNER JOIN company_averages ca
    ON jpf.company_id = ca.company_id
WHERE 
    jpf.salary_year_avg > ca.avg_company_salary;