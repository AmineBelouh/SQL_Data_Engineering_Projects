USE company_jobs;

ALTER TABLE dev.internal_applications_fact 
DROP COLUMN internal_candidate;

SELECT * 
FROM dev.internal_applications_fact;