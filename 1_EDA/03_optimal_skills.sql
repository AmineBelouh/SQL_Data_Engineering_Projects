/*
Optimal Skills to Learn

This query identifies the best skills to learn for Data Engineering by combining salary and job demand.

- FROM + JOINs: Combines job postings with the skills associated with each job.
- WHERE:
    - Filters for Data Engineer positions.
    - Includes only remote jobs.
    - Excludes jobs without a reported annual salary.
- MEDIAN(salary_year_avg): Calculates the median salary associated with each skill.
- COUNT(jpf.*): Measures how many job postings require each skill.
- LN(COUNT(jpf.*)): Applies a logarithm to demand. This prevents extremely popular skills from dominating the score simply because they have more postings.

- optimal_score: Combines salary and adjusted demand:
    Optimal Score = Median Salary × LN(Demand) / 1,000,000

- HAVING COUNT > 100: Only considers skills appearing in more than 100 postings, making the results more reliable.
- ORDER BY optimal_score DESC: Ranks skills from the highest to lowest score.
- LIMIT 25: Returns the top 25 skills.
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 2) AS ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*))) / 1_000_000, 2) AS optimal_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25;

/*
┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │          193 │            5.26 │          0.97 │
│ python     │      135000.0 │         1133 │            7.03 │          0.95 │
│ aws        │      137320.0 │          783 │            6.66 │          0.91 │
│ sql        │      130000.0 │         1128 │            7.03 │          0.91 │
│ airflow    │      150000.0 │          386 │            5.96 │          0.89 │
│ spark      │      140000.0 │          503 │            6.22 │          0.87 │
│ snowflake  │      135500.0 │          438 │            6.08 │          0.82 │
│ kafka      │      145000.0 │          292 │            5.68 │          0.82 │
│ azure      │      128000.0 │          475 │            6.16 │          0.79 │
│ java       │      135000.0 │          303 │            5.71 │          0.77 │
│ scala      │      137290.0 │          247 │            5.51 │          0.76 │
│ git        │      140000.0 │          208 │            5.34 │          0.75 │
│ kubernetes │      150500.0 │          147 │            4.99 │          0.75 │
│ databricks │      132750.0 │          266 │            5.58 │          0.74 │
│ redshift   │      130000.0 │          274 │            5.61 │          0.73 │
│ gcp        │      136000.0 │          196 │            5.28 │          0.72 │
│ hadoop     │      135000.0 │          198 │            5.29 │          0.71 │
│ nosql      │      134415.0 │          193 │            5.26 │          0.71 │
│ pyspark    │      140000.0 │          152 │            5.02 │           0.7 │
│ mongodb    │      135750.0 │          136 │            4.91 │          0.67 │
│ docker     │      135000.0 │          144 │            4.97 │          0.67 │
│ go         │      140000.0 │          113 │            4.73 │          0.66 │
│ r          │      134775.0 │          133 │            4.89 │          0.66 │
│ bigquery   │      135000.0 │          123 │            4.81 │          0.65 │
│ github     │      135000.0 │          127 │            4.84 │          0.65 │
└────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘
  25 rows                                                           5 columns  

Key Takeaways:

- Terraform ranks #1 overall with the highest optimal score (0.97), combining a very high median salary ($184K) with meaningful demand.
- Python, AWS, and SQL are the strongest all-around choices. They combine high demand with solid salaries, making them especially valuable for long-term employability.
- Airflow and Spark stand out as specialized Data Engineering skills, offering $140K–$150K+ median salaries with strong demand.
- Snowflake and Kafka offer a strong salary–demand balance, particularly for modern data platforms and streaming.
- Cloud skills remain essential: AWS ranks #3, Azure #9, GCP #16, while Databricks and Snowflake also perform well.
- The results suggest that building a skill stack is better than focusing on one skill:
    SQL + Python + Cloud (AWS/Azure) + Spark/Airflow + Snowflake/Databricks provides a strong combination of demand and earning potential.
*/