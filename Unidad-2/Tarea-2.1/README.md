# Tarea 2.1: Modelado Conceptual E-R y E-R Extendido

## Información General
- **Unidad:** Unidad 2 — Diseño de Bases de Datos con el modelo E-R
- **Actividad:** Tarea 2.1 — Modelado conceptual E-R y E-R Extendido de un caso real
- **Caso de estudio:** Taller Mecánico y Refaccionaria "El Motor"
- **Herramienta CASE:** draw.io (`.drawio`)

## 1. Planteamiento del Problema y Contexto
El Taller Mecánico y Refaccionaria "El Motor" requiere organizar de forma estructurada la información de su operación diaria, abarcando tanto los servicios de diagnóstico y reparación vehicular como la gestión y venta/abastecimiento de refacciones. Este diseño conceptual modela los datos operativos para evitar redundancia, inconsistencias y ambigüedades antes de pasar al diseño lógico y físico.

## 2. Reglas de Negocio
- Todo vehículo atendido se asocia a un cliente registrado y puede registrar una o más órdenes de servicio a lo largo del tiempo.
- Cada orden de servicio documenta el trabajo realizado y puede incluir mano de obra, servicios y/o refacciones utilizadas.
- Las refacciones disponen de información de inventario y precio unitario, lo cual condiciona su asignación o salida en las órdenes/ventas.
- *(Ajusta o añade las reglas específicas de tu reporte técnico).*

## 3. Diseño Conceptual (Modelo E-R y E-R Extendido)
- **Entidades:** Identificación de las entidades principales del dominio del taller y la refaccionaria.
- **Atributos:** Especificación de atributos clave (identificadores), atributos compuestos, atributos derivados y atributos multivalorados.
- **Relaciones, Cardinalidades y Participación:** Definición de relaciones entre entidades con sus respectivas cardinalidades (`1:1`, `1:N`, `N:M`) y restricciones de participación (total o parcial).
- **Extensiones E-R Extendido (E-RE):** Aplicación de especialización/generalización, jerarquías y/o agregación según lo definido en el modelo conceptual.

## 4. Justificación del Diseño
El modelo separa claramente las entidades y relaciones del dominio para reflejar las reglas de negocio reales del taller y la refaccionaria, empleando estructuras del modelo E-R extendido únicamente donde aportan claridad semántica y evitan duplicidad de atributos o relaciones ambiguas.

## 5. Entregables en el Repositorio
- `Reporte_Tecnico_Tarea_2_1_ER-v2.pdf`: Reporte técnico con planteamiento del problema, reglas de negocio, diagrama E-R/E-RE en alta resolución y justificación de diseño.
- `diagrama_er_extendido_el_motor.drawio`: Archivo fuente editable del diagrama en herramienta CASE[cite: 2].

## 6. Video Explicativo (YouTube)
- **Enlace público:** *(Pendiente de incorporar)*
