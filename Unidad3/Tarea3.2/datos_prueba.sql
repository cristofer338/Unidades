-- Datos de prueba (Tarea 3.2) · ejecutar después de schema.sql
SET search_path TO taller;

INSERT INTO cliente (nombres, apellido_paterno, apellido_materno, calle, colonia, cp, correo) VALUES
 ('Juan Carlos', 'Gómez', 'Ramírez', 'Blvd. Harold R. Pape 1200', 'Centro', '25700', 'juan.gomez@correo.com'),
 ('María Fernanda', 'López', 'Treviño', 'Calle Hidalgo 345', 'Guadalupe', '25750', NULL);

INSERT INTO cliente_telefono VALUES (1, '8661234567'), (1, '8669876543'), (2, '8661112233');

INSERT INTO vehiculo (vin, placa, marca, modelo_anio, color, kilometraje, id_cliente) VALUES
 ('1HGCM82633A004352', 'ABC-123-A', 'Honda',  2018, 'Gris',  85000, 1),
 ('3FADP4BJ5BM123456', 'XYZ-987-B', 'Ford',   2011, 'Rojo', 142000, 1),
 ('1N4AL3AP8JC231234', 'MTY-456-C', 'Nissan', 2020, 'Blanco', 41000, 2);

INSERT INTO empleado (curp, nombres, apellido_paterno, apellido_materno, fecha_ingreso, tipo) VALUES
 ('GOMR900512HCLMRN08', 'Roberto',  'Gómez',   'Martínez', '2019-03-15', 'MECANICO'),
 ('HERL850223HCLRPS04', 'Luis',     'Hernández','Pérez',   '2021-07-01', 'MECANICO'),
 ('TRVA950830MCLLRN02', 'Ana',      'Treviño', 'Salas',    '2022-01-10', 'RECEPCIONISTA');

INSERT INTO mecanico (id_empleado, especialidad, tarifa_hora) VALUES
 (1, 'Motor y transmisión', 250.00), (2, 'Frenos y suspensión', 220.00);
INSERT INTO recepcionista (id_empleado, turno, modulo_atencion) VALUES (3, 'MATUTINO', 'Mostrador 1');

INSERT INTO servicio (nombre_servicio, precio_base) VALUES
 ('Afinación mayor', 1200.00), ('Cambio de frenos', 900.00), ('Cambio de aceite', 450.00);

INSERT INTO refaccion VALUES
 ('BAL-DEL-001', 'Balatas delanteras', 'Fritec', 480.00, 20),
 ('ACE-5W30-4L', 'Aceite sintético 5W30 4L', 'Mobil', 650.00, 15),
 ('FIL-ACE-014', 'Filtro de aceite', 'Gonher', 120.00, 40);

INSERT INTO orden_servicio (fecha_ingreso, fecha_entrega_est, diagnostico_inicial, estado, vin) VALUES
 ('2026-10-20', '2026-10-22', 'Ruido al frenar', 'EN_PROCESO', '1HGCM82633A004352'),
 ('2026-10-21', '2026-10-21', 'Servicio preventivo', 'TERMINADO', '1N4AL3AP8JC231234');

INSERT INTO servicio_aplicado VALUES (1, 2, 900.00), (2, 3, 450.00);
INSERT INTO asignacion_trabajo (folio_orden, id_mecanico, horas_trabajadas, fecha_asignacion) VALUES
 (1, 2, 2.5, '2026-10-20'), (2, 1, 1.0, '2026-10-21');
INSERT INTO uso_refaccion VALUES
 (1, 2, 'BAL-DEL-001', 1), (2, 1, 'ACE-5W30-4L', 1), (2, 1, 'FIL-ACE-014', 1);
