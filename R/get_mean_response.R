#' @keywords internal
get_mean_response <- function(object) {  # for j = 1
  UseMethod("get_mean_response")
}


#' @keywords internal
#' @export
get_mean_response.clm <- function(object) {
  # Have to do this the long way, for now! :(
  mf <- model.frame(object)
  if (!is.null(cl <- attr(object$terms, "dataClasses"))) {
    .checkMFClasses(cl, mf)
  }
  X <- model.matrix(object$terms, data = mf, contrasts = object$contrasts)
  beta_kept <- object$beta
  X_predictors <- X[, -1L, drop = FALSE]
  if (!is.null(object$aliased$beta)) {
    beta_kept <- beta_kept[!object$aliased$beta]
    X_predictors <- X_predictors[, !object$aliased$beta, drop = FALSE]
  }
  drop(X_predictors %*% beta_kept - object$alpha[1L])
}


#' @keywords internal
#' @export
get_mean_response.glm <- function(object) {
  object$linear.predictors
}


#' @keywords internal
#' @export
get_mean_response.lrm <- function(object) {
  # No negative sign since orm uses the reverse parameterization: Pr(Y >= j)
  predict(object, type = "lp", kint = 1L)
}


#' @keywords internal
#' @export
get_mean_response.orm <- function(object) {
  # No negative sign since orm uses the reverse parameterization: Pr(Y >= j)
  predict(object, type = "lp", kint = 1L)
}


#' @keywords internal
#' @export
get_mean_response.polr <- function(object) {
  # object$lp
  object$lp - object$zeta[1L]  # Xb - a1
}


#' @keywords internal
#' @export
get_mean_response.vglm <- function(object) {
  if (object@misc$reverse) {
    object@predictors[, 1L, drop = TRUE]
  } else {
    -object@predictors[, 1L, drop = TRUE]
  }
}
