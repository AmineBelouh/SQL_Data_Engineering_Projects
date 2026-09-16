USE company_jobs;

CREATE SCHEMA IF NOT EXISTS staging;

DROP SCHEMA IF EXISTS staging;

CREATE SCHEMA IF NOT EXISTS dev;

SELECT *
FROM information_schema.schemata;