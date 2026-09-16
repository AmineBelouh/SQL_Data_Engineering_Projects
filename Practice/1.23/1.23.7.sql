SELECT
    job_id,
    job_title_short
FROM
    job_postings_fact AS jpf
WHERE
    job_title_short = 'Data Engineer'
    AND EXISTS (
                SELECT
                    1
                FROM skills_job_dim AS sjd
                INNER JOIN skills_dim AS sd
                    ON sjd.skill_id = sd.skill_id
                WHERE sd.skills = 'python'
                    AND jpf.job_id = sjd.job_id
    );