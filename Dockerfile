# Retail (WIP) - ETL e-commerce (pandas, sklearn, kagglehub)
# Requiere MariaDB en red (ver docker-compose.yml)
FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /work

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# PyMySQL (puro Python) para SQLAlchemy sobre MariaDB; evita compilar el conector nativo.
RUN pip install --no-cache-dir \
    pandas \
    scikit-learn \
    sqlalchemy \
    pymysql \
    cryptography \
    kagglehub \
    python-dotenv \
    jupyter

COPY src/ src/
COPY data/ data/
COPY notebook/ notebook/

# credenciales Kaggle montadas en volumen en tiempo de ejecución
ENV KAGGLE_CONFIG_DIR=/root/.kaggle

CMD ["bash"]
