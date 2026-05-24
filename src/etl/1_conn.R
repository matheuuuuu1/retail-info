library(tidyverse)
library(DBI)
library(RPostgres)
library(dplyr)

con <- dbConnect(
  RPostgres::Postgres(),
  host     = "localhost",
  dbname = "postgres",
  user     = "postgres",
  password = "root1234",
  port     = "5432"
)
# Crear la referencia virtual a la vista
vista_remota <- tbl(con, "processed")

# R te mostrará las primeras 10 filas para que la explores (¡al instante!)
print(vista_remota)

# Puedes usar glimpse para ver las columnas y tipos de datos
glimpse(vista_remota)
