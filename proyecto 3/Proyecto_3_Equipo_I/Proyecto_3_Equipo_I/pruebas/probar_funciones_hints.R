# =====================================================================
# probar_funciones_hints.R
# ---------------------------------------------------------------------
# Prueba las funciones de múltiples hints SIN abrir swirl.
# Simula respuestas correctas e incorrectas de un estudiante y muestra
# qué mensaje daría cada función.
#
# Uso (con el proyecto de RStudio abierto en la carpeta del equipo):
#   source("pruebas/probar_funciones_hints.R")
#
# No forma parte de las lecciones: es una herramienta del equipo para
# comprobar que la retroalimentación funciona antes del commit final.
# =====================================================================

# Carpeta del proyecto: se deduce de la ubicación de este script
# (funciona desde la raíz del repositorio o desde la carpeta del equipo).
.raiz <- local({
  for (marco in rev(sys.frames())) {
    if (exists("ofile", envir = marco, inherits = FALSE)) {
      return(normalizePath(file.path(dirname(get("ofile", envir = marco)), "..")))
    }
  }
  if (file.exists("funciones/funciones_hints.R")) "." else ".."
})
source(file.path(.raiz, "funciones", "pruebas_comunes.R"), encoding = "UTF-8")
source(file.path(.raiz, "funciones", "funciones_hints.R"), encoding = "UTF-8")

# Ejecuta la función de prueba como lo haría swirl:
# crea el estado 'e' con la instrucción (expr) y su resultado (val).
simular <- function(funcion_prueba, instruccion, esperado) {
  e <- new.env()
  e$expr <- parse(text = instruccion)[[1]]
  e$val  <- eval(e$expr, globalenv())
  cat("\n>", instruccion, "\n")
  resultado <- funcion_prueba()          # la función busca 'e' aquí
  estado <- if (identical(resultado, esperado)) "OK" else "REVISAR"
  cat("   Resultado:", resultado, "| Esperado:", esperado, "->", estado, "\n")
  invisible(identical(resultado, esperado))
}

resultados <- c()

# ---------------------------------------------------------------------
cat("\n================ LECCIÓN 1: test_ic_proporcion() ================\n")
source(file.path(.raiz, "Estimacion_1_Una_Poblacion", "initLesson.R"), encoding = "UTF-8")
p_gorro <- mean(usa_camion); n <- length(usa_camion)
casos1 <- list(
  c("ic_prop <- p_gorro + c(-1, 1) * qnorm(0.975) * sqrt(p_gorro * (1 - p_gorro) / n)", TRUE),
  c("ic_prop <- p_gorro + c(-1, 1) * 1.96 * sqrt(p_gorro * (1 - p_gorro) / n)",        TRUE),
  c("p_gorro + c(-1, 1) * qnorm(0.975) * sqrt(p_gorro * (1 - p_gorro) / n)",          FALSE), # no guardó
  c("ic_prop <- p_gorro + qnorm(0.975) * sqrt(p_gorro * (1 - p_gorro) / n)",          FALSE), # un límite
  c("ic_prop <- p_gorro + c(-1, 1) * qnorm(0.95) * sqrt(p_gorro * (1 - p_gorro) / n)",FALSE), # 90%
  c("ic_prop <- p_gorro + c(-1, 1) * qnorm(0.025) * sqrt(p_gorro * (1 - p_gorro) / n)",FALSE),# invertido
  c("ic_prop <- p_gorro + c(-1, 1) * qnorm(0.975) * p_gorro * (1 - p_gorro) / n",     FALSE), # sin sqrt
  c("ic_prop <- sum(usa_camion) + c(-1, 1) * qnorm(0.975) * sqrt(p_gorro * (1 - p_gorro) / n)", FALSE), # conteo
  c("ic_prop <- c(0.1, 0.3)",                                                         FALSE)  # otro
)
for (k in casos1) resultados <- c(resultados, simular(test_ic_proporcion, k[1], as.logical(k[2])))

# ---------------------------------------------------------------------
cat("\n================ LECCIÓN 2: test_ic_dif_medias() ================\n")
source(file.path(.raiz, "Estimacion_2_Dos_Poblaciones", "initLesson.R"), encoding = "UTF-8")
casos2 <- list(
  c("ic_dif <- t.test(matutino, vespertino)$conf.int",                  TRUE),
  c("ic_dif <- t.test(matutino, vespertino)",                           FALSE), # objeto completo
  c("ic_dif <- t.test(vespertino, matutino)$conf.int",                  FALSE), # orden invertido
  c("ic_dif <- t.test(matutino)$conf.int",                              FALSE), # un grupo
  c("ic_dif <- mean(matutino) - mean(vespertino)",                      FALSE), # solo puntual
  c("ic_dif <- t.test(matutino, vespertino, var.equal = TRUE)$conf.int",FALSE), # var. iguales
  c("ic_dif <- t.test(matutino, vespertino, conf.level = 0.90)$conf.int",FALSE),# 90%
  c("t.test(matutino, vespertino)$conf.int",                            FALSE), # no guardó
  c("ic_dif <- c(1, 2)",                                                FALSE)  # otro
)
for (k in casos2) resultados <- c(resultados, simular(test_ic_dif_medias, k[1], as.logical(k[2])))

# ---------------------------------------------------------------------
cat("\n============= LECCIÓN 3: test_tamano_muestra_media() =============\n")
source(file.path(.raiz, "Estimacion_3_Confianza_y_Muestra", "initLesson.R"), encoding = "UTF-8")
casos3 <- list(
  c("n_media <- ceiling((qnorm(0.975) * sigma / 0.15)^2)", TRUE),
  c("n_media <- ceiling((1.96 * sigma / 0.15)^2)",         TRUE),
  c("n_media <- (qnorm(0.975) * sigma / 0.15)^2",          FALSE), # sin redondear
  c("n_media <- round((qnorm(0.975) * sigma / 0.15)^2)",   FALSE), # round
  c("n_media <- ceiling((qnorm(0.95) * sigma / 0.15)^2)",  FALSE), # 90%
  c("n_media <- ceiling((qnorm(0.995) * sigma / 0.15)^2)", FALSE), # 99%
  c("n_media <- ceiling(qnorm(0.975) * sigma / 0.15)",     FALSE), # sin cuadrado
  c("n_media <- ceiling((qnorm(0.975) * 0.15 / sigma)^2)", FALSE), # invertido
  c("ceiling((qnorm(0.975) * sigma / 0.15)^2)",            FALSE), # no guardó
  c("n_media <- 50",                                       FALSE)  # otro
)
for (k in casos3) resultados <- c(resultados, simular(test_tamano_muestra_media, k[1], as.logical(k[2])))

cat("\n==================================================================\n")
cat("Casos correctos:", sum(resultados), "de", length(resultados), "\n")
