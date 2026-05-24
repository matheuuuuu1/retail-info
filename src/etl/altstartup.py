import os
import getpass
import subprocess
import psycopg2  # Reemplaza por pyodbc o el conector de tu BD si no es PostgreSQL

def solicitar_credenciales():
    print("=== Configuración de Credenciales de Forma Segura ===")
    print("postgres, localhost, postgres, 5432")
    os.environ['DB_USER'] = input("Introduce el usuario de la BD: ")
    os.environ['DB_PASSWORD'] = getpass.getpass("Introduce la contraseña de la BD: ")
    os.environ['DB_HOST'] = input("Introduce el host de la BD (ej. localhost): ")
    os.environ['DB_NAME'] = input("Introduce el nombre de la BD: ") # Debería ir "sales"
    os.environ['DB_PORT'] = input("Introduce el puerto de la BD (ej. 5432): ")
    print("\n[+] Credenciales cargadas en el entorno del sistema.")

def ejecutar_scripts_sql(lista_sql):
    print("\n--- PASO 1: Ejecutando Scripts SQL (Limpieza y Vistas) ---")
    try:
        # Nos conectamos usando las variables de entorno recién creadas
        conn = psycopg2.connect(
            host=os.environ['DB_HOST'],
            database=os.environ['DB_NAME'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASSWORD'],
            port=os.environ['DB_PORT']
        )
        cursor = conn.cursor()
        
        for script in lista_sql:
            print(f"[🚀 SQL] Ejecutando: {script}...")
            with open(script, 'r', encoding='utf-8') as archivo:
                query = archivo.read()
            cursor.execute(query)
            conn.commit()
            print(f"[✓ SQL] {script} ejecutado con éxito.")
            
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"[X] Error crítico en la ejecución de SQL: {e}")
        exit(1) # Detiene todo si SQL falla

def ejecutar_scripts_r(lista_r):
    print("\n--- PASO 2: Ejecutando Scripts de R (Consultas y Procesamiento) ---")
    for script in lista_r:
        print(f"[🚀 R] Ejecutando: {script}...")
        try:
            # subprocess pasa automáticamente 'os.environ' al script de R
            resultado = subprocess.run(
                ['Rscript', script], 
                check=True, 
                text=True, 
                capture_output=True
            )
            print(f"[✓ R] {script} finalizado.")
            # Si quieres ver lo que R imprimió en consola, descomenta la siguiente línea:
            # print(resultado.stdout)
        except subprocess.CalledProcessError as e:
            print(f"[X] Error en el script de R {script}:")
            print(e.stderr)
            exit(1)

if __name__ == "__main__":
    # Define aquí el orden exacto en el que deben ejecutarse tus archivos
    scripts_sql_ordenados = ["1_raw.sql", "2_structure.sql", "3_insert.sql", "4_fix.sql", "5_viewexport.sql"]
    scripts_r_ordenados = ["1_conn.R"]
    
    solicitar_credenciales()
    ejecutar_scripts_sql(scripts_sql_ordenados)
    #ejecutar_scripts_r(scripts_r_ordenados)
    print("\n[🎉] ¡Todo el flujo se ha completado exitosamente!")