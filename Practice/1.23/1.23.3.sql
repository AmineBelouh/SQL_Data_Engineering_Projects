
SELECT
    job_id, 
    job_title_short,
    job_location
FROM 
    job_postings_fact 
WHERE company_id = (
    SELECT
        company_id
    FROM company_dim
    WHERE name = 'Google'
    ) AND salary_year_avg > 100_000;