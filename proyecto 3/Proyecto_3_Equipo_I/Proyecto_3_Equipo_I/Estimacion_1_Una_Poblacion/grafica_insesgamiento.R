# Gráfica de la lección 1 (Class: figure en lesson.yaml).
# Histograma de 1000 medias muestrales simuladas: su centro coincide con
# la media poblacional, lo que ilustra que la media muestral es insesgada.
hist(medias_sim, breaks = 30, col = "lightblue", border = "white",
     main = "1000 medias muestrales (n = 40)",
     xlab = "Media muestral del tiempo de traslado (min)",
     ylab = "Frecuencia")
abline(v = mean(poblacion_traslado), col = "red", lwd = 3)
abline(v = mean(medias_sim), col = "darkblue", lwd = 2, lty = 2)
legend("topright", bty = "n",
       legend = c("Media poblacional (parámetro)", "Promedio de las medias"),
       col = c("red", "darkblue"), lwd = c(3, 2), lty = c(1, 2))
