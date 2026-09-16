USE company_jobs;

SELECT *
FROM information_schema.schemata;

SELECT *
FROM information_schema.tables
WHERE table_catalog = 'company_jobs';

SELECT 
    *
FROM information_schema.columns
WHERE table_catalog = 'company_jobs' AND table_name = 'priority_skills';

SELECT 
    *
FROM information_schema.table_constraints
WHERE constraint_catalog = 'company_jobs';

CREATE SCHEMA IF NOT EXISTS staging;

CREATE OR REPLACE TABLE staging.priority_skills (
    skill_id INT PRIMARY KEY,
    skill_name VARCHAR(50),
    priority_lvl INT
);

INSERT INTO staging.priority_skills (
    skill_id,
    skill_name,
    priority_lvl
)
VALUES 
    (1, 'python', 1),
    (0, 'sql', 1),
    (183, 'tableau', 2);

SELECT * FROM staging.priority_skills;