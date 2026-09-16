SELECT 
    job_title, 
    company_id,
    job_location
FROM work_mode_mart.remote_jobs
UNION
SELECT 
    job_title, 
    company_id,
    job_location
FROM work_mode_mart.not_remote_jobs
ORDER BY job_location, company_id, job_title;



SELECT 
    job_title, 
    company_id,
    job_location
FROM work_mode_mart.remote_jobs
UNION ALL
SELECT 
    job_title, 
    company_id,
    job_location
FROM work_mode_mart.not_remote_jobs
ORDER BY job_location, company_id, job_title;




SELECT 
    job_title, 
    company_id,
    job_location
FROM work_mode_mart.remote_jobs
INTERSECT
SELECT 
    job_title, 
    company_id,
    job_location
FROM work_mode_mart.not_remote_jobs
ORDER BY job_location, company_id, job_title;



SELECT 
    job_title, 
    company_id,
    job_location
FROM work_mode_mart.remote_jobs
INTERSECT ALL
SELECT 
    job_title, 
    company_id,
    job_location
FROM work_mode_mart.not_remote_jobs
ORDER BY job_location, company_id, job_title;




SELECT 
    job_title, 
    company_id,
    job_location
FROM work_mode_mart.remote_jobs
EXCEPT
SELECT 
    job_title, 
    company_id,
    job_location
FROM work_mode_mart.not_remote_jobs
ORDER BY job_location, company_id, job_title;




SELECT 
    job_title, 
    company_id,
    job_location
FROM work_mode_mart.remote_jobs
EXCEPT ALL
SELECT 
    job_title, 
    company_id,
    job_location
FROM work_mode_mart.not_remote_jobs
ORDER BY job_location, company_id, job_title;