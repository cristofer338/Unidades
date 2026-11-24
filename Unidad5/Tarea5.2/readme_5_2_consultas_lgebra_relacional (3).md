# Unidad 5: Álgebra Relacional

## Tarea 5.2: Resolución de Consultas sobre el Esquema Relacional con Álgebra Formal

* **Institución:** Instituto Tecnológico de Monclova
* **Carrera:** Ingeniería en Sistemas Computacionales
* **Alumno:** Cristofer Alejandro Barboza Chávez
* **Matrícula:** 124050398
* **Caso de Estudio:** Taller Mecánico y Refaccionaria "El Motor"

---

## Catálogo de 10 Consultas Formales

### Consulta 1 (Básica — Selección y Proyección)

* **Requerimiento:** Obtener VIN, placa, marca y año del modelo de vehículos registrados con kilometraje mayor a 80,000 km.

* **Álgebra Relacional:**

$$\pi_{\text{vin}, \text{placa}, \text{marca}, \text{modelo\\_anio}}\left(\sigma_{\text{kilometraje} > 80000}(\text{vehiculo})\right)$$

* **Tablas Intermedias:**
  1. $T_1 = \sigma_{\text{kilometraje} > 80000}(\text{vehiculo})$
  2. $\text{Resultado} = \pi_{\text{vin}, \text{placa}, \text{marca}, \text{modelo\\_anio}}(T_1)$

---

### Consulta 2 (Básica — Filtro de Catálogo)

* **Requerimiento:** Listar código, nombre de pieza y precio unitario de las refacciones con precio menor o igual a $500.00.

* **Álgebra Relacional:**

$$\pi_{\text{codigo\\_refaccion}, \text{nombre\\_pieza}, \text{precio\\_unitario}}\left(\sigma_{\text{precio\\_unitario} \le 500.00}(\text{refaccion})\right)$$

* **Tablas Intermedias:**
  1. $T_1 = \sigma_{\text{precio\\_unitario} \le 500.00}(\text{refaccion})$
  2. $\text{Resultado} = \pi_{\text{codigo\\_refaccion}, \text{nombre\\_pieza}, \text{precio\\_unitario}}(T_1)$

---

### Consulta 3 (Intermedia — Join Triple)

* **Requerimiento:** Mostrar folio de orden, estado, placa del vehículo y nombre completo del cliente para cada orden.

* **Álgebra Relacional:**

$$\pi_{\text{folio\\_orden}, \text{estado}, \text{placa}, \text{nombres}, \text{apellido\\_paterno}, \text{apellido\\_materno}}\left((\text{orden\\_servicio} \bowtie_{\text{vin}} \text{vehiculo}) \bowtie_{\text{id\\_cliente}} \text{cliente}\right)$$

* **Tablas Intermedias:**
  1. $T_1 = \text{orden\\_servicio} \bowtie_{\text{vin}} \text{vehiculo}$
  2. $T_2 = T_1 \bowtie_{\text{id\\_cliente}} \text{cliente}$
  3. $\text{Resultado} = \pi_{\text{folio\\_orden}, \text{estado}, \text{placa}, \text{nombres}, \text{apellido\\_paterno}, \text{apellido\\_materno}}(T_2)$

---

### Consulta 4 (Intermedia — Join + Desigualdad)

* **Requerimiento:** Obtener folio de orden, ID de servicio, nombre del servicio y costo aplicado donde el precio cobrado difiera del precio base del catálogo.

* **Álgebra Relacional:**

$$\pi_{\text{folio\\_orden}, \text{id\\_servicio}, \text{nombre\\_servicio}, \text{costo\\_aplicado}}\left(\sigma_{\text{costo\\_aplicado} \neq \text{precio\\_base}}(\text{servicio\\_aplicado} \bowtie_{\text{id\\_servicio}} \text{servicio})\right)$$

* **Tablas Intermedias:**
  1. $T_1 = \text{servicio\\_aplicado} \bowtie_{\text{id\\_servicio}} \text{servicio}$
  2. $T_2 = \sigma_{\text{costo\\_aplicado} \neq \text{precio\\_base}}(T_1)$
  3. $\text{Resultado} = \pi_{\text{folio\\_orden}, \text{id\\_servicio}, \text{nombre\\_servicio}, \text{costo\\_aplicado}}(T_2)$

---

### Consulta 5 (Intermedia — Especialización)

* **Requerimiento:** Listar ID de empleado, CURP, nombres, especialidad y tarifa por hora de los mecánicos.

* **Álgebra Relacional:**

$$\pi_{\text{id\\_empleado}, \text{curp}, \text{nombres}, \text{especialidad}, \text{tarifa\\_hora}}\left(\text{empleado} \bowtie_{\text{id\\_empleado}} \text{mecanico}\right)$$

* **Tablas Intermedias:**
  1. $T_1 = \text{empleado} \bowtie_{\text{id\\_empleado}} \text{mecanico}$
  2. $\text{Resultado} = \pi_{\text{id\\_empleado}, \text{curp}, \text{nombres}, \text{especialidad}, \text{tarifa\\_hora}}(T_1)$

---

### Consulta 6 (Intermedia — Agregación)

* **Requerimiento:** Calcular por mecánico (`id_mecanico`) el total de horas trabajadas y la cantidad de órdenes asignadas.

* **Álgebra Relacional:**

$${}_{\text{id\\_mecanico}}\mathcal{G}_{\text{SUM}(\text{horas\\_trabajadas}) \text{ AS total\\_horas},\, \text{COUNT}(\text{folio\\_orden}) \text{ AS num\\_ordenes}}(\text{asignacion\\_trabajo})$$

* **Tablas Intermedias:**
  1. $\text{Resultado} = {}_{\text{id\\_mecanico}}\mathcal{G}_{\text{SUM}(\text{horas\\_trabajadas}) \text{ AS total\\_horas},\, \text{COUNT}(\text{folio\\_orden}) \text{ AS num\\_ordenes}}(\text{asignacion\\_trabajo})$

---

### Consulta 7 (Compleja — Agregación + Filtro)

* **Requerimiento:** Obtener el folio de orden y el monto acumulado en servicios para órdenes que superen los $1,000.00.

* **Álgebra Relacional:**

$$\sigma_{\text{total\\_servicios} > 1000.00}\left({}_{\text{folio\\_orden}}\mathcal{G}_{\text{SUM}(\text{costo\\_aplicado}) \text{ AS total\\_servicios}}(\text{servicio\\_aplicado})\right)$$

* **Tablas Intermedias:**
  1. $T_1 = {}_{\text{folio\\_orden}}\mathcal{G}_{\text{SUM}(\text{costo\\_aplicado}) \text{ AS total\\_servicios}}(\text{servicio\\_aplicado})$
  2. $\text{Resultado} = \sigma_{\text{total\\_servicios} > 1000.00}(T_1)$

**Árbol de Ejecución (UML Flowchart):**

```mermaid
graph BT
    A["Tabla: servicio_aplicado"] --> B["Agregacion: folio_orden G SUM(costo_aplicado) AS total_servicios"]
    B --> C["T1: Subtotales por Orden"]
    C --> D["Seleccion: total_servicios mayor a 1000.00"]
    D --> E["Resultado Final"]
```

---

### Consulta 8 (Compleja — Left Outer Join)

* **Requerimiento:** Listar todos los clientes con el VIN de sus vehículos, incluyendo a aquellos clientes sin vehículo registrado.

* **Álgebra Relacional:**

$$\pi_{\text{id\\_cliente}, \text{nombres}, \text{apellido\\_paterno}, \text{vin}}\left(\text{cliente} \bowtie_{\text{id\\_cliente}}^{\text{left}} \text{vehiculo}\right)$$

* **Tablas Intermedias:**
  1. $T_1 = \text{cliente} \bowtie_{\text{id\\_cliente}}^{\text{left}} \text{vehiculo}$
  2. $\text{Resultado} = \pi_{\text{id\\_cliente}, \text{nombres}, \text{apellido\\_paterno}, \text{vin}}(T_1)$

**Árbol de Ejecución (UML Flowchart):**

```mermaid
graph BT
    A["Tabla: cliente"] --> C["Left Join por id_cliente"]
    B["Tabla: vehiculo"] --> C
    C --> D["T1: Clientes y Vehiculos (Conserva NULLs)"]
    D --> E["Proyeccion: id_cliente, nombres, apellido_paterno, vin"]
    E --> F["Resultado Final"]
```

---

### Consulta 9 (Compleja — Diferencia de Conjuntos)

* **Requerimiento:** Obtener código y nombre de las refacciones del catálogo que nunca han sido utilizadas.

* **Álgebra Relacional:**

$$\pi_{\text{codigo\\_refaccion}, \text{nombre\\_pieza}}\left(\text{refaccion} \bowtie \left(\pi_{\text{codigo\\_refaccion}}(\text{refaccion}) - \pi_{\text{codigo\\_refaccion}}(\text{uso\\_refaccion})\right)\right)$$

* **Tablas Intermedias:**
  1. $T_1 = \pi_{\text{codigo\\_refaccion}}(\text{refaccion})$
  2. $T_2 = \pi_{\text{codigo\\_refaccion}}(\text{uso\\_refaccion})$
  3. $T_3 = T_1 - T_2$
  4. $T_4 = \text{refaccion} \bowtie T_3$
  5. $\text{Resultado} = \pi_{\text{codigo\\_refaccion}, \text{nombre\\_pieza}}(T_4)$

**Árbol de Ejecución (UML Flowchart):**

```mermaid
graph BT
    A["Tabla: refaccion"] --> A1["Proyeccion: codigo_refaccion (T1)"]
    B["Tabla: uso_refaccion"] --> B1["Proyeccion: codigo_refaccion (T2)"]
    A1 --> C["Diferencia de Conjuntos: T1 - T2"]
    B1 --> C
    C --> D["Join Natural con Catálogo: refaccion"]
    A --> D
    D --> E["Proyeccion Final: codigo_refaccion, nombre_pieza"]
    E --> F["Resultado Final"]
```

---

### Consulta 10 (Compleja — Join Múltiple + Proyección Generalizada)

* **Requerimiento:** Calcular el importe total de mano de obra ($\text{horas\\_trabajadas} \times \text{tarifa\\_hora}$) por mecánico y por orden.

* **Álgebra Relacional:**

$$\pi_{\text{folio\\_orden}, \text{id\\_mecanico}, \text{nombres}, (\text{horas\\_trabajadas} \times \text{tarifa\\_hora}) \rightarrow \text{importe\\_mano\\_obra}}\left((\text{asignacion\\_trabajo} \bowtie_{\text{id\\_mecanico} = \text{id\\_empleado}} \text{mecanico}) \bowtie_{\text{id\\_empleado}} \text{empleado}\right)$$

* **Tablas Intermedias:**
  1. $T_1 = \text{asignacion\\_trabajo} \bowtie_{\text{id\\_mecanico} = \text{id\\_empleado}} \text{mecanico}$
  2. $T_2 = T_1 \bowtie_{\text{id\\_empleado}} \text{empleado}$
  3. $\text{Resultado} = \pi_{\text{folio\\_orden}, \text{id\\_mecanico}, \text{nombres}, (\text{horas\\_trabajadas} \times \text{tarifa\\_hora}) \rightarrow \text{importe\\_mano\\_obra}}(T_2)$

**Árbol de Ejecución (UML Flowchart):**

```mermaid
graph BT
    A["Tabla: asignacion_trabajo"] --> D["Join 1: por id_mecanico = id_empleado"]
    B["Tabla: mecanico"] --> D
    D --> E["Join 2: por id_empleado"]
    C["Tabla: empleado"] --> E
    E --> F["Proyeccion Generalizada: horas * tarifa -> importe_mano_obra"]
    F --> G["Resultado Final"]
```

---

## Entregables en Teams

| Entregable | Estado / Enlace | 
| :--- | :--- | 
| **1. PDF:** Reporte técnico del catálogo y validaciones | `Tarea_5_2_Consultas_Algebra.pdf` | 
| **2. GitHub:** Archivo Markdown y script `taller_el_motor_relax.txt` | `README_5.2.md` | 
| **3. YouTube:** Video explicando C7, C8 y C10 (webcam en esquina inferior derecha) | `[Pegar Enlace Público de YouTube Aquí]` | 