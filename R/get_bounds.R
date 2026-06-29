#' @keywords internal
get_bounds <- function(object, ...) {
  UseMethod("get_bounds")
}


#' @keywords internal
#' @export
get_bounds.clm <- function(object, ...) {
  unname(
    c(-Inf, stats::coef(object)[seq_len(ncat(object) - 1)] -
        stats::coef(object)[1L], Inf)
  )
}


#' @keywords internal
#' @export
get_bounds.glm <- function(object, ...) {
  y <- get_response_values(object)
  c(ifelse(y == 1, yes = -Inf, no = 0), ifelse(y == 2, yes = Inf, no = 0))
}


#' @keywords internal
#' @export
get_bounds.lrm <- function(object, ...) {
  coefs <- -unname(stats::coef(object))
  c(-Inf, coefs[seq_len(ncat(object) - 1)] - coefs[1L], Inf)
}


#' @keywords internal
#' @export
get_bounds.orm <- function(object, ...) {
  coefs <- -unname(stats::coef(object))
  c(-Inf, coefs[seq_len(ncat(object) - 1)] - coefs[1L], Inf)
}


#' @keywords internal
#' @export
get_bounds.polr <- function(object, ...) {
  unname(
    c(-Inf, object$zeta - object$zeta[1L], Inf)
  )
}


#' @keywords internal
#' @export
get_bounds.vglm <- function(object, ...) {
  coefs <- if (object@misc$reverse) {
    -unname(stats::coef(object))
  } else {
    unname(stats::coef(object))
  }
  c(-Inf, coefs[seq_len(ncat(object) - 1)] - coefs[1L], Inf)
}
