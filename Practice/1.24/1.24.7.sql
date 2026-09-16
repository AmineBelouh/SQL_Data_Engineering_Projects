DELETE FROM job_skill_priorities AS tgt
WHERE NOT EXISTS (
    SELECT 1
    FROM staging.priority_skills AS src
    WHERE tgt.skill_id = src.skill_id
);

SELECT
    *
FROM job_skill_priorities
WHERE skill_id = 183;

-- The NOT EXISTS operator is highly efficient for "anti-joins." It checks for the absence of a relationship between the target table and the subquery source.