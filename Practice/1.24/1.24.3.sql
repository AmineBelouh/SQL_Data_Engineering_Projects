UPDATE job_skill_priorities
SET status = 'URGENT'
WHERE status = 'Active';

SELECT * FROM job_skill_priorities LIMIT 10;