-- Q5. Support rep performance: customers, revenue, share of total and rank
SELECT
    e.FirstName || ' ' || e.LastName AS sales_rep,
    e.HireDate,
    COUNT(DISTINCT c.CustomerId)     AS customers,
    ROUND(SUM(i.Total), 2)           AS revenue,
    ROUND(100.0 * SUM(i.Total) / SUM(SUM(i.Total)) OVER (), 1) AS pct_of_revenue,
    RANK() OVER (ORDER BY SUM(i.Total) DESC) AS revenue_rank
FROM Employee e
JOIN Customer c ON c.SupportRepId = e.EmployeeId
JOIN Invoice  i ON i.CustomerId   = c.CustomerId
GROUP BY e.EmployeeId
ORDER BY revenue DESC;
