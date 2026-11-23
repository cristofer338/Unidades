-- =====================================================================
-- Tec Monclova · Ingeniería en Sistemas Computacionales
-- Unidad 4: Normalización de bases de datos
-- Tarea 4.2: Esquema normalizado (3FN / FNBC)
-- Caso de estudio: Taller Mecánico y Refaccionaria "El Motor"
-- Alumno: Cristofer Alejandro Barboza Chávez · I24050398
-- SGBD: PostgreSQL 16
-- Ejecución: psql -U postgres -d taller_el_motor -f normalized_schema.sql
-- Script idempotente: elimina y recrea el esquema "taller".
--
-- Derivación (ver PDF de la Tarea 4.2):
--   HOJA_ORDEN (no normalizada)
--     -> 1FN : se separan grupos repetitivos y atributos compuestos
--     -> 2FN : se eliminan dependencias parciales
--     -> 3FN : se eliminan dependencias transitivas
--     -> FNBC: todos los determinantes son llaves candidatas
-- =====================================================================

DROP SCHEMA IF EXISTS taller CASCADE;
CREATE SCHEMA taller;
SET search_path TO taller;

-- ---------------------------------------------------------------------
-- CLIENTE
-- 3FN: id_cliente -> {nombres, apellidos, calle, colonia, cp, correo}
-- Antes (1FN) estos datos se repetían en cada orden del mismo cliente
-- (dependencia transitiva folio_orden -> id_cliente -> datos del cliente).
-- Atributos atómicos: nombre_completo y direccion se descompusieron.
-- ---------------------------------------------------------------------
CREATE TABLE cliente (
    id_cliente       INTEGER GENERATED ALWAYS AS IDENTITY,
    nombres          VARCHAR(60)  NOT NULL,
    apellido_paterno VARCHAR(40)  NOT NULL,
    apellido_materno VARCHAR(40)  NOT NULL,
    calle            VARCHAR(80)  NOT NULL,
    colonia          VARCHAR(60)  NOT NULL,
    cp               CHAR(5)      NOT NULL,
    correo           VARCHAR(100),
    CONSTRAINT pk_cliente        PRIMARY KEY (id_cliente),
    CONSTRAINT ck_cliente_cp     CHECK (cp ~ '^[0-9]{5}$'),
    CONSTRAINT ck_cliente_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%')
);

-- ---------------------------------------------------------------------
-- CLIENTE_TELEFONO
-- 1FN: el atributo multivalorado {telefonos} pasa a su propia relación.
-- 4FN: los teléfonos son independientes de vehículos y órdenes, por eso
--      no se mezclan en una misma tabla (evita dependencias multivaluadas).
-- ---------------------------------------------------------------------
CREATE TABLE cliente_telefono (
    id_cliente INTEGER     NOT NULL,
    telefono   VARCHAR(10) NOT NULL,
    CONSTRAINT pk_cliente_telefono PRIMARY KEY (id_cliente, telefono),
    CONSTRAINT fk_telefono_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_telefono_formato CHECK (telefono ~ '^[0-9]{10}$')
);

-- ---------------------------------------------------------------------
-- VEHICULO
-- 3FN: vin -> {placa, marca, modelo_anio, color, kilometraje, id_cliente}
-- FNBC: vin y placa son llaves candidatas (vin <-> placa).
-- ---------------------------------------------------------------------
CREATE TABLE vehiculo (
    vin         CHAR(17)    NOT NULL,
    placa       VARCHAR(10) NOT NULL,
    marca       VARCHAR(40) NOT NULL,
    modelo_anio SMALLINT    NOT NULL,
    color       VARCHAR(30),
    kilometraje INTEGER     NOT NULL DEFAULT 0,
    id_cliente  INTEGER     NOT NULL,
    CONSTRAINT pk_vehiculo         PRIMARY KEY (vin),
    CONSTRAINT uq_vehiculo_placa   UNIQUE (placa),
    CONSTRAINT fk_vehiculo_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_vehiculo_vin  CHECK (vin ~ '^[A-HJ-NPR-Z0-9]{17}$'),
    CONSTRAINT ck_vehiculo_anio CHECK (modelo_anio BETWEEN 1950 AND 2100),
    CONSTRAINT ck_vehiculo_km   CHECK (kilometraje >= 0)
);
CREATE INDEX ix_vehiculo_cliente ON vehiculo (id_cliente);

-- ---------------------------------------------------------------------
-- EMPLEADO (superentidad)
-- 2FN: id_empleado -> datos del empleado (antes repetidos por cada orden
--      en la que participaba: dependencia parcial de (folio, id_empleado)).
-- FNBC: id_empleado y curp son llaves candidatas.
-- uq_empleado_id_tipo permite la FK compuesta de los subtipos.
-- ---------------------------------------------------------------------
CREATE TABLE empleado (
    id_empleado      INTEGER GENERATED ALWAYS AS IDENTITY,
    curp             CHAR(18)    NOT NULL,
    nombres          VARCHAR(60) NOT NULL,
    apellido_paterno VARCHAR(40) NOT NULL,
    apellido_materno VARCHAR(40) NOT NULL,
    fecha_ingreso    DATE        NOT NULL DEFAULT CURRENT_DATE,
    tipo             VARCHAR(14) NOT NULL,
    CONSTRAINT pk_empleado         PRIMARY KEY (id_empleado),
    CONSTRAINT uq_empleado_curp    UNIQUE (curp),
    CONSTRAINT uq_empleado_id_tipo UNIQUE (id_empleado, tipo),
    CONSTRAINT ck_empleado_tipo    CHECK (tipo IN ('MECANICO', 'RECEPCIONISTA')),
    CONSTRAINT ck_empleado_curp    CHECK (curp ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[A-Z0-9][0-9]$')
);

-- ---------------------------------------------------------------------
-- MECANICO (subtipo)
-- especialidad y tarifa_hora solo aplican a mecánicos; se separan para
-- evitar columnas NULL en empleado.
-- ---------------------------------------------------------------------
CREATE TABLE mecanico (
    id_empleado  INTEGER      NOT NULL,
    tipo         VARCHAR(14)  NOT NULL DEFAULT 'MECANICO',
    especialidad VARCHAR(60)  NOT NULL,
    tarifa_hora  NUMERIC(8,2) NOT NULL,
    CONSTRAINT pk_mecanico PRIMARY KEY (id_empleado),
    CONSTRAINT fk_mecanico_empleado FOREIGN KEY (id_empleado, tipo)
        REFERENCES empleado (id_empleado, tipo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_mecanico_tipo   CHECK (tipo = 'MECANICO'),
    CONSTRAINT ck_mecanico_tarifa CHECK (tarifa_hora > 0)
);

-- ---------------------------------------------------------------------
-- RECEPCIONISTA (subtipo)
-- ---------------------------------------------------------------------
CREATE TABLE recepcionista (
    id_empleado     INTEGER     NOT NULL,
    tipo            VARCHAR(14) NOT NULL DEFAULT 'RECEPCIONISTA',
    turno           VARCHAR(10) NOT NULL,
    modulo_atencion VARCHAR(30) NOT NULL,
    CONSTRAINT pk_recepcionista PRIMARY KEY (id_empleado),
    CONSTRAINT fk_recepcionista_empleado FOREIGN KEY (id_empleado, tipo)
        REFERENCES empleado (id_empleado, tipo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_recepcionista_tipo  CHECK (tipo = 'RECEPCIONISTA'),
    CONSTRAINT ck_recepcionista_turno CHECK (turno IN ('MATUTINO', 'VESPERTINO', 'NOCTURNO'))
);

-- ---------------------------------------------------------------------
-- SERVICIO
-- 2FN: id_servicio -> {nombre_servicio, precio_base}
-- (antes dependían solo de id_servicio dentro de la llave (folio, id_servicio)).
-- FNBC: id_servicio y nombre_servicio son llaves candidatas.
-- ---------------------------------------------------------------------
CREATE TABLE servicio (
    id_servicio     INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre_servicio VARCHAR(80)   NOT NULL,
    precio_base     NUMERIC(10,2) NOT NULL,
    CONSTRAINT pk_servicio        PRIMARY KEY (id_servicio),
    CONSTRAINT uq_servicio_nombre UNIQUE (nombre_servicio),
    CONSTRAINT ck_servicio_precio CHECK (precio_base >= 0)
);

-- ---------------------------------------------------------------------
-- REFACCION
-- 2FN: codigo_refaccion -> {nombre_pieza, marca_pieza, precio_unitario, stock_actual}
-- ---------------------------------------------------------------------
CREATE TABLE refaccion (
    codigo_refaccion VARCHAR(20)   NOT NULL,
    nombre_pieza     VARCHAR(80)   NOT NULL,
    marca_pieza      VARCHAR(40),
    precio_unitario  NUMERIC(10,2) NOT NULL,
    stock_actual     INTEGER       NOT NULL DEFAULT 0,
    CONSTRAINT pk_refaccion       PRIMARY KEY (codigo_refaccion),
    CONSTRAINT ck_refaccion_precio CHECK (precio_unitario >= 0),
    CONSTRAINT ck_refaccion_stock  CHECK (stock_actual >= 0)
);

-- ---------------------------------------------------------------------
-- ORDEN_SERVICIO
-- 3FN: folio_orden -> {fechas, diagnóstico, estado, vin}.
-- Se eliminó la dependencia transitiva folio_orden -> vin -> datos del
-- vehículo y folio_orden -> vin -> id_cliente -> datos del cliente.
-- ---------------------------------------------------------------------
CREATE TABLE orden_servicio (
    folio_orden         INTEGER GENERATED ALWAYS AS IDENTITY,
    fecha_ingreso       DATE         NOT NULL DEFAULT CURRENT_DATE,
    fecha_entrega_est   DATE,
    diagnostico_inicial VARCHAR(300),
    estado              VARCHAR(12)  NOT NULL DEFAULT 'RECIBIDO',
    vin                 CHAR(17)     NOT NULL,
    CONSTRAINT pk_orden_servicio PRIMARY KEY (folio_orden),
    CONSTRAINT fk_orden_vehiculo FOREIGN KEY (vin)
        REFERENCES vehiculo (vin) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_orden_estado CHECK (estado IN ('RECIBIDO', 'EN_PROCESO', 'TERMINADO', 'ENTREGADO', 'CANCELADO')),
    CONSTRAINT ck_orden_fechas CHECK (fecha_entrega_est IS NULL OR fecha_entrega_est >= fecha_ingreso)
);
CREATE INDEX ix_orden_vehiculo ON orden_servicio (vin);

-- ---------------------------------------------------------------------
-- SERVICIO_APLICADO (M:N orden - servicio)
-- Solo conserva costo_aplicado: depende de TODA la llave (folio, servicio).
-- ---------------------------------------------------------------------
CREATE TABLE servicio_aplicado (
    folio_orden    INTEGER       NOT NULL,
    id_servicio    INTEGER       NOT NULL,
    costo_aplicado NUMERIC(10,2) NOT NULL,
    CONSTRAINT pk_servicio_aplicado PRIMARY KEY (folio_orden, id_servicio),
    CONSTRAINT fk_sa_orden FOREIGN KEY (folio_orden)
        REFERENCES orden_servicio (folio_orden) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_sa_servicio FOREIGN KEY (id_servicio)
        REFERENCES servicio (id_servicio) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_sa_costo CHECK (costo_aplicado >= 0)
);
CREATE INDEX ix_sa_servicio ON servicio_aplicado (id_servicio);

-- ---------------------------------------------------------------------
-- ASIGNACION_TRABAJO (M:N orden - mecánico)
-- horas_trabajadas y fecha_asignacion dependen de (folio, mecánico).
-- ---------------------------------------------------------------------
CREATE TABLE asignacion_trabajo (
    folio_orden      INTEGER      NOT NULL,
    id_mecanico      INTEGER      NOT NULL,
    horas_trabajadas NUMERIC(5,2) NOT NULL DEFAULT 0,
    fecha_asignacion DATE         NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT pk_asignacion_trabajo PRIMARY KEY (folio_orden, id_mecanico),
    CONSTRAINT fk_asig_orden FOREIGN KEY (folio_orden)
        REFERENCES orden_servicio (folio_orden) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_asig_mecanico FOREIGN KEY (id_mecanico)
        REFERENCES mecanico (id_empleado) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_asig_horas CHECK (horas_trabajadas >= 0)
);
CREATE INDEX ix_asig_mecanico ON asignacion_trabajo (id_mecanico);

-- ---------------------------------------------------------------------
-- USO_REFACCION (M:N sobre la asignación)
-- cantidad_usada depende de (folio, mecánico, refacción).
-- ---------------------------------------------------------------------
CREATE TABLE uso_refaccion (
    folio_orden      INTEGER     NOT NULL,
    id_mecanico      INTEGER     NOT NULL,
    codigo_refaccion VARCHAR(20) NOT NULL,
    cantidad_usada   INTEGER     NOT NULL,
    CONSTRAINT pk_uso_refaccion PRIMARY KEY (folio_orden, id_mecanico, codigo_refaccion),
    CONSTRAINT fk_uso_asignacion FOREIGN KEY (folio_orden, id_mecanico)
        REFERENCES asignacion_trabajo (folio_orden, id_mecanico) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_uso_refaccion FOREIGN KEY (codigo_refaccion)
        REFERENCES refaccion (codigo_refaccion) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_uso_cantidad CHECK (cantidad_usada > 0)
);
CREATE INDEX ix_uso_refaccion ON uso_refaccion (codigo_refaccion);

-- ---------------------------------------------------------------------
-- VISTAS: atributos derivados (NO se almacenan; hacerlo violaría la
-- normalización porque dependerían de otros atributos no llave).
-- ---------------------------------------------------------------------
CREATE VIEW v_vehiculo AS
SELECT v.vin,
       v.modelo_anio,
       (EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER - v.modelo_anio) AS antiguedad_anios
FROM vehiculo v;

CREATE VIEW v_orden_monto AS
SELECT t.folio_orden,
       t.total_servicios,
       t.total_refacciones,
       t.total_mano_obra,
       t.total_servicios + t.total_refacciones + t.total_mano_obra AS monto_total
FROM (
    SELECT o.folio_orden,
           COALESCE((SELECT SUM(sa.costo_aplicado)
                       FROM servicio_aplicado sa
                      WHERE sa.folio_orden = o.folio_orden), 0) AS total_servicios,
           COALESCE((SELECT SUM(ur.cantidad_usada * r.precio_unitario)
                       FROM uso_refaccion ur
                       JOIN refaccion r ON r.codigo_refaccion = ur.codigo_refaccion
                      WHERE ur.folio_orden = o.folio_orden), 0) AS total_refacciones,
           COALESCE((SELECT SUM(a.horas_trabajadas * m.tarifa_hora)
                       FROM asignacion_trabajo a
                       JOIN mecanico m ON m.id_empleado = a.id_mecanico
                      WHERE a.folio_orden = o.folio_orden), 0) AS total_mano_obra
    FROM orden_servicio o
) t;
