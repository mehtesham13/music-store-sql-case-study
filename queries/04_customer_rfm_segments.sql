-- Q4. RFM segmentation: score each customer 1-4 on recency, frequency and monetary value
WITH base AS (
    SELECT c.CustomerId,
           c.FirstName || ' ' || c.LastName AS customer,
           c.Country,
           julianday((SELECT MAX(InvoiceDate) FROM Invoice)) - julianday(MAX(i.InvoiceDate)) AS days_since_last,
           COUNT(i.InvoiceId) AS orders,
           SUM(i.Total)       AS spend
    FROM Customer c
    JOIN Invoice  i ON i.CustomerId = c.CustomerId
    GROUP BY c.CustomerId
),
scored AS (
    SELECT *,
           NTILE(4) OVER (ORDER BY days_since_last DESC) AS r_score,  -- more recent = higher
           NTILE(4) OVER (ORDER BY orders)               AS f_score,
           NTILE(4) OVER (ORDER BY spend)                AS m_score
    FROM base
)
SELECT customer, Country, CAST(days_since_last AS INT) AS days_since_last, orders,
       ROUND(spend, 2) AS spend, r_score, f_score, m_score,
       CASE
           WHEN r_score >= 3 AND m_score = 4 THEN 'Champion'
           WHEN r_score <= 2 AND m_score >= 3 THEN 'At risk (high value, lapsing)'
           WHEN r_score >= 3                  THEN 'Active'
           ELSE 'Low value / lapsing'
       END AS segment
FROM scored
ORDER BY spend DESC;
