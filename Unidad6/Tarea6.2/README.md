# Unidad 6 — Tarea 6.2: Implementación de Script DDL, Carga de Datos y Consultas DML

**Caso de estudio:** Taller Mecánico y Refaccionaria *"El Motor"*  
**SGBD:** PostgreSQL  

---

## Estructura del Repositorio

* `01_schema_ddl.sql`: Creación de tablas, claves primarias (`PRIMARY KEY`), claves foráneas (`FOREIGN KEY`), restricciones (`CHECK`, `UNIQUE`, `NOT NULL`) e índices en PostgreSQL.
* `02_data_inserts.sql`: Inserción de datos de prueba (`INSERT`) para clientes, vehículos, refacciones, órdenes de servicio y detalle de refacciones por orden.
* `03_queries_dml.sql`: Consultas `SELECT` con `WHERE`, `ORDER BY`, funciones de agregación (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`), `GROUP BY` + `HAVING`, reuniones (`INNER JOIN`, `LEFT JOIN`) y pruebas controladas de `UPDATE`, `DELETE` e integridad referencial.
* `README_6.2.md`: Guía de clonación, ejecución y evidencias.

---

## Cómo Clonar y Ejecutar en PostgreSQL

1. **Clonar el repositorio:**
   ```bash
   git clone <URL_DE_TU_REPOSITORIO_PUBLICO_EN_GITHUB>
   cd <NOMBRE_DE_LA_CARPETA>
