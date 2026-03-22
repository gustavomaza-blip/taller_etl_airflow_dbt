# Proyecto ETL: Ingesta de Datos Climáticos de 10 ciudades con variables adicionales

## Descripción
Pipeline ETL que extrae datos climáticos de 10 ciudades de Ecuador desde la API de Open-Meteo, los carga en PostgreSQL y los transforma usando dbt.

## Tecnologías
- Docker
- Apache Airflow
- dbt Core
- PostgreSQL
- Python

## Ciudades incluidas
Loja, Quito, Guayaquil, Cuenca, Manta, Ambato, Riobamba, Ibarra, Machala, Santo Domingo

## Variables climáticas
- Temperatura (°C y °F)
- Humedad (%)
- Presión atmosférica (hPa)
- Velocidad del viento (km/h)
- Condición climática (Soleado, Nublado, Lluvia, etc.)

## Estructura del Proyecto
## Mejoras realizadas
- 10 ciudades de Ecuador
- Humedad, presi�n y velocidad del viento
- Macros Jinja reutilizables
