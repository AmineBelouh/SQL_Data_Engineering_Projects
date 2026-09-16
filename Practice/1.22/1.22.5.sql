USE company_jobs;

CREATE OR REPLACE TEMPORARY TABLE ds_skills_count_temp AS
SELECT
    sd.skills,
    COUNT(jpf.job_id) AS skill_count
FROM data_jobs.job_postings_fact AS jpf
INNER JOIN data_jobs.skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN data_jobs.skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Scientist'
GROUP BY
    sd.skills
ORDER BY
    skill_count DESC;


SELECT * FROM ds_skills_count_temp;