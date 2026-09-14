#!/usr/bin/env bash
# Retail: pipeline ETL. Requiere MariaDB local para las fases SQL.
# Uso:  ./run.sh down|ml   (fases 0 y 2; las fases 1 SQL son con mysql CLI)
set -euo pipefail
cd "$(dirname "$0")"

export DB_USER="${DB_USER:-root}"
export DB_PASS="${DB_PASS:-root1234}"
export DB_HOST="${DB_HOST:-localhost}"
export DB_PORT="${DB_PORT:-3306}"
export DB_NAME="${DB_NAME:-ecommerce_orders}"

if [ ! -d .venv ]; then
    echo "Creando .venv e instalando dependencias (una sola vez)..."
    python3 -m venv .venv
    ./.venv/bin/pip install --upgrade pip
    ./.venv/bin/pip install pandas scikit-learn sqlalchemy mariadb kagglehub
fi

case "${1:-}" in
    down) exec ./.venv/bin/python src/func/down.py ;;
    ml)   exec ./.venv/bin/python src/etl/ml.py ;;
    *)
        echo "Uso:  ./run.sh down | ml"
        echo "Fase 1 (SQL) necesita MariaDB corriendo y se ejecuta con mysql CLI:"
        echo "  mysql -u root -p < src/etl/1_raw.sql && mysql -u root -p < src/etl/2_structure.sql && mysql -u root -p < src/etl/4_fix.sql"
        exit 1 ;;
esac
