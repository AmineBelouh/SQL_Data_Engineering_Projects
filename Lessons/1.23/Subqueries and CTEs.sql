-- Show each job's salary next to the overall market median

USE data_jobs;

SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    (
        SELECT
           MEDIAN(salary_year_avg)
        FROM job_postings_fact
    ) AS market_median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

-- Stage only jobs that are remote before aggregating to determine the remote median salary per job


SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT
           MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM 
    (
        SELECT
            job_title_short,
            salary_year_avg
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS remote_jobs
GROUP BY 
    job_title_short;


-- Keep only titles whose median salary is above the overall median

SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT
           MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM 
    (
        SELECT
            job_title_short,
            salary_year_avg
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS remote_jobs
GROUP BY 
    job_title_short
HAVING
    MEDIAN(salary_year_avg) > (
        SELECT
           MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    );


--------------------------------------------
--------------------------------------------
--------------------------------------------


-- CTE

WITH title_median_salary AS (
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_salary
    FROM job_postings_fact
    GROUP BY
        job_title_short,
        job_work_from_home
)

SELECT 
    remote_work.job_title_short,
    remote_work.median_salary AS remote_median_salary,
    onsite_work.median_salary AS onsite_median_salary,
    (remote_work.median_salary -  onsite_work.median_salary) AS diff
FROM title_median_salary AS remote_work
INNER JOIN title_median_salary AS onsite_work
    ON remote_work.job_title_short = onsite_work.job_title_short
WHERE 
    remote_work.job_work_from_home = TRUE
    AND onsite_work.job_work_from_home = FALSE
ORDER BY
    diff DESC;




--------------------------------------------
--------------------------------------------
--------------------------------------------



SELECT
    *
FROM
    range(10) AS src(key) -- how to name values using such functions (not just aliasing in SELECT)
WHERE NOT EXISTS (
    SELECT
        1
    FROM
        range(3) AS tgt(key)
    WHERE 
        src.key = tgt.key
    );


-- jobs with no skills
SELECT
    *
FROM job_postings_fact AS src
WHERE NOT EXISTS (
    SELECT
        1
    FROM skills_job_dim AS trgt
    WHERE src.job_id = trgt.job_id
)
ORDER BY job_id;