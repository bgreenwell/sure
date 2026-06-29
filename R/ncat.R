#' @keywords internal
ncat <- function(object) {
  UseMethod("ncat")
}


#' @keywords internal
#' @export
ncat.clm <- function(object) {
  length(object$y.levels)
}


#' @keywords internal
#' @export
ncat.glm <- function(object) {
  length(unique(get_response_values(object)))
}


#' @keywords internal
#' @export
ncat.lrm <- function(object) {
  object$non.slopes + 1
}


#' @keywords internal
#' @export
ncat.orm <- function(object) {
  object$non.slopes + 1
}


#' @keywords internal
#' @export
ncat.polr <- function(object) {
  length(object$lev)
}


#' @keywords internal
#' @export
ncat.vglm <- function(object) {
  length(attributes(object)$extra$colnames.y)
}
