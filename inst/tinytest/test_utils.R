# Test Utility functions

df1 <- sim_data(type = "quadratic")

# --- clm objects ---
if (tinytest::at_home() && requireNamespace("ordinal", quietly = TRUE)) {
  library(ordinal)
  fit.logit <- ordinal::clm(y ~ x + I(x ^ 2), data = df1, link = "logit")
  fit.probit <- ordinal::clm(y ~ x + I(x ^ 2), data = df1, link = "probit")
  fit.loglog <- ordinal::clm(y ~ x + I(x ^ 2), data = df1, link = "loglog")
  fit.cloglog <- ordinal::clm(y ~ x + I(x ^ 2), data = df1, link = "cloglog")
  fit.cauchit <- ordinal::clm(y ~ x + I(x ^ 2), data = df1, link = "cauchit")

  expect_equal(length(sure:::get_bounds(fit.logit)), 5)
  expect_identical(sure:::get_response_values(fit.logit), as.integer(df1$y))
  expect_equal(sure:::ncat(fit.logit), 4)
  expect_equal(sure:::get_distribution_function(fit.logit), plogis)
  expect_equal(sure:::get_distribution_function(fit.probit), pnorm)
  expect_equal(sure:::get_distribution_function(fit.loglog), sure:::pgumbel)
  expect_equal(sure:::get_distribution_function(fit.cloglog), sure:::pGumbel)
  expect_equal(sure:::get_distribution_function(fit.cauchit), pcauchy)
  expect_equal(sure:::get_distribution_name(fit.logit), "logis")
  expect_equal(sure:::get_distribution_name(fit.probit), "norm")
  expect_equal(sure:::get_distribution_name(fit.loglog), "gumbel")
  expect_equal(sure:::get_distribution_name(fit.cloglog), "Gumbel")
  expect_equal(sure:::get_distribution_name(fit.cauchit), "cauchy")
  expect_equal(sure:::get_quantile_function(fit.logit), qlogis)
  expect_equal(sure:::get_quantile_function(fit.probit), qnorm)
  expect_equal(sure:::get_quantile_function(fit.loglog), sure:::qgumbel)
  expect_equal(sure:::get_quantile_function(fit.cloglog), sure:::qGumbel)
  expect_equal(sure:::get_quantile_function(fit.cauchit), qcauchy)
}

# --- glm objects ---
# Fit binary probit model
suppressWarnings(
  fit_glm <- stats::glm(y ~ x + I(x ^ 2), data = df1,
                        family = binomial(link = "probit"))
)
expect_equal(sure:::get_distribution_function(fit_glm), pnorm)
expect_equal(sure:::get_distribution_name(fit_glm), "norm")
expect_equal(sure:::get_quantile_function(fit_glm), qnorm)
expect_identical(sure:::get_response_values(fit_glm), as.integer(df1$y != 1L) + 1L)

# --- lrm objects ---
if (tinytest::at_home() && requireNamespace("rms", quietly = TRUE)) {
  library(rms)
  fit_lrm <- rms::lrm(y ~ x, data = df1)

  expect_equal(length(sure:::get_bounds(fit_lrm)), 5)
  expect_equal(sure:::get_distribution_function(fit_lrm), plogis)
  expect_equal(sure:::get_distribution_name(fit_lrm), "logis")
  expect_equal(sure:::get_quantile_function(fit_lrm), qlogis)
  expect_identical(sure:::get_response_values(fit_lrm), as.integer(df1$y))
  expect_equal(sure:::ncat(fit_lrm), 4)
}

# --- orm objects ---
if (requireNamespace("rms", quietly = TRUE)) {
  library(rms)
  fit.logit <- rms::orm(y ~ x, data = df1, family = "logistic")
  fit.probit <- rms::orm(y ~ x, data = df1, family = "probit")
  fit.loglog <- rms::orm(y ~ x, data = df1, family = "loglog")
  fit.cloglog <- rms::orm(y ~ x, data = df1, family = "cloglog")
  fit.cauchit <- rms::orm(y ~ x, data = df1, family = "cauchit")

  expect_equal(length(sure:::get_bounds(fit.logit)), 5)
  expect_identical(sure:::get_response_values(fit.logit), as.integer(df1$y))
  expect_equal(sure:::ncat(fit.logit), 4)
  expect_equal(sure:::get_distribution_function(fit.logit), plogis)
  expect_equal(sure:::get_distribution_function(fit.probit), pnorm)
  expect_equal(sure:::get_distribution_function(fit.loglog), sure:::pgumbel)
  expect_equal(sure:::get_distribution_function(fit.cloglog), sure:::pGumbel)
  expect_equal(sure:::get_distribution_function(fit.cauchit), pcauchy)
  expect_equal(sure:::get_distribution_name(fit.logit), "logis")
  expect_equal(sure:::get_distribution_name(fit.probit), "norm")
  expect_equal(sure:::get_distribution_name(fit.loglog), "gumbel")
  expect_equal(sure:::get_distribution_name(fit.cloglog), "Gumbel")
  expect_equal(sure:::get_distribution_name(fit.cauchit), "cauchy")
  expect_equal(sure:::get_quantile_function(fit.logit), qlogis)
  expect_equal(sure:::get_quantile_function(fit.probit), qnorm)
  expect_equal(sure:::get_quantile_function(fit.loglog), sure:::qgumbel)
  expect_equal(sure:::get_quantile_function(fit.cloglog), sure:::qGumbel)
  expect_equal(sure:::get_quantile_function(fit.cauchit), qcauchy)
}

# --- polr objects ---
if (tinytest::at_home() && requireNamespace("MASS", quietly = TRUE)) {
  library(MASS)
  fit.logit <- MASS::polr(y ~ x + I(x ^ 2), data = df1, method = "logistic")
  fit.probit <- MASS::polr(y ~ x + I(x ^ 2), data = df1, method = "probit")
  fit.loglog <- MASS::polr(y ~ x + I(x ^ 2), data = df1, method = "loglog")
  fit.cloglog <- MASS::polr(y ~ x + I(x ^ 2), data = df1, method = "cloglog")
  fit.cauchit <- MASS::polr(y ~ x + I(x ^ 2), data = df1, method = "cauchit")

  expect_equal(length(sure:::get_bounds(fit.logit)), 5)
  expect_identical(sure:::get_response_values(fit.logit), as.integer(df1$y))
  expect_equal(sure:::ncat(fit.logit), 4)
  expect_equal(sure:::get_distribution_function(fit.logit), plogis)
  expect_equal(sure:::get_distribution_function(fit.probit), pnorm)
  expect_equal(sure:::get_distribution_function(fit.loglog), sure:::pgumbel)
  expect_equal(sure:::get_distribution_function(fit.cloglog), sure:::pGumbel)
  expect_equal(sure:::get_distribution_function(fit.cauchit), pcauchy)
  expect_equal(sure:::get_distribution_name(fit.logit), "logis")
  expect_equal(sure:::get_distribution_name(fit.probit), "norm")
  expect_equal(sure:::get_distribution_name(fit.loglog), "gumbel")
  expect_equal(sure:::get_distribution_name(fit.cloglog), "Gumbel")
  expect_equal(sure:::get_distribution_name(fit.cauchit), "cauchy")
  expect_equal(sure:::get_quantile_function(fit.logit), qlogis)
  expect_equal(sure:::get_quantile_function(fit.probit), qnorm)
  expect_equal(sure:::get_quantile_function(fit.loglog), sure:::qgumbel)
  expect_equal(sure:::get_quantile_function(fit.cloglog), sure:::qGumbel)
  expect_equal(sure:::get_quantile_function(fit.cauchit), qcauchy)
}

# --- vglm objects ---
if (tinytest::at_home() && requireNamespace("VGAM", quietly = TRUE)) {
  library(VGAM)
  suppressWarnings(
    fit.logit <- VGAM::vglm(y ~ x + I(x ^ 2), data = df1,
                            family = VGAM::cumulative(link = "logitlink",
                                                      parallel = TRUE))
  )
  suppressWarnings(
    fit.probit <- VGAM::vglm(y ~ x + I(x ^ 2), data = df1,
                             family = VGAM::cumulative(link = "probitlink",
                                                       parallel = TRUE))
  )
  suppressWarnings(
    fit.cloglog <- VGAM::vglm(y ~ x + I(x ^ 2), data = df1,
                              family = VGAM::cumulative(link = "clogloglink",
                                                        parallel = TRUE))
  )
  suppressWarnings(
    fit.cauchit <- VGAM::vglm(y ~ x + I(x ^ 2), data = df1,
                              family = VGAM::cumulative(link = "cauchitlink",
                                                        parallel = TRUE))
  )

  expect_equal(length(sure:::get_bounds(fit.logit)), 5)
  expect_identical(sure:::get_response_values(fit.logit), as.integer(df1$y))
  expect_equal(sure:::ncat(fit.logit), 4)
  expect_equal(sure:::get_distribution_function(fit.logit), plogis)
  expect_equal(sure:::get_distribution_function(fit.probit), pnorm)
  expect_equal(sure:::get_distribution_function(fit.cloglog), sure:::pGumbel)
  expect_equal(sure:::get_distribution_function(fit.cauchit), pcauchy)
  expect_equal(sure:::get_distribution_name(fit.logit), "logis")
  expect_equal(sure:::get_distribution_name(fit.probit), "norm")
  expect_equal(sure:::get_distribution_name(fit.cloglog), "Gumbel")
  expect_equal(sure:::get_distribution_name(fit.cauchit), "cauchy")
  expect_equal(sure:::get_quantile_function(fit.logit), qlogis)
  expect_equal(sure:::get_quantile_function(fit.probit), qnorm)
  expect_equal(sure:::get_quantile_function(fit.cloglog), sure:::qGumbel)
  expect_equal(sure:::get_quantile_function(fit.cauchit), qcauchy)
}

# --- get_mean_response comparison ---
if (tinytest::at_home() &&
    requireNamespace("ordinal", quietly = TRUE) &&
    requireNamespace("rms", quietly = TRUE) &&
    requireNamespace("MASS", quietly = TRUE) &&
    requireNamespace("VGAM", quietly = TRUE)) {
  
  library(ordinal)
  library(MASS)
  library(rms)
  library(VGAM)

  fit.clm <- ordinal::clm(y ~ x, data = df1, link = "logit")
  fit.polr <- MASS::polr(y ~ x, data = df1, method = "logistic")
  fit.lrm <- rms::lrm(y ~ x, data = df1)
  fit.orm <- rms::orm(y ~ x, data = df1, family = "logistic")
  fit.vglm <- VGAM::vglm(y ~ x, data = df1,
                         family = VGAM::cumulative(link = "logitlink",
                                                   parallel = TRUE))

  mr <- cbind(
    "clm" = sure:::get_mean_response(fit.clm),
    "polr" = sure:::get_mean_response(fit.polr),
    "lrm" = sure:::get_mean_response(fit.lrm),
    "orm" = sure:::get_mean_response(fit.orm),
    "vglm" = sure:::get_mean_response(fit.vglm)
  )

  max.diff <- apply(mr, MARGIN = 1, FUN = function(x) max(as.numeric(dist(x))))
  expect_true(max(max.diff) < 1e-05)
}
