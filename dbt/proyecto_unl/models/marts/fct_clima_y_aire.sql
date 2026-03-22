{{ config(materialized='table') }}

WITH clima AS (
    SELECT * FROM {{ ref('stg_clima') }}
),

calidad AS (
    SELECT * FROM {{ ref('stg_calidad_aire') }}
)

SELECT 
    c.nombre_ciudad,
    c.temp_celsius,
    c.humedad,
    c.presion,
    c.condicion_climatica,
    ca.indice_ica,
    ca.particulas_pm25,
    CASE
        WHEN ca.indice_ica <= 50 THEN 'Bueno'
        WHEN ca.indice_ica <= 100 THEN 'Moderado'
        ELSE 'Dañino'
    END AS categoria_calidad_aire
FROM clima c
LEFT JOIN calidad ca ON c.nombre_ciudad = ca.nombre_ciudad
