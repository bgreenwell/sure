#' @keywords internal
get_distribution_function <- function(object) {
  fns <- list(
    logis = plogis, norm = pnorm, gumbel = pgumbel, Gumbel = pGumbel,
    cauchy = pcauchy
  )
  fns[[get_distribution_name(object)]]
}
