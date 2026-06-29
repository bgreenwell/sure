#' @keywords internal
get_distribution_function <- function(object) {
  UseMethod("get_distribution_function")
}


#' @keywords internal
#' @export
get_distribution_function.clm <- function(object) {
  switch(object$link,
         "logit" = plogis,
         "probit" = pnorm,
         "loglog" = pgumbel,
         "cloglog" = pGumbel,
         "cauchit" = pcauchy)
}


#' @keywords internal
#' @export
get_distribution_function.glm <- function(object) {
  link <- object$family$link
  if (link %in% c("logit", "probit", "cloglog", "cauchit")) {
    switch(link,
           "logit" = plogis,
           "probit" = pnorm,
           "cloglog" = pGumbel,
           "cauchit" = pcauchy)
  } else {
    pnorm
  }
}


#' @keywords internal
#' @export
get_distribution_function.lrm <- function(object) {
  plogis
}


#' @keywords internal
#' @export
get_distribution_function.orm <- function(object) {
  switch(object$family,
         "logistic" = plogis,
         "probit" = pnorm,
         "loglog" = pgumbel,
         "cloglog" = pGumbel,
         "cauchit" = pcauchy)
}


#' @keywords internal
#' @export
get_distribution_function.polr <- function(object) {
  switch(object$method,
         "logistic" = plogis,
         "probit" = pnorm,
         "loglog" = pgumbel,
         "cloglog" = pGumbel,
         "cauchit" = pcauchy)
}


#' @keywords internal
#' @export
get_distribution_function.vglm <- function(object) {
  switch(sub("link$", "", object@family@infos()$link),
         "logit" = plogis,
         "probit" = pnorm,
         "loglog" = pgumbel,
         "cloglog" = pGumbel,
         "cauchit" = pcauchy)
}
