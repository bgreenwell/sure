#' @keywords internal
get_quantile_function <- function(object) {
  fns <- list(
    logis = qlogis, norm = qnorm, gumbel = qgumbel, Gumbel = qGumbel,
    cauchy = qcauchy
  )
  fns[[get_distribution_name(object)]]
}
