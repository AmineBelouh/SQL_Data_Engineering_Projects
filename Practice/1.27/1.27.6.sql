SELECT
    DATE_TRUNC('quarter', job_posted_date) AS job_posted_quarter,
    CASE
        WHEN DATE_TRUNC('quarter', job_posted_date)::VARCHAR LIKE '%-01-%' THEN '1'
        WHEN DATE_TRUNC('quarter', job_posted_date)::VARCHAR LIKE '%-04-%' THEN '2'
        WHEN DATE_TRUNC('quarter', job_posted_date)::VARCHAR LIKE '%-07-%' THEN '3'
        ELSE '4'
    END AS formatted_quarter,
    COUNT(job_id) AS job_count
FROM
    job_postings_fact
WHERE
    DATE_TRUNC('year', job_posted_date) BETWEEN '2023-01-01' AND '2024-12-31'
GROUP BY
    job_posted_quarter,
    CASE
        WHEN DATE_TRUNC('quarter', job_posted_date)::VARCHAR LIKE '%-01-%' THEN '1'
        WHEN DATE_TRUNC('quarter', job_posted_date)::VARCHAR LIKE '%-04-%' THEN '2'
        WHEN DATE_TRUNC('quarter', job_posted_date)::VARCHAR LIKE '%-07-%' THEN '3'
        ELSE '4'
    END
ORDER BY
    job_posted_quarter;