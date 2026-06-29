#' @keywords internal
get_quantile_function <- function(object) {
  UseMethod("get_quantile_function")
}


#' @keywords internal
#' @export
get_quantile_function.clm <- function(object) {
  switch(object$link,
         "logit" = qlogis,
         "probit" = qnorm,
         "loglog" = qgumbel,
         "cloglog" = qGumbel,
         "cauchit" = qcauchy)
}


#' @keywords internal
#' @export
get_quantile_function.glm <- function(object) {
  link <- object$family$link
  if (link %in% c("logit", "probit", "cloglog", "cauchit")) {
    switch(link,
           "logit" = qlogis,
           "probit" = qnorm,
           "cloglog" = qGumbel,
           "cauchit" = qcauchy)
  } else {
    qnorm
  }
}


#' @keywords internal
#' @export
get_quantile_function.lrm <- function(object) {
  qlogis
}


#' @keywords internal
#' @export
get_quantile_function.orm <- function(object) {
  switch(object$family,
         "logistic" = qlogis,
         "probit" = qnorm,
         "loglog" = qgumbel,
         "cloglog" = qGumbel,
         "cauchit" = qcauchy)
}


#' @keywords internal
#' @export
get_quantile_function.polr <- function(object) {
  switch(object$method,
         "logistic" = qlogis,
         "probit" = qnorm,
         "loglog" = qgumbel,
         "cloglog" = qGumbel,
         "cauchit" = qcauchy)
}


#' @keywords internal
#' @export
get_quantile_function.vglm <- function(object) {
  switch(sub("link$", "", object@family@infos()$link),
         "logit" = qlogis,
         "probit" = qnorm,
         "loglog" = qgumbel,
         "cloglog" = qGumbel,
         "cauchit" = qcauchy)
}
