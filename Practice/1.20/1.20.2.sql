SELECT
    job_title_short,
    job_no_degree_mention::INT AS no_degree_mentioned,
    COUNT(job_id) AS job_postings
FROM job_postings_fact
WHERE
    job_posted_date::DATE BETWEEN '2024-12-01' AND '2024-12-31'
GROUP BY 
    job_title_short,
    job_no_degree_mention::INT
ORDER BY
    job_title_short,
    job_no_degree_mention::INT;