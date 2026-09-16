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
        jpf.job_id,
        ARRAY_AGG(sjd.skill_id) AS skill_id_array 
    FROM
        job_postings_fact AS jpf
    LEFT JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
), skills_unnest_cte AS (
    
)