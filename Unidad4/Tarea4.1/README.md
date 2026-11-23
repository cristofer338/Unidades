# Tarea 4.1 · Fundamentos de dependencias y mapa conceptual de formas normales

| | |
|---|---|
| **Institución** | Tec Monclova · Ingeniería en Sistemas Computacionales |
| **Unidad** | 4 · Normalización de bases de datos |
| **Competencia específica** | Aplica el proceso de normalización al diseño de los esquemas de bases de datos para detectar anomalías y garantizar la integridad de la información |
| **Alumno** | Cristofer Alejandro Barboza Chávez · I24050398 |
| **Caso de estudio** | Taller Mecánico y Refaccionaria "El Motor" (proyecto aplicado, PostgreSQL 16) |

---

## 1. Propósito del repositorio

Este repositorio contiene el material de la **Tarea 4.1**: la investigación teórica sobre normalización, dependencias funcionales y anomalías de actualización, y un **mapa conceptual** que sintetiza las reglas de la 1FN, 2FN, 3FN, FNBC, 4FN y 5FN. Todos los ejemplos están tomados del dominio del proyecto (clientes, vehículos, órdenes de servicio, servicios, refacciones y mecánicos) para que la teoría quede conectada con el diseño que se normaliza en la Tarea 4.2.

## 2. Cumplimiento de las instrucciones de la tarea

| # | Requisito de la tarea | Dónde se cumple |
|---|---|---|
| 1 | Concepto formal de **normalización** | PDF §2.1 (definición, objetivos, descomposición sin pérdida de información, nota sobre desnormalización controlada) |
| 2 | **Dependencias funcionales completas y parciales** | PDF §2.2 (definiciones y ejemplos con `SERVICIO_APLICADO`) |
| 3 | **Dependencias transitivas** | PDF §2.2 (ejemplo `folio_orden → vin → marca`) |
| 4 | Otras dependencias necesarias para 4FN/5FN | PDF §2.2: dependencia trivial, multivaluada (MVD), de reunión (JD) y axiomas de Armstrong |
| 5 | **Anomalías de inserción, borrado y modificación** | PDF §2.3 (Tabla 1 con redundancia real, Tabla 2 con cada anomalía y su causa) |
| 6 | Reglas de **1FN, 2FN, 3FN, FNBC y 4FN/5FN** con ejemplos breves | PDF §3.1 a §3.6, más comparativo en §3.7 |
| 7 | **Mapa conceptual** | PDF §4 e imagen `img/mapa_conceptual.png` |
| 8 | Referencias | PDF §6 |

## 3. Contenido del repositorio

```
tarea_4_1/
├── README.md                                   <- este archivo
├── docs/
│   └── Tarea_4_1_Fundamentos_Normalizacion.pdf <- documento principal (9 páginas)
└── img/
    └── mapa_conceptual.png                     <- mapa conceptual (recurso visual)
```

## 4. Resumen del desarrollo teórico

### 4.1 Normalización
Proceso de descomponer relaciones en otras más pequeñas, cada una con un solo tema, para (a) almacenar cada hecho en un único lugar, (b) permitir que las restricciones de integridad se garanticen mediante llaves y (c) conservar la información: la reunión natural de las relaciones resultantes reconstruye la original.

### 4.2 Dependencias funcionales (DF)
`X → Y` significa que cada valor de X determina un único valor de Y. Son reglas del negocio, no algo que se infiere de unas pocas filas.

| Tipo | Definición | Ejemplo del taller |
|---|---|---|
| **Completa** | Y depende de toda la llave (ningún atributo de la llave compuesta sobra) | `(folio_orden, id_servicio) → costo_aplicado` |
| **Parcial** | Y depende solo de una parte de una llave compuesta | `id_servicio → nombre_servicio` dentro de la llave `(folio_orden, id_servicio)` |
| **Transitiva** | `A → B` y `B → C`, con B no llave; entonces `A → C` "a través" de B | `folio_orden → vin` y `vin → marca` |
| **Multivaluada (MVD)** | `X ↠ Y`: a cada X le corresponde un conjunto de Y, independiente de los demás atributos | `id_mecanico ↠ certificacion` e `id_mecanico ↠ marca` |
| **De reunión (JD)** | La relación es la reunión natural de varias de sus proyecciones | `SUMINISTRO(proveedor, refaccion, marca_vehiculo)` bajo una regla cíclica |

### 4.3 Anomalías de actualización
Se demuestran con la relación `ORDEN_REFACCION(folio_orden, codigo_refaccion, nombre_pieza, precio_unitario, cantidad)`, que viola 2FN porque `codigo_refaccion → nombre_pieza, precio_unitario`:

| Anomalía | Efecto | Causa |
|---|---|---|
| **Inserción** | No se puede registrar una refacción nueva sin una orden, porque `folio_orden` es parte de la llave | Un hecho depende de otro para existir |
| **Borrado** | Cancelar la única orden que usó una refacción borra su nombre y precio | Dos temas comparten la misma fila |
| **Modificación** | Cambiar un precio exige editar N filas; si se olvida una, hay inconsistencia | Redundancia del mismo dato |

### 4.4 Formas normales

| Forma | Condición | Elimina | Cómo se corrige |
|---|---|---|---|
| **1FN** | Valores atómicos, sin grupos repetitivos, con llave primaria | Atributos compuestos y multivalorados | Mover los grupos repetitivos a otra relación |
| **2FN** | 1FN + todo atributo no primo depende de **toda** la llave | Dependencias parciales | Extraer la parte de la llave con sus dependientes |
| **3FN** | 2FN + ningún atributo no primo depende de otro no primo | Dependencias transitivas | Extraer el determinante intermedio |
| **FNBC** | Todo determinante de una DF no trivial es superllave | Determinantes que no son llave (llaves candidatas traslapadas) | Descomponer por el determinante |
| **4FN** | FNBC + toda MVD no trivial tiene superllave como determinante | Hechos multivalorados independientes en una misma relación | Una relación por cada hecho multivaluado |
| **5FN** | 4FN + toda JD está implicada por las llaves candidatas | Dependencias de reunión | Descomponer en proyecciones cuya reunión reconstruye la original |

Puntos que el documento aclara con ejemplo propio:
- **3FN vs FNBC:** `ATENCION(id_cliente, tipo_servicio, id_mecanico)` cumple 3FN pero no FNBC. La descomposición en FNBC siempre es sin pérdida, pero **no siempre conserva todas las dependencias**.
- **5FN:** solo aplica si la regla de negocio cíclica realmente se cumple; si no, la relación ternaria debe conservarse.

## 5. Mapa conceptual

![Mapa conceptual de la normalización](img/mapa_conceptual.png)

El mapa relaciona el problema (redundancia → anomalías), la herramienta (tipos de dependencias) y la cadena de formas normales, indicando en qué forma normal se elimina cada tipo de dependencia: parcial → 2FN, transitiva → 3FN, multivaluada → 4FN, de reunión → 5FN.

## 6. Referencias

- Codd, E. F. (1970). *A relational model of data for large shared data banks.* Communications of the ACM, 13(6).
- Codd, E. F. (1974). *Recent investigations into relational data base systems.* IFIP Congress (forma normal Boyce-Codd).
- Fagin, R. (1977). *Multivalued dependencies and a new normal form for relational databases.* ACM TODS, 2(3).
- Fagin, R. (1979). *Normal forms and relational database operators.* ACM SIGMOD (5FN).
- Kent, W. (1983). *A simple guide to five normal forms in relational database theory.* Communications of the ACM, 26(2).
- Elmasri, R. y Navathe, S. B. *Fundamentals of Database Systems.*
- Silberschatz, A., Korth, H. F. y Sudarshan, S. *Database System Concepts.*
- Date, C. J. *An Introduction to Database Systems.*

## 7. Entregables

| Entregable (Teams) | Ubicación / enlace |
|---|---|
| Documento PDF con mapa conceptual y desarrollo teórico con ejemplos | `docs/Tarea_4_1_Fundamentos_Normalizacion.pdf` |
| Repositorio público de GitHub con archivos del documento y recursos visuales | Este repositorio: _[pegar enlace del repositorio]_ |
| Video público de YouTube (anomalías de actualización y condiciones de 1FN, 2FN, 3FN y FNBC; cámara web en la esquina inferior derecha) | _[pegar enlace del video]_ |

## 8. Relación con la Tarea 4.2

Esta tarea establece la teoría; la **Tarea 4.2** la aplica paso a paso al esquema del taller "El Motor" (hoja de orden no normalizada → 1FN → 2FN → 3FN → FNBC) y entrega el script `normalized_schema.sql`.
