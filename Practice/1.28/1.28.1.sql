SELECT *
FROM information_schema.schemata;

SELECT *
FROM information_schema.tables
WHERE table_catalog = 'company_jobs';

SELECT 
    *
FROM information_schema.columns
WHERE table_catalog = 'company_jobs' AND table_name = 'remote_jobs';

SELECT 
    *
FROM information_schema.table_constraints
WHERE constraint_catalog = 'company_jobs';


CREATE SCHEMA IF NOT EXISTS work_mode_mart;

CREATE OR REPLACE TABLE work_mode_mart.remote_jobs AS 
SELECT
    j.job_title, 
    j.company_id, 
    j.job_location
FROM data_jobs.job_postings_fact AS j
WHERE j.job_work_from_home = TRUE AND j.job_location = 'Anywhere';

CREATE OR REPLACE TABLE work_mode_mart.not_remote_jobs AS 
SELECT
    j.job_title, 
    j.company_id, 
    j.job_location
FROM data_jobs.job_postings_fact AS j
WHERE j.job_work_from_home = FALSE OR job_work_from_home IS NULL;

SELECT COUNT(*) FROM work_mode_mart.remote_jobs;
SELECT COUNT(*) FROM work_mode_mart.not_remote_jobs;

SELECT * FROM data_jobs.job_postings_fact WHERE job_work_from_home IS NULL;