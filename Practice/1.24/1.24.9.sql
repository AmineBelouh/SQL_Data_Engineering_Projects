DELETE FROM staging.priority_skills
WHERE skill_id = 1;

SELECT * FROM staging.priority_skills;

MERGE INTO job_skill_priorities AS tgt
USING (
    SELECT 
        sjd.job_id,
        sjd.skill_id,
        ps.skill_name,
        ps.priority_lvl
    FROM data_jobs.skills_job_dim AS sjd
    INNER JOIN staging.priority_skills AS ps
        ON sjd.skill_id = ps.skill_id ) AS src
    ON tgt.job_id = src.job_id AND tgt.skill_id = src.skill_id
WHEN MATCHED THEN
    UPDATE SET
        skill_name = src.skill_name,
        priority_lvl = src.priority_lvl
WHEN NOT MATCHED THEN
    INSERT (job_id, skill_id, skill_name, priority_lvl, status)
    VALUES (src.job_id, src.skill_id, src.skill_name, src.priority_lvl, 'NEW_SKILL') 
WHEN NOT MATCHED BY SOURCE THEN DELETE;


SELECT
    *
FROM  job_skill_priorities
WHERE  skill_id = 1;