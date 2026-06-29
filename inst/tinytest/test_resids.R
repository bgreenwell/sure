# Test Surrogate residuals

df1 <- sim_data(type = "quadratic")

# --- clm objects ---
if (tinytest::at_home() && requireNamespace("ordinal", quietly = TRUE)) {
  library(ordinal)
  fit <- ordinal::clm(y ~ x + I(x ^ 2), data = df1, link = "logit")
  res1 <- resids(fit)
  res2 <- resids(fit, nsim = 10)

  expect_equal(length(res1), nrow(df1))
  expect_equal(length(res2), nrow(df1))
  expect_null(attr(res1, "boot_reps"))
  expect_null(attr(res1, "boot_id"))
  expect_inherits(attr(res2, "boot_reps"), "matrix")
  expect_inherits(attr(res2, "boot_id"), "matrix")
  expect_equal(dim(attr(res2, "boot_reps")), c(nrow(df1), 10))
  expect_equal(dim(attr(res2, "boot_id")), c(nrow(df1), 10))
}

# --- glm objects ---
fit_glm <- glm(y ~ x + I(x ^ 2), data = df1, family = binomial)
res1_glm <- resids(fit_glm)
res2_glm <- resids(fit_glm, nsim = 10)
res3_glm <- resids(fit_glm, jitter_scale = "probability")
res4_glm <- resids(fit_glm, nsim = 10, jitter_scale = "probability")

expect_equal(length(res1_glm), nrow(df1))
expect_equal(length(res2_glm), nrow(df1))
expect_equal(length(res3_glm), nrow(df1))
expect_equal(length(res4_glm), nrow(df1))
expect_null(attr(res1_glm, "boot_reps"))
expect_null(attr(res1_glm, "boot_id"))
expect_null(attr(res3_glm, "boot_reps"))
expect_null(attr(res3_glm, "boot_id"))
expect_inherits(attr(res2_glm, "boot_reps"), "matrix")
expect_inherits(attr(res2_glm, "boot_id"), "matrix")
expect_inherits(attr(res4_glm, "boot_reps"), "matrix")
expect_inherits(attr(res4_glm, "boot_id"), "matrix")
expect_equal(dim(attr(res2_glm, "boot_reps")), c(nrow(df1), 10))
expect_equal(dim(attr(res2_glm, "boot_id")), c(nrow(df1), 10))
expect_equal(dim(attr(res4_glm, "boot_reps")), c(nrow(df1), 10))
expect_equal(dim(attr(res4_glm, "boot_id")), c(nrow(df1), 10))

# --- lrm objects ---
if (tinytest::at_home() && requireNamespace("rms", quietly = TRUE)) {
  library(rms)
  fit_lrm <- rms::lrm(y ~ x, data = df1)
  res1_lrm <- resids(fit_lrm)
  res2_lrm <- resids(fit_lrm, nsim = 10)

  expect_equal(length(res1_lrm), nrow(df1))
  expect_equal(length(res2_lrm), nrow(df1))
  expect_null(attr(res1_lrm, "boot_reps"))
  expect_null(attr(res1_lrm, "boot_id"))
  expect_inherits(attr(res2_lrm, "boot_reps"), "matrix")
  expect_inherits(attr(res2_lrm, "boot_id"), "matrix")
  expect_equal(dim(attr(res2_lrm, "boot_reps")), c(nrow(df1), 10))
  expect_equal(dim(attr(res2_lrm, "boot_id")), c(nrow(df1), 10))
}

# --- orm objects ---
if (tinytest::at_home() && requireNamespace("rms", quietly = TRUE)) {
  library(rms)
  fit_orm <- rms::orm(y ~ x, data = df1, family = "logistic")
  res1_orm <- resids(fit_orm)
  res2_orm <- resids(fit_orm, nsim = 10)

  expect_equal(length(res1_orm), nrow(df1))
  expect_equal(length(res2_orm), nrow(df1))
  expect_null(attr(res1_orm, "boot_reps"))
  expect_null(attr(res1_orm, "boot_id"))
  expect_inherits(attr(res2_orm, "boot_reps"), "matrix")
  expect_inherits(attr(res2_orm, "boot_id"), "matrix")
  expect_equal(dim(attr(res2_orm, "boot_reps")), c(nrow(df1), 10))
  expect_equal(dim(attr(res2_orm, "boot_id")), c(nrow(df1), 10))
}

# --- polr objects ---
if (tinytest::at_home() && requireNamespace("MASS", quietly = TRUE)) {
  library(MASS)
  fit_polr <- MASS::polr(y ~ x + I(x ^ 2), data = df1, method = "logistic")
  res1_polr <- resids(fit_polr)
  res2_polr <- resids(fit_polr, nsim = 10)

  expect_equal(length(res1_polr), nrow(df1))
  expect_equal(length(res2_polr), nrow(df1))
  expect_null(attr(res1_polr, "boot_reps"))
  expect_null(attr(res1_polr, "boot_id"))
  expect_inherits(attr(res2_polr, "boot_reps"), "matrix")
  expect_inherits(attr(res2_polr, "boot_id"), "matrix")
  expect_equal(dim(attr(res2_polr, "boot_reps")), c(nrow(df1), 10))
  expect_equal(dim(attr(res2_polr, "boot_id")), c(nrow(df1), 10))
}

# --- vglm objects ---
if (tinytest::at_home() && requireNamespace("VGAM", quietly = TRUE)) {
  library(VGAM)
  suppressWarnings(
    fit_vglm <- VGAM::vglm(y ~ x + I(x ^ 2), data = df1,
                           family = VGAM::cumulative(link = "logitlink",
                                                     parallel = TRUE))
  )
  res1_vglm <- resids(fit_vglm)
  res2_vglm <- resids(fit_vglm, nsim = 10)

  expect_equal(length(res1_vglm), nrow(df1))
  expect_equal(length(res2_vglm), nrow(df1))
  expect_null(attr(res1_vglm, "boot_reps"))
  expect_null(attr(res1_vglm, "boot_id"))
  expect_inherits(attr(res2_vglm, "boot_reps"), "matrix")
  expect_inherits(attr(res2_vglm, "boot_id"), "matrix")
  expect_equal(dim(attr(res2_vglm, "boot_reps")), c(nrow(df1), 10))
  expect_equal(dim(attr(res2_vglm, "boot_id")), c(nrow(df1), 10))
}

# --- clm objects with different links ---
if (tinytest::at_home() && requireNamespace("ordinal", quietly = TRUE)) {
  library(ordinal)
  fit1 <- ordinal::clm(y ~ x + I(x ^ 2), data = df1, link = "logit")
  fit2 <- ordinal::clm(y ~ x + I(x ^ 2), data = df1, link = "probit")
  fit3 <- ordinal::clm(y ~ x + I(x ^ 2), data = df1, link = "loglog")
  fit4 <- ordinal::clm(y ~ x + I(x ^ 2), data = df1, link = "cloglog")
  fit5 <- ordinal::clm(y ~ x + I(x ^ 2), data = df1, link = "cauchit")

  expect_equal(length(resids(fit1)), nrow(df1))
  expect_equal(length(resids(fit2)), nrow(df1))
  expect_equal(length(resids(fit3)), nrow(df1))
  expect_equal(length(resids(fit4)), nrow(df1))
  expect_equal(length(resids(fit5)), nrow(df1))
}
