-- ============================================================================
-- Unidad 6 - Tarea 6.2: Carga de Datos de Prueba (DML - INSERT) en SQL Server
-- Caso de estudio: Taller Mecánico y Refaccionaria "El Motor"
-- ============================================================================

USE taller_el_motor;
GO

BEGIN TRANSACTION;

-- 1. Clientes (6 registros; el 6to no tendrá vehículos para probar LEFT JOIN)
INSERT INTO dbo.clientes (nombre_completo, telefono, correo, rfc, fecha_registro, activo)
VALUES
    ('Carlos Mendoza Ríos',     '866-120-4410', 'cmendoza@correo.mx',   'MERC880412H21', '2025-09-10', 1),
    ('Sofía Alejandra Garza',   '866-145-8923', 'sgarza@correo.mx',     'GARS921105M45', '2025-10-02', 1),
    ('Roberto Valdez Treviño',  '866-198-3301', 'rvaldez@correo.mx',    'VATR800719H12', '2025-11-15', 1),
    ('Mariana López Calderón',  '866-210-7745', 'mlopez@correo.mx',     'LOCM950328M88', '2026-01-08', 1),
    ('Javier Alonso Domínguez', '866-254-6190', 'jdominguez@correo.mx', 'AODJ771201H09', '2026-02-14', 1),
    ('Lucía Fernanda Ortiz',    '866-301-9082', 'lortiz@correo.mx',     'OIFL990617M33', '2026-03-01', 1);

-- 2. Vehículos (6 registros asociados a los primeros 5 clientes)
INSERT INTO dbo.vehiculos (id_cliente, marca, modelo, anio, placas, num_serie, kilometraje)
VALUES
    (1, 'Nissan',     'Versa',   2020, 'FGH-102-A', '3N1CN8AE5ZL100011',  68500),
    (1, 'Chevrolet',  'Aveo',    2018, 'FGH-103-A', '3G1TA5AF5JL100022',  94200),
    (2, 'Toyota',     'Corolla', 2022, 'FJK-441-B', '2T1BURHE0NC100033',  41300),
    (3, 'Ford',       'Ranger',  2019, 'FLM-809-C', '1FTER4EH1KLA100044', 112800),
    (4, 'Mazda',      'Mazda3',  2021, 'FNP-219-D', '3MZBPBLM8MM100055',  53600),
    (5, 'Volkswagen', 'Jetta',   2017, 'FQR-674-E', '3VW2B7AJ9HM100066', 128400);

-- 3. Refacciones (7 piezas de refaccionaria)
INSERT INTO dbo.refacciones (codigo_sku, nombre_pieza, categoria, precio_unitario, stock_actual, stock_minimo)
VALUES
    ('REF-ACE-001', 'Aceite Sintético 5W-30 (4L)',    'Lubricantes', 680.00,  24, 6),
    ('REF-FIL-002', 'Filtro de Aceite Motor',         'Filtros',     165.00,  30, 8),
    ('REF-BAL-003', 'Balatas Delanteras Cerámicas',   'Frenos',      890.00,  12, 5),
    ('REF-BUJ-004', 'Juego de Bujías Iridium (4 pz)', 'Encendido',   740.00,  15, 4),
    ('REF-BAT-005', 'Batería 12V 650 CCA',            'Eléctrico',  2350.00,   7, 3),
    ('REF-AMO-006', 'Amortiguador Delantero Gas',     'Suspensión', 1480.00,   4, 4),
    ('REF-COR-007', 'Banda de Distribución / Tiempo', 'Motor',       960.00,   9, 3);

-- 4. Órdenes de servicio (6 órdenes en distintos estados)
INSERT INTO dbo.ordenes_servicio (id_vehiculo, fecha_ingreso, fecha_entrega, diagnostico, mano_de_obra, estado)
VALUES
    (1, '2026-10-05T09:00:00', '2026-10-05T15:30:00', 'Afinación mayor y cambio de aceite',           950.00,  'ENTREGADA'),
    (2, '2026-10-12T10:15:00', '2026-10-12T17:00:00', 'Reemplazo de balatas delanteras y purgado',   750.00,  'ENTREGADA'),
    (3, '2026-10-20T08:30:00', '2026-10-20T13:00:00', 'Cambio de aceite y filtro preventivo',         500.00,  'ENTREGADA'),
    (4, '2026-11-02T11:00:00', NULL,                  'Revisión de suspensión y batería descargada', 1200.00, 'EN_PROCESO'),
    (5, '2026-11-10T09:45:00', '2026-11-11T16:00:00', 'Cambio de bujías y banda de distribución',    1650.00, 'ENTREGADA'),
    (6, '2026-11-18T14:20:00', NULL,                  'Diagnóstico general de motor y frenos',        850.00,  'ABIERTA');

-- 5. Detalle de refacciones por orden (N:M)
INSERT INTO dbo.detalle_orden_refacciones (id_orden, id_refaccion, cantidad, precio_unitario)
VALUES
    (1, 1, 1,  680.00),
    (1, 2, 1,  165.00),
    (1, 4, 1,  740.00),
    (2, 3, 1,  890.00),
    (3, 1, 1,  680.00),
    (3, 2, 1,  165.00),
    (4, 5, 1, 2350.00),
    (4, 6, 2, 1480.00),
    (5, 4, 1,  740.00),
    (5, 7, 1,  960.00);

COMMIT TRANSACTION;
GO
