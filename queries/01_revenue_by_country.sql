-- Q1. Which countries bring in the most revenue, and how much is each customer worth there?
SELECT
    c.Country,
    COUNT(DISTINCT c.CustomerId)                          AS customers,
    ROUND(SUM(i.Total), 2)                                AS revenue,
    ROUND(SUM(i.Total) / COUNT(DISTINCT c.CustomerId), 2) AS revenue_per_customer,
    ROUND(100.0 * SUM(i.Total) / (SELECT SUM(Total) FROM Invoice), 1) AS pct_of_revenue
FROM Customer c
JOIN Invoice  i ON i.CustomerId = c.CustomerId
GROUP BY c.Country
ORDER BY revenue DESC
LIMIT 10;
