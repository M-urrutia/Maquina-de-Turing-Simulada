# 📟 Máquina de Turing Simulada

**Autor:** Maximiliano Urrutia

Simulación 3D interactiva de una Máquina de Turing capaz de **sumar** y **restar** números en notación unaria.

---

## 🧩 Resumen rápido

- La primera celda leída determina la operación:
  - `1` → **suma**
  - `0` → **resta**
- Ambos números deben estar separados por un `0`.
- Las tablas de la simulación **empiezan en 0** por defecto.
- **Restricción de resta:** la máquina **NO** puede calcular `(mayor) - (menor)`.  
  Debe usarse la forma `(menor) - (mayor)`.

---

## 🧠 Formato de entrada

- Notación unaria: por ejemplo, `3` → `111`
- Ejemplo completo (suma de 2 + 3): `1 11 0 111` → (`1` indica suma)
- Ejemplo completo (resta de 2 - 3): `0 11 0 111` → (`0` indica resta)

> Nota: el `0` entre los números actúa como separador.

---

## 🏷️ Estados y transiciones

La máquina cuenta con **11 estados** (`Q0` a `Q11`).  
Formato de la tabla: **Estado – Entrada → [Escritura, Movimiento, Siguiente estado]**

| Estado | Entrada | Escritura | Movimiento | Siguiente | Descripción |
|--------|---------|-----------|------------|-----------|-------------|
| Q0     | 0       | 0         | R (1)      | Q5        | Determina operación (resta si 0). |
| Q0     | 1       | 0         | R (1)      | Q1        | Determina operación (suma si 1). |
| Q1     | 0       | 1         | R (1)      | Q2        | Inicio suma: busca separador. |
| Q1     | 1       | 1         | R (1)      | Q1        | Avanza en primer número. |
| Q2     | 0       | 0         | L (0)      | Q3        | Busca final del segundo número. |
| Q2     | 1       | 1         | R (1)      | Q2        | Avanza hacia derecha. |
| Q3     | 0       | 0         | R (0)      | Q3        | Movimiento dentro de corrección. |
| Q3     | 1       | 0         | R (1)      | Q4        | Lee 1 y lo convierte a 0. |
| Q4     | 0       | 0         | R (1)      | Final     | Finaliza operación. |
| Q4     | 1       | 1         | R (1)      | Final     | Finaliza operación. |
| Q5     | 0       | 0         | R (1)      | Q4        | Inicio resta: verifica si queda número. |
| Q5     | 1       | 0         | R (1)      | Q6        | Continúa proceso de resta. |
| Q6     | 0       | 0         | R (1)      | Q7        | Busca separador central. |
| Q6     | 1       | 1         | R (1)      | Q6        | Avanza hacia derecha. |
| Q7     | 0       | 0         | L (0)      | Q8        | Busca final del segundo número y vuelve. |
| Q7     | 1       | 1         | R (1)      | Q7        | Avanza hacia final. |
| Q8     | 0       | 0         | L (0)      | Q4        | Si no hay '1' → fin de resta. |
| Q8     | 1       | 0         | L (0)      | Q9        | Borra último `1` del segundo número. |
| Q9     | 0       | 0         | L (0)      | Q10       | Regresa al separador. |
| Q9     | 1       | 1         | L (0)      | Q9        | Sigue moviéndose a la izquierda. |
| Q10    | 0       | 0         | L (0)      | Q4        | Si derecha vacía → fin. |
| Q10    | 1       | 1         | L (0)      | Q11       | Sigue proceso de ajuste. |
| Q11    | 0       | 0         | R (1)      | Q5        | Busca primer `0` a la izquierda. |
| Q11    | 1       | 1         | L (0)      | Q11       | Avanza buscando el 0. |

> Movimientos: `R (1)` = mover a la derecha; `L (0)` = mover a la izquierda.

---

## 🎮 Controles de la simulación

- **W A S D** — mover cámara (adelante/izquierda/atrás/derecha)  
- **UP** — subir  
- **SHIFT** — bajar  
- **E** — editar el estado de una celda (acércate y presiona E)

La escena principal se llama: `turing`


Para iniciar la máquina presione la tecla ENTER

