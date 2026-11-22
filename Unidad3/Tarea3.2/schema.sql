-- =====================================================================
--  Taller Mecánico y Refaccionaria "El Motor"
--  Tarea 3.2 · Esquema físico (DDL) · PostgreSQL 14+
--  Alumno: Cristofer Alejandro Barboza Chávez · I24050398
--
--  Ejecución:  psql -U postgres -d taller_el_motor -f schema.sql
--  El script es idempotente: borra y recrea todo el esquema.
-- =====================================================================

DROP SCHEMA IF EXISTS taller CASCADE;
CREATE SCHEMA taller;
SET search_path TO taller;

-- ---------------------------------------------------------------------
-- 1. CLIENTE
--    Atributos compuestos (nombre_completo, direccion) aplanados en columnas.
-- ---------------------------------------------------------------------
CREATE TABLE cliente (
    id_cliente        INTEGER GENERATED ALWAYS AS IDENTITY,
    nombres           VARCHAR(60)  NOT NULL,
    apellido_paterno  VARCHAR(40)  NOT NULL,
    apellido_materno  VARCHAR(40)  NOT NULL,
    calle             VARCHAR(80)  NOT NULL,
    colonia           VARCHAR(60)  NOT NULL,
    cp                CHAR(5)      NOT NULL,
    correo            VARCHAR(100),
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT ck_cliente_cp     CHECK (cp ~ '^[0-9]{5}$'),
    CONSTRAINT ck_cliente_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%')
);

-- Atributo multivalorado "telefonos" -> tabla propia (1FN)
CREATE TABLE cliente_telefono (
    id_cliente  INTEGER     NOT NULL,
    telefono    VARCHAR(10) NOT NULL,
    CONSTRAINT pk_cliente_telefono PRIMARY KEY (id_cliente, telefono),
    CONSTRAINT fk_telefono_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_telefono_formato CHECK (telefono ~ '^[0-9]{10}$')
);

-- ---------------------------------------------------------------------
-- 2. VEHICULO  (relación POSEE 1:N -> FK en el lado N)
--    "antiguedad_anios" es derivado: se calcula en la vista v_vehiculo.
-- ---------------------------------------------------------------------
CREATE TABLE vehiculo (
    vin           CHAR(17)     NOT NULL,
    placa         VARCHAR(10)  NOT NULL,
    marca         VARCHAR(40)  NOT NULL,
    modelo_anio   SMALLINT     NOT NULL,
    color         VARCHAR(30),
    kilometraje   INTEGER      NOT NULL DEFAULT 0,
    id_cliente    INTEGER      NOT NULL,
    CONSTRAINT pk_vehiculo PRIMARY KEY (vin),
    CONSTRAINT uq_vehiculo_placa UNIQUE (placa),
    CONSTRAINT fk_vehiculo_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_vehiculo_vin  CHECK (vin ~ '^[A-HJ-NPR-Z0-9]{17}$'),
    CONSTRAINT ck_vehiculo_anio CHECK (modelo_anio BETWEEN 1950 AND 2100),
    CONSTRAINT ck_vehiculo_km   CHECK (kilometraje >= 0)
);
CREATE INDEX ix_vehiculo_cliente ON vehiculo (id_cliente);

-- ---------------------------------------------------------------------
-- 3. EMPLEADO y su especialización total y disjunta
--    Estrategia: tabla para la superentidad + una tabla por subentidad.
--    El discriminador "tipo" y la FK compuesta (id_empleado, tipo)
--    garantizan que un empleado no pueda estar en dos subtipos (disjunta).
-- ---------------------------------------------------------------------
CREATE TABLE empleado (
    id_empleado       INTEGER GENERATED ALWAYS AS IDENTITY,
    curp              CHAR(18)     NOT NULL,
    nombres           VARCHAR(60)  NOT NULL,
    apellido_paterno  VARCHAR(40)  NOT NULL,
    apellido_materno  VARCHAR(40)  NOT NULL,
    fecha_ingreso     DATE         NOT NULL DEFAULT CURRENT_DATE,
    tipo              VARCHAR(14)  NOT NULL,
    CONSTRAINT pk_empleado PRIMARY KEY (id_empleado),
    CONSTRAINT uq_empleado_curp UNIQUE (curp),
    CONSTRAINT uq_empleado_id_tipo UNIQUE (id_empleado, tipo),
    CONSTRAINT ck_empleado_tipo CHECK (tipo IN ('MECANICO', 'RECEPCIONISTA')),
    CONSTRAINT ck_empleado_curp CHECK (curp ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[A-Z0-9][0-9]$')
);

CREATE TABLE mecanico (
    id_empleado   INTEGER       NOT NULL,
    tipo          VARCHAR(14)   NOT NULL DEFAULT 'MECANICO',
    especialidad  VARCHAR(60)   NOT NULL,
    tarifa_hora   NUMERIC(8,2)  NOT NULL,
    CONSTRAINT pk_mecanico PRIMARY KEY (id_empleado),
    CONSTRAINT fk_mecanico_empleado FOREIGN KEY (id_empleado, tipo)
        REFERENCES empleado (id_empleado, tipo)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_mecanico_tipo   CHECK (tipo = 'MECANICO'),
    CONSTRAINT ck_mecanico_tarifa CHECK (tarifa_hora > 0)
);

CREATE TABLE recepcionista (
    id_empleado      INTEGER      NOT NULL,
    tipo             VARCHAR(14)  NOT NULL DEFAULT 'RECEPCIONISTA',
    turno            VARCHAR(10)  NOT NULL,
    modulo_atencion  VARCHAR(30)  NOT NULL,
    CONSTRAINT pk_recepcionista PRIMARY KEY (id_empleado),
    CONSTRAINT fk_recepcionista_empleado FOREIGN KEY (id_empleado, tipo)
        REFERENCES empleado (id_empleado, tipo)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ck_recepcionista_tipo  CHECK (tipo = 'RECEPCIONISTA'),
    CONSTRAINT ck_recepcionista_turno CHECK (turno IN ('MATUTINO', 'VESPERTINO', 'NOCTURNO'))
);

-- ---------------------------------------------------------------------
-- 4. ORDEN_SERVICIO  (relación GENERA 1:N -> FK en el lado N)
--    "monto_total" es derivado: se calcula en la vista v_orden_monto.
-- ---------------------------------------------------------------------
CREATE TABLE orden_servicio (
    folio_orden          INTEGER GENERATED ALWAYS AS IDENTITY,
    fecha_ingreso        DATE         NOT NULL DEFAULT CURRENT_DATE,
    fecha_entrega_est    DATE,
    diagnostico_inicial  VARCHAR(300),
    estado               VARCHAR(12)  NOT NULL DEFAULT 'RECIBIDO',
    vin                  CHAR(17)     NOT NULL,
    CONSTRAINT pk_orden_servicio PRIMARY KEY (folio_orden),
    CONSTRAINT fk_orden_vehiculo FOREIGN KEY (vin)
        REFERENCES vehiculo (vin)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_orden_estado CHECK (estado IN
        ('RECIBIDO', 'EN_PROCESO', 'TERMINADO', 'ENTREGADO', 'CANCELADO')),
    CONSTRAINT ck_orden_fechas CHECK (fecha_entrega_est IS NULL OR fecha_entrega_est >= fecha_ingreso)
);
CREATE INDEX ix_orden_vin ON orden_servicio (vin);

-- ---------------------------------------------------------------------
-- 5. SERVICIO y relación INCLUYE (M:N con atributo costo_aplicado)
-- ---------------------------------------------------------------------
CREATE TABLE servicio (
    id_servicio      INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre_servicio  VARCHAR(80)   NOT NULL,
    precio_base      NUMERIC(10,2) NOT NULL,
    CONSTRAINT pk_servicio PRIMARY KEY (id_servicio),
    CONSTRAINT uq_servicio_nombre UNIQUE (nombre_servicio),
    CONSTRAINT ck_servicio_precio CHECK (precio_base >= 0)
);

CREATE TABLE servicio_aplicado (
    folio_orden     INTEGER       NOT NULL,
    id_servicio     INTEGER       NOT NULL,
    costo_aplicado  NUMERIC(10,2) NOT NULL,
    CONSTRAINT pk_servicio_aplicado PRIMARY KEY (folio_orden, id_servicio),
    CONSTRAINT fk_sa_orden FOREIGN KEY (folio_orden)
        REFERENCES orden_servicio (folio_orden)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_sa_servicio FOREIGN KEY (id_servicio)
        REFERENCES servicio (id_servicio)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_sa_costo CHECK (costo_aplicado >= 0)
);
CREATE INDEX ix_sa_servicio ON servicio_aplicado (id_servicio);

-- ---------------------------------------------------------------------
-- 6. REFACCION
-- ---------------------------------------------------------------------
CREATE TABLE refaccion (
    codigo_refaccion  VARCHAR(20)   NOT NULL,
    nombre_pieza      VARCHAR(80)   NOT NULL,
    marca_pieza       VARCHAR(40),
    precio_unitario   NUMERIC(10,2) NOT NULL,
    stock_actual      INTEGER       NOT NULL DEFAULT 0,
    CONSTRAINT pk_refaccion PRIMARY KEY (codigo_refaccion),
    CONSTRAINT ck_refaccion_precio CHECK (precio_unitario >= 0),
    CONSTRAINT ck_refaccion_stock  CHECK (stock_actual >= 0)
);

-- ---------------------------------------------------------------------
-- 7. ASIGNACION_TRABAJO  (relación ASIGNA M:N: orden - mecánico)
--    Es la relación que el E-RE agrega como entidad de nivel superior.
-- ---------------------------------------------------------------------
CREATE TABLE asignacion_trabajo (
    folio_orden       INTEGER       NOT NULL,
    id_mecanico       INTEGER       NOT NULL,
    horas_trabajadas  NUMERIC(5,2)  NOT NULL DEFAULT 0,
    fecha_asignacion  DATE          NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT pk_asignacion_trabajo PRIMARY KEY (folio_orden, id_mecanico),
    CONSTRAINT fk_asig_orden FOREIGN KEY (folio_orden)
        REFERENCES orden_servicio (folio_orden)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_asig_mecanico FOREIGN KEY (id_mecanico)
        REFERENCES mecanico (id_empleado)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_asig_horas CHECK (horas_trabajadas >= 0)
);
CREATE INDEX ix_asig_mecanico ON asignacion_trabajo (id_mecanico);

-- ---------------------------------------------------------------------
-- 8. USO_REFACCION  (relación UTILIZA M:N: asignación - refacción)
--    La FK compuesta apunta a la agregación completa (orden + mecánico).
-- ---------------------------------------------------------------------
CREATE TABLE uso_refaccion (
    folio_orden       INTEGER      NOT NULL,
    id_mecanico       INTEGER      NOT NULL,
    codigo_refaccion  VARCHAR(20)  NOT NULL,
    cantidad_usada    INTEGER      NOT NULL,
    CONSTRAINT pk_uso_refaccion PRIMARY KEY (folio_orden, id_mecanico, codigo_refaccion),
    CONSTRAINT fk_uso_asignacion FOREIGN KEY (folio_orden, id_mecanico)
        REFERENCES asignacion_trabajo (folio_orden, id_mecanico)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_uso_refaccion FOREIGN KEY (codigo_refaccion)
        REFERENCES refaccion (codigo_refaccion)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_uso_cantidad CHECK (cantidad_usada > 0)
);
CREATE INDEX ix_uso_refaccion ON uso_refaccion (codigo_refaccion);

-- ---------------------------------------------------------------------
-- 9. VISTAS para los atributos derivados (no se almacenan en tablas)
-- ---------------------------------------------------------------------
CREATE VIEW v_vehiculo AS
SELECT v.*,
       (EXTRACT(YEAR FROM CURRENT_DATE)::INT - v.modelo_anio) AS antiguedad_anios
FROM vehiculo v;

CREATE VIEW v_orden_monto AS
SELECT o.folio_orden,
       COALESCE(s.total_servicios, 0)    AS total_servicios,
       COALESCE(r.total_refacciones, 0)  AS total_refacciones,
       COALESCE(m.total_mano_obra, 0)    AS total_mano_obra,
       COALESCE(s.total_servicios, 0) + COALESCE(r.total_refacciones, 0)
         + COALESCE(m.total_mano_obra, 0) AS monto_total
FROM orden_servicio o
LEFT JOIN (SELECT folio_orden, SUM(costo_aplicado) AS total_servicios
           FROM servicio_aplicado GROUP BY folio_orden) s ON s.folio_orden = o.folio_orden
LEFT JOIN (SELECT u.folio_orden, SUM(u.cantidad_usada * f.precio_unitario) AS total_refacciones
           FROM uso_refaccion u JOIN refaccion f USING (codigo_refaccion)
           GROUP BY u.folio_orden) r ON r.folio_orden = o.folio_orden
LEFT JOIN (SELECT a.folio_orden, SUM(a.horas_trabajadas * m.tarifa_hora) AS total_mano_obra
           FROM asignacion_trabajo a JOIN mecanico m ON m.id_empleado = a.id_mecanico
           GROUP BY a.folio_orden) m ON m.folio_orden = o.folio_orden;
