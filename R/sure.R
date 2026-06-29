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
#' <https://github.com/AFIT-R/sure>. As of right now, `sure` exports the
#' following functions:
#' \itemize{
#'   \item{`resids`} - construct (surrogate-based) residuals;
#'   \item{`plot`} - plot diagnostics using
#'   [tinyplot::tinyplot()]-based graphics;
#'   \item{`gof`} - simulate p-values from a goodness-of-fit test.
#' }
#'
#' @references
#' Liu, Dungang and Zhang, Heping. Residuals and Diagnostics for Ordinal
#' Regression Models: A Surrogate Approach.
#' *Journal of the American Statistical Association* (accepted).
#' @importFrom stats .checkMFClasses lowess median model.frame model.matrix
#'
#' @importFrom stats model.response nobs pbinom pcauchy plogis pnorm ppoints
#'
#' @importFrom stats predict qcauchy qlogis qnorm qqline qqplot qqnorm quantile
#'
#' @importFrom stats qunif runif
#'
#' @docType package
#'
#' @name sure
NULL
