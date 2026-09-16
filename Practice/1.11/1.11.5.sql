SELECT
    jpf.job_title_short,
    sd.skills,
    COUNT(jpf.job_id) AS job_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.salary_year_avg > 100_000
GROUP BY
    jpf.job_title_short,
    sd.skills
ORDER BY
    COUNT(jpf.job_id) DESC;