# =====================================================================
# initLesson.R  -  Lección 3: Confianza, precisión y tamaño de muestra
# ---------------------------------------------------------------------
# swirl ejecuta este archivo al iniciar la lección. Los objetos creados
# aquí quedan disponibles en la consola del estudiante.
# =====================================================================

# Tiempo de carga (segundos) de la app del campus, medido en 50 accesos.
tiempos_carga <- c(3.01, 1.98, 1.77, 2.94, 3.92, 2.42, 1.64, 0.72, 1.51, 2.68,
                   1.69, 3.79, 3.80, 1.35, 1.51, 2.75, 3.30, 2.21, 1.67, 2.57,
                   1.75, 1.26, 1.96, 2.00, 1.83, 2.99, 3.67, 2.02, 2.36, 2.06,
                   2.46, 3.03, 1.92, 2.01, 3.20, 2.07, 2.86, 3.47, 3.96, 1.23,
                   2.86, 1.53, 2.99, 1.75, 1.06, 2.52, 2.53, 2.66, 2.22, 2.28)

# Desviación estándar poblacional CONOCIDA por registros históricos del
# servidor. Al conocer sigma usamos la distribución normal (z).
sigma <- 0.8
