CREATE OR REPLACE TABLE job_postings_fact_year_salary AS
SELECT
    job_id, 
    job_title_short, 
    job_posted_date, 
    job_location, 
    salary_year_avg
FROM data_jobs.job_postings_fact
WHERE salary_year_avg IS NOT NULL;

DELETE FROM job_postings_fact_year_salary
WHERE job_location IS NULL;

SELECT * FROM job_postings_fact_year_salary;