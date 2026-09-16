
SELECT DISTINCT
    sd.skills
FROM
    skills_dim AS sd
WHERE NOT EXISTS (
    SELECT
        1
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    WHERE
        jpf.job_title_short = 'Senior Data Engineer'
        AND sd.skill_id = sjd.skill_id
);