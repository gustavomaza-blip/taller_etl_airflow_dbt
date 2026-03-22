import requests
import pandas as pd
from airflow.decorators import dag, task
from datetime import datetime
from sqlalchemy import create_engine
import subprocess

DBT_URI = "postgresql+psycopg2://user_dbt:password_dbt@postgres_warehouse:5432/db_warehouse"
DBT_DIR = "/opt/airflow/dbt/proyecto_unl"

Ciudades = {
    "Loja": {"lat": -4.0069, "lon": -79.2118},
    "Quito": {"lat": -0.1807, "lon": -78.4678},
    "Guayaquil": {"lat": -2.1709, "lon": -79.9224},
    "Cuenca": {"lat": -2.9006, "lon": -79.0045},
    "Manta": {"lat": -0.9677, "lon": -80.7089},
    "Ambato": {"lat": -1.2417, "lon": -78.6192},
    "Riobamba": {"lat": -1.6755, "lon": -78.6465},
    "Ibarra": {"lat": 0.3518, "lon": -78.1175},
    "Machala": {"lat": -3.2666, "lon": -79.9617},
    "Santo Domingo": {"lat": -0.2522, "lon": -79.1712}
}

@dag(
    dag_id='dag_ingesta_multiple',
    start_date=datetime(2023, 1, 1),
    schedule_interval='@hourly',
    catchup=False
)

def elt_clima_nacional():
    
    # Tarea 1: Extracción de datos desde API y carga masiva a Postgres
    @task
    def extraer_api_y_cargar():
        lista_datos = []
        # Bucle para consultar la api para cada ciudad
        for ciudad, coords in Ciudades.items():
            url = f"https://api.open-meteo.com/v1/forecast?latitude={coords['lat']}&longitude={coords['lon']}&current_weather=true&hourly=relativehumidity_2m,pressure_msl"
            respuesta = requests.get(url).json()

            clima = respuesta["current_weather"]
            clima["ciudad"] = ciudad
            clima["fecha_ingesta"] = datetime.now()
            
            # Agregar humedad y presión desde datos horarios
            if "hourly" in respuesta:
                clima["humedad"] = respuesta["hourly"]["relativehumidity_2m"][0] if respuesta["hourly"]["relativehumidity_2m"] else None
                clima["presion"] = respuesta["hourly"]["pressure_msl"][0] if respuesta["hourly"]["pressure_msl"] else None
            else:
                clima["humedad"] = None
                clima["presion"] = None
                
            lista_datos.append(clima)
        
        df = pd.DataFrame(lista_datos)

        # Carga masiva a Postgres
        engine = create_engine(DBT_URI)
        df.to_sql("raw_clima_nacional", con=engine, if_exists="append", index=False)
        print(f"Ingesta de {len(lista_datos)} ciudades completada con éxito.")    
    # Tarea 2:

    @task
    def ejecutar_dbt():
        # Ejecutar los modelos y las pruebas de calidad
        comando1 = "dbt run"
        subprocess.run(comando1, cwd=DBT_DIR, shell=True, check=True)
    
    @task
    def ejecutar_dbt_test():
        # Ejecutar los modelos y las pruebas de calidad
        comando2 = "dbt test"
        subprocess.run(comando2, cwd=DBT_DIR, shell=True, check=True)
        

    # Definir el flujo de tareas
    extraer_api_y_cargar() >> ejecutar_dbt() >> ejecutar_dbt_test()

dag_principal = elt_clima_nacional()