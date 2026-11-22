-- Pruebas de reglas de integridad (Tarea 3.2). Cada sentencia marcada ERROR debe fallar.
SET search_path TO taller;
\echo '--- 1. Integridad de entidad: PK duplicada'
INSERT INTO servicio_aplicado VALUES (1, 2, 100.00);
\echo '--- 2. Integridad referencial: vehiculo con cliente inexistente'
INSERT INTO vehiculo VALUES ('2T1BURHE0JC034567','QQQ-111-D','Toyota',2019,'Azul',1000,99);
\echo '--- 3. Dominio: stock negativo'
INSERT INTO refaccion VALUES ('TEST-NEG', 'Pieza prueba', 'X', 10.00, -5);
\echo '--- 4. Dominio: estado de orden no permitido'
INSERT INTO orden_servicio (estado, vin) VALUES ('PAUSADA', '1HGCM82633A004352');
\echo '--- 5. Dominio: VIN con longitud incorrecta'
INSERT INTO vehiculo VALUES ('ABC123','QQQ-222-D','Toyota',2019,'Azul',1000,1);
\echo '--- 6. Jerarquia disjunta: empleado mecanico no puede ser tambien recepcionista'
INSERT INTO recepcionista (id_empleado, turno, modulo_atencion) VALUES (1, 'VESPERTINO', 'Mostrador 2');
\echo '--- 7. NOT NULL: cliente sin apellido paterno'
INSERT INTO cliente (nombres, apellido_paterno, apellido_materno, calle, colonia, cp) VALUES ('Pedro', NULL, 'Ruiz', 'Calle 1', 'Centro', '25700');
\echo '--- 8. ON DELETE RESTRICT: borrar cliente con vehiculos'
DELETE FROM cliente WHERE id_cliente = 1;
\echo '--- 9. ON UPDATE CASCADE: cambiar VIN se propaga a la orden'
UPDATE vehiculo SET vin = '1HGCM82633A004999' WHERE vin = '1HGCM82633A004352';
SELECT folio_orden, vin FROM orden_servicio ORDER BY folio_orden;
\echo '--- 10. ON DELETE CASCADE: borrar orden 2 elimina sus servicios, asignaciones y usos'
DELETE FROM orden_servicio WHERE folio_orden = 2;
SELECT (SELECT count(*) FROM servicio_aplicado WHERE folio_orden=2) AS servicios,
       (SELECT count(*) FROM asignacion_trabajo WHERE folio_orden=2) AS asignaciones,
       (SELECT count(*) FROM uso_refaccion      WHERE folio_orden=2) AS usos;
\echo '--- 11. Atributos derivados (vistas)'
SELECT vin, modelo_anio, antiguedad_anios FROM v_vehiculo ORDER BY vin;
SELECT * FROM v_orden_monto ORDER BY folio_orden;
