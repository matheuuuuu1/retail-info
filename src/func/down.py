import requests
import zipfile as zf
import os

# Configuración
url = 'https://storage.googleapis.com/kaggle-data-sets/10270704/16013257/bundle/archive.zip?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gcp-kaggle-com%40kaggle-161607.iam.gserviceaccount.com%2F20260511%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20260511T021440Z&X-Goog-Expires=259200&X-Goog-SignedHeaders=host&X-Goog-Signature=4e0a8a1242706b1558cca3a209efc17b5ef785a7fcb24483da9878445f11729798ea13f884f0635ca0bc9722a2d6e85fddf99167bf3227839250f946a603d8de6ae4b614ad52c175089ad0f270f63464c6119f33e74262564d217eec403a44737335d1d1088eabef60ee3f82b3d83783788f66f56b7df1b4b8f149776e468b3a3c035240153b349a5f20eb943f10187c95815d9ceb95d29937859293a1f68030977cb31293bffea0fe81bedc0bf5a1417927b44e1463839ce863c2575b08f391375568e74b35c357914461df99868c680c97532748a6adafec9d709b166b2be74cea6fa88669c987a47d01bff52745a37188acac834ab219ac275e598f51e333'
zip_path = os.path.join('retail', 'data', 'retail_sales_dataset.csv.zip')
dest_dir = os.path.join('retail', 'data', 'raw')

# Aseguramos que existan las carpetas (por si acaso)
os.makedirs(dest_dir, exist_ok=True)

print('Descargando...')
# Usamos un bloque with para manejar la descarga de forma segura
with requests.get(url, stream=True) as r:
    r.raise_for_status() # Si el enlace de Kaggle expiró, aquí te avisará
    with open(zip_path, 'wb') as f:
        for chunk in r.iter_content(chunk_size=8192):
            f.write(chunk)

print('Extrayendo...')
with zf.ZipFile(zip_path, 'r') as zip_ref:
    zip_ref.extractall(dest_dir)

print('Limpiando...')
if os.path.exists(zip_path):
    os.remove(zip_path)

print('Listo: Datos extraídos en data/raw y temporal eliminado.')