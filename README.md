# 🛒 Retail — Pipeline de Análisis E-Commerce

Pipeline **ETL de extremo a extremo** sobre un dataset público de órdenes de e-commerce (Kaggle): desde la ingesta cruda en MariaDB, pasando por normalización, vistas analíticas, **segmentación de clientes con K-Means**, análisis estadístico en **R** y visualización ejecutiva en **Power BI / web**.

## ✅ Estado del pipeline

| Fase | Descripción | Herramientas | Estado |
|------|-------------|--------------|--------|
| 0 | Ingesta del dataset | Python (`kagglehub`) | ✅ |
| 1 | Carga cruda, normalización y vistas | SQL / MariaDB | ✅ |
| 2 | ETL + segmentación (K-Means) | Python (`pandas`, `scikit-learn`, `SQLAlchemy`) | ✅ |
| 3 | Análisis estadístico y reporte técnico | R (`ggplot2`, R Markdown) | ⏳ pendiente |
| 4 | Dashboard ejecutivo + web interactiva | Power BI · HTML/CSS/JS (Plotly) | ⏳ pendiente |

> Diagrama de arquitectura completo (Mermaid): [`docs/pipeline_architecture.md`](docs/pipeline_architecture.md)

## 🏗️ Arquitectura

```
Kaggle ──▶ CSV crudo ──▶ MariaDB (raw_data) ──▶ Modelo normalizado ──▶ Vistas SQL
                                                        │
                                                Python (SQLAlchemy)
                                                        │
                                             pandas + K-Means (RFM)
                                                        │
                                              processed_customer_clusters
                                                        │
                                    ┌───────────────────┴───────────────────┐
                                 R (hipótesis, ggplot2,          Power BI / Web
                                 R Markdown reporte)            (dashboard)
```

## 🧰 Tecnologías

- **Base de datos:** MariaDB (MySQL-compatible)
- **ETL / ML:** Python — `pandas`, `scikit-learn`, `SQLAlchemy`, conector oficial `mariadb`
- **Análisis:** R — `ggplot2`, `stats`, R Markdown
- **Visualización:** Power BI · HTML/CSS/JS (Plotly / Streamlit)

## 📁 Estructura del proyecto

```
.
├── data/raw/                 # CSV descargado (gitignored)
├── docs/
│   └── pipeline_architecture.md  # Diagrama y estado del pipeline
├── src/
│   ├── etl/
│   │   ├── 1_raw.sql         # Fase 1: tabla cruda + LOAD DATA
│   │   ├── 2_structure.sql   # Fase 1: normalización (customers/products/orders)
│   │   ├── 4_fix.sql         # Fase 1: vistas analíticas
│   │   └── ml.py             # Fase 2: ETL + K-Means
│   └── func/
│       └── down.py           # Fase 0: descarga del dataset (kagglehub)
└── README.md
```

## 🚀 Cómo ejecutar

### Requisitos
- **MariaDB** corriendo en local (puerto 3306 por defecto)
- **Python 3.12+** con: `pandas`, `scikit-learn`, `sqlalchemy`, `mariadb` (conector oficial)
- **R** + `DBI`, `RMariaDB`/`RMySQL`, `ggplot2`, `rmarkdown` *(para la Fase 3)*

### Fase 0 — Descarga del dataset
```bash
python src/func/down.py
```
Descarga `ecommerce_orders_dataset.csv` desde Kaggle y lo deja en `data/raw/`.

### Fase 1 — MariaDB / SQL
```bash
mysql -u root -p < src/etl/1_raw.sql        # tabla cruda + carga del CSV
mysql -u root -p < src/etl/2_structure.sql  # normalización (3 tablas)
mysql -u root -p < src/etl/4_fix.sql        # vistas analíticas
```

### Fase 2 — ETL + Machine Learning
```bash
python src/etl/ml.py
```
Lee `vw_customer_aggregations`, estandariza features tipo RFM y ejecuta **K-Means (k=4)**. Los segmentos se guardan en la tabla `processed_customer_clusters`.

Conexión por variables de entorno: `DB_USER`, `DB_PASS`, `DB_HOST`, `DB_PORT`, `DB_NAME`.

### Fase 3 y 4 — R y visualización *(en desarrollo)*
Análisis estadístico con R y dashboards en Power BI / web.

## 📊 Resultados validados (2026-08-04)

Dataset de **30,000 órdenes**:

| Métrica | Valor |
|---------|-------|
| Órdenes / Clientes / Productos | 30,000 / 8,683 / 2,500 |
| Ingresos totales | $11.37M |
| Ticket promedio (AOV) | $379 |
| Margen de ganancia | 19.49% |
| Tasa de devolución | 10.11% |
| Uso de cupones | 68.10% |

**Segmentos de clientes (K-Means):** VIP/Alto Valor (935) · Frecuentes (3,787) · En Riesgo/Inactivos (2,156) · Nuevos/Ocasionales (1,805).

## 🗺️ Roadmap

- [x] **Fase 0–2**: ingesta, MariaDB/SQL, ETL + K-Means
- [ ] **Fase 3**: análisis estadístico en R + reporte R Markdown
- [ ] **Fase 4**: dashboard Power BI y/o web interactiva

## 🔐 Seguridad

Las credenciales están **gitignored** (`.claude/`, `kaggle.json`). Configura las tuyas localmente sin subirlas al repositorio. La contraseña de la BD se maneja por variable de entorno.

## 📄 Licencia

Proyecto académico/portafolio. Dataset: [E-Commerce Orders Dataset 2026](https://www.kaggle.com/datasets/mmumairkhattak/e-commerce-orders-dataset-2026-scra) (Kaggle, uso no comercial).
