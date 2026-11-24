# Unidad 6: Introducción al Lenguaje SQL — Tarea 6.1: Sintaxis y Clasificación de Sentencias SQL (LDD y LMD)

**Caso de estudio:** Taller Mecánico y Refaccionaria *"El Motor"*  
**SGBD de referencia:** PostgreSQL  

---

## 1. Características Generales del Lenguaje SQL

SQL (*Structured Query Language*) es el estándar declarativo para definir, consultar y manipular datos en sistemas gestores de bases de datos relacionales (SGBDR). En lugar de especificar paso a paso cómo recorrer las estructuras físicas de almacenamiento, el usuario expresa **qué** datos necesita o **qué** estructura desea obtener, y el motor del SGBD determina el plan de ejecución óptimo.

* **Lenguaje declarativo:** Enfocado en el resultado deseado más que en el algoritmo de acceso.
* **Independencia física y lógica:** Aísla las aplicaciones de cambios internos en índices, particiones o disposición en disco.
* **Integridad y restricciones:** Permite declarar reglas directamente en el esquema (`PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`).
* **Control transaccional:** Soporta transacciones con propiedades **ACID** (`BEGIN`, `COMMIT`, `ROLLBACK`), aunque el comportamiento de confirmación automática (*auto-commit*) varía entre comandos estructurales y de datos.
* **Portabilidad con variantes dialectales:** Comparte un núcleo estándar ANSI/ISO, con extensiones específicas en motores como **PostgreSQL** (`SERIAL` / `GENERATED ALWAYS AS IDENTITY`, `RETURNING`, `ON CONFLICT`, `ILIKE`, etc.).

---

## 2. Tabla Comparativa y Taxonómica: LDD (DDL) vs. LMD (DML)

| Característica | LDD / DDL (*Data Definition Language*) | LMD / DML (*Data Manipulation Language*) |
| :--- | :--- | :--- |
| **Propósito principal** | Define, modifica o elimina la estructura de objetos de la base de datos (tablas, esquemas, vistas, índices, restricciones). | Consulta, inserta, actualiza o elimina registros (tuplas/filas) almacenados dentro de las tablas. |
| **Comandos cubiertos** | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` | `INSERT`, `UPDATE`, `DELETE`, `SELECT` |
| **Nivel de impacto** | Estructural / de esquema y metadatos del catálogo. | A nivel de filas o conjuntos de resultados sobre los datos. |
| **Transacciones / Auto-commit** | En la mayoría de los SGBDR implica confirmación automática (*auto-commit*); en **PostgreSQL** los DDL son transaccionales dentro de bloques `BEGIN ... COMMIT`. | Se ejecutan dentro del contexto transaccional (`COMMIT` / `ROLLBACK`). |
| **Cláusula de filtro de filas** | No aplica directamente a filas de datos (aplica a nombres, columnas o restricciones). | `WHERE` (en `SELECT`, `UPDATE`, `DELETE`) para acotar las filas afectadas. |
| **Ejemplo en "El Motor"** | `CREATE TABLE vehiculos (...)`, `ALTER TABLE refacciones ADD COLUMN ...` | `INSERT INTO clientes ...`, `UPDATE ordenes_servicio SET estado = ...`, `SELECT ...` |

---

## 3. Sintaxis Formal de Comandos LDD (DDL)

### 3.1 `CREATE`
Crea objetos en la base de datos (bases de datos, esquemas, tablas, índices, vistas).

```sql
CREATE TABLE [IF NOT EXISTS] nombre_esquema.nombre_tabla (
    nombre_columna tipo_dato [DEFAULT expresion] [NOT NULL | NULL] [UNIQUE] [PRIMARY KEY]
                   [REFERENCES tabla_padre (columna_padre)
                    [ON DELETE accion] [ON UPDATE accion]]
                   [CHECK (condicion)],
    ...,
    [CONSTRAINT nombre_restriccion PRIMARY KEY (col1, col2, ...)],
    [CONSTRAINT nombre_restriccion FOREIGN KEY (col_fk)
     REFERENCES tabla_padre (col_pk) [ON DELETE accion] [ON UPDATE accion]],
    [CONSTRAINT nombre_restriccion UNIQUE (col_u1, col_u2, ...)],
    [CONSTRAINT nombre_restriccion CHECK (condicion)]
);
