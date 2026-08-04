import os
import logging
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sqlalchemy import create_engine, text

# 1. Configuración de Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

# 2. Configuración de Conexión a MariaDB / MySQL
DB_USER = os.getenv("DB_USER", "root")
DB_PASS = os.getenv("DB_PASS", "root1234")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "3306")
DB_NAME = os.getenv("DB_NAME", "ecommerce_orders")

DATABASE_URL = f"mariadb+mariadbconnector://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

def get_engine():
    """Crea y retorna el motor de conexión de SQLAlchemy."""
    return create_engine(DATABASE_URL, echo=False, pool_pre_ping=True)

def fetch_data(engine) -> pd.DataFrame:
    """Extrae la información de la vista analítica de clientes."""
    query = "SELECT * FROM vw_customer_aggregations;"
    logging.info("Extrayendo datos de 'vw_customer_aggregations'...")
    with engine.connect() as connection:
        df = pd.read_sql_query(sql=text(query), con=connection)
    logging.info(f"Registros extraídos: {len(df)}")
    return df

def preprocess_and_cluster(df: pd.DataFrame, n_clusters: int = 4) -> pd.DataFrame:
    """Prepara las características (features), las escala y ejecuta K-Means."""
    logging.info("Seleccionando variables numéricas para el modelo RFM/Comportamiento...")
    
    # Selección de variables para el clustering (Recencia, Frecuencia, Valor Monetario, Devoluciones)
    feature_cols = [
        "total_orders_count",
        "total_items_purchased",
        "total_spend_lifetime",
        "total_profit_generated",
        "avg_ticket_size",
        "days_since_last_order",
        "total_returned_orders"
    ]

    # Manejo de valores nulos si los hubiera
    df_features = df[feature_cols].fillna(0)

    # Escalado de características (Estandarización Z-score)
    scaler = StandardScaler()
    scaled_data = scaler.fit_transform(df_features)

    # Entrenamiento del Modelo K-Means
    logging.info(f"Entrenando modelo K-Means con k={n_clusters} clusters...")
    kmeans = KMeans(n_clusters=n_clusters, random_state=42, n_init=10)
    df["cluster_id"] = kmeans.fit_predict(scaled_data)

    # Mapeo opcional de nombres de segmentos según la interpretación de los centroides
    cluster_labels = {
        0: "VIP / Alto Valor",
        1: "Clientes Frecuentes",
        2: "Clientes en Riesgo / Inactivos",
        3: "Nuevos / Ocasionales"
    }
    df["cluster_name"] = df["cluster_id"].map(lambda x: cluster_labels.get(x, f"Segmento {x}"))

    return df

def save_to_database(df: pd.DataFrame, engine):
    """Guarda los resultados del clustering en la base de datos."""
    output_cols = [
        "customer_id",
        "cluster_id",
        "cluster_name",
        "days_since_last_order",
        "total_orders_count",
        "total_spend_lifetime",
        "avg_ticket_size",
        "avg_review_given"
    ]
    
    df_result = df[output_cols].copy()
    
    target_table = "processed_customer_clusters"
    logging.info(f"Guardando resultados en la tabla '{target_table}'...")

    # Guardar en MariaDB (reemplaza o append la tabla según sea necesario)
    with engine.begin() as connection:
        df_result.to_sql(
            name=target_table,
            con=connection,
            if_exists="replace",  # Opciones: 'fail', 'replace', 'append'
            index=False
        )
    logging.info(f"Proceso completado con éxito. {len(df_result)} registros guardados.")

def main():
    try:
        engine = get_engine()
        
        # 1. Extracción
        df_customers = fetch_data(engine)
        
        if df_customers.empty:
            logging.warning("No se encontraron datos en la vista. Finalizando proceso.")
            return
        
        # 2. Transformación y ML
        df_clustered = preprocess_and_cluster(df_customers, n_clusters=4)
        
        # 3. Carga de resultados
        save_to_database(df_clustered, engine)

    except Exception as e:
        logging.error(f"Error durante el pipeline de Clustering: {e}", exc_info=True)

if __name__ == "__main__":
    main()