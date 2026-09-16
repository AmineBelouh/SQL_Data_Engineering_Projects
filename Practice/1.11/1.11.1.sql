SELECT
    jpc.job_id,
    jpc.job_title,
    cd.name AS company_name,
    jpc.job_location,
    jpc.job_posted_date
FROM job_postings_fact AS jpc
INNER JOIN company_dim AS cd
    ON jpc.company_id = cd.company_id
WHERE jpc.job_title_short = 'Data Engineer'
ORDER BY jpc.job_posted_date DESC;