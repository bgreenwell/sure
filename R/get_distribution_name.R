#' @keywords internal
get_distribution_name <- function(object) {
  UseMethod("get_distribution_name")
}


#' @keywords internal
#' @export
get_distribution_name.clm <- function(object) {
  switch(object$link,
         "logit" = "logis",
         "probit" = "norm",
         "loglog" = "gumbel",
         "cloglog" = "Gumbel",
         "cauchit" = "cauchy")
}


#' @keywords internal
#' @export
get_distribution_name.glm <- function(object) {
  link <- object$family$link
  if (link %in% c("logit", "probit", "cloglog", "cauchit")) {
    switch(link,
           "logit" = "logis",
           "probit" = "norm",
           # Y = 1 corresponds to S > 0, so P(Y = 1) = 1 - F(-eta), which
           # matches the cloglog inverse link only for Gumbel-max (#45)
           "cloglog" = "gumbel",
           "cauchit" = "cauchy")
  } else {
    "norm"
  }
}


#' @keywords internal
#' @export
get_distribution_name.lrm <- function(object) {
  "logis"
}


#' @keywords internal
#' @export
get_distribution_name.orm <- function(object) {
  switch(object$family,
         "logistic" = "logis",
         "probit" = "norm",
         "loglog" = "gumbel",
         "cloglog" = "Gumbel",
         "cauchit" = "cauchy")
}


#' @keywords internal
#' @export
get_distribution_name.polr <- function(object) {
  switch(object$method,
         "logistic" = "logis",
         "probit" = "norm",
         "loglog" = "gumbel",
         "cloglog" = "Gumbel",
         "cauchit" = "cauchy")
}


#' @keywords internal
#' @export
get_distribution_name.vglm <- function(object) {
  switch(sub("link$", "", object@family@infos()$link),
         "logit" = "logis",
         "probit" = "norm",
         "loglog" = "gumbel",
         "cloglog" = "Gumbel",
         "cauchit" = "cauchy")
}
