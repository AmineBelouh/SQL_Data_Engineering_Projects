/*
Top Demanded Skills

This query identifies the 10 most in-demand skills for remote Data Engineer jobs.

- FROM + JOINs: Combines job postings with the skills required for each posting.
- WHERE:
    - Filters for Data Engineer positions.
    - Includes only remote jobs (job_work_from_home = TRUE).
- GROUP BY skills: Groups all job postings by skill.
- COUNT(job_id): Counts how many job postings require each skill, measuring demand.
- ORDER BY demand_count DESC: Sorts skills from most to least demanded.
- LIMIT 10: Returns only the top 10 most requested skills.
*/

SELECT
    sd.skills,
    COUNT(jpf.job_id) AS demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
GROUP BY 
    sd.skills
ORDER BY
    demand_count DESC
LIMIT 10;

/*
┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │        29221 │
│ python     │        28776 │
│ aws        │        17823 │
│ azure      │        14143 │
│ spark      │        12799 │
│ airflow    │         9996 │
│ snowflake  │         8639 │
│ databricks │         8183 │
│ java       │         7267 │
│ gcp        │         6446 │
└────────────┴──────────────┘
  10 rows         2 columns  

Key takeaways:

- SQL and Python dominate — together they form the foundation of data engineering.
- Cloud is mandatory — AWS, Azure, and GCP all appear, with AWS leading by a clear margin.
- Big data matters — Spark remains the industry standard for large-scale data processing.
- Pipeline orchestration is a core skill — Airflow is the most recognized tool.
- Modern data platforms are in demand — Snowflake and Databricks have become mainstream rather than niche technologies.
- Java is useful but secondary — prioritize Python first unless a specific role requires Java.
*/