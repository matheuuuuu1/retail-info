import os
import shutil
import kagglehub

# Configuración de tus rutas locales
target_file_name = "ecommerce_orders_dataset.csv"  # Reemplaza con el nombre del archivo dentro del dataset
dest_dir = os.path.join('data', 'raw')
dest_file_path = os.path.join(dest_dir, target_file_name)

# Aseguramos que existan las carpetas de destino
os.makedirs(dest_dir, exist_ok=True)

print('Descargando archivo desde Kaggle...')
# kagglehub descarga el archivo específico
downloaded_file_path = kagglehub.dataset_download(
    "mmumairkhattak/e-commerce-orders-dataset-2026-scra",
    path=target_file_name
)

print('Moviendo archivo a la carpeta del proyecto...')
# Mover de la caché de kagglehub a tu carpeta local dest_dir
shutil.move(downloaded_file_path, dest_file_path)

print(f'Listo: Datos disponibles en {dest_file_path}')