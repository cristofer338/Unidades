# Tarea 4.2 · Proceso paso a paso de normalización del proyecto aplicado

| | |
|---|---|
| **Institución** | Tec Monclova · Ingeniería en Sistemas Computacionales |
| **Unidad** | 4 · Normalización de bases de datos |
| **Competencia específica** | Aplica el proceso de normalización al diseño de los esquemas de bases de datos para detectar anomalías y garantizar la integridad de la información |
| **Alumno** | Cristofer Alejandro Barboza Chávez · I24050398 |
| **Proyecto** | Taller Mecánico y Refaccionaria "El Motor" |
| **SGBD** | PostgreSQL 16 (esquema `taller`) |

---

## 1. Propósito del repositorio

Documenta el **proceso deductivo de descomposición de tablas** que lleva a un esquema totalmente normalizado (3FN, con validación de FNBC) para el proyecto, partiendo de una estructura no normalizada: la **hoja de orden de servicio**, donde cliente, vehículo, servicios, mecánicos y refacciones aparecen mezclados en un solo registro. Incluye el script SQL corregido derivado del esquema final.

> El esquema final coincide con el esquema físico de la Tarea 3.2. Esta tarea explica **por qué** el esquema tiene esa forma: cada tabla responde a una dependencia funcional concreta.

## 2. Cumplimiento de las instrucciones de la tarea

| # | Requisito de la tarea | Dónde se cumple |
|---|---|---|
| 1 | Tomar una estructura no normalizada o con dependencias complejas del proyecto | PDF §2: `HOJA_ORDEN` con grupos repetitivos anidados, ejemplo de una orden y 11 dependencias funcionales identificadas |
| 2 | Anomalías de la estructura de partida | PDF §2.2 (Tabla 2: inserción, borrado y modificación con casos del taller) |
| 3 | **Desnormalizado → 1FN** (grupos repetitivos y atomicidad) | PDF §3, Figura 1 y Tabla 3; imagen `img/fig_unf_1fn.png` |
| 4 | **1FN → 2FN** (dependencias parciales) | PDF §4, Tabla 4, Figura 2 y Tabla 5; imagen `img/fig_1fn_2fn.png` |
| 5 | **2FN → 3FN** (dependencias transitivas) | PDF §5, Tablas 6 y 7, Figura 3; imagen `img/fig_2fn_3fn.png` |
| 6 | Validación de **FNBC** (y comentario de 4FN/5FN) | PDF §6, Tabla 8 (determinantes de las 12 relaciones) |
| 7 | **Script SQL corregido** del esquema normalizado | `sql/normalized_schema.sql` |
| 8 | Desglose analítico y anomalías corregidas | PDF §7, Tabla 9 (antes y después) |

## 3. Contenido del repositorio

```
tarea_4_2/
├── README.md                                    <- este archivo
├── docs/
│   └── Tarea_4_2_Proceso_Normalizacion.pdf      <- desglose analítico (14 páginas)
├── sql/
│   └── normalized_schema.sql                    <- script LDD normalizado
└── img/
    ├── fig_unf_1fn.png                          <- no normalizada -> 1FN
    ├── fig_1fn_2fn.png                          <- 1FN -> 2FN
    ├── fig_2fn_3fn.png                          <- 2FN -> 3FN
    └── esquema_final.png                        <- esquema normalizado (12 tablas)
```

## 4. Punto de partida

```
HOJA_ORDEN(
  folio_orden, fecha_ingreso, fecha_entrega_est, diagnostico_inicial, estado,
  vin, placa, marca, modelo_anio, color, kilometraje,
  id_cliente, nombre_completo, direccion(calle, colonia, cp), correo,
  { telefono },
  { id_servicio, nombre_servicio, precio_base, costo_aplicado },
  { id_empleado, curp, nombre_empleado, fecha_ingreso_emp, especialidad,
    tarifa_hora, horas_trabajadas, fecha_asignacion,
    { codigo_refaccion, nombre_pieza, marca_pieza,
      precio_unitario, stock_actual, cantidad_usada } }
)
```

### Dependencias funcionales del negocio

```
folio_orden                  -> fecha_ingreso, fecha_entrega_est, diagnostico_inicial, estado, vin
vin                          -> placa, marca, modelo_anio, color, kilometraje, id_cliente
placa                        -> vin
id_cliente                   -> nombres, apellido_paterno, apellido_materno, calle, colonia, cp, correo
id_servicio                  -> nombre_servicio, precio_base
(folio_orden, id_servicio)   -> costo_aplicado
id_empleado                  -> curp, nombres, apellidos, fecha_ingreso_emp, especialidad, tarifa_hora
curp                         -> id_empleado
(folio_orden, id_empleado)   -> horas_trabajadas, fecha_asignacion
codigo_refaccion             -> nombre_pieza, marca_pieza, precio_unitario, stock_actual
(folio_orden, id_empleado, codigo_refaccion) -> cantidad_usada
```

## 5. Proceso de normalización

### Fase 1 · No normalizada → 1FN
**Violaciones:** atributos compuestos (`nombre_completo`, `direccion`), atributo multivalorado (`{telefono}`) y grupos repetitivos (`{servicios}`, `{mecánicos}` con `{refacciones}` anidadas).
**Solución:** se descomponen los compuestos; el cuerpo de la orden queda en `ORDEN`; cada grupo repetitivo pasa a su relación con la llave de la orden + su identificador; las refacciones heredan la llave del mecánico.

| Relación 1FN | Llave |
|---|---|
| `ORDEN` | `folio_orden` |
| `ORDEN_TELEFONO` | `(folio_orden, telefono)` |
| `ORDEN_SERVICIO_DET` | `(folio_orden, id_servicio)` |
| `ORDEN_MECANICO` | `(folio_orden, id_empleado)` |
| `ORDEN_MEC_REFACCION` | `(folio_orden, id_empleado, codigo_refaccion)` |

Se evita aplanar todo en una sola tabla porque obligaría a repetir el producto cartesiano de teléfonos × servicios × mecánicos × refacciones (dependencias multivaluadas independientes, propias de la 4FN).

![1FN](img/fig_unf_1fn.png)

### Fase 2 · 1FN → 2FN
Se eliminan las **dependencias parciales** en las relaciones con llave compuesta:

| Relación 1FN | Dependencia parcial | Resultado 2FN |
|---|---|---|
| `ORDEN_SERVICIO_DET` | `id_servicio → nombre_servicio, precio_base` | `SERVICIO` + `SERVICIO_APLICADO(folio_orden, id_servicio, costo_aplicado)` |
| `ORDEN_MECANICO` | `id_empleado → curp, nombres, apellidos, fecha_ingreso, especialidad, tarifa_hora` | `EMPLEADO` + `ASIGNACION_TRABAJO(folio_orden, id_mecanico, horas_trabajadas, fecha_asignacion)` |
| `ORDEN_MEC_REFACCION` | `codigo_refaccion → nombre_pieza, marca_pieza, precio_unitario, stock_actual` | `REFACCION` + `USO_REFACCION(folio_orden, id_mecanico, codigo_refaccion, cantidad_usada)` |

![2FN](img/fig_1fn_2fn.png)

### Fase 3 · 2FN → 3FN
Se eliminan las **dependencias transitivas**:

- En `ORDEN`: `folio_orden → vin → (placa, marca, modelo_anio, color, kilometraje, id_cliente)` y `vin → id_cliente → (datos del cliente)`. Se extraen **`VEHICULO`** y **`CLIENTE`**; queda `ORDEN_SERVICIO(folio_orden, fechas, diagnostico, estado, vin)`.
- Los teléfonos pertenecen al cliente, no a la orden: `ORDEN_TELEFONO` se redefine como **`CLIENTE_TELEFONO(id_cliente, telefono)`**.
- `EMPLEADO` se especializa en **`MECANICO`** (`especialidad`, `tarifa_hora`) y **`RECEPCIONISTA`** (`turno`, `modulo_atencion`) para evitar columnas nulas. El discriminador `tipo` y la FK compuesta `(id_empleado, tipo)` impiden que un empleado sea de ambos tipos.

![3FN](img/fig_2fn_3fn.png)

### Validación de FNBC

| Relación | Llaves candidatas | ¿FNBC? |
|---|---|---|
| `cliente` | `id_cliente` | Sí |
| `cliente_telefono` | `(id_cliente, telefono)` | Sí |
| `vehiculo` | `vin` ; `placa` | Sí (ambos determinantes son llave) |
| `empleado` | `id_empleado` ; `curp` | Sí |
| `mecanico` / `recepcionista` | `id_empleado` | Sí |
| `orden_servicio` | `folio_orden` | Sí |
| `servicio` | `id_servicio` ; `nombre_servicio` | Sí |
| `servicio_aplicado` | `(folio_orden, id_servicio)` | Sí |
| `refaccion` | `codigo_refaccion` | Sí |
| `asignacion_trabajo` | `(folio_orden, id_mecanico)` | Sí |
| `uso_refaccion` | `(folio_orden, id_mecanico, codigo_refaccion)` | Sí |

**4FN / 5FN:** los hechos multivalorados independientes (teléfonos, servicios, mecánicos) quedaron en relaciones separadas, por lo que no hay MVD no triviales con determinante no llave; no existe una regla de negocio que permita reconstruir las relaciones de enlace por reunión de proyecciones menores.

## 6. Esquema final

![Esquema final](img/esquema_final.png)

12 tablas: `cliente`, `cliente_telefono`, `vehiculo`, `empleado`, `mecanico`, `recepcionista`, `orden_servicio`, `servicio`, `servicio_aplicado`, `asignacion_trabajo`, `refaccion`, `uso_refaccion`; más las vistas `v_vehiculo` y `v_orden_monto`.

## 7. Anomalías corregidas

| Anomalía | Antes (hoja de orden) | Después (esquema normalizado) |
|---|---|---|
| Modificación: precio de una refacción | Editar todas las órdenes donde se usó | `UPDATE refaccion SET precio_unitario = ... WHERE codigo_refaccion = ...;` (una fila) |
| Modificación: domicilio del cliente | Corregir en cada orden y vehículo | `UPDATE cliente SET calle = ... WHERE id_cliente = ...;` |
| Inserción: refacción, servicio o mecánico nuevo | Imposible sin una orden | `INSERT` directo en su tabla |
| Inserción: cliente sin orden | Imposible | `INSERT INTO cliente` y luego su vehículo |
| Borrado: cancelar una orden | Se pierde el catálogo y datos del cliente | `DELETE FROM orden_servicio ...` elimina solo la orden y sus líneas (`ON DELETE CASCADE`) |
| Integridad referencial | Sin control | Llaves foráneas con `ON UPDATE CASCADE` y `ON DELETE RESTRICT/CASCADE` |

## 8. Script SQL: `sql/normalized_schema.sql`

Contiene únicamente sentencias LDD (`CREATE SCHEMA`, `CREATE TABLE`, `CREATE INDEX`, `CREATE VIEW`). Cada tabla trae un comentario con la fase en la que se obtuvo y la dependencia funcional que la justifica.

| Fase | Tablas / elementos en el script |
|---|---|
| 1FN | `cliente_telefono` (multivalorado), `servicio_aplicado`, `asignacion_trabajo`, `uso_refaccion` (grupos repetitivos); atributos compuestos descompuestos en `cliente` y `empleado` |
| 2FN | `servicio`, `refaccion`, `empleado` (+ `mecanico`), tablas de enlace |
| 3FN | `orden_servicio`, `vehiculo`, `cliente`, `cliente_telefono`; subtipos `mecanico` y `recepcionista` |
| FNBC | Restricciones `UNIQUE` para llaves candidatas: `placa`, `curp`, `nombre_servicio` y `(id_empleado, tipo)` |

Integridad declarativa: `PRIMARY KEY`, `FOREIGN KEY` con acciones referenciales, `UNIQUE`, `NOT NULL`, `DEFAULT` y `CHECK` (formatos de VIN, CURP, CP y teléfono; rangos de año, kilometraje, precios y horas; listas de valores de estado y turno).

### Ejecución

```bash
createdb -U postgres taller_el_motor
psql -U postgres -d taller_el_motor -f sql/normalized_schema.sql
```

El script es **idempotente**: hace `DROP SCHEMA IF EXISTS taller CASCADE` y lo recrea.

### Verificación sugerida

```sql
\dt taller.*                 -- deben aparecer las 12 tablas
\d taller.vehiculo           -- PK, UNIQUE(placa), FK a cliente, CHECK de VIN
SELECT conname, contype FROM pg_constraint
WHERE connamespace = 'taller'::regnamespace ORDER BY conrelid::regclass::text, contype;
SELECT * FROM taller.v_vehiculo;
SELECT * FROM taller.v_orden_monto;
```

### Alcance de la validación
El script reproduce el diseño físico que se implementó y validó en **PostgreSQL 16.15** en la Tarea 3.2 (creación, carga de datos y pruebas de restricciones). Esta versión es la normalizada derivada de esa estructura; el entorno donde se generó el documento no incluía PostgreSQL, por lo que la ejecución de este archivo debe comprobarse con los comandos anteriores.

## 9. Decisiones de diseño y limitaciones

- **Atributos derivados** (antigüedad del vehículo, monto de la orden) se calculan en vistas y **no** se almacenan: depender de otros atributos no llave violaría la normalización.
- **Supuesto sobre `cp` y `colonia`:** se asumió que el código postal no determina la colonia (un CP puede cubrir varias colonias). Si el negocio decidiera lo contrario, habría que extraer `CODIGO_POSTAL(cp, colonia)` para conservar la FNBC.
- **Participación total de `empleado`:** que todo empleado tenga fila en `mecanico` o `recepcionista` no se puede forzar solo con restricciones declarativas (requeriría una restricción diferida o un disparador); la aplicación debe insertar empleado y subtipo en la misma transacción. Lo que sí se garantiza es la disyunción.
- **Precio histórico de refacciones:** `servicio_aplicado` guarda `costo_aplicado`, pero `uso_refaccion` no guarda el precio al momento del uso, de modo que `v_orden_monto` usa el precio vigente. Si se requiere histórico, conviene agregar `precio_aplicado` a `uso_refaccion`; no es una violación de 3FN porque es un hecho distinto del precio del catálogo.

## 10. Entregables

| Entregable (Teams) | Ubicación / enlace |
|---|---|
| Documento PDF con el desglose analítico de cada fase y las anomalías corregidas | `docs/Tarea_4_2_Proceso_Normalizacion.pdf` |
| Repositorio público de GitHub con `normalized_schema.sql` | Este repositorio: _[pegar enlace del repositorio]_ |
| Video público de YouTube (proceso deductivo de descomposición paso a paso; cámara web en la esquina inferior derecha) | _[pegar enlace del video]_ |

## 11. Relación con otras tareas

- **Tarea 4.1:** fundamentos teóricos (dependencias, anomalías, formas normales y mapa conceptual).
- **Tarea 3.2:** esquema físico original en PostgreSQL del que deriva el resultado final de esta tarea.
