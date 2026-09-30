# =====================================================================
# funciones_hints.R
# ---------------------------------------------------------------------
# Funciones de MÚLTIPLES HINTS para preguntas cmd_question.
#
# Cada función:
#   1. revisa si la respuesta es correcta  -> devuelve TRUE;
#   2. identifica errores frecuentes       -> mensaje específico + FALSE;
#   3. cualquier otro error                -> mensaje general + FALSE.
# Los mensajes orientan al estudiante SIN darle la instrucción completa.
#
# Relación con lesson.yaml (ejemplo):
#   - Class: cmd_question
#     CorrectAnswer: ic_prop <- p_gorro + c(-1, 1) * ...
#     AnswerTests: test_ic_proporcion()      <- llama a esta función
#     Hint: "..."                            <- pista general de respaldo
#
# | Función                    | Lección                             |
# |----------------------------|-------------------------------------|
# | test_ic_proporcion()       | Estimacion_1_Una_Poblacion          |
# | test_ic_dif_medias()       | Estimacion_2_Dos_Poblaciones        |
# | test_tamano_muestra_media()| Estimacion_3_Confianza_y_Muestra    |
#
# Requiere las utilidades de pruebas_comunes.R (.a_numero, .cercanos).
# =====================================================================


# ---------- Utilidades para analizar la instrucción del estudiante ----

# Nombre del objeto al que el estudiante asignó el resultado
# (x <- ..., x = ... o ... -> x). Si no asignó nada devuelve NA.
.nombre_asignado <- function(expr) {
  if (is.call(expr) &&
      as.character(expr[[1]]) %in% c("<-", "=", "<<-") &&
      is.name(expr[[2]])) {
    return(as.character(expr[[2]]))
  }
  NA_character_
}

# Si el resultado es correcto pero no se guardó con el nombre pedido.
.revisar_nombre <- function(expr, nombre) {
  asignado <- .nombre_asignado(expr)
  if (identical(asignado, nombre)) return(TRUE)
  if (is.na(asignado)) {
    message("¡El cálculo es correcto! Pero no lo guardaste. ",
            "Asigna el resultado al objeto ", nombre, " usando <-")
  } else {
    message("¡El cálculo es correcto! Pero lo guardaste en '", asignado,
            "'. El objeto debe llamarse exactamente ", nombre, ".")
  }
  FALSE
}


# =====================================================================
# 1) LECCIÓN 1 - Intervalo de confianza del 95% para una proporción
#    Respuesta esperada:
#    ic_prop <- p_gorro + c(-1, 1) * qnorm(0.975) *
#               sqrt(p_gorro * (1 - p_gorro) / n)
# =====================================================================
test_ic_proporcion <- function() {
  e <- get("e", parent.frame())

  # Valores de referencia (se calculan con los datos originales)
  p   <- mean(get("usa_camion", envir = globalenv()))
  m   <- length(get("usa_camion", envir = globalenv()))
  ee  <- sqrt(p * (1 - p) / m)
  correcto <- p + c(-1, 1) * qnorm(0.975) * ee

  v <- .a_numero(e$val)

  # --- Caso 0: el resultado no es numérico ----------------------------
  if (is.null(v)) {
    message("Tu instrucción no produjo números. El intervalo se construye ",
            "con p_gorro, qnorm() y sqrt().")
    return(FALSE)
  }

  # --- Respuesta correcta (acepta 1.96 en lugar de qnorm(0.975)) ------
  if (length(v) == 2 && .cercanos(v, correcto, tol = 1e-3)) {
    return(.revisar_nombre(e$expr, "ic_prop"))
  }

  # --- Error 1: calculó solo un límite (olvidó c(-1, 1)) --------------
  if (length(v) == 1) {
    if (.cercanos(v, correcto[1], 1e-3) || .cercanos(v, correcto[2], 1e-3)) {
      message("Calculaste solo UNO de los límites. Multiplica por c(-1, 1) ",
              "para obtener el límite inferior y el superior al mismo tiempo.")
    } else if (.cercanos(v, p, 1e-6)) {
      message("Ese valor es la estimación puntual p_gorro. Ahora súmale y ",
              "réstale el margen de error para formar el intervalo.")
    } else {
      message("Tu resultado es un solo número, pero un intervalo tiene dos ",
              "límites. Recuerda usar c(-1, 1).")
    }
    return(FALSE)
  }

  if (length(v) == 2) {
    centro <- mean(v)
    semiancho <- (v[2] - v[1]) / 2

    # --- Error 2: usó el conteo (8) en lugar de la proporción ---------
    if (abs(centro - sum(get("usa_camion", envir = globalenv()))) < 1) {
      message("El centro de tu intervalo es el NÚMERO de estudiantes que ",
              "usan camión. En la fórmula va la PROPORCIÓN p_gorro.")
      return(FALSE)
    }

    if (abs(centro - p) < 1e-6) {
      z_usado <- semiancho / ee

      # --- Error 3: límites invertidos (qnorm(0.025) es negativo) ----
      if (semiancho < 0) {
        message("Tus límites salieron al revés (el primero es mayor). ",
                "¿Usaste qnorm(0.025)? Ese valor es negativo; para 95% se ",
                "usa el cuantil de la cola derecha.")
        return(FALSE)
      }
      # --- Error 4: nivel de confianza equivocado --------------------
      if (abs(z_usado - qnorm(0.95)) < 0.01) {
        message("Usaste el valor crítico de 90% de confianza. Para 95% ",
                "queda 2.5% en CADA cola, no 5%.")
        return(FALSE)
      }
      if (abs(z_usado - qnorm(0.995)) < 0.01) {
        message("Ese valor crítico corresponde a 99% de confianza. ",
                "Revisa qué cuantil deja 2.5% en cada cola.")
        return(FALSE)
      }
      # --- Error 5: olvidó la raíz cuadrada --------------------------
      if (abs(semiancho - qnorm(0.975) * p * (1 - p) / m) < 1e-4) {
        message("Tu intervalo es demasiado angosto. Revisa el error ",
                "estándar: p_gorro * (1 - p_gorro) / n va dentro de sqrt().")
        return(FALSE)
      }
    }
  }

  # --- Cualquier otro error: pista general ----------------------------
  message("Revisa la estructura: estimación ± valor crítico × error ",
          "estándar. Usa p_gorro, qnorm(), sqrt() y c(-1, 1).")
  FALSE
}


# =====================================================================
# 2) LECCIÓN 2 - Intervalo del 95% para la diferencia de medias
#    Respuesta esperada:
#    ic_dif <- t.test(matutino, vespertino)$conf.int
# =====================================================================
test_ic_dif_medias <- function() {
  e <- get("e", parent.frame())

  x <- get("matutino",   envir = globalenv())
  y <- get("vespertino", envir = globalenv())
  correcto <- t.test(x, y)$conf.int

  # --- Error 1: guardó todo el objeto de t.test() ---------------------
  if (inherits(e$val, "htest")) {
    message("Guardaste el resultado COMPLETO de t.test(). Solo necesitamos ",
            "el intervalo: extrae el componente conf.int con el operador $.")
    return(FALSE)
  }

  v <- .a_numero(e$val)
  if (is.null(v)) {
    message("Tu instrucción no produjo un intervalo numérico. ",
            "Usa t.test() con los dos grupos y extrae conf.int.")
    return(FALSE)
  }

  # --- Respuesta correcta ---------------------------------------------
  if (.cercanos(v, correcto, 1e-4)) {
    return(.revisar_nombre(e$expr, "ic_dif"))
  }

  # --- Error 2: calculó solo la estimación puntual --------------------
  if (length(v) == 1 && .cercanos(v, mean(x) - mean(y), 1e-6)) {
    message("Ese número es la estimación PUNTUAL de la diferencia. ",
            "Ahora necesitamos el INTERVALO; t.test() lo calcula por ti.")
    return(FALSE)
  }

  if (length(v) == 2) {
    # --- Error 3: orden invertido (vespertino - matutino) -------------
    if (.cercanos(v, -rev(correcto), 1e-4)) {
      message("Tu intervalo tiene los signos invertidos: calculaste ",
              "vespertino - matutino. El primer grupo debe ser matutino.")
      return(FALSE)
    }
    # --- Error 4: intervalo de un solo grupo --------------------------
    if (.cercanos(v, t.test(x)$conf.int, 1e-4) ||
        .cercanos(v, t.test(y)$conf.int, 1e-4)) {
      message("Ese es el intervalo de la media de UN solo turno. ",
              "Para estimar la diferencia, t.test() debe recibir ambos grupos.")
      return(FALSE)
    }
    # --- Error 5: supuso varianzas iguales ----------------------------
    if (.cercanos(v, t.test(x, y, var.equal = TRUE)$conf.int, 1e-4)) {
      message("Usaste var.equal = TRUE (varianzas iguales). En esta lección ",
              "usamos el intervalo de Welch, que es el predeterminado.")
      return(FALSE)
    }
    # --- Error 6: nivel de confianza distinto de 95% ------------------
    if (abs(mean(v) - (mean(x) - mean(y))) < 1e-6) {
      message("El centro de tu intervalo es correcto, pero el ancho no. ",
              "Revisa el nivel de confianza: queremos 95%, que es el ",
              "valor predeterminado de t.test().")
      return(FALSE)
    }
  }

  # --- Cualquier otro error -------------------------------------------
  message("Revisa tu instrucción: necesitas t.test() con los dos turnos ",
          "(primero matutino) y extraer $conf.int.")
  FALSE
}


# =====================================================================
# 3) LECCIÓN 3 - Tamaño de muestra para estimar una media
#    95% de confianza, sigma = 0.8 s, margen de error E = 0.15 s
#    Respuesta esperada:
#    n_media <- ceiling((qnorm(0.975) * sigma / 0.15)^2)   # = 110
# =====================================================================
test_tamano_muestra_media <- function() {
  e <- get("e", parent.frame())

  s <- get("sigma", envir = globalenv())
  E <- 0.15
  sin_redondear <- (qnorm(0.975) * s / E)^2      # 109.27...
  correcto <- ceiling(sin_redondear)             # 110

  v <- .a_numero(e$val)
  if (is.null(v) || length(v) != 1) {
    message("El resultado debe ser UN solo número: el tamaño de muestra.")
    return(FALSE)
  }

  # --- Respuesta correcta ---------------------------------------------
  if (v == correcto) {
    return(.revisar_nombre(e$expr, "n_media"))
  }

  # --- Error 1: no redondeó -------------------------------------------
  if (abs(v - sin_redondear) < 0.05) {
    message("Obtuviste ", round(v, 2), ", pero no se pueden observar ",
            "fracciones de datos. Redondea el resultado a un entero.")
    return(FALSE)
  }
  # --- Error 2: redondeó hacia abajo (round o floor) ------------------
  if (v == floor(sin_redondear)) {
    message("Redondeaste hacia abajo. Con ", v, " datos el margen de error ",
            "quedaría un poco ARRIBA de 0.15. En tamaño de muestra siempre ",
            "se redondea hacia arriba: busca la función que hace eso.")
    return(FALSE)
  }
  # --- Error 3: nivel de confianza equivocado -------------------------
  n90 <- (qnorm(0.95)  * s / E)^2
  n99 <- (qnorm(0.995) * s / E)^2
  if (abs(v - n90) < 1 || v == ceiling(n90)) {
    message("Ese tamaño corresponde a 90% de confianza. Para 95% ",
            "el valor crítico deja 2.5% en cada cola.")
    return(FALSE)
  }
  if (abs(v - n99) < 1 || v == ceiling(n99)) {
    message("Ese tamaño corresponde a 99% de confianza. ",
            "Revisa el cuantil que usaste en qnorm().")
    return(FALSE)
  }
  # --- Error 4: olvidó elevar al cuadrado -----------------------------
  raiz <- qnorm(0.975) * s / E
  if (abs(v - raiz) < 0.05 || v == ceiling(raiz)) {
    message("Tu resultado es muy pequeño. Revisa la fórmula completa: ",
            "todo el cociente (z * sigma / E) se eleva al cuadrado.")
    return(FALSE)
  }
  # --- Error 5: invirtió sigma y E ------------------------------------
  invertido <- (qnorm(0.975) * E / s)^2
  if (abs(v - invertido) < 0.01 || v == ceiling(invertido)) {
    message("Parece que intercambiaste sigma y E. La desviación estándar ",
            "va en el numerador y el margen de error en el denominador.")
    return(FALSE)
  }

  # --- Cualquier otro error -------------------------------------------
  message("Revisa la fórmula n = (z * sigma / E)^2 con z para 95%, ",
          "sigma = 0.8 y E = 0.15; después redondea hacia arriba.")
  FALSE
}
