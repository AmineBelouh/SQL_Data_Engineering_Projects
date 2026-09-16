SELECT
    job_title_short,
    job_work_from_home,
    AVG(salary_year_avg)::INT AS annual_salary_avg,
    AVG(job_work_from_home::INT * ((salary_year_avg / 2080) * 260))::INT AS annual_commute_cost_savings,
    (AVG(salary_year_avg) + AVG(job_work_from_home::INT * ((salary_year_avg / 2080) * 260)))::INT AS adjusted_annual_salary_avg 
FROM
    job_postings_fact
WHERE
    job_country = 'United States' 
    AND job_title LIKE '%Data%'
GROUP BY
    job_title_short,
    job_work_from_home
ORDER BY
    job_title_short DESC,
    job_work_from_home;