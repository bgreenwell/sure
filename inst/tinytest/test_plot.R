# Plot methods
if (requireNamespace("tinyplot", quietly = TRUE)) {
  pdf(NULL)

  set.seed(101)
  df <- sim_data(n = 300, type = "quadratic")
  fit <- glm(y ~ x, data = df, family = binomial(link = "logit"))
  res <- resids(fit)

  # sure no longer registers a plot() method for glm objects, so stats'
  # plot.lm() diagnostics are left alone
  expect_null(getS3method("plot", "glm", optional = TRUE))

  # plot.resid() takes its Q-Q reference distribution from `fit`
  expect_silent(plot(res, fit = fit, what = c("qq", "fitted", "covariate"),
                     covariate = df$x))
  expect_silent(plot(res, what = "qq"))
  expect_error(plot(res, what = "fitted"), pattern = "fit")
  expect_error(plot(res, what = "covariate"), pattern = "covariate")

  # Jittering on the response scale has no Q-Q reference distribution
  res_jit <- suppressWarnings(
    resids(fit, method = "jitter", jitter_scale = "response")
  )
  expect_error(plot(res_jit, what = "qq"), pattern = "Q-Q")
  expect_silent(plot(res_jit, what = "covariate", covariate = df$x))

  if (requireNamespace("MASS", quietly = TRUE)) {
    fit_polr <- MASS::polr(y ~ x, data = df)
    expect_silent(plot(fit_polr, what = c("qq", "fitted")))
    expect_silent(plot(fit_polr, what = "covariate", covariate = df$x))
  }

  dev.off()
}
