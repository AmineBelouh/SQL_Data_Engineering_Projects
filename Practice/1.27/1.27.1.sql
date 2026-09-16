SELECT 
    abbrev,
    COUNT(*) AS record_count
FROM pg_timezone_names()
GROUP BY abbrev
ORDER BY record_count DESC;

-- System functions like pg_timezone_names() act like tables in the FROM clause, allowing you to select and aggregate columns just like a normal table.