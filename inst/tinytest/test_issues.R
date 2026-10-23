# Regression tests for reported GitHub issues (https://github.com/bgreenwell/sure/issues)

# --- Issue #28: binary GLMs when response is not a factor ---
# Aggregated/grouped binomial response (cbind(success, failure)) used to
# error; the general (non-binary) GLM latent method now supports it.
heart <- data.frame(
  ck = 0:11 * 40 + 20,
  ha = c(2, 13, 30, 30, 21, 19, 18, 13, 19, 15, 7, 8),
  ok = c(88, 26, 8, 5, 0, 1, 1, 1, 1, 0, 0, 0)
)
fit28 <- glm(cbind(ha, ok) ~ ck, family = binomial(link = "logit"), data = heart)
res28 <- resids(fit28)
expect_equal(length(res28), nrow(heart))
expect_true(all(is.finite(res28)))

# Plain numeric/logical (non-factor) binary responses should also work
set.seed(1)
x28 <- rnorm(200)
y28 <- rbinom(200, size = 1, prob = plogis(x28))
expect_equal(length(resids(glm(y28 ~ x28, family = binomial))), 200)
expect_equal(length(resids(glm(as.logical(y28) ~ x28, family = binomial))), 200)

# --- Issues #35 and #38: aliased (collinear) predictors in clm objects ---
# get_mean_response.clm() used to crash with "non-conformable arguments"
# when model.matrix() dropped columns for aliased coefficients but
# object$beta was indexed without the matching subset.
if (tinytest::at_home() && requireNamespace("ordinal", quietly = TRUE)) {
  library(ordinal)
  data(wine, package = "ordinal")
  fit35 <- clm(rating ~ 1 + judge + temp + bottle, data = wine)
  expect_true(any(fit35$aliased$beta))
  expect_equal(length(resids(fit35)), nrow(wine))
  expect_equal(length(surrogate(fit35)), nrow(wine))

  df38 <- sim_data(type = "quadratic")
  df38$z <- df38$x  # perfectly collinear with x -> forces aliasing
  fit38 <- clm(y ~ x + z, data = df38)
  expect_true(any(fit38$aliased$beta))
  expect_equal(length(resids(fit38)), nrow(df38))
}

# --- Issue #39: resids() failed for vglm models once VGAM started
# suffixing link names (e.g. "logitlink" instead of "logit") ---
if (tinytest::at_home() && requireNamespace("VGAM", quietly = TRUE)) {
  library(VGAM)
  df39 <- sim_data(type = "quadratic")
  for (lnk in c("logitlink", "probitlink", "clogloglink", "cauchitlink")) {
    suppressWarnings(
      fit39 <- VGAM::vglm(y ~ x + I(x ^ 2), data = df39,
                          family = VGAM::cumulative(link = lnk, parallel = TRUE))
    )
    expect_equal(length(resids(fit39)), nrow(df39))
  }
}

# --- Issue #44: nsim controls the number of bootstrap replicates stored in
# the boot_reps/boot_id attributes; the primary returned vector is always a
# single draw of length n regardless of nsim (by design; see ?resids) ---
df44 <- sim_data(type = "quadratic")
fit44 <- glm(y ~ x + I(x ^ 2), data = df44, family = binomial)
res44_1 <- resids(fit44, nsim = 1)
res44_10 <- resids(fit44, nsim = 10)
expect_equal(length(res44_1), nrow(df44))
expect_equal(length(res44_10), nrow(df44))
expect_equal(dim(attr(res44_10, "boot_reps")), c(nrow(df44), 10))
boot_reps44 <- attr(res44_10, "boot_reps")
expect_false(all(boot_reps44[, 1] == boot_reps44[, 2]))

# --- Issue #45: binary cloglog GLMs used the Gumbel-min latent distribution;
# Y = 1 corresponds to S > 0, so the latent error must be Gumbel-max ---
set.seed(45)
x45 <- rnorm(5000)
y45 <- rbinom(5000, size = 1, prob = binomial("cloglog")$linkinv(-0.3 + 0.8 * x45))
fit45 <- glm(y45 ~ x45, family = binomial(link = "cloglog"))
expect_equal(sure:::get_distribution_name(fit45), "gumbel")
eta45 <- seq(-2, 2, length.out = 9)
expect_equal(1 - sure:::get_distribution_function(fit45)(-eta45),
             binomial("cloglog")$linkinv(eta45))
# Under a correctly specified model, S - eta follows the latent distribution,
# whose mean is +0.5772 (Euler's constant) for Gumbel-max and -0.5772 for
# Gumbel-min
expect_equal(mean(surrogate(fit45) - fit45$linear.predictors), 0.5772,
             tolerance = 0.05)
