# Tarea 3.1: Transformación de Modelo E-R a Esquema Relacional

**Caso:** Taller Mecánico y Refaccionaria "El Motor"
**Tec Monclova · Ingeniería en Sistemas Computacionales**
**Unidad 3:** Modelo relacional

**Alumno:** Cristofer Alejandro Barboza Chávez
**No. de control:** I24050398

---

## Enlaces

- 🎥 **Video en YouTube:** [pegar enlace del video]
- 📄 **Reporte técnico (PDF):** [Reporte_Tarea_3_1_Esquema_Relacional.pdf](Reporte_Tarea_3_1_Esquema_Relacional.pdf)
- 📚 **Documentación del esquema relacional:** [esquema_relacional.md](esquema_relacional.md)
- 🖼️ **Diagrama del esquema relacional (PNG):** [esquema_relacional.png](esquema_relacional.png)
- 📑 **Diagrama del esquema relacional (PDF):** [esquema_relacional.pdf](esquema_relacional.pdf)
- 🧩 **Fuente editable del diagrama (Graphviz):** [esquema_relacional.dot](esquema_relacional.dot)
- ⬅️ **Tareas de la Unidad 2 (E-R y UML):** [pegar enlace a la carpeta de la unidad 2]

---

## Descripción

Transformación del diagrama E-R / E-RE del taller a 12 relaciones, aplicando las reglas de conversión: entidades fuertes, atributos compuestos (aplanados), multivalorado (nueva relación), relaciones 1:N (propagación de llave), M:N (relaciones con PK compuesta), jerarquía (tabla por subtipo) y agregación.

## Tablas resultantes

| Tabla | Proviene de |
|---|---|
| `cliente` | CLIENTE |
| `cliente_telefono` | atributo multivalorado `telefonos` |
| `vehiculo` | VEHICULO + POSEE (1:N) |
| `orden_servicio` | ORDEN_SERVICIO + GENERA (1:N) |
| `servicio` | SERVICIO |
| `servicio_aplicado` | INCLUYE (M:N) |
| `refaccion` | REFACCION |
| `empleado`, `mecanico`, `recepcionista` | jerarquía EMPLEADO |
| `asignacion_trabajo` | ASIGNA (M:N, agregación) |
| `uso_refaccion` | UTILIZA (M:N sobre la agregación) |

## Herramientas

- Graphviz para el diagrama
- OBS Studio para el video
