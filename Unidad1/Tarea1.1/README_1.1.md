# Tarea 1.1: Fundamentos, objetivos y modelos de bases de datos

**Alumno:** Cristofer Alejandro Barboza Chávez · **Carrera:** Informática · **Núm. de control:** I24050398
**Unidad 1:** Introducción a las bases de datos

📄 Documento formal: [Tarea_1.1_Fundamentos_Objetivos_Modelos_BD.pdf](Tarea_1.1_Fundamentos_Objetivos_Modelos_BD.pdf)
🎬 Guion del video: [guion_video_1.1.md](guion_video_1.1.md)

---

## Índice

1. [Fundamentos](#1-fundamentos)
2. [Mapa conceptual analítico](#2-mapa-conceptual-analítico)
3. [Tabla comparativa de modelos de bases de datos](#3-tabla-comparativa-de-modelos-de-bases-de-datos)
   - [Diagramas](#diagramas)
4. [Conclusión](#conclusión)
5. [Referencias (APA 7)](#referencias-apa-7)

---

## 1. Fundamentos

Una **base de datos** es un conjunto organizado de información relacionada entre sí, almacenada de forma estructurada para facilitar su consulta, administración, modificación y actualización (IBM, s. f.).

| Concepto | Definición |
|---|---|
| Dato | Representación de un hecho o característica (nombre, edad, dirección). |
| Información | Datos organizados que adquieren significado y utilidad. |
| Tabla | Estructura que organiza los datos en filas y columnas. |
| Registro | Conjunto de datos relacionados que representan un elemento. |
| Campo | Atributo o característica almacenada en una tabla. |
| Clave primaria | Campo que identifica de manera única cada registro. |
| Clave foránea | Campo que relaciona dos tablas. |
| SGBD | Software que permite crear, administrar, consultar y controlar una base de datos. |

**Objetivos:** almacenar información, facilitar el acceso, evitar la redundancia, mantener la integridad, proteger la información, permitir la actualización y compartir información.

**Usos:** almacenamiento de información, administración de registros, procesamiento de transacciones, generación de reportes, control de inventarios y gestión de usuarios.

**Áreas de aplicación:** educación, salud, finanzas, comercio, gobierno, entretenimiento y transporte.

**Ventajas:** organización, rapidez, seguridad, integridad, disponibilidad y reducción de redundancia.

## 2. Mapa conceptual analítico

![Mapa conceptual](diagramas/png/01_mapa_conceptual.png)

## 3. Tabla comparativa de modelos de bases de datos

| Modelo | Definición | Forma de representar los datos | Ejemplo |
|---|---|---|---|
| **Jerárquico** | Estructura de árbol en la que cada registro hijo depende de un único padre. | Nodos enlazados por niveles padre–hijo (1:N); se recorre desde la raíz. | IBM IMS; universidad (departamentos y carreras). |
| **De red** | Extiende el jerárquico: un registro puede tener varios padres. | Registros conectados por conjuntos propietario–miembro (CODASYL); permite M:N. | IDMS; estudiantes y materias. |
| **Relacional** | Propuesto por Codd (1970): datos en relaciones (tablas) vinculadas por valores. | Tablas con filas y columnas; claves primarias y foráneas; consultas con SQL. | MySQL, PostgreSQL, Oracle. |
| **Orientado a objetos** | Almacena objetos como los maneja un lenguaje orientado a objetos. | Objetos de una clase con atributos, métodos, identidad y herencia. | ObjectDB; clase Estudiante. |
| **Documental** | Base NoSQL que guarda documentos de estructura flexible. | Documentos JSON/BSON agrupados en colecciones. | MongoDB; catálogo de productos. |
| **Orientado a grafos** | Base NoSQL que representa entidades y sus relaciones como grafo. | Nodos, aristas y propiedades. | Neo4j; redes sociales. |

### Diagramas

| | |
|---|---|
| ![Jerárquico](diagramas/png/02_modelo_jerarquico.png) | ![Red](diagramas/png/03_modelo_red.png) |
| ![Relacional](diagramas/png/04_modelo_relacional.png) | ![Orientado a objetos](diagramas/png/05_modelo_orientado_objetos.png) |
| ![Documental](diagramas/png/06_modelo_documental.png) | ![Grafos](diagramas/png/07_modelo_grafos.png) |

Los **fuentes vectoriales** (SVG, editables con Inkscape, draw.io o cualquier editor de texto) están en [`diagramas/svg/`](diagramas/svg/).

## Conclusión

Las bases de datos permiten almacenar, organizar, proteger y consultar información de manera eficiente. Cada modelo responde a necesidades distintas: el relacional destaca por sus tablas y SQL; el documental y el de grafos resuelven casos con datos flexibles o muy conectados.

## Referencias (APA 7)

- Codd, E. F. (1970). A relational model of data for large shared data banks. *Communications of the ACM, 13*(6), 377–387. https://doi.org/10.1145/362384.362685
- Coronel, C., y Morris, S. (2019). *Database systems: Design, implementation, and management* (13.ª ed.). Cengage Learning.
- Elmasri, R., y Navathe, S. B. (2016). *Fundamentals of database systems* (7.ª ed.). Pearson.
- Kosinski, M. (s. f.). *What is a database?* IBM. https://www.ibm.com/think/topics/database
- MongoDB. (s. f.). *Types of databases*. https://www.mongodb.com/resources/basics/databases/types
- Oracle. (2020, 24 de noviembre). *What is a database?* https://www.oracle.com/database/what-is-database/
- Silberschatz, A., Korth, H. F., y Sudarshan, S. (2019). *Database system concepts* (7.ª ed.). McGraw-Hill Education.
