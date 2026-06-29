# Test Surrogate response values

if (tinytest::at_home() && requireNamespace("MASS", quietly = TRUE)) {
  df1 <- sim_data(type = "quadratic")

  # Fit cumulative link model
  fit <- MASS::polr(y ~ x, data = df1, method = "probit")

  # Compute residuals
  set.seed(101)  # for reproducibility
  s <- surrogate(fit)  # surrogate response values
  set.seed(101)  # for reproducibility
  r <- resids(fit)  # surrogate-based residuals
  mr <- sure:::get_mean_response(fit)  # mean response

  # Expectations
  expect_equivalent(as.numeric(r), as.numeric(s - mr))
}
