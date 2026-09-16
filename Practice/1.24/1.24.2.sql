DROP TABLE IF EXISTS job_skill_priorities;

CREATE TABLE IF NOT EXISTS job_skill_priorities (
    job_id INT,
    skill_id INT,
    skill_name VARCHAR(50),
    priority_lvl INT,
    status VARCHAR(50)
);

INSERT INTO job_skill_priorities (job_id, skill_id, status)
SELECT
    sjd.job_id,
    sjd.skill_id,
    'Active' AS status
FROM
    staging.priority_skills AS ps
INNER JOIN data_jobs.skills_job_dim AS sjd
    ON ps.skill_id = sjd.skill_id;


SELECT
    *
FROM job_skill_priorities;
LIMIT 20;