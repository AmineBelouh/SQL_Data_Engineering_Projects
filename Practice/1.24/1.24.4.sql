MERGE INTO job_skill_priorities AS tgt
    USING staging.priority_skills AS src
    ON tgt.skill_id = src.skill_id
WHEN MATCHED THEN --only triggers for rows where the join condition evaluates to TRUE.
    UPDATE SET 
        skill_name = src.skill_name,
        priority_lvl = src.priority_lvl;
            

SELECT
    *
FROM job_skill_priorities
WHERE priority_lvl = 2;