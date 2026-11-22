# Tarea 2.1: Modelado conceptual E-R y E-R Extendido

**Caso:** Taller Mecánico y Refaccionaria "El Motor"
**Tec Monclova · Ingeniería en Sistemas Computacionales**
**Unidad 2:** Diseño de Bases de Datos con el modelo E-R

**Alumno:** Cristofer Alejandro Barboza Chávez
**No. de control:** I24050398

---

## Enlaces

- 🎥 **Video en YouTube:** [pegar enlace del video]
- 📄 **Reporte técnico (PDF):** [Reporte_Tecnico_Tarea_2_1_ER-v3.pdf](Reporte_Tecnico_Tarea_2_1_ER-v3.pdf)
- 🧩 **Archivo fuente del diagrama (draw.io):** [diagrama_ER_ElMotor.drawio](diagrama_ER_ElMotor.drawio)
- 🖼️ **Diagrama en imagen:** [diagrama_ER_ElMotor.png](diagrama_ER_ElMotor.png)
- 📑 **Diagrama en PDF:** [diagrama_ER_ElMotor.pdf](diagrama_ER_ElMotor.pdf)

---

## Descripción

El taller "El Motor" (Monclova, Coahuila) lleva el control de clientes, vehículos, órdenes de servicio, personal y refacciones en libretas y hojas sueltas. Este proyecto propone el diseño conceptual de la base de datos con el modelo Entidad-Relación y Entidad-Relación Extendido (especialización y agregación).

## Resumen del modelo (notación UML)

Resumen en UML (diagrama de clases con Mermaid, que GitHub muestra automáticamente). El diagrama E-R formal está en el archivo `.drawio` y en el reporte.

```mermaid
classDiagram
    class CLIENTE {
        +id_cliente PK
        +nombre_completo
        +direccion
        +telefonos[1..*]
        +correo
    }
    class VEHICULO {
        +vin PK
        +placa
        +marca
        +modelo_anio
        +color
        +kilometraje
        +/antiguedad_anios
    }
    class ORDEN_SERVICIO {
        +folio_orden PK
        +fecha_ingreso
        +fecha_entrega_est
        +diagnostico_inicial
        +estado
        +/monto_total
    }
    class SERVICIO {
        +id_servicio PK
        +nombre_servicio
        +precio_base
    }
    class REFACCION {
        +codigo_refaccion PK
        +nombre_pieza
        +marca_pieza
        +precio_unitario
        +stock_actual
    }
    class EMPLEADO {
        +id_empleado PK
        +curp
        +nombre_completo
        +fecha_ingreso
    }
    class MECANICO {
        +especialidad
        +tarifa_hora
    }
    class RECEPCIONISTA {
        +turno
        +modulo_atencion
    }
    class ASIGNACION_TRABAJO {
        +horas_trabajadas
        +fecha_asignacion
    }

    CLIENTE "1" -- "1..*" VEHICULO : posee
    VEHICULO "1" -- "0..*" ORDEN_SERVICIO : genera
    ORDEN_SERVICIO "*" -- "1..*" SERVICIO : incluye
    ORDEN_SERVICIO "1..*" -- "*" MECANICO : asigna
    ASIGNACION_TRABAJO "*" -- "*" REFACCION : utiliza
    ORDEN_SERVICIO .. ASIGNACION_TRABAJO
    MECANICO .. ASIGNACION_TRABAJO
    EMPLEADO <|-- MECANICO
    EMPLEADO <|-- RECEPCIONISTA
```

## Conceptos del E-R extendido aplicados

- **Especialización:** EMPLEADO → MECANICO, RECEPCIONISTA (total y disjunta).
- **Agregación:** la asignación orden–mecánico se relaciona con REFACCION.
- **Atributos:** claves, compuestos, multivalorados y derivados.
- **Participación:** total y parcial.

## Herramientas

- draw.io (diagrams.net) como herramienta CASE
- OBS Studio para el video
