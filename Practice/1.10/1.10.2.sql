SELECT 
    table_name,
    constraint_name,
    COUNT(constraint_name) AS constraint_name_count
FROM information_schema.key_column_usage
WHERE table_catalog = 'data_jobs'
GROUP BY table_name, constraint_name
HAVING COUNT(constraint_name) > 1;