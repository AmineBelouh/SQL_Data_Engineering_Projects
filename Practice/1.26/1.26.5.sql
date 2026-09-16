WITH check_cte AS (
    SELECT
        *,
        COUNT(*) AS job_count
    FROM (
        SELECT  
            cd.name AS company_name,
            CASE
                WHEN jpf.salary_year_avg >= 100_000 THEN '1: $100,000+'
                WHEN jpf.salary_year_avg >= 75_000 THEN '2: $75,000 - $99,999'
                WHEN jpf.salary_year_avg >= 50_000 THEN '3: $50,000 - $74,999'
                WHEN jpf.salary_year_avg >= 25_000 THEN '4: $25,000 - $49,999'
                ELSE '5: Less than $25,000'
            END AS salary_range
        FROM job_postings_fact AS jpf
        INNER JOIN company_dim AS cd
            ON jpf.company_id = cd.company_id
        WHERE jpf.salary_year_avg IS NOT NULL
            AND jpf.job_title_short = 'Data Engineer'
            AND (jpf.job_title LIKE '%Junior%' OR jpf.job_title LIKE '%Entry%')
    ) AS company_salaries
    GROUP BY
        company_name,
        salary_range
    ORDER BY
        salary_range,
        job_count DESC
)

-- SELECT
--     *
-- FROM check_cte
-- WHERE company_name = 'Patterned Learning AI';

SELECT
    company_name,
    row_number() OVER(PARTITION BY company_name) AS rn
FROM check_cte
ORDER BY rn DESC;