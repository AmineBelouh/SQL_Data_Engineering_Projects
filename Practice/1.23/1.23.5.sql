SELECT
    job_id, 
    job_title_short,
    job_location
FROM
    job_postings_fact 
WHERE 
    job_country IN (
            SELECT
                job_country
            FROM
                job_postings_fact 
            GROUP BY
                job_country
            HAVING
                COUNT(job_id) > (
                    SELECT
                        AVG(job_count) AS average_job_count
                    FROM (
                        SELECT
                            COUNT(job_id) AS job_count
                        FROM
                            job_postings_fact
                        GROUP BY
                            job_country
                    )
            )          
)
ORDER BY job_country, job_id;