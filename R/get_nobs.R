#' @keywords internal
get_nobs <- function(object, ...) {
  n <- try(stats::nobs(object, ...), silent = TRUE)
  if (inherits(n, "try-error") || is.null(n) || is.na(n)) {
    length(get_response_values(object))
  } else {
    n
  }
}


#' @keywords internal
get_glm_cdf <- function(object) {
  family <- object$family$family
  fitted_vals <- object$fitted.values
  trials <- object$prior.weights
  if (is.null(trials)) {
    trials <- rep(1, length(fitted_vals))
  }

  if (family == "binomial") {
    function(y, lower = FALSE) {
      if (lower) {
        pbinom(y - 1, size = trials, prob = fitted_vals)
      } else {
        pbinom(y, size = trials, prob = fitted_vals)
      }
    }
  } else if (family == "poisson") {
    function(y, lower = FALSE) {
      if (lower) {
        ppois(y - 1, lambda = fitted_vals)
      } else {
        ppois(y, lambda = fitted_vals)
      }
    }
  } else if (family == "gaussian") {
    sigma <- stats::sigma(object)
    sd_vals <- sigma / sqrt(trials)
    function(y, lower = FALSE) {
      pnorm(y, mean = fitted_vals, sd = sd_vals)
    }
  } else if (family == "Gamma") {
    shape <- if (requireNamespace("MASS", quietly = TRUE)) {
      MASS::gamma.shape(object)$alpha
    } else {
      1 / (sum((object$y - fitted_vals)^2 / fitted_vals^2) / object$df.residual)
    }
    shape_vals <- shape * trials
    scale_vals <- fitted_vals / shape_vals
    function(y, lower = FALSE) {
      pgamma(y, shape = shape_vals, scale = scale_vals)
    }
  } else if (grepl("Negative Binomial", family) || family == "negative.binomial") {
    theta <- object$theta
    function(y, lower = FALSE) {
      if (lower) {
        pnbinom(y - 1, size = theta, mu = fitted_vals)
      } else {
        pnbinom(y, size = theta, mu = fitted_vals)
      }
    }
  } else {
    stop(paste("Family", family, "is not yet supported for GLM residuals."), call. = FALSE)
  }
}


#' @keywords internal
run_bootstrap_reps <- function(object, nsim, fun, ...) {
  n_obs <- get_nobs(object)
  boot_reps <- boot_id <- matrix(nrow = n_obs, ncol = nsim)
  for (i in seq_len(nsim)) {
    boot_id[, i] <- sample(n_obs, replace = TRUE)
    boot_reps[, i] <- fun(object, ..., boot_id = boot_id[, i, drop = TRUE])
  }
  if (!is.null(stats::na.action(object))) {
    boot_reps <- stats::naresid(stats::na.action(object), boot_reps)
    boot_id <- stats::naresid(stats::na.action(object), boot_id)
  }
  list(boot_reps = boot_reps, boot_id = boot_id)
}

