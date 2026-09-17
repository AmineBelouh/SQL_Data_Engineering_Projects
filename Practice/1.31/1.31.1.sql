SELECT
    jpf.job_id,
    jpf.job_title_short,
    ARRAY_LENGTH ( ARRAY_AGG(
        sjd.skill_id ORDER BY sjd.skill_id
    ) ) AS skill_count
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
GROUP BY
    jpf.job_id,
    jpf.job_title_short
HAVING 
    ARRAY_LENGTH ( ARRAY_AGG(
        sjd.skill_id ORDER BY sjd.skill_id
    ) ) > 12;




SELECT
    cd.name AS company_name,
    ARRAY_AGG (
        DISTINCT jpf.job_location
    ) AS hiring_locations
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
GROUP BY cd.name
LIMIT 20;



WITH priority_list AS (
SELECT
    UNNEST(['Data Engineer', 'Data Scientist', 'Senior Data Engineer']) AS titles
)

SELECT
    job_id, 
    job_title_short, 
    salary_year_avg
FROM
    job_postings_fact AS jpf
INNER JOIN priority_list pl
    ON jpf.job_title_short = pl.titles;



WITH job_skill_counts AS ( 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    ARRAY_LENGTH(ARRAY_AGG(sjd.skill_id)) AS skill_count
FROM
    job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
WHERE jpf.job_title_short IN ('Data Engineer', 'Data Analyst')
GROUP BY jpf.job_id, jpf.job_title_short
)

SELECT
    job_title_short,
    AVG(skill_count) AS avg_skills
FROM job_skill_counts
GROUP BY job_title_short;






SELECT
    cd.name AS company_name,
    ARRAY_LENGTH( ARRAY_AGG (
        DISTINCT jpf.job_location
    ) ) AS location_diversity_count
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
GROUP BY cd.name
HAVING ARRAY_LENGTH( ARRAY_AGG (
        DISTINCT jpf.job_location
    ) ) > 5
ORDER BY location_diversity_count DESC;




WITH skills_array_cte AS (
    SELECT
        job_id,
        ARRAY_AGG(skill_id) AS skill_id_array 
    FROM
        skills_job_dim
    GROUP BY job_id
), skills_unnest_cte AS (
    SELECT
        job_id,
        UNNEST(skill_id_array) AS skill_id
    FROM skills_array_cte
)

SELECT
    s.job_id,
    sd.skills AS skill_name
FROM skills_unnest_cte AS s
INNER JOIN skills_dim AS sd
    ON s.skill_id = sd.skill_id
LIMIT 100;





WITH company_skills_count_cte AS (
    SELECT
        cd.name AS company_name,
        ARRAY_LENGTH(ARRAY_AGG(DISTINCT sjd.skill_id)) AS skills_count
    FROM
        job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    INNER JOIN company_dim AS cd
        ON jpf.company_id = cd.company_id
    GROUP BY cd.name
), ranking_companies_cte AS (
    SELECT
        *,
        DENSE_RANK() OVER(ORDER BY skills_count DESC) AS rank
    FROM company_skills_count_cte
)
SELECT
    *
FROM ranking_companies_cte
WHERE rank <= 10;




WITH companies_salaries_cte AS (
    SELECT
        company_id,
        AVG(salary_year_avg) AS avg_salary,
        ARRAY_AGG (
            salary_year_avg
        ) AS company_salaries
    FROM
        job_postings_fact
    WHERE salary_year_avg IS NOT NULL 
    GROUP BY company_id
), unnest_salaries_cte AS (
    SELECT
        company_id,
        UNNEST(company_salaries) AS salary,
        avg_salary
    FROM companies_salaries_cte
)
SELECT
    company_id,
    salary,
    avg_salary
FROM unnest_salaries_cte
WHERE salary > avg_salary * 1.5;





WITH skills_count_cte AS (
    SELECT
        jpf.company_id,
        jpf.job_id,
        ARRAY_LENGTH(ARRAY_AGG(DISTINCT sjd.skill_id)) AS skills_count
    FROM
        job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    GROUP BY jpf.company_id, jpf.job_id
), avg_skills_cte AS (
SELECT
    company_id,
    job_id,
    skills_count,
    AVG(skills_count) OVER(PARTITION BY company_id) AS avg_company_skills
FROM skills_count_cte
)
SELECT
    *
FROM avg_skills_cte
WHERE skills_count > avg_company_skills;