#' @keywords internal
get_response_values <- function(object, ...) {
  UseMethod("get_response_values")
}


#' @keywords internal
#' @export
get_response_values.clm <- function(object, ...) {
  unname(as.integer(object$y))
}


#' @keywords internal
#' @export
get_response_values.glm <- function(object, ...) {
  y <- object$y
  if (is.null(y)) {
    y <- model.response(model.frame(object))
  }
  is_binary <- object$family$family == "binomial" && all(object$prior.weights == 1L)

  if (is_binary) {
    # Coerce to binary 0/1 numeric vector
    if (is.factor(y)) {
      y <- as.integer(y) - 1L
    } else if (is.character(y)) {
      y <- as.integer(as.factor(y)) - 1L
    } else if (is.logical(y)) {
      y <- as.integer(y)
    } else {
      uy <- sort(unique(y))
      if (length(uy) == 2L) {
        y <- as.integer(y == uy[2L])
      } else if (length(uy) == 1L) {
        if (uy %in% c(1L, 2L)) {
          y <- as.integer(y == 2L)
        } else {
          y <- as.integer(y != uy)
        }
      }
    }
    y <- as.integer(y) + 1L
  } else if (object$family$family == "binomial") {
    if (is.matrix(y)) {
      y <- y[, 1L]
    } else {
      if (any(y < 1 & y > 0)) {
        y <- round(y * object$prior.weights)
      }
    }
  }
  y
}


#' @keywords internal
#' @export
get_response_values.lrm <- function(object, ...) {
  as.integer(model.response(model.frame(object)))
}


#' @keywords internal
#' @export
get_response_values.orm <- function(object, ...) {
  as.integer(model.response(model.frame(object)))
}


#' @keywords internal
#' @export
get_response_values.polr <- function(object, ...) {
  unname(as.integer(model.response(model.frame(object))))
}


#' @keywords internal
#' @export
get_response_values.vglm <- function(object, ...) {
  unname(apply(object@y, MARGIN = 1, FUN = function(x) which(x == 1)))
}
