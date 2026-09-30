# Gráfica 1 de la lección 3 (Class: figure en lesson.yaml).
# Intervalos de 90%, 95% y 99% para la misma muestra: mayor confianza,
# intervalo más ancho (menor precisión).
niveles <- c("90%", "95%", "99%")
plot(NA, xlim = range(intervalos) + c(-0.05, 0.05), ylim = c(0.5, 3.5),
     yaxt = "n", xlab = "Tiempo medio de carga (s)", ylab = "",
     main = "Misma muestra, distinto nivel de confianza")
axis(2, at = 1:3, labels = niveles, las = 1)
segments(intervalos[, 1], 1:3, intervalos[, 2], 1:3,
         lwd = 6, col = c("seagreen3", "steelblue", "firebrick"))
abline(v = xbarra, lty = 2)
text(xbarra, 3.45, "media muestral", pos = 4, cex = 0.8)
