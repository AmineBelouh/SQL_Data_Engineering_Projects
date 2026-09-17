SELECT
    ROW_NUMBER() OVER() AS global_row_id,
    job_id,
    job_posted_date
FROM job_postings_fact
ORDER BY job_posted_date
LIMIT 10;



SELECT
    job_id,
    job_location,
    salary_year_avg,
    AVG(salary_year_avg) OVER(PARTITION BY job_location) AS location_job_salary,
    salary_year_avg -  AVG(salary_year_avg) OVER(PARTITION BY job_location) AS diff
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 20;



SELECT
    job_id,
    skill_id,
    COUNT(*) OVER(PARTITION BY skill_id) AS global_skill_count 
FROM
    skills_job_dim AS sjd
LIMIT 20;



SELECT
    company_id,
    job_id,
    job_posted_date,
    salary_year_avg,
    SUM(salary_year_avg) OVER(PARTITION BY company_id ORDER BY job_posted_date) AS running_salary_total
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 10;



WITH ranked_postings AS (
    SELECT
        company_id,
        job_id,
        job_posted_date,
        ROW_NUMBER() OVER(PARTITION BY company_id ORDER BY job_posted_date DESC) AS rank
    FROM job_postings_fact
)

SELECT
    *
FROM ranked_postings
WHERE rank = 1;




SELECT
    *
FROM (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        RANK() OVER(PARTITION BY job_title_short ORDER BY salary_year_avg DESC) AS rank
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
)
WHERE rank <= 3
ORDER BY job_title_short, rank;





SELECT
        job_id,
        job_location,
        salary_year_avg,
        DENSE_RANK() OVER(PARTITION BY job_location ORDER BY salary_year_avg DESC) AS salary_level
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY job_location, salary_level;






SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    AVG(salary_year_avg) OVER(PARTITION BY job_title_short) AS avg_salary,
    salary_year_avg - AVG(salary_year_avg) OVER(PARTITION BY job_title_short) AS deviation 
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL;




WITH companies_postings AS (
    SELECT
        company_id,
        job_id,
        job_posted_date,
        LAG(job_posted_date) OVER(PARTITION BY company_id ORDER BY job_posted_date) AS previous_post
    FROM
        job_postings_fact
)

SELECT
    *,
    job_posted_date - previous_post
FROM companies_postings
WHERE previous_post IS NOT NULL
LIMIT 50;





WITH job_title_salaries AS (
    SELECT
        job_title_short,
        job_id,
        job_posted_date,
        salary_year_avg AS current_salary,
        LEAD(salary_year_avg) OVER(PARTITION BY job_title_short ORDER BY job_posted_date) AS next_post_salary
    FROM
        job_postings_fact
    WHERE salary_year_avg IS NOT NULL
)

SELECT
    *,
    next_post_salary - current_salary AS diff_between,
    CASE
        WHEN current_salary - next_post_salary < 0 THEN 'Increasing' 
        WHEN current_salary - next_post_salary > 0 THEN 'Decreasing'
        ELSE 'Stable'
    END AS trend_direction
FROM job_title_salaries
LIMIT 50;




SELECT 
    *,
    salary_year_avg / total_salary_expenditure * 100 AS percent_of_total_spend
FROM (
    SELECT
        company_id,
        job_id,
        salary_year_avg,
        SUM(salary_year_avg) OVER(PARTITION BY company_id) AS total_salary_expenditure
    FROM
        job_postings_fact
    WHERE salary_year_avg IS NOT NULL
)
ORDER BY company_id;



WITH salaries AS (
    SELECT
        job_title_short,
        job_id, 
        salary_year_avg,
        MIN(salary_year_avg) OVER(PARTITION BY job_title_short) AS min_s,
        MAX(salary_year_avg) OVER(PARTITION BY job_title_short) AS max_s
    FROM
        job_postings_fact
    WHERE salary_year_avg IS NOT NULL
)

SELECT
    *,
    (salary_year_avg - min_s) / NULLIF((max_s - min_s), 0) AS normalized_salary_score
FROM    
    salaries
ORDER BY
    job_title_short;