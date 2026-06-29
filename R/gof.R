#' Goodness-of-Fit Simulation
#'
#' Simulate p-values from a goodness-of-fit test.
#'
#' @param object An object of class [ordinal::clm()],
#' [stats::glm()], [rms::lrm()], [rms::orm()],
#' [MASS::polr()], or [VGAM::vglm()].
#'
#' @param nsim Integer specifying the number of bootstrap replicates to use.
#'
#' @param test Character string specifying which goodness-of-fit test to use.
#' Current options include: `"ks"` for the Kolmogorov-Smirnov test,
#' `"ad"` for the Anderson-Darling test, and `"cvm"` for the
#' Cramer-Von Mises test. Default is `"ks"`.
#'
#' @param ... Additional optional arguments. (Currently ignored.)
#'
#' @param x An object of class `"gof"`.
#'
#' @return A numeric vector of class `"gof", "numeric"` containing the
#' simulated p-values.
#'
#' @details
#' Under the null hypothesis, the distribution of the p-values should appear
#' uniformly distributed on the interval \verb{[0, 1]}. This can be visually
#' investigated using the `plot` method. A 45 degree line is indicative of
#' a "good" fit.
#'
#' @rdname gof
#'
#' @export
#'
#' @examples
#' # See ?resids for an example
#' ?resids
gof <- function(object, nsim = 10, test = c("ks", "ad", "cvm"), ...) {
  if ((nsim <- as.integer(nsim)) < 2) {
    stop("nsim must be a positive integer >= 2")
  }
  UseMethod("gof")
}


#' @rdname gof
#'
#' @export
gof.default <- function(object, nsim = 10, test = c("ks", "ad", "cvm"), ...) {
  test <- match.arg(test)
  if (test %in% c("ad", "cvm") && !requireNamespace("goftest", quietly = TRUE)) {
    stop("Package \"goftest\" is required for the Anderson-Darling and Cramér-von Mises tests. Please install it.", call. = FALSE)
  }
  res <- resids(object, nsim = nsim)
  pfun <- get_distribution_function(object)
  sim_pvals(res, test = test, pfun = pfun)
}


#' @rdname gof
#'
#' @export
plot.gof <- function(x, ...) {
  graphics::plot(stats::ecdf(x), xlab = "p-value", xlim = c(0, 1), ...)
  graphics::abline(0, 1, lty = 2)
}


#' @keywords internal
sim_pvals <- function(res, test, pfun) {
  gof_test <- switch(test, "ks" = stats::ks.test, "ad" = goftest::ad.test,
                     "cvm" = goftest::cvm.test)
  pvals <- apply(attr(res, "boot_reps"), MARGIN = 2, FUN = function(x) {
    gof_test(x, pfun)$p.value
  })
  class(pvals) <- c("gof", "numeric")
  pvals
}
