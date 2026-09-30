# =====================================================================
# initLesson.R  -  Lección 1: Estimación puntual e intervalos (1 población)
# ---------------------------------------------------------------------
# swirl ejecuta este archivo al iniciar la lección. Los objetos creados
# aquí quedan disponibles en la consola del estudiante.
# =====================================================================

# Población SIMULADA: tiempo de traslado (minutos) de 2000 estudiantes del IIT.
# En la realidad no conocemos la población; aquí la simulamos para poder
# comparar el parámetro verdadero con sus estimaciones.
set.seed(2026)
poblacion_traslado <- round(rgamma(2000, shape = 9, rate = 0.3), 1)

# Muestra de 40 estudiantes (datos fijos para que todos obtengan lo mismo).
traslado <- c(39.9, 26.7, 29, 24.9, 25, 23.8, 23.5, 28.5, 39.5, 15.5,
              30.4, 25.6, 23.8, 21.7, 29.1, 28.4, 36.9, 23.6, 39.2, 18,
              47.5, 38.5, 21.4, 52.3, 34.4, 32, 34.3, 14.8, 40.7, 40.5,
              45.1, 17.5, 21.3, 48.2, 33.5, 20.2, 38.8, 27.1, 19.3, 22.1)

# ¿Usa transporte público (camión)?  1 = sí, 0 = no  (mismos 40 estudiantes)
usa_camion <- c(0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0,
                0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0)

# Actividad integradora: horas de estudio a la semana (otra muestra de 40).
horas_estudio <- c(15.2, 14.1, 19, 6.9, 20.8, 13.7, 5.7, 8.3, 12.3, 12,
                   2.9, 15, 9.8, 12.7, 14.3, 18, 14.6, 16.5, 8.9, 10.3,
                   13.6, 12.1, 7.9, 6.9, 11.1, 15, 13.3, 7.5, 9.2, 9.1,
                   4.7, 10.4, 12.1, 15.6, 18.5, 12.2, 19.4, 12.3, 17.7, 17.8)
