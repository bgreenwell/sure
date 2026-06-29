#' Simulate Data for Diagnostic Plots
#'
#' Generate simulated data sets designed to illustrate various model
#' misspecifications and diagnostics for ordinal regression models, as
#' described in Liu and Zhang (2017).
#'
#' @param n Integer specifying the number of observations to simulate. Default is
#' `2000`.
#' @param type Character string specifying the type of data/model to simulate.
#' Default is `"quadratic"` (linear relation with a quadratic trend). Other options
#' include: `"heteroscedastic"` (non-constant variance), `"gumbel"` (Gumbel
#' error distribution), `"proportionality"` (non-proportional hazards), and
#' `"interaction"` (interaction effect).
#' @param ... Additional optional arguments (currently ignored).
#'
#' @return A data frame containing the simulated predictor(s) and the ordered
#' factor response variable `y`.
#'
#' @references
#' Liu, Dungang and Zhang, Heping. Residuals and Diagnostics for Ordinal
#' Regression Models: A Surrogate Approach.
#' *Journal of the American Statistical Association* (accepted).
#'
#' @export
#'
#' @examples
#' # Simulate quadratic data
#' set.seed(101)
#' df <- sim_data(n = 500, type = "quadratic")
#' head(df)
sim_data <- function(
  n = 2000,
  type = c("quadratic", "heteroscedastic", "gumbel", "proportionality", "interaction"),
  ...
) {

  # Match type argument
  type <- match.arg(type)

  # Check that n is a positive integer
  if ((n <- as.integer(n)) < 2) {
    stop("n must be an integer >= 2", call. = FALSE)
  }

  # Helper to discretize continuous latent variable z
  discretize <- function(z, threshold) {
    as.ordered(findInterval(z, threshold) + 1L)
  }

  switch(type,
    "quadratic" = {
      threshold <- c(0, 4, 8)
      x <- stats::runif(n, min = 1, max = 7)
      z <- 16 - 8 * x + 1 * x ^ 2 + stats::rnorm(n)
      data.frame("y" = discretize(z, threshold), "x" = x)
    },
    "heteroscedastic" = {
      threshold <- c(0, 30, 70, 100)
      x <- stats::runif(n, min = 2, max = 7)
      z <- 36 + 4 * x + stats::rnorm(n, sd = x ^ 2)
      data.frame("y" = discretize(z, threshold), "x" = x)
    },
    "gumbel" = {
      threshold <- c(0, 4, 8)
      x <- stats::runif(n, min = 1, max = 7)
      z <- 16 - 8 * x + 1 * x ^ 2 + rgumbel(n)
      data.frame("y" = discretize(z, threshold), "x" = x)
    },
    "proportionality" = {
      # Returns exactly n rows by dividing n between the two groups
      n2 <- ceiling(n / 2)
      x <- stats::runif(n2, min = -3, max = 3)
      z1 <- 0 - 1 * x + stats::rnorm(n2)
      z2 <- 0 - 1.5 * x + stats::rnorm(n2)
      y1 <- findInterval(z1, c(-1.5, 0)) + 1L
      y2 <- findInterval(z2, c(1, 3)) + 1L
      df <- data.frame(
        "y" = as.ordered(c(y1, y2)),
        "x" = c(x, x)
      )
      df[seq_len(n), , drop = FALSE]
    },
    "interaction" = {
      threshold <- c(0, 20, 40)
      x1 <- stats::runif(n, min = 1, max = 7)
      x2 <- gl(2, ceiling(n / 2), length = n, labels = c("Control", "Treatment"))
      z <- 16 - 5 * x1 + 3 * (x2 == "Treatment") + 10 * x1 * (x2 == "Treatment") + stats::rnorm(n)
      data.frame("y" = discretize(z, threshold), "x1" = x1, "x2" = x2)
    }
  )

}
