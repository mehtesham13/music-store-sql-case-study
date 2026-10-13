-- Q7. Do customers buy whole albums or individual tracks?
-- An invoice counts as a full-album purchase if it contains every track of one album and nothing else.
WITH invoice_album AS (
    SELECT il.InvoiceId,
           MIN(t.AlbumId)            AS album_id,
           COUNT(DISTINCT t.AlbumId) AS albums_in_invoice,
           COUNT(*)                  AS tracks_in_invoice
    FROM InvoiceLine il
    JOIN Track t ON t.TrackId = il.TrackId
    GROUP BY il.InvoiceId
),
album_size AS (
    SELECT AlbumId, COUNT(*) AS album_tracks FROM Track GROUP BY AlbumId
)
SELECT
    CASE WHEN ia.albums_in_invoice = 1 AND ia.tracks_in_invoice = a.album_tracks
         THEN 'Full album' ELSE 'Individual tracks' END AS purchase_type,
    COUNT(*) AS invoices,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM Invoice), 1) AS pct_of_invoices
FROM invoice_album ia
JOIN album_size a ON a.AlbumId = ia.album_id
GROUP BY purchase_type;
