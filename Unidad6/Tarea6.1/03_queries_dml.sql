-- ============================================================================
-- Unidad 6 - Tarea 6.2: Consultas DML y Pruebas de Mantenimiento (SQL Server)
-- Caso de estudio: Taller Mecánico y Refaccionaria "El Motor"
-- ============================================================================

USE taller_el_motor;
GO

-- ----------------------------------------------------------------------------
-- A. CONSULTAS SELECT BÁSICAS CON WHERE Y ORDER BY
-- 1) Refacciones con precio unitario >= $700, ordenadas de mayor a menor precio
-- ----------------------------------------------------------------------------
SELECT
    codigo_sku,
    nombre_pieza,
    categoria,
    precio_unitario,
    stock_actual
FROM dbo.refacciones
WHERE precio_unitario >= 700.00
ORDER BY precio_unitario DESC, nombre_pieza ASC;
GO

-- 2) Vehículos con más de 60,000 km
SELECT
    id_vehiculo,
    marca,
    modelo,
    anio,
    placas,
    kilometraje
FROM dbo.vehiculos
WHERE kilometraje > 60000
ORDER BY kilometraje DESC;
GO

-- ----------------------------------------------------------------------------
-- B. FUNCIONES DE AGREGACIÓN (COUNT, SUM, AVG, MIN, MAX)
-- ----------------------------------------------------------------------------
SELECT
    COUNT(*)                              AS total_refacciones,
    SUM(stock_actual)                     AS unidades_totales_stock,
    CAST(AVG(precio_unitario) AS DECIMAL(10, 2)) AS precio_promedio,
    MIN(precio_unitario)                  AS precio_minimo,
    MAX(precio_unitario)                  AS precio_maximo
FROM dbo.refacciones;
GO

-- ----------------------------------------------------------------------------
-- C. AGRUPACIÓN CON GROUP BY Y FILTRO DE GRUPOS CON HAVING
-- ----------------------------------------------------------------------------
SELECT
    estado,
    COUNT(*)                                   AS cantidad_ordenes,
    SUM(mano_de_obra)                          AS total_mano_obra,
    CAST(AVG(mano_de_obra) AS DECIMAL(10, 2))  AS promedio_mano_obra
FROM dbo.ordenes_servicio
GROUP BY estado
HAVING SUM(mano_de_obra) >= 1000.00
ORDER BY total_mano_obra DESC;
GO

-- ----------------------------------------------------------------------------
-- D. REUNIONES ENTRE TABLAS: INNER JOIN Y LEFT JOIN
-- 1) INNER JOIN (y LEFT JOIN en detalle) para total de órdenes con cliente y vehículo
-- ----------------------------------------------------------------------------
SELECT
    o.id_orden,
    c.nombre_completo AS cliente,
    v.marca + ' ' + v.modelo + ' (' + CAST(v.anio AS VARCHAR(4)) + ')' AS vehiculo,
    v.placas,
    o.estado,
    o.mano_de_obra,
    COALESCE(SUM(d.cantidad * d.precio_unitario), 0.00) AS total_refacciones,
    o.mano_de_obra + COALESCE(SUM(d.cantidad * d.precio_unitario), 0.00) AS total_orden
FROM dbo.ordenes_servicio o
INNER JOIN dbo.vehiculos v ON o.id_vehiculo = v.id_vehiculo
INNER JOIN dbo.clientes c  ON v.id_cliente  = c.id_cliente
LEFT JOIN dbo.detalle_orden_refacciones d ON o.id_orden = d.id_orden
GROUP BY
    o.id_orden,
    c.nombre_completo,
    v.marca,
    v.modelo,
    v.anio,
    v.placas,
    o.estado,
    o.mano_de_obra
ORDER BY o.id_orden;
GO

-- 2) LEFT JOIN: Todos los clientes y sus vehículos (incluye Lucía sin vehículos)
SELECT
    c.id_cliente,
    c.nombre_completo,
    c.telefono,
    v.id_vehiculo,
    v.marca,
    v.modelo,
    v.placas
FROM dbo.clientes c
LEFT JOIN dbo.vehiculos v ON c.id_cliente = v.id_cliente
ORDER BY c.id_cliente, v.id_vehiculo;
GO

-- ----------------------------------------------------------------------------
-- E. PRUEBAS CONTROLADAS DE MANTENIMIENTO: UPDATE Y DELETE + INTEGRIDAD
-- ----------------------------------------------------------------------------

-- Prueba 1 (UPDATE válido): Actualizar orden #6 y ver resultado con OUTPUT
BEGIN TRANSACTION;
UPDATE dbo.ordenes_servicio
SET estado = 'ENTREGADA',
    fecha_entrega = SYSDATETIME(),
    mano_de_obra = 950.00
OUTPUT inserted.id_orden, inserted.id_vehiculo, inserted.estado, inserted.mano_de_obra, inserted.fecha_entrega
WHERE id_orden = 6;
ROLLBACK TRANSACTION;
GO

-- Prueba 2 (UPDATE que viola restricción CHECK): Precio negativo
BEGIN TRANSACTION;
BEGIN TRY
    UPDATE dbo.refacciones
    SET precio_unitario = -50.00
    WHERE id_refaccion = 1;
END TRY
BEGIN CATCH
    SELECT
        ERROR_NUMBER()  AS numero_error,
        ERROR_MESSAGE() AS mensaje_error;
END CATCH;
ROLLBACK TRANSACTION;
GO

-- Prueba 3 (DELETE bloqueado por integridad referencial FK):
-- Intentar borrar al cliente #1 que tiene vehículos asociados
BEGIN TRANSACTION;
BEGIN TRY
    DELETE FROM dbo.clientes
    WHERE id_cliente = 1;
END TRY
BEGIN CATCH
    SELECT
        ERROR_NUMBER()  AS numero_error,
        ERROR_MESSAGE() AS mensaje_error;
END CATCH;
ROLLBACK TRANSACTION;
GO

-- Prueba 4 (DELETE válido sobre registro sin dependencias):
BEGIN TRANSACTION;
INSERT INTO dbo.clientes (nombre_completo, telefono, correo, rfc)
OUTPUT inserted.id_cliente, inserted.nombre_completo
VALUES ('Cliente Temporal Prueba', '866-000-0000', 'temp@correo.mx', 'TEMP900101X00');

DELETE FROM dbo.clientes
OUTPUT deleted.id_cliente, deleted.nombre_completo
WHERE correo = 'temp@correo.mx';
COMMIT TRANSACTION;
GO
