# =====================================================================
# initLesson.R  -  Lección 2: Estimación para dos poblaciones
# ---------------------------------------------------------------------
# swirl ejecuta este archivo al iniciar la lección. Los objetos creados
# aquí quedan disponibles en la consola del estudiante.
# Los datos están escritos de forma fija para que los resultados sean
# idénticos en cualquier computadora.
# =====================================================================

# Calificaciones (0-100) del examen parcial de Estadística en dos turnos.
matutino <- c(79, 76, 92, 87, 92, 74, 82, 86, 67, 71, 68, 75, 80, 69, 69,
              70, 78, 86, 78, 70, 63, 76, 84, 85, 77, 79, 99, 78, 76, 78,
              66, 85, 85, 69, 79)                       # n = 35

vespertino <- c(70, 55, 60, 65, 56, 71, 75, 52, 77, 64, 72, 69, 44, 78, 71,
                87, 88, 63, 89, 72, 62, 71, 81, 57, 64, 84, 64, 73, 65, 58)
                                                        # n = 30

# Actividad integradora: tiempo de ejecución (milisegundos) de dos
# algoritmos de ordenamiento, medido 25 veces cada uno.
algoritmo_1 <- c(106, 121, 133, 137, 132, 125, 127, 94, 133, 151, 100, 109,
                 134, 113, 117, 123, 128, 131, 121, 152, 105, 150, 101, 117, 124)

algoritmo_2 <- c(160, 118, 109, 123, 101, 130, 113, 142, 133, 101, 121, 147,
                 152, 142, 116, 122, 136, 131, 158, 154, 129, 132, 131, 117, 143)
