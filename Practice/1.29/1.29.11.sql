WITH clean_location_cte AS (
SELECT
    *,
    LOWER(TRIM(job_location)) AS clean_location
FROM
    job_postings_fact
)

SELECT
    job_id,
    clean_location,
    CASE
        WHEN clean_location LIKE '%remote%' OR clean_location LIKE '%anywhere%' THEN 'Remote'
        WHEN NULLIF(clean_location, '') IS NULL THEN 'Global'
        ELSE 'On-site/Hybrid'
    END AS location_category 
FROM
    clean_location_cte;