#' sure: An R package for constructing surrogate-based residuals and diagnostics
#' for ordinal and general regression models.
#'
#' The `sure` package provides surrogate-based residuals for fitted ordinal
#' and general (e.g., binary) regression models of class
#' [ordinal::clm()], [stats::glm()], [rms::lrm()],
#' [rms::orm()], [MASS::polr()], or
#' [VGAM::vglm()].
#'
#' The development version can be found on GitHub:
#' <https://github.com/bgreenwell/sure>. As of right now, `sure` exports the
#' following functions:
#'
#' - `resids()` - construct (surrogate-based) residuals;
#' - `plot()` - plot diagnostics using [tinyplot::tinyplot()]-based graphics;
#' - `gof()` - simulate p-values from a goodness-of-fit test.
#'
#' @references
#' Liu, Dungang and Zhang, Heping. Residuals and Diagnostics for Ordinal
#' Regression Models: A Surrogate Approach.
#' *Journal of the American Statistical Association* (accepted).
#' @importFrom stats .checkMFClasses lowess median model.frame model.matrix
#'
#' @importFrom stats model.response nobs pbinom pcauchy pgamma plogis pnbinom
#' @importFrom stats pnorm ppoints ppois
#'
#' @importFrom stats predict qcauchy qlogis qnorm qqline qqplot qqnorm quantile
#'
#' @importFrom stats qunif runif
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
