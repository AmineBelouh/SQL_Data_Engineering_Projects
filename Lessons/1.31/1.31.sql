-- ARRAY

WITH skills AS (
    SELECT 'python' AS skill_name
    UNION
    SELECT 'sql'
    UNION
    SELECT 'r'
), skills_array AS (
    SELECT
        ARRAY_AGG(skill_name ORDER BY skill_name) AS skills_all
    FROM skills
)
SELECT
    skills_all[1] AS first_skill,
    skills_all[2] AS second_skill,
    skills_all[3] AS third_skill
FROM skills_array;




-- STRUCT
SELECT {skill_name: 'python', skill_type: 'programming'};

WITH skill_struct AS (
    SELECT 
        STRUCT_PACK(
            skill_name:= 'python',
            skill_type:= 'programming'
        ) AS skills
)

SELECT 
    skills.skill_name,
    skills.skill_type 
FROM skill_struct;


WITH skills_name_type AS (
    SELECT 'python' AS skill_name, 'programming' AS skill_type
    UNION
    SELECT 'sql', 'query language'
    UNION
    SELECT 'r', 'programming'
)
SELECT
    STRUCT_PACK (
        name:= skill_name,
        type:= skill_type
    ) AS struct_skills
FROM skills_name_type;



-- ARRAY Of STRUCTS

SELECT [
    {skill: 'python', type: 'programming'},
    {skill: 'sql', type: 'query_language'}
] AS skills_array_of_structs;



WITH skills_name_type AS (
    SELECT 'python' AS skill_name, 'programming' AS skill_type
    UNION
    SELECT 'sql', 'query language'
    UNION
    SELECT 'r', 'programming'
), skills_array_struct_cte AS (
    SELECT
        ARRAY_AGG (
            STRUCT_PACK (
            name:= skill_name,
            type:= skill_type
            ) ORDER BY skill_name, skill_type
        ) AS array_struct_skills
    FROM skills_name_type
)

SELECT 
    array_struct_skills[1].name
FROM skills_array_struct_cte;



-- MAP
WITH skill_map AS (
    SELECT MAP {'skill': 'sql', 'type': 'query_language'} AS skill_type -- you can't repeat keys
)

SELECT  
    skill_type['skill']
FROM skill_map;




-- JSON
WITH skill_json_cte AS (
SELECT
    '{"skill": "python", "type": "programming"}'::JSON AS skill_json
)

SELECT
    STRUCT_PACK (
        skill := json_extract_string(skill_json, '$.skill'), -- $ start at the root of the json document
        type := json_extract_string(skill_json, '$.type')
    )
FROM skill_json_cte;



WITH skills_json_cte AS (
    SELECT
        '[
        {"skill": "python", "type": "programming"},
        {"skill": "sql", "type": "query_language"},
        {"skill": "r", "type": "programming"}
        ]'::JSON AS skills_json
)
SELECT
    ARRAY_AGG (
        STRUCT_PACK (
            skill := json_extract_string (e.value, '$.skill'),
            type := json_extract_string (e.value, '$.type')
        )
        ORDER BY json_extract_string (e.value, '$.skill'), json_extract_string (e.value, '$.type')
    )
FROM skills_json_cte, json_each(skills_json) AS e;






--------------------------------------
--------------------------------------

CREATE OR REPLACE TEMP TABLE jobs_skills_array_temp AS 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM
    job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
GROUP BY
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg;

WITH skills_cte AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM
        jobs_skills_array_temp
)

SELECT 
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM skills_cte
GROUP BY skill;



--------------------------------------
--------------------------------------


CREATE OR REPLACE TEMP TABLE jobs_skills_array_struct_temp AS 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill:= sd.skills,
            skill_type:= sd.type
        )
        ) AS skills_array_struct
FROM
    job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
GROUP BY
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg;




WITH skills_cte AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array_struct) AS skills,
        UNNEST(skills_array_struct).skill AS skill,
        UNNEST(skills_array_struct).skill_type AS skill_type
    FROM
        jobs_skills_array_struct_temp
)

SELECT
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM
    skills_cte
GROUP BY
    skill_type
ORDER BY median_salary DESC;