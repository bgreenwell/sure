#' Surrogate response
#'
#' Simulate surrogate response values for cumulative link regression models
#' using the latent method described in Liu and Zhang (2017).
#'
#' @param object An object of class [ordinal::clm()],
#' [stats::glm()] [rms::lrm()], [rms::orm()],
#' [MASS::polr()], or [VGAM::vglm()].
#'
#' @param nsim Integer specifying the number of bootstrap replicates to use.
#' Default is `1L` meaning no bootstrap samples.
#'
#' @param method Character string specifying which method to use to generate the
#' surrogate response values. Current options are `"latent"` and
#' `"jitter"`. Default is `"latent"`.
#'
#' @param jitter_scale Character string specifyint the scale on which to perform
#' the jittering whenever `method = "jitter"`. Current options are
#' `"response"` and `"probability"`. Default is `"response"`.
#'
#' @param ... Additional optional arguments. (Currently ignored.)
#'
#' @return A numeric vector of class `c("numeric", "surrogate")` containing
#' the simulated surrogate response values. Additionally, if `nsim` > 1,
#' then the result will contain the attributes:
#' \describe{
#'   \item{`boot_reps`}{A matrix  with `nsim` columns, one for each
#'   bootstrap replicate of the surrogate values. Note, these are random and do
#'   not correspond to the original ordering of the data;}
#'   \item{`boot_id`}{A matrix  with `nsim` columns. Each column
#'   contains the observation number each surrogate value corresponds to in
#'   `boot_reps`. (This is used for plotting purposes.)}
#' }
#'
#' @note
#' Surrogate response values require sampling from a continuous distribution;
#' consequently, the result will be different with every call to
#' `surrogate`. The internal functions used for sampling from truncated
#' distributions are based on modified versions of
#' [truncdist::rtrunc()] and [truncdist::qtrunc()].
#'
#' For `"glm"` objects, only the `binomial()` family is supported.
#'
#' @references
#' Liu, Dungang and Zhang, Heping. Residuals and Diagnostics for Ordinal
#' Regression Models: A Surrogate Approach.
#' *Journal of the American Statistical Association* (accepted). URL
#' http://www.tandfonline.com/doi/abs/10.1080/01621459.2017.1292915?journalCode=uasa20
#'
#' Nadarajah, Saralees and Kotz, Samuel. R Programs for Truncated Distributions.
#' *Journal of Statistical Software, Code Snippet*, 16(2), 1-8, 2006. URL
#' https://www.jstatsoft.org/v016/c02.
#'
#' @export
#'
#' @examples
#' # Generate data from a quadratic probit model
#' set.seed(101)
#' n <- 2000
#' x <- runif(n, min = -3, max = 6)
#' z <- 10 + 3*x - 1*x^2 + rnorm(n)
#' y <- ifelse(z <= 0, yes = 0, no = 1)
#'
#' # Scatterplot matrix
#' pairs(~ x + y + z)
#'
#' # Setup for side-by-side plots
#' par(mfrow = c(1, 2))
#'
#' # Misspecified mean structure
#' fm1 <- glm(y ~ x, family = binomial(link = "probit"))
#' s1 <- surrogate(fm1)
#' scatter.smooth(x, s1 - fm1$linear.predictors,
#'                main = "Misspecified model",
#'                ylab = "Surrogate residual",
#'                lpars = list(lwd = 3, col = "red2"))
#' abline(h = 0, lty = 2, col = "blue2")
#'
#' # Correctly specified mean structure
#' fm2 <- glm(y ~ x + I(x ^ 2), family = binomial(link = "probit"))
#' s2 <- surrogate(fm2)
#' scatter.smooth(x, s2 - fm2$linear.predictors,
#'                main = "Correctly specified model",
#'                ylab = "Surrogate residual",
#'                lpars = list(lwd = 3, col = "red2"))
#' abline(h = 0, lty = 2, col = "blue2")
surrogate <- function(object, nsim = 1L, method = c("latent", "jitter"),
                      jitter_scale = c("response", "probability"), ...) {

  # Match arguments
  method <- match.arg(method)
  jitter_scale = match.arg(jitter_scale)

  # Issue warning for jittering method
  if (method == "jitter") {
    warning("Jittering is an experimental feature, use at your own risk!",
            call. = FALSE)
  }

  # Generate surrogate response values
  s <- generate_surrogate(object, method = method, jitter_scale = jitter_scale)

  # Multiple (re)samples
  if (nsim > 1L) {  # bootstrap
    boot_results <- run_bootstrap_reps(
      object, nsim = nsim, fun = generate_surrogate,
      method = method, jitter_scale = jitter_scale
    )
    attr(s, "boot_reps") <- boot_results$boot_reps
    attr(s, "boot_id") <- boot_results$boot_id
  }

  # Pad main residuals if needed
  if (!is.null(stats::na.action(object))) {
    s <- stats::naresid(stats::na.action(object), s)
  }

  # Return residuals
  class(s) <- c("numeric", "surrogate")
  if (method == "jitter") {
    attr(s, "jitter_scale") <- jitter_scale
  }
  s

}
