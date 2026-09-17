SELECT 
    *
FROM job_postings_fact
WHERE 
    NULLIF(TRIM(job_title), '') IS NOT NULL 
    AND NULLIF(UPPER(job_location), 'N/A') IS NOT NULL;