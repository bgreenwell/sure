#' sure: Surrogate Residuals for Ordinal and General Regression Models
#'
#' The `sure` package provides surrogate-based residuals for fitted ordinal
#' and general (e.g., binary) regression models of class
#' [ordinal::clm()], [stats::glm()], [rms::lrm()], [rms::orm()],
#' [MASS::polr()], or [VGAM::vglm()], as well as multinomial models and
#' general classifiers via a matrix of predicted class probabilities. Start
#' with [resids()], then plot the result with [plot.resid()].
#'
#' @references
#' Liu, Dungang and Zhang, Heping. Residuals and Diagnostics for Ordinal
#' Regression Models: A Surrogate Approach.
#' *Journal of the American Statistical Association*, 113(522), 845-854, 2018.
#' \doi{10.1080/01621459.2017.1292915}
#'
#' Greenwell, Brandon M., McCarthy, Andrew J., Boehmke, Bradley C. and Liu,
#' Dungang. Residuals and Diagnostics for Binary and Ordinal Regression Models:
#' An Introduction to the sure Package. *The R Journal*, 10(1), 2018.
#' \doi{10.32614/RJ-2018-004}
#'
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
