WITH source AS (
    SELECT * FROM "db_warehouse"."public"."raw_clima_nacional"
)
SELECT 
    ciudad AS nombre_ciudad,
    fecha_ingesta,
    temperature AS temp_celsius,
    ROUND((temperature * 9.0 / 5.0 + 32.0)::numeric, 2) AS temp_fahrenheit,
    humedad,
    presion,
    windspeed AS velocidad_viento,
    CASE 
        WHEN weathercode = 0 THEN 'Soleado'
        WHEN weathercode IN (1, 2, 3) THEN 'Parcialmente nublado'
        WHEN weathercode = 45 THEN 'Niebla'
        WHEN weathercode IN (51, 53, 55) THEN 'Llovizna'
        WHEN weathercode IN (61, 63, 65) THEN 'Lluvia'
        WHEN weathercode IN (71, 73, 75) THEN 'Nieve'
        WHEN weathercode IN (80, 81, 82) THEN 'Aguacero'
        ELSE 'Desconocido'
    END AS condicion_climatica
FROM source