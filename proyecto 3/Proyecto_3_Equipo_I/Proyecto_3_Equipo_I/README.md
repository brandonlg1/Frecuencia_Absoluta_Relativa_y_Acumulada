# Proyecto 3 · Estimación estadística con swirl — Equipo I

**Asignatura:** Estadística — Unidad III. Estimación
**Docente:** Dra. Liliana Orizel Martínez Martínez
**Universidad Autónoma de Ciudad Juárez** · Instituto de Ingeniería y Tecnología · Ingeniería de Software

## Integrantes

- Brandon López García
- Efrén Jovany Nava Alemán
- Juan Carlos Coutiño Barragán

## Descripción de las lecciones

| Lección | Carpeta | Contenido |
|---|---|---|
| 1. Estimación puntual e intervalos para una población | `Estimacion_1_Una_Poblacion/` | Población, muestra, parámetro y estimador; características de un estimador (insesgado, eficiente, consistente) con una simulación; estimación puntual; intervalo de confianza para una media (t) y para una proporción (z); interpretación. |
| 2. Estimación para dos poblaciones | `Estimacion_2_Dos_Poblaciones/` | Diferencia de medias (Welch, `t.test()`), diferencia de proporciones, intervalo para una varianza (ji-cuadrada) y para la razón de varianzas (`var.test()`); interpretación de intervalos que contienen o no al 0 / al 1. |
| 3. Confianza, precisión y tamaño de muestra | `Estimacion_3_Confianza_y_Muestra/` | Nivel de confianza, valor crítico, margen de error y precisión; comparación de 90 %, 95 % y 99 %; efecto del tamaño de muestra; determinación del tamaño de muestra para una media y para una proporción. |

Cada lección sigue la secuencia **Explicación → Pregunta → Código en R → Interpretación** e incluye: objetivo, explicaciones breves, ejemplos, al menos 3 preguntas de opción múltiple, 2 numéricas o de respuesta exacta, 4 actividades con código en R, 2 de interpretación, gráficas, pistas (`Hint`), una actividad integradora y un resumen final.

**Pregunta con múltiples hints:** hay una en cada lección (`cmd_question`). Las funciones están en `funciones/funciones_hints.R`:

| Lección | Función | Qué detecta |
|---|---|---|
| 1 | `test_ic_proporcion()` | solo un límite, nivel de 90 % o 99 %, límites invertidos, sin raíz cuadrada, conteo en lugar de proporción, no guardó el resultado |
| 2 | `test_ic_dif_medias()` | objeto completo de `t.test()`, orden invertido, un solo grupo, solo estimación puntual, `var.equal = TRUE`, otro nivel de confianza, no guardó |
| 3 | `test_tamano_muestra_media()` | no redondeó, redondeó hacia abajo, nivel de 90 % o 99 %, sin elevar al cuadrado, `sigma` y `E` invertidos, no guardó |

Todas dan retroalimentación general para errores no previstos.

## Estructura del proyecto

```
Proyecto_3_Equipo_I/
├── README.md                         documentación del proyecto
├── MANIFEST                          orden de las lecciones para swirl
├── Estimacion_1_Una_Poblacion/
│   ├── lesson.yaml                   secuencia de explicaciones y preguntas
│   ├── initLesson.R                  datos: poblacion_traslado, traslado, usa_camion, horas_estudio
│   ├── customTests.R                 carga las funciones de ../funciones/
│   └── grafica_insesgamiento.R       histograma de medias muestrales
├── Estimacion_2_Dos_Poblaciones/
│   ├── lesson.yaml
│   ├── initLesson.R                  datos: matutino, vespertino, algoritmo_1, algoritmo_2
│   ├── customTests.R
│   └── grafica_turnos.R              diagramas de caja por turno
├── Estimacion_3_Confianza_y_Muestra/
│   ├── lesson.yaml
│   ├── initLesson.R                  datos: tiempos_carga, sigma
│   ├── customTests.R
│   ├── grafica_niveles.R             intervalos de 90, 95 y 99 %
│   └── grafica_margen_n.R            margen de error vs. tamaño de muestra
├── funciones/
│   ├── pruebas_comunes.R             pruebas reutilizables (valor_es, objeto_es, num_cercano, texto_es…)
│   └── funciones_hints.R             funciones de múltiples hints (una por lección)
├── pruebas/
│   └── probar_funciones_hints.R      comprueba las funciones de hints sin abrir swirl
└── docs/
    ├── arquitectura.png              diagrama de arquitectura
    └── arquitectura.pdf
```

### ¿Cómo se relacionan los archivos?

1. `swirl()` lee `MANIFEST` y muestra las tres lecciones en orden.
2. Al iniciar una lección, swirl ejecuta `initLesson.R`, que crea los datos en la consola.
3. swirl carga `customTests.R`, que localiza la carpeta `funciones/` y hace `source()` de `pruebas_comunes.R` y `funciones_hints.R`.
4. swirl recorre `lesson.yaml` fila por fila. En cada pregunta, el campo `AnswerTests` llama a una función de `funciones/` (por ejemplo `test_ic_dif_medias()`), que revisa lo que escribió el estudiante (`e$expr`) y su resultado (`e$val`) y devuelve `TRUE` o `FALSE` con un mensaje específico.
5. Las filas `figure` ejecutan los archivos `grafica_*.R`.

Ver el diagrama completo en [`docs/arquitectura.png`](docs/arquitectura.png).

## Paquetes de R necesarios

- `swirl` (para tomar las lecciones)
- `swirlify` (solo para probarlas como desarrollador)
- Las lecciones usan únicamente funciones de R base y `stats` (`mean`, `sd`, `var`, `qt`, `qnorm`, `qchisq`, `t.test`, `var.test`, `hist`, `boxplot`…).

```r
install.packages(c("swirl", "swirlify"))
```

Se recomienda R 4.2 o superior (maneja correctamente los acentos en Windows).

## Instrucciones para ejecutar las lecciones

**Como estudiante** (desde el proyecto de RStudio del repositorio clonado):

```r
library(swirl)
install_course_directory("Proyecto_3_Equipo_I")   # ruta relativa a la carpeta del repositorio
swirl()
```

Elige el curso **Proyecto 3 Equipo I** y después la lección. Dentro de swirl: `skip()` salta una pregunta, `play()` / `nxt()` permiten experimentar en la consola y `bye()` sale guardando el avance.

**Como desarrollador** (para probar una lección):

```r
library(swirlify)
set_lesson("Proyecto_3_Equipo_I/Estimacion_1_Una_Poblacion/lesson.yaml")
test_lesson()
```

Para comprobar las funciones de múltiples hints sin abrir swirl:

```r
source("Proyecto_3_Equipo_I/pruebas/probar_funciones_hints.R")
# Debe terminar con: Casos correctos: 28 de 28
```

## Reproducibilidad

- Las muestras están escritas de forma fija en cada `initLesson.R`; la población simulada y la simulación de medias usan `set.seed()`.
- No se usan rutas absolutas: `customTests.R` encuentra `funciones/` de forma relativa a la lección.
- En este proyecto no se realizan pruebas de hipótesis; solo estimación e interpretación de intervalos.
