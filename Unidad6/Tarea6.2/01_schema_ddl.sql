-- ============================================================================
-- Unidad 6 - Tarea 6.2: Definición de Esquema (DDL) en SQL Server (T-SQL)
-- Caso de estudio: Taller Mecánico y Refaccionaria "El Motor"
-- ============================================================================

IF DB_ID(N'taller_el_motor') IS NULL
BEGIN
    CREATE DATABASE taller_el_motor;
END
GO

USE taller_el_motor;
GO

-- Limpieza previa segura si se re-ejecuta el script
IF OBJECT_ID(N'dbo.detalle_orden_refacciones', N'U') IS NOT NULL
    DROP TABLE dbo.detalle_orden_refacciones;
IF OBJECT_ID(N'dbo.ordenes_servicio', N'U') IS NOT NULL
    DROP TABLE dbo.ordenes_servicio;
IF OBJECT_ID(N'dbo.refacciones', N'U') IS NOT NULL
    DROP TABLE dbo.refacciones;
IF OBJECT_ID(N'dbo.vehiculos', N'U') IS NOT NULL
    DROP TABLE dbo.vehiculos;
IF OBJECT_ID(N'dbo.clientes', N'U') IS NOT NULL
    DROP TABLE dbo.clientes;
GO

-- 1. Tabla: clientes
CREATE TABLE dbo.clientes (
    id_cliente      INT IDENTITY(1,1) NOT NULL,
    nombre_completo VARCHAR(120)      NOT NULL,
    telefono        VARCHAR(20)       NOT NULL,
    correo          VARCHAR(120)      NULL,
    rfc             VARCHAR(13)       NULL,
    fecha_registro  DATE              NOT NULL CONSTRAINT df_clientes_fecha DEFAULT (CAST(GETDATE() AS DATE)),
    activo          BIT               NOT NULL CONSTRAINT df_clientes_activo DEFAULT (1),
    CONSTRAINT pk_clientes PRIMARY KEY (id_cliente),
    CONSTRAINT uq_clientes_correo UNIQUE (correo),
    CONSTRAINT uq_clientes_rfc UNIQUE (rfc),
    CONSTRAINT chk_cliente_nombre_no_vacio CHECK (LEN(LTRIM(RTRIM(nombre_completo))) > 0)
);
GO

-- 2. Tabla: vehiculos
CREATE TABLE dbo.vehiculos (
    id_vehiculo  INT IDENTITY(1,1) NOT NULL,
    id_cliente   INT               NOT NULL,
    marca        VARCHAR(50)       NOT NULL,
    modelo       VARCHAR(50)       NOT NULL,
    anio         INT               NOT NULL,
    placas       VARCHAR(15)       NOT NULL,
    num_serie    VARCHAR(25)       NULL,
    kilometraje  INT               NOT NULL CONSTRAINT df_vehiculos_km DEFAULT (0),
    CONSTRAINT pk_vehiculos PRIMARY KEY (id_vehiculo),
    CONSTRAINT uq_vehiculos_placas UNIQUE (placas),
    CONSTRAINT uq_vehiculos_num_serie UNIQUE (num_serie),
    CONSTRAINT fk_vehiculos_cliente FOREIGN KEY (id_cliente)
        REFERENCES dbo.clientes (id_cliente)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT chk_vehiculos_anio CHECK (anio BETWEEN 1970 AND 2027),
    CONSTRAINT chk_vehiculos_km CHECK (kilometraje >= 0)
);
GO

-- 3. Tabla: refacciones
CREATE TABLE dbo.refacciones (
    id_refaccion    INT IDENTITY(1,1) NOT NULL,
    codigo_sku      VARCHAR(30)       NOT NULL,
    nombre_pieza    VARCHAR(120)      NOT NULL,
    categoria       VARCHAR(50)       NOT NULL,
    precio_unitario DECIMAL(10, 2)    NOT NULL,
    stock_actual    INT               NOT NULL CONSTRAINT df_refacciones_stock DEFAULT (0),
    stock_minimo    INT               NOT NULL CONSTRAINT df_refacciones_min DEFAULT (5),
    CONSTRAINT pk_refacciones PRIMARY KEY (id_refaccion),
    CONSTRAINT uq_refacciones_sku UNIQUE (codigo_sku),
    CONSTRAINT chk_refacciones_precio CHECK (precio_unitario >= 0),
    CONSTRAINT chk_refacciones_stock CHECK (stock_actual >= 0),
    CONSTRAINT chk_refacciones_min CHECK (stock_minimo >= 0)
);
GO

-- 4. Tabla: ordenes_servicio
CREATE TABLE dbo.ordenes_servicio (
    id_orden      INT IDENTITY(1,1) NOT NULL,
    id_vehiculo   INT               NOT NULL,
    fecha_ingreso DATETIME2(0)      NOT NULL CONSTRAINT df_ordenes_ingreso DEFAULT (SYSDATETIME()),
    fecha_entrega DATETIME2(0)      NULL,
    diagnostico   VARCHAR(500)      NOT NULL,
    mano_de_obra  DECIMAL(10, 2)    NOT NULL CONSTRAINT df_ordenes_mano_obra DEFAULT (0.00),
    estado        VARCHAR(20)       NOT NULL CONSTRAINT df_ordenes_estado DEFAULT ('ABIERTA'),
    CONSTRAINT pk_ordenes_servicio PRIMARY KEY (id_orden),
    CONSTRAINT fk_ordenes_vehiculo FOREIGN KEY (id_vehiculo)
        REFERENCES dbo.vehiculos (id_vehiculo)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT chk_ordenes_mano_obra CHECK (mano_de_obra >= 0),
    CONSTRAINT chk_ordenes_estado CHECK (estado IN ('ABIERTA', 'EN_PROCESO', 'ENTREGADA', 'CANCELADA')),
    CONSTRAINT chk_ordenes_fechas CHECK (fecha_entrega IS NULL OR fecha_entrega >= fecha_ingreso)
);
GO

-- 5. Tabla: detalle_orden_refacciones (relación N:M entre órdenes y refacciones)
CREATE TABLE dbo.detalle_orden_refacciones (
    id_orden        INT            NOT NULL,
    id_refaccion    INT            NOT NULL,
    cantidad        INT            NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_detalle_orden_refacciones PRIMARY KEY (id_orden, id_refaccion),
    CONSTRAINT fk_detalle_orden FOREIGN KEY (id_orden)
        REFERENCES dbo.ordenes_servicio (id_orden)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_detalle_refaccion FOREIGN KEY (id_refaccion)
        REFERENCES dbo.refacciones (id_refaccion)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT chk_detalle_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_detalle_precio CHECK (precio_unitario >= 0)
);
GO

-- Índices auxiliares para búsquedas frecuentes
CREATE INDEX idx_vehiculos_id_cliente ON dbo.vehiculos (id_cliente);
CREATE INDEX idx_ordenes_id_vehiculo ON dbo.ordenes_servicio (id_vehiculo);
CREATE INDEX idx_ordenes_estado ON dbo.ordenes_servicio (estado);
GO
