SELECT
    COUNT(DISTINCT 
        CASE
            WHEN jpf.job_work_from_home = TRUE THEN jpf.company_id
        END
        ) AS wfh_companies,
    COUNT(DISTINCT 
        CASE
            WHEN jpf.job_work_from_home = FALSE THEN jpf.company_id
        END
    ) AS non_wfh_companies
FROM job_postings_fact AS jpf;