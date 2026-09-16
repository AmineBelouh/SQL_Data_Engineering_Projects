/*
Top Paying Skills

This query identifies the highest-paying skills for remote Data Engineer jobs.

- FROM + JOINs: Combines job postings with the skills associated with each job.
- WHERE:
    - Filters for Data Engineer positions.
    - Includes only remote jobs (job_work_from_home = TRUE).
- GROUP BY skills: Groups all job postings by individual skill.
- MEDIAN(salary_year_avg): Calculates the median annual salary for each skill to reduce the effect of salary outliers.
- COUNT(job_id): Counts how many job postings require each skill (demand).
- HAVING COUNT(job_id) > 100: Keeps only skills that appear in at least 100 job postings, ensuring the results are statistically meaningful.
- ORDER BY median_salary DESC: Ranks skills from highest to lowest median salary.
- LIMIT 25: Returns the top 25 highest-paying skills.
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
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
HAVING
    COUNT(jpf.job_id) > 100
ORDER BY
    median_salary DESC
LIMIT 25;

/*
┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ rust       │      210000.0 │          232 │
│ golang     │      184000.0 │          912 │
│ terraform  │      184000.0 │         3248 │
│ spring     │      175500.0 │          364 │
│ neo4j      │      170000.0 │          277 │
│ gdpr       │      169616.0 │          582 │
│ zoom       │      168438.0 │          127 │
│ graphql    │      167500.0 │          445 │
│ mongo      │      162250.0 │          265 │
│ fastapi    │      157500.0 │          204 │
│ bitbucket  │      155000.0 │          478 │
│ django     │      155000.0 │          265 │
│ crystal    │      154224.0 │          129 │
│ atlassian  │      151500.0 │          249 │
│ c          │      151500.0 │          444 │
│ typescript │      151000.0 │          388 │
│ kubernetes │      150500.0 │         4202 │
│ node       │      150000.0 │          179 │
│ airflow    │      150000.0 │         9996 │
│ css        │      150000.0 │          262 │
│ ruby       │      150000.0 │          736 │
│ redis      │      149000.0 │          605 │
│ vmware     │      148798.0 │          136 │
│ ansible    │      148798.0 │          475 │
│ jupyter    │      147500.0 │          400 │
└────────────┴───────────────┴──────────────┘
  25 rows                         3 columns

Key Takeaways:

- Rust commands the highest median salary ($210K), although demand is relatively low (232 postings).
- Terraform stands out by combining a very high salary ($184K) with strong demand (3,248 postings), making it one of the most valuable skills.
- Golang is another premium skill, offering a high median salary ($184K) with solid demand (912 postings).
- Kubernetes and Airflow offer an excellent balance of high salaries (~$150K) and very high demand (4,202 and 9,996 postings respectively).
- Skills like GraphQL, FastAPI, Neo4j, MongoDB, and Django show that specialized backend and database technologies are associated with higher-paying roles.
- Overall, cloud infrastructure, DevOps, distributed systems, and modern backend technologies tend to command the highest salaries in data engineering.
*/