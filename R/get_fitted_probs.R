#' @keywords internal
get_fitted_probs <- function(object) {
  UseMethod("get_fitted_probs")
}


#' @keywords internal
#' @export
get_fitted_probs.clm <- function(object) {
  newdata <- stats::model.frame(object)
  vars <- as.character(attr(object$terms, "variables"))
  resp <- vars[1 + attr(object$terms, "response")]  # response name
  newdata <- newdata[!names(newdata) %in% resp]
  predict(object, newdata = newdata, type = "prob")$fit
}


#' @keywords internal
#' @export
get_fitted_probs.glm <- function(object) {
  prob <- object$fitted.values
  cbind(prob, 1 - prob)
}


#' @keywords internal
#' @export
get_fitted_probs.lrm <- function(object) {
  predict(object, type = "fitted.ind")
}


#' @keywords internal
#' @export
get_fitted_probs.orm <- function(object) {
  predict(object, type = "fitted.ind")
}


#' @keywords internal
#' @export
get_fitted_probs.polr <- function(object) {
  object$fitted.values
}


#' @keywords internal
#' @export
get_fitted_probs.vglm <- function(object) {
  object@fitted.values
}
