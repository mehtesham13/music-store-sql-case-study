-- Q3. The best-selling genre in each country (ties kept)
WITH genre_sales AS (
    SELECT i.BillingCountry AS country,
           g.Name           AS genre,
           SUM(il.Quantity) AS units
    FROM InvoiceLine il
    JOIN Invoice i ON i.InvoiceId = il.InvoiceId
    JOIN Track   t ON t.TrackId   = il.TrackId
    JOIN Genre   g ON g.GenreId   = t.GenreId
    GROUP BY country, genre
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY country ORDER BY units DESC) AS rnk,
           ROUND(100.0 * units / SUM(units) OVER (PARTITION BY country), 1) AS pct_of_country_units
    FROM genre_sales
)
SELECT country, genre, units, pct_of_country_units
FROM ranked
WHERE rnk = 1
ORDER BY units DESC;
