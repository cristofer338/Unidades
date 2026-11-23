# Unidad 5: Álgebra Relacional
## Tarea 5.1: Operadores Fundamentales y Extendidos del Álgebra Relacional

* **Institución:** Instituto Tecnológico de Monclova
* **Carrera:** Ingeniería en Sistemas Computacionales
* **Alumno:** Cristofer Alejandro Barboza Chávez
* **Matrícula:** 124050398
* **Caso de Estudio:** Taller Mecánico y Refaccionaria "El Motor"

---

## 1. Marco Teórico Formal

El **álgebra relacional** es un lenguaje de consulta procedural formal ideado por Edgar F. Codd. Opera sobre una o más relaciones (tablas) de entrada y produce una nueva relación como resultado. Sirve como cimiento matemático para la optimización de consultas en los SGBD relacionales.

---

## 2. Definición y Notación Formal de Operadores

### 2.1 Operadores Unarios

| Operador | Símbolo | Notación Formal | Comportamiento Procedural |
| :--- | :---: | :---: | :--- |
| **Selección** | $\sigma$ | $\sigma_{\theta}(R)$ | Filtra horizontalmente las tuplas que satisfacen la condición booleana $\theta$. |
| **Proyección** | $\pi$ | $\pi_{A_1, \dots, A_k}(R)$ | Extrae verticalmente las columnas $A_1, \dots, A_k$ eliminando duplicados. |
| **Renombramiento** | $\rho$ | $\rho_{S(B_1, \dots, B_n)}(R)$ | Modifica el nombre de la relación $R$ a $S$ y/o renombrar sus atributos. |

### 2.2 Operadores Binarios de Conjuntos

Requieren que las relaciones $R$ y $S$ sean **compatibles en esquema** (mismo grado y dominios compatibles).

| Operador | Símbolo | Notación Formal | Comportamiento Procedural |
| :--- | :---: | :---: | :--- |
| **Unión** | $\cup$ | $R \cup S$ | Tuplas pertenecientes a $R$, a $S$, o a ambas. |
| **Intersección** | $\cap$ | $R \cap S$ | Tuplas presentes simultáneamente en $R$ y en $S$. |
| **Diferencia** | $-$ | $R - S$ | Tuplas presentes en $R$ pero no en $S$ (negación lógica). |

### 2.3 Operadores Binarios Relacionales

| Operador | Símbolo | Notación Formal | Comportamiento Procedural |
| :--- | :---: | :---: | :--- |
| **Producto Cartesiano** | $\times$ | $R \times S$ | Combina cada tupla de $R$ con cada tupla de $S$ ($|R| \times |S|$ tuplas). |
| **Reunión (Join)** | $\bowtie$ | $R \bowtie_{\theta} S$ | Equivale a $\sigma_{\theta}(R \times S)$. Acopla tuplas según la condición $\theta$. |
| **División** | $\div$ | $R \div S$ | Obtiene las tuplas de $R(A,B)$ asociadas con **todas** las tuplas de $S(B)$. |

### 2.4 Operadores del Álgebra Relacional Extendida

| Operador | Notación Formal | Comportamiento Procedural |
| :--- | :---: | :--- |
| **Proyección Generalizada** | $\pi_{F_1, \dots, F_k}(R)$ | Permite expresiones aritméticas, transformaciones y alias en los atributos. |
| **Agregación y Agrupación** | $_{G}\mathcal{G}_{F_1(A_1), \dots, F_m(A_m)}(R)$ | Agrupa por $G$ y calcula funciones ($\text{SUM}$, $\text{COUNT}$, $\text{AVG}$, $\text{MIN}$, $\text{MAX}$). |
| **Left Outer Join** | $R \mathbin{\text{⟕}}_{\theta} S$ | Preserva tuplas de $R$; si no hay pareja en $S$, rellena con $\text{NULL}$. |
| **Right Outer Join** | $R \mathbin{\text{⟖}}_{\theta} S$ | Preserva tuplas de $S$; si no hay pareja en $R$, rellena con $\text{NULL}$. |
| **Full Outer Join** | $R \mathbin{\text{⟗}}_{\theta} S$ | Preserva todas las tuplas de $R$ y $S$, rellenando con $\text{NULL}$ las ausencias. |

---

## 3. Mapa Conceptual en UML (Mermaid)

```mermaid
classDiagram
    class AlgebraRelacional {
        +Lenguaje Procedural Formal
        +Entradas: Relaciones
        +Salida: Nueva Relacion
    }

    class OperadoresBasicos {
        +Unarios
        +Binarios_Conjuntos
        +Binarios_Relacionales
    }

    class OperadoresExtendidos {
        +Proyeccion_Generalizada
        +Agregacion_y_Agrupacion
        +Outer_Joins
    }

    class Unarios {
        +Seleccion: σ(R) [Filtro Horizontal]
        +Proyeccion: π(R) [Filtro Vertical]
        +Renombramiento: ρ(R) [Alias]
    }

    class BinariosConjuntos {
        +Union: R ∪ S
        +Interseccion: R ∩ S
        +Diferencia: R - S
    }

    class BinariosRelacionales {
        +ProductoCartesiano: R × S
        +Join: R ⋈ S
        +Division: R ÷ S
    }

    class Agregacion {
        +Group_By: Atributos G
        +Funciones: SUM, COUNT, AVG, MIN, MAX
    }

    class OuterJoins {
        +Left_Outer_Join: R ⟕ S
        +Right_Outer_Join: R ⟖ S
        +Full_Outer_Join: R ⟗ S
    }

    AlgebraRelacional <|-- OperadoresBasicos
    AlgebraRelacional <|-- OperadoresExtendidos

    OperadoresBasicos <|-- Unarios
    OperadoresBasicos <|-- BinariosConjuntos
    OperadoresBasicos <|-- BinariosRelacionales

    OperadoresExtendidos <|-- Agregacion
    OperadoresExtendidos <|-- OuterJoins
```

---

## 4. Entregables en Teams

| Entregable | Estado / Enlace |
| :--- | :--- |
| **1. PDF:** Informe técnico con mapa conceptual y marco teórico | `Tarea_5_1_Algebra_Relacional.pdf` |
| **2. GitHub:** Archivo Markdown fuente | `README_5.1.md` |
| **3. YouTube:** Video de notación formal (webcam en esquina inferior derecha) | `[Pegar Enlace Público de YouTube Aquí]` |