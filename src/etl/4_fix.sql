-- Convertir brands
UPDATE product
SET brand = CASE brand
              WHEN 'Brand 1'     THEN 'Max Inc.'
              WHEN 'Brand 2'    THEN 'Levi Strauss'
              WHEN 'Brand 3' THEN 'PUIG'
              ELSE brand -- Si no coincide, mantiene la marca original
            END
WHERE brand IN ('Brand 1', 'Brand 2', 'Brand 3');