-- Q8. Top artists by revenue and the running share of total revenue (Pareto check)
WITH artist_rev AS (
    SELECT ar.Name AS artist,
           SUM(il.UnitPrice * il.Quantity) AS revenue
    FROM InvoiceLine il
    JOIN Track  t  ON t.TrackId   = il.TrackId
    JOIN Album  al ON al.AlbumId  = t.AlbumId
    JOIN Artist ar ON ar.ArtistId = al.ArtistId
    GROUP BY ar.ArtistId
)
SELECT
    artist,
    ROUND(revenue, 2) AS revenue,
    ROUND(100.0 * SUM(revenue) OVER (ORDER BY revenue DESC ROWS UNBOUNDED PRECEDING)
          / SUM(revenue) OVER (), 1) AS cumulative_pct,
    ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rank
FROM artist_rev
ORDER BY revenue DESC
LIMIT 15;
