

-- Top des ventes par genre et artiste, CTE avec ROW_NUMBER
WITH top_ventes AS (
    SELECT
        t.genre_id,
        al.artist_id,
        SUM(il.quantity) AS total_ventes
    FROM invoice_line il
             JOIN track t ON il.track_id = t.track_id
             JOIN album al ON t.album_id = al.album_id
    GROUP BY t.genre_id, al.artist_id
),
     ranked AS (
         SELECT
             tv.genre_id,
             tv.artist_id,
             tv.total_ventes,
             ROW_NUMBER() OVER (
                 PARTITION BY tv.genre_id
                 ORDER BY tv.total_ventes DESC
                 ) AS rn
         FROM top_ventes tv
     )
SELECT
    g.name AS genre,
    ar.name AS artiste,
    r.total_ventes
FROM ranked r
         JOIN genre g ON g.genre_id = r.genre_id
         JOIN artist ar ON ar.artist_id = r.artist_id
WHERE r.rn = 1
ORDER BY g.name;














