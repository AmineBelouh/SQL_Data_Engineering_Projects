SELECT
    job_posted_date,
    company_id,
    company_id::VARCHAR || '-' || job_posted_date::DATE::VARCHAR AS compound_key,
    job_title_short
FROM
    job_postings_fact
LIMIT 10;