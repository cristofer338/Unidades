# Proyecto Integrador de Bases de Datos — Unidad 5
**Tema:** Álgebra Relacional  
**Caso de Estudio:** Taller Mecánico y Refaccionaria "El Motor"

## Datos Institucionales
* **Alumno:** Cristofer Alejandro Barboza Chávez
* **Matrícula:** 124050398
* **Carrera:** Ingeniería en Sistemas Computacionales
* **Institución:** Instituto Tecnológico de Monclova
* **Materia:** Taller de Bases de Datos

---

## Estructura de la Entrega

```text
.
├── README_General.md
├── README_5.1.md
├── README_5.2.md
└── relax/
    └── taller_el_motor_relax.txt
```

---

## Esquema Relacional Base en UML / ERD (12 Tablas)

```mermaid
erDiagram
    CLIENTE ||--o{ CLIENTE_TELEFONO : posee
    CLIENTE ||--o{ VEHICULO : posee
    VEHICULO ||--o{ ORDEN_SERVICIO : recibe
    ORDEN_SERVICIO ||--o{ SERVICIO_APLICADO : incluye
    SERVICIO ||--o{ SERVICIO_APLICADO : se_aplica_en
    EMPLEADO ||--|| MECANICO : es_un
    EMPLEADO ||--|| RECEPCIONISTA : es_un
    ORDEN_SERVICIO ||--o{ ASIGNACION_TRABAJO : se_asigna
    MECANICO ||--o{ ASIGNACION_TRABAJO : trabaja_en
    ASIGNACION_TRABAJO ||--o{ USO_REFACCION : utiliza
    REFACCION ||--o{ USO_REFACCION : es_usada_en

    CLIENTE {
        int id_cliente PK
        string nombres
        string apellido_paterno
        string apellido_materno
        string correo
    }

    CLIENTE_TELEFONO {
        int id_cliente PK_FK
        string telefono PK
    }

    VEHICULO {
        string vin PK
        string placa UK
        string marca
        int modelo_anio
        int kilometraje
        int id_cliente FK
    }

    ORDEN_SERVICIO {
        int folio_orden PK
        date fecha_ingreso
        string estado
        string vin FK
    }

    SERVICIO {
        int id_servicio PK
        string nombre_servicio UK
        decimal precio_base
    }

    SERVICIO_APLICADO {
        int folio_orden PK_FK
        int id_servicio PK_FK
        decimal costo_aplicado
    }

    EMPLEADO {
        int id_empleado PK
        string curp UK
        string nombres
        string tipo
    }

    MECANICO {
        int id_empleado PK_FK
        string especialidad
        decimal tarifa_hora
    }

    RECEPCIONISTA {
        int id_empleado PK_FK
        string turno
        string modulo_atencion
    }

    ASIGNACION_TRABAJO {
        int folio_orden PK_FK
        int id_mecanico PK_FK
        decimal horas_trabajadas
    }

    REFACCION {
        string codigo_refaccion PK
        string nombre_pieza
        decimal precio_unitario
        int stock_actual
    }

    USO_REFACCION {
        int folio_orden PK_FK
        int id_mecanico PK_FK
        string codigo_refaccion PK_FK
        int cantidad_usada
    }
```