# Tarea 3.2: Esquema físico en SGBD y script LDD

**Caso:** Taller Mecánico y Refaccionaria "El Motor"
**Tec Monclova · Ingeniería en Sistemas Computacionales**
**Unidad 3:** Modelo relacional

**Alumno:** Cristofer Alejandro Barboza Chávez
**No. de control:** I24050398

---

## Enlaces

- 🎥 **Video en YouTube:** [pegar enlace del video]
- 📄 **Reporte técnico (PDF):** [Reporte_Tarea_3_2_Esquema_Fisico_SQL.pdf](Reporte_Tarea_3_2_Esquema_Fisico_SQL.pdf)
- 🗄️ **Script DDL:** [schema.sql](schema.sql)
- 🧪 **Datos de prueba:** [datos_prueba.sql](datos_prueba.sql)
- ✅ **Pruebas de integridad:** [pruebas_integridad.sql](pruebas_integridad.sql)
- 🖼️ **Diagrama del esquema físico (PNG):** [esquema_fisico.png](esquema_fisico.png)
- 📑 **Diagrama del esquema físico (PDF):** [esquema_fisico.pdf](esquema_fisico.pdf)
- 🧾 **Salida de las pruebas de integridad:** [evidencia_pruebas.txt](evidencia_pruebas.txt)

---

## Requisitos

- PostgreSQL 14 o superior (probado en 16)
- Cliente `psql`, pgAdmin o DBeaver

## Cómo ejecutar

```bash
createdb -U postgres taller_el_motor
psql -U postgres -d taller_el_motor -f schema.sql
psql -U postgres -d taller_el_motor -f datos_prueba.sql
psql -U postgres -d taller_el_motor -f pruebas_integridad.sql
```

`schema.sql` es idempotente: elimina y recrea el esquema `taller`.

## Contenido del esquema

- 12 tablas, 2 vistas (`v_vehiculo`, `v_orden_monto`) y 5 índices adicionales
- 11 llaves foráneas con `ON UPDATE CASCADE` y `ON DELETE` `CASCADE` o `RESTRICT` según la regla de negocio
- 20 restricciones `CHECK`, además de `NOT NULL`, `UNIQUE` y `DEFAULT`

## Herramientas

- PostgreSQL 16
- OBS Studio para el video
