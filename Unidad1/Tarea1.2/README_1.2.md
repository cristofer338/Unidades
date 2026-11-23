# Tarea 1.2: Clasificación y arquitecturas (ANSI/SPARC y SGBD)

**Alumno:** Cristofer Alejandro Barboza Chávez · **Carrera:** Informática · **Núm. de control:** I24050398
**Unidad 1:** Introducción a las bases de datos

📄 Documento formal: [Tarea_1.2_Clasificacion_y_Arquitecturas_BD.pdf](Tarea_1.2_Clasificacion_y_Arquitecturas_BD.pdf)
🎬 Guion del video: [guion_video_1.2.md](guion_video_1.2.md)

---

## Índice

1. [Cuadro sinóptico: clasificación de las bases de datos](#1-cuadro-sinóptico-clasificación-de-las-bases-de-datos)
2. [Arquitectura de tres niveles (ANSI/SPARC)](#2-arquitectura-de-tres-niveles-ansisparc)
3. [Arquitectura funcional del SGBD](#3-arquitectura-funcional-del-sgbd)
4. [Flujo de datos entre niveles](#4-flujo-de-datos-entre-niveles)
5. [Referencias (APA 7)](#referencias-apa-7)

---

## 1. Cuadro sinóptico: clasificación de las bases de datos

![Cuadro sinóptico](diagramas/png/01_cuadro_sinoptico_clasificacion.png)

| Criterio | Tipos |
|---|---|
| Ubicación | Centralizadas, distribuidas, en la nube (DBaaS) |
| Variabilidad de los datos | Estáticas, dinámicas |
| Modelo de datos | Jerárquicas, de red, relacionales, orientadas a objetos, documentales, de grafos, clave–valor |
| Contenido | Bibliográficas, de texto completo, directorios, especializadas |
| Propósito | Operacionales (OLTP), analíticas (OLAP) |

## 2. Arquitectura de tres niveles (ANSI/SPARC)

![Tres niveles](diagramas/png/02_arquitectura_tres_niveles.png)

| Nivel | Descripción |
|---|---|
| **Externo** | Vistas de cada grupo de usuarios; cada uno ve solo lo que necesita. |
| **Conceptual** | Estructura lógica de toda la base de datos (entidades, relaciones, restricciones). |
| **Interno (físico)** | Cómo se almacenan los datos: archivos, índices, bloques en disco. |

- **Independencia lógica:** cambiar el esquema conceptual sin afectar las vistas.
- **Independencia física:** cambiar el almacenamiento sin afectar el esquema conceptual.

## 3. Arquitectura funcional del SGBD

![SGBD](diagramas/png/03_arquitectura_funcional_sgbd.png)

| Módulo | Función |
|---|---|
| Interfaces (SQL, DML, DDL) | Reciben consultas, manipulación y definición de datos. |
| Procesador de consultas | Analiza, optimiza y ejecuta la instrucción. |
| Gestor de transacciones | Consistencia, concurrencia y recuperación ante fallos. |
| Control de seguridad e integridad | Verifica permisos y reglas de integridad. |
| Gestor de almacenamiento | Buffers, archivos, índices y lectura/escritura en disco. |
| Diccionario de datos | Metadatos de toda la base de datos. |

## 4. Flujo de datos entre niveles

![Flujo](diagramas/png/04_flujo_datos_niveles.png)

**Pasos 1–4:** consulta sobre una vista → traducción al esquema conceptual → traducción a estructuras internas → lectura de bloques en disco.
**Pasos 5–8:** el disco devuelve bloques → se reconstruyen registros lógicos → se aplica la vista → se presenta el resultado.

Los **fuentes vectoriales** están en [`diagramas/svg/`](diagramas/svg/).

## Referencias (APA 7)

- Coronel, C., y Morris, S. (2019). *Database systems: Design, implementation, and management* (13.ª ed.). Cengage Learning.
- Elmasri, R., y Navathe, S. B. (2016). *Fundamentals of database systems* (7.ª ed.). Pearson.
- MongoDB. (s. f.). *Types of databases*. https://www.mongodb.com/resources/basics/databases/types
- Oracle. (2020, 24 de noviembre). *What is a database?* https://www.oracle.com/database/what-is-database/
- Silberschatz, A., Korth, H. F., y Sudarshan, S. (2019). *Database system concepts* (7.ª ed.). McGraw-Hill Education.
- Tsichritzis, D., y Klug, A. (1978). The ANSI/X3/SPARC DBMS framework: Report of the study group on database management systems. *Information Systems, 3*(3), 173–191. https://doi.org/10.1016/0306-4379(78)90001-7
