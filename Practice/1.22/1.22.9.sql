CREATE TABLE IF NOT EXISTS jan_2023_cleanup_copy AS
SELECT *
FROM data_jobs.job_postings_fact;

SELECT COUNT(*)
FROM jan_2023_cleanup_copy;

DELETE FROM jan_2023_cleanup_copy
WHERE job_posted_date < '2023-01-01';

SELECT COUNT(*)
FROM jan_2023_cleanup_copy;