# Gráfica 2 de la lección 3 (Class: figure en lesson.yaml).
# Margen de error contra tamaño de muestra para 90%, 95% y 99%.
n_graf <- 10:500
confianzas <- c(0.90, 0.95, 0.99)
colores <- c("seagreen3", "steelblue", "firebrick")
plot(NA, xlim = range(n_graf), ylim = c(0, 0.7),
     xlab = "Tamaño de muestra (n)", ylab = "Margen de error (s)",
     main = "Margen de error vs. tamaño de muestra")
for (i in seq_along(confianzas)) {
  z_i <- qnorm(1 - (1 - confianzas[i]) / 2)
  lines(n_graf, z_i * sigma / sqrt(n_graf), lwd = 3, col = colores[i])
}
legend("topright", legend = c("90%", "95%", "99%"), col = colores, lwd = 3,
       title = "Confianza", bty = "n")
