-- Q6. How much of the catalog has never sold, by media type?
SELECT
    m.Name AS media_type,
    COUNT(*) AS tracks,
    SUM(CASE WHEN il.TrackId IS NULL THEN 1 ELSE 0 END) AS never_sold,
    ROUND(100.0 * SUM(CASE WHEN il.TrackId IS NULL THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_never_sold
FROM Track t
JOIN MediaType m ON m.MediaTypeId = t.MediaTypeId
LEFT JOIN (SELECT DISTINCT TrackId FROM InvoiceLine) il ON il.TrackId = t.TrackId
GROUP BY m.Name
ORDER BY tracks DESC;
