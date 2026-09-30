# =====================================================================
# pruebas_comunes.R
# ---------------------------------------------------------------------
# Pruebas personalizadas (AnswerTests) que usan las TRES lecciones.
#
# ¿Cómo se usan?
#   En lesson.yaml se escribe, por ejemplo:
#       AnswerTests: "objeto_es('xbarra', 'mean(traslado)')"
#   swirl evalúa ese texto y llama a la función definida aquí.
#
# ¿Cómo llegan a swirl?
#   swirl carga automáticamente el archivo customTests.R de cada lección.
#   Ese customTests.R localiza esta carpeta (funciones/) y hace source()
#   de este archivo y de funciones_hints.R.
#
# Todas las funciones obtienen el estado de swirl ('e') igual que las
# pruebas originales de swirl:  e <- get("e", parent.frame())
#   e$expr : la instrucción que escribió el estudiante (sin evaluar)
#   e$val  : el valor que produjo esa instrucción o la respuesta escrita
# Devuelven TRUE (respuesta aceptada) o FALSE (swirl muestra el Hint).
# =====================================================================


# ---------- Utilidades internas (empiezan con punto) ------------------

# Convierte un valor a vector numérico; si no se puede, devuelve NULL.
.a_numero <- function(v) {
  if (is.null(v) || is.list(v)) return(NULL)
  x <- suppressWarnings(tryCatch(as.numeric(unclass(v)),
                                 error = function(err) NULL))
  if (is.null(x) || length(x) == 0 || anyNA(x)) return(NULL)
  x
}

# ¿Dos valores numéricos son iguales salvo redondeo? (tolerancia relativa)
.cercanos <- function(a, b, tol = 1e-4) {
  a <- .a_numero(a)
  b <- .a_numero(b)
  if (is.null(a) || is.null(b) || length(a) != length(b)) return(FALSE)
  isTRUE(all.equal(a, b, tolerance = tol, check.attributes = FALSE))
}

# Evalúa un texto con código de R en el entorno de trabajo del estudiante.
.evaluar <- function(codigo) {
  eval(parse(text = codigo), envir = globalenv())
}

# Quita mayúsculas, espacios y acentos para comparar respuestas de texto.
.normalizar <- function(txt) {
  txt <- tolower(trimws(paste(txt, collapse = " ")))
  chartr("áéíóúüñ", "aeiouun", txt)
}


# ---------- Pruebas para cmd_question ---------------------------------

# El valor que produjo la instrucción coincide con 'esperado'.
# Acepta cualquier forma correcta de obtener el resultado.
# Ejemplo: valor_es('mean(poblacion_traslado)')
valor_es <- function(esperado, tol = 1e-4) {
  e <- get("e", parent.frame())
  .cercanos(e$val, .evaluar(esperado), tol)
}

# Existe el objeto 'nombre' y su valor coincide con 'esperado'.
# Ejemplo: objeto_es('xbarra', 'mean(traslado)')
objeto_es <- function(nombre, esperado, tol = 1e-4) {
  if (!exists(nombre, envir = globalenv(), inherits = FALSE)) return(FALSE)
  .cercanos(get(nombre, envir = globalenv()), .evaluar(esperado), tol)
}

# Existe el objeto 'nombre' y cumple una condición lógica.
# Útil cuando el resultado es aleatorio (simulaciones).
# Ejemplo: objeto_cumple('medias_sim', 'length(medias_sim) == 1000')
objeto_cumple <- function(nombre, condicion) {
  if (!exists(nombre, envir = globalenv(), inherits = FALSE)) return(FALSE)
  isTRUE(tryCatch(.evaluar(condicion), error = function(err) FALSE))
}

# La instrucción del estudiante utiliza la función indicada.
# Ejemplo: usa_funcion('t.test')
usa_funcion <- function(funcion) {
  e <- get("e", parent.frame())
  funcion %in% all.names(e$expr)
}


# ---------- Pruebas para exact_question y text_question ---------------

# Respuesta numérica con tolerancia (permite redondeos razonables).
# Ejemplo: num_cercano(30.06, 0.01)
num_cercano <- function(valor, tol = 0.01) {
  e <- get("e", parent.frame())
  x <- .a_numero(e$val)
  !is.null(x) && length(x) == 1 && abs(x - valor) <= tol + 1e-9
}

# Respuesta de texto: acepta cualquiera de las opciones, sin importar
# mayúsculas ni acentos.
# Ejemplo: texto_es(c('consistente', 'consistencia'))
texto_es <- function(opciones) {
  e <- get("e", parent.frame())
  .normalizar(e$val) %in% vapply(opciones, .normalizar, character(1))
}
