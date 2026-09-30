# =====================================================================
# customTests.R
# ---------------------------------------------------------------------
# swirl carga AUTOMÁTICAMENTE este archivo al iniciar la lección.
# Las funciones que existan aquí pueden usarse en el campo AnswerTests
# de lesson.yaml.
#
# Para no repetir código en las tres lecciones, este archivo solo
# localiza la carpeta compartida ../funciones/ y carga:
#   - pruebas_comunes.R  (valor_es, objeto_es, num_cercano, texto_es...)
#   - funciones_hints.R  (funciones de múltiples hints)
# =====================================================================

.carpeta_funciones <- local({
  ruta_leccion <- NULL

  # 1) source() guarda la ruta del archivo que está leyendo en 'ofile'.
  for (marco in rev(sys.frames())) {
    if (exists("ofile", envir = marco, inherits = FALSE)) {
      ruta_leccion <- dirname(get("ofile", envir = marco))
      break
    }
  }

  # 2) Respaldo: swirl guarda la ruta de la lección en e$path.
  if (is.null(ruta_leccion)) {
    for (marco in rev(sys.frames())) {
      if (exists("e", envir = marco, inherits = FALSE)) {
        e_swirl <- get("e", envir = marco)
        if (is.environment(e_swirl) && !is.null(e_swirl$path)) {
          ruta_leccion <- e_swirl$path
          break
        }
      }
    }
  }

  # 3) Candidatos: junto a la lección o desde el directorio de trabajo.
  candidatos <- c(
    if (!is.null(ruta_leccion)) file.path(ruta_leccion, "..", "funciones"),
    file.path(getwd(), "funciones"),
    file.path(getwd(), "..", "funciones")
  )
  encontrados <- candidatos[file.exists(file.path(candidatos, "funciones_hints.R"))]
  if (length(encontrados) == 0) {
    stop("No se encontró la carpeta 'funciones'. Verifica que la lección ",
         "esté dentro de la carpeta del proyecto (Proyecto_3_Equipo_I).")
  }
  normalizePath(encontrados[1])
})

# Se cargan en ESTE entorno para que swirl pueda llamarlas desde AnswerTests.
source(file.path(.carpeta_funciones, "pruebas_comunes.R"), local = environment(),
       encoding = "UTF-8")
source(file.path(.carpeta_funciones, "funciones_hints.R"), local = environment(),
       encoding = "UTF-8")
