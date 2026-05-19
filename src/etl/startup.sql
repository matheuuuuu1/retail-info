DROP DATABASE IF EXISTS sales;
CREATE DATABASE sales;

\c sales

\i 'C:/Git/Retail/src/etl/1_raw.sql'
\i 'C:/Git/Retail/src/etl/2_structure.sql'
\i 'C:/Git/Retail/src/etl/3_insert.sql'
\i 'C:/Git/Retail/src/etl/4_fix.sql'