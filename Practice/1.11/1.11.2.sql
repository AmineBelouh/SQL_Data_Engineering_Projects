SELECT
    jpf.job_id,
    jpf.job_title,
    sd.skills,
    jpf.job_country
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE   
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_country = 'United States'
    AND jpf.job_health_insurance = TRUE
ORDER BY
    jpf.job_id DESC;


SELECT
    *
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';