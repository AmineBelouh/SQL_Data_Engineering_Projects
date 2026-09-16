SELECT
    jpf.job_title_short,
    sd.skill_id,
    sd.skills,
    COUNT(*) AS job_count
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    job_title_short LIKE '%Data%'
GROUP BY 
    jpf.job_title_short,
    sd.skill_id,
    sd.skills
ORDER BY 
    COUNT(*) DESC;