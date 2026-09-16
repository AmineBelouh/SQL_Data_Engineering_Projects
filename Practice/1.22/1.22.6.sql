CREATE OR REPLACE VIEW top_hiring_companies_temp AS
SELECT
    cd.company_id,
    cd.name AS company_name,
    COUNT(jpf.job_id) AS posting_count  
FROM data_jobs.job_postings_fact AS jpf
INNER JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
GROUP BY 
    cd.company_id,
    cd.name
HAVING
    COUNT(jpf.job_id) > 10
ORDER BY posting_count DESC;

SELECT * FROM top_hiring_companies_temp;