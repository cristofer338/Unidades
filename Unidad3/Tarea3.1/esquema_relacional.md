# Esquema relacional — Taller Mecánico y Refaccionaria "El Motor"

Resultado de transformar el diagrama E-R / E-RE (Unidad 2) al modelo relacional. PK = llave primaria, FK = llave foránea, UQ = única.

## Esquemas de relación

Notación: **PK** entre `[ ]`, FK con `*`.

- **ASIGNACION_TRABAJO**([folio_orden]*, [id_mecanico]*, horas_trabajadas, fecha_asignacion)
- **CLIENTE**([id_cliente], nombres, apellido_paterno, apellido_materno, calle, colonia, cp, correo)
- **CLIENTE_TELEFONO**([id_cliente]*, [telefono])
- **EMPLEADO**([id_empleado], curp, nombres, apellido_paterno, apellido_materno, fecha_ingreso, tipo)
- **MECANICO**([id_empleado]*, tipo*, especialidad, tarifa_hora)
- **ORDEN_SERVICIO**([folio_orden], fecha_ingreso, fecha_entrega_est, diagnostico_inicial, estado, vin*)
- **RECEPCIONISTA**([id_empleado]*, tipo*, turno, modulo_atencion)
- **REFACCION**([codigo_refaccion], nombre_pieza, marca_pieza, precio_unitario, stock_actual)
- **SERVICIO**([id_servicio], nombre_servicio, precio_base)
- **SERVICIO_APLICADO**([folio_orden]*, [id_servicio]*, costo_aplicado)
- **USO_REFACCION**([folio_orden]*, [id_mecanico]*, [codigo_refaccion]*, cantidad_usada)
- **VEHICULO**([vin], placa, marca, modelo_anio, color, kilometraje, id_cliente*)

## Llaves foráneas

| Tabla | Columnas | Referencia | ON UPDATE | ON DELETE |
|---|---|---|---|---|
| asignacion_trabajo | id_mecanico | mecanico(id_empleado) | CASCADE | RESTRICT |
| asignacion_trabajo | folio_orden | orden_servicio(folio_orden) | CASCADE | CASCADE |
| cliente_telefono | id_cliente | cliente(id_cliente) | CASCADE | CASCADE |
| mecanico | id_empleado, tipo | empleado(id_empleado, tipo) | CASCADE | CASCADE |
| orden_servicio | vin | vehiculo(vin) | CASCADE | RESTRICT |
| recepcionista | id_empleado, tipo | empleado(id_empleado, tipo) | CASCADE | CASCADE |
| servicio_aplicado | folio_orden | orden_servicio(folio_orden) | CASCADE | CASCADE |
| servicio_aplicado | id_servicio | servicio(id_servicio) | CASCADE | RESTRICT |
| uso_refaccion | folio_orden, id_mecanico | asignacion_trabajo(folio_orden, id_mecanico) | CASCADE | CASCADE |
| uso_refaccion | codigo_refaccion | refaccion(codigo_refaccion) | CASCADE | RESTRICT |
| vehiculo | id_cliente | cliente(id_cliente) | CASCADE | RESTRICT |

## Tablas

### asignacion_trabajo

| Atributo | Dominio | Llave | Nulo |
|---|---|---|---|
| folio_orden | INTEGER | PK, FK | No |
| id_mecanico | INTEGER | PK, FK | No |
| horas_trabajadas | NUMERIC(5,2) |  | No |
| fecha_asignacion | DATE |  | No |

### cliente

| Atributo | Dominio | Llave | Nulo |
|---|---|---|---|
| id_cliente | INTEGER | PK | No |
| nombres | VARCHAR(60) |  | No |
| apellido_paterno | VARCHAR(40) |  | No |
| apellido_materno | VARCHAR(40) |  | No |
| calle | VARCHAR(80) |  | No |
| colonia | VARCHAR(60) |  | No |
| cp | CHAR(5) |  | No |
| correo | VARCHAR(100) |  | Sí |

### cliente_telefono

| Atributo | Dominio | Llave | Nulo |
|---|---|---|---|
| id_cliente | INTEGER | PK, FK | No |
| telefono | VARCHAR(10) | PK | No |

### empleado

| Atributo | Dominio | Llave | Nulo |
|---|---|---|---|
| id_empleado | INTEGER | PK | No |
| curp | CHAR(18) | UQ | No |
| nombres | VARCHAR(60) |  | No |
| apellido_paterno | VARCHAR(40) |  | No |
| apellido_materno | VARCHAR(40) |  | No |
| fecha_ingreso | DATE |  | No |
| tipo | VARCHAR(14) |  | No |

### mecanico

| Atributo | Dominio | Llave | Nulo |
|---|---|---|---|
| id_empleado | INTEGER | PK, FK | No |
| tipo | VARCHAR(14) | FK | No |
| especialidad | VARCHAR(60) |  | No |
| tarifa_hora | NUMERIC(8,2) |  | No |

### orden_servicio

| Atributo | Dominio | Llave | Nulo |
|---|---|---|---|
| folio_orden | INTEGER | PK | No |
| fecha_ingreso | DATE |  | No |
| fecha_entrega_est | DATE |  | Sí |
| diagnostico_inicial | VARCHAR(300) |  | Sí |
| estado | VARCHAR(12) |  | No |
| vin | CHAR(17) | FK | No |

### recepcionista

| Atributo | Dominio | Llave | Nulo |
|---|---|---|---|
| id_empleado | INTEGER | PK, FK | No |
| tipo | VARCHAR(14) | FK | No |
| turno | VARCHAR(10) |  | No |
| modulo_atencion | VARCHAR(30) |  | No |

### refaccion

| Atributo | Dominio | Llave | Nulo |
|---|---|---|---|
| codigo_refaccion | VARCHAR(20) | PK | No |
| nombre_pieza | VARCHAR(80) |  | No |
| marca_pieza | VARCHAR(40) |  | Sí |
| precio_unitario | NUMERIC(10,2) |  | No |
| stock_actual | INTEGER |  | No |

### servicio

| Atributo | Dominio | Llave | Nulo |
|---|---|---|---|
| id_servicio | INTEGER | PK | No |
| nombre_servicio | VARCHAR(80) | UQ | No |
| precio_base | NUMERIC(10,2) |  | No |

### servicio_aplicado

| Atributo | Dominio | Llave | Nulo |
|---|---|---|---|
| folio_orden | INTEGER | PK, FK | No |
| id_servicio | INTEGER | PK, FK | No |
| costo_aplicado | NUMERIC(10,2) |  | No |

### uso_refaccion

| Atributo | Dominio | Llave | Nulo |
|---|---|---|---|
| folio_orden | INTEGER | PK, FK | No |
| id_mecanico | INTEGER | PK, FK | No |
| codigo_refaccion | VARCHAR(20) | PK, FK | No |
| cantidad_usada | INTEGER |  | No |

### vehiculo

| Atributo | Dominio | Llave | Nulo |
|---|---|---|---|
| vin | CHAR(17) | PK | No |
| placa | VARCHAR(10) | UQ | No |
| marca | VARCHAR(40) |  | No |
| modelo_anio | SMALLINT |  | No |
| color | VARCHAR(30) |  | Sí |
| kilometraje | INTEGER |  | No |
| id_cliente | INTEGER | FK | No |

## Restricciones CHECK

| Tabla | Restricción | Regla |
|---|---|---|
| asignacion_trabajo | ck_asig_horas | `horas_trabajadas >= 0` |
| cliente | ck_cliente_correo | `correo IS NULL OR correo LIKE '%_@_%._%'` |
| cliente | ck_cliente_cp | `cp ~ '^[0-9]{5}$'` |
| cliente_telefono | ck_telefono_formato | `telefono ~ '^[0-9]{10}$'` |
| empleado | ck_empleado_curp | `curp ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[A-Z0-9][0-9]$'` |
| empleado | ck_empleado_tipo | `tipo IN ('MECANICO', 'RECEPCIONISTA')` |
| mecanico | ck_mecanico_tarifa | `tarifa_hora > 0` |
| mecanico | ck_mecanico_tipo | `tipo = 'MECANICO'` |
| orden_servicio | ck_orden_estado | `estado IN ('RECIBIDO', 'EN_PROCESO', 'TERMINADO', 'ENTREGADO', 'CANCELADO')` |
| orden_servicio | ck_orden_fechas | `fecha_entrega_est IS NULL OR fecha_entrega_est >= fecha_ingreso` |
| recepcionista | ck_recepcionista_tipo | `tipo = 'RECEPCIONISTA'` |
| recepcionista | ck_recepcionista_turno | `turno IN ('MATUTINO', 'VESPERTINO', 'NOCTURNO')` |
| refaccion | ck_refaccion_precio | `precio_unitario >= 0` |
| refaccion | ck_refaccion_stock | `stock_actual >= 0` |
| servicio | ck_servicio_precio | `precio_base >= 0` |
| servicio_aplicado | ck_sa_costo | `costo_aplicado >= 0` |
| uso_refaccion | ck_uso_cantidad | `cantidad_usada > 0` |
| vehiculo | ck_vehiculo_anio | `modelo_anio BETWEEN 1950 AND 2100` |
| vehiculo | ck_vehiculo_km | `kilometraje >= 0` |
| vehiculo | ck_vehiculo_vin | `vin ~ '^[A-HJ-NPR-Z0-9]{17}$'` |
