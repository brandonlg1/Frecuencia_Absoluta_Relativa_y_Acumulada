# Gráfica de la lección 2 (Class: figure en lesson.yaml).
# Diagramas de caja de las calificaciones de ambos turnos; el punto rojo
# marca la media de cada grupo.
boxplot(list(Matutino = matutino, Vespertino = vespertino),
        col = c("lightgoldenrod", "lightsteelblue"),
        main = "Calificaciones del parcial por turno",
        ylab = "Calificación")
points(1:2, c(mean(matutino), mean(vespertino)), pch = 19, col = "red", cex = 1.4)
legend("bottomleft", legend = "Media muestral", pch = 19, col = "red", bty = "n")
