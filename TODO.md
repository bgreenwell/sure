# TODO

This document tracks bugs, planned overhauls, and feature enhancements for the `sure` package, prioritized by order of importance and logical execution sequence.

---

## 1. Dependency Reduction & Overhaul (Highest Priority)

- [x] **Remove Heavy Plotting Dependencies**
  - Remove `ggplot2` and `gridExtra` from the `Imports` list in `DESCRIPTION`.
  - Re-implement `autoplot()` using `tinyplot` (a zero-dependency base-R graphics wrapper) to reduce compile/install time and footprint.
- [x] **Demote `goftest` to `Suggests`**
  - Move the `goftest` package from `Imports` to `Suggests` in `DESCRIPTION`.
  - Implement runtime checks (e.g. `requireNamespace("goftest", quietly = TRUE)`) in `gof()` so it is only required when performing Anderson-Darling or Cramér-von Mises goodness-of-fit tests.
  - This leaves the core package with **zero** external non-base imports.
- [x] **API Style Overhaul (lowerCamelCase to snake_case)**
  - Transition internal utilities and public API functions to `snake_case`.
    - `getDistributionFunction` $\rightarrow$ `get_distribution_function`
    - `getResponseValues` $\rightarrow$ `get_response_values`
    - `getMeanResponse` $\rightarrow$ `get_mean_response`
    - `getFittedProbs` $\rightarrow$ `get_fitted_probs`
    - `getQuantileFunction` $\rightarrow$ `get_quantile_function`
    - `getBounds` $\rightarrow$ `get_bounds`
    - Argument `jitter.scale` $\rightarrow$ `jitter_scale`
- [x] **Modularize `utils.R`**
  - Split the complex `utils.R` file into separate files for each generic (`get_bounds.R`, `get_distribution_function.R`, `get_distribution_name.R`, `get_fitted_probs.R`, `get_mean_response.R`, `get_nobs.R`, `get_quantile_function.R`, `get_response_values.R`, `ncat.R`) to simplify internal structure.
- [x] **Deduplicate and Clean Up Bootstrap Code**
  - Abstract bootstrap replication loop setups from `resids.R` and `surrogate.R` into a single helper (`run_bootstrap_reps()`).
- [x] **Rebuild the Jittering Approach**
  - Jittering is currently clunky, incorrect, and wrongly implemented. Audit and rebuild to ensure mathematical correctness.

---

## 2. Critical Bugs & Usability Fixes (Medium-High Priority)

- [x] **Fix Precedence Bug in `gof()`**
  - **Issue**: In `R/gof.R:L37`, `if (nsim <- as.integer(nsim) < 2)` evaluates `<` before `<-`, assigning `FALSE` to `nsim` for `nsim >= 2` and crashing downstream.
  - **Fix**: Parenthesize: `if ((nsim <- as.integer(nsim)) < 2)`.
- [x] **Fix `nsim > 1` Bootstrap crashes due to `nobs()`** (GitHub Issue #44)
  - **Issue**: `nobs(object)` is called to set matrix dimensions for bootstrap reps, but some model classes (e.g., `vglm` from `VGAM` or older classes) do not support `nobs()`, causing crashes.
  - **Fix**: Implement a robust internal `get_nobs()` utility that falls back to `length(get_response_values(object))` when `nobs()` is unsupported.
- [x] **Fix Link Function Name Matching for `vglm` Models** (GitHub Issue #39)
  - **Issue**: `VGAM::vglm` link names are often suffixed with `"link"` (e.g. `"logitlink"`, `"probitlink"`), which causes the switch statements in `getDistributionFunction`, `getDistributionName`, and `getQuantileFunction` to return `NULL` and fail.
  - **Fix**: Strip the `"link"` suffix from `object@family@infos()$link` before matching.
- [x] **Handle Missing Values (`NA`) Gracefully** (GitHub Issue #9)
  - **Issue**: Models fit with missing values (and `na.action = na.exclude` or `na.omit`) cause residuals to mismatch in length or crash.
  - **Fix**: Align behavior with R standards (using `na.action` to pad output with `NA` where appropriate).
- [x] **Handle Aliased Parameters Correctly** (GitHub Issue #35)
  - **Issue**: Rank-deficient models with aliased (collinear) variables crash during residual generation, especially in the manual design matrix reconstruction for `clm` and `polr`.
  - **Fix**: Properly detect and omit aliased parameters when reconstructing linear predictors.
- [x] **Fix `getBounds.glm()` Return Value**
  - **Issue**: `getBounds.glm()` checks `y == 0` and `y == 1`, but `getResponseValues.glm()` returns `{1, 2}` due to factor coercion. This yields incorrect bounds `c(0, 0)`.
  - **Fix**: Update checks to `{1, 2}` to align with `getResponseValues.glm()`.
- [x] **Robust Binary GLM Response Factor Coercion** (GitHub Issue #28)
  - **Issue**: When a binary GLM's response is not a factor (e.g., numeric `0`/`1` or logical), coercion behavior can be inconsistent.
  - **Fix**: Standardize integer mapping for all binary GLM responses.

---

## 3. Residual Method Enhancements (Medium Priority)

- [x] **Support Matrix/Two-Column Response Binomial Models**
  - Support `glm` objects specified with `y ~ cbind(successes, failures)`.
- [x] **Add Latent Method to Vanilla GLMs** (GitHub Issue #27)
  - Support the latent surrogate method for general, non-binary vanilla GLMs.
- [x] **Proper Handling of Case Weights** (GitHub Issue #15)
  - Account for case weights (`weights` argument in model fitting) in the surrogate residual calculation.

---

## 4. Model & Package Integrations (Medium-Low Priority)

- [x] **Multinomial & Discrete Choice Model (DCM) Support** (GitHub Issue #22)
  - Implement surrogate residuals for multinomial logit and probit models.
  - Implement conditional Gumbel sampler (`rmgumbel()`) and conditional multivariate normal sampler (`rmulti_trun()`).
  - Add S3 methods for `mlogit`, `multinom` (from `nnet`), and `mnp` (from `MNP`).
- [x] **Vectorized Direct Sampler for General/ML Classifiers**
  - Implement a probability-based vectorized direct inverse-CDF sampler for general classifiers (random forests, xgboost, neural networks, GAMs).
  - Expose a wrapper interface accepting predicted probabilities matrix (`proba`) and outcomes vector (`y`).
- [ ] **Support Survey Ordinal Models (`svyolr`)** (GitHub Issue #34)
  - Add S3 methods to support ordinal regression objects of class `svyolr` from the `survey` package.
- [ ] **Support Bayesian Ordinal Models (`brms`)** (GitHub Issue #33)
  - Add S3 methods to support Bayesian ordinal models of class `brmsfit` from the `brms` package.

---

## 5. Metadata & Infrastructure (Lowest Priority)

- [x] **Consider Upgrading Package R Dependency** (GitHub Issue #37)
  - Upgrade minimum R version from `R (>= 3.1)` to `R (>= 4.0.0)` in `DESCRIPTION`.
- [x] **Rebuild Tests via `tinytest`**
  - Completely replace the `testthat` testing framework with `tinytest` to eliminate heavy testing dependencies.
- [ ] **Vignette Creation** (GitHub Issue #31)
  - Add a comprehensive vignette illustrating the usage of surrogate residuals.
- [ ] **Add a `fitted()` Generic/Method** (GitHub Issue #36)
  - Add `fitted()` method support to retrieve fitted values/predictions from residuals objects.
- [ ] **Consider Splitting `surrogate` into its own Package** (GitHub Issue #26)
  - Decouple `surrogate` function from residuals diagnostic plots into a standalone computation-only package.
