{{ config(materialized='table') }}

WITH staging AS (
    SELECT * FROM {{ ref('stg_clima') }}
)

SELECT 
    nombre_ciudad,
    DATE(fecha_ingesta) AS fecha,
    
    -- Temperaturas
    COUNT(*) AS total_registros,
    ROUND(AVG(temp_celsius)::numeric, 2) AS temp_celsius_promedio,
    ROUND(MAX(temp_celsius)::numeric, 2) AS temp_celsius_maxima,
    ROUND(MIN(temp_celsius)::numeric, 2) AS temp_celsius_minima,
    ROUND(AVG(temp_fahrenheit)::numeric, 2) AS temp_fahrenheit_promedio,
    
    -- Humedad
    ROUND(AVG(humedad)::numeric, 2) AS humedad_promedio,
    MAX(humedad) AS humedad_maxima,
    MIN(humedad) AS humedad_minima,
    
    -- Presión
    ROUND(AVG(presion)::numeric, 2) AS presion_promedio,
    
    -- Viento
    ROUND(AVG(velocidad_viento)::numeric, 2) AS viento_promedio_kmh,
    
    -- Conteos por condición
    SUM(CASE WHEN condicion_climatica = 'Soleado' THEN 1 ELSE 0 END) AS dias_soleado,
    SUM(CASE WHEN condicion_climatica = 'Parcialmente nublado' THEN 1 ELSE 0 END) AS dias_nublado,
    SUM(CASE WHEN condicion_climatica IN ('Lluvia', 'Llovizna', 'Aguacero') THEN 1 ELSE 0 END) AS dias_lluvia,
    
    -- Clasificación por temperatura
    SUM(CASE WHEN temp_celsius > 25 THEN 1 ELSE 0 END) AS dias_caluroso,
    SUM(CASE WHEN temp_celsius < 15 THEN 1 ELSE 0 END) AS dias_frio

FROM staging
GROUP BY nombre_ciudad, DATE(fecha_ingesta)
ORDER BY nombre_ciudad, fecha