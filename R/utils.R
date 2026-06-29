# various internal functions

################################################################################
# The following functions have been taken from truncdist, but have been modified
# to not throw warnings when vectors are passed to arguments a and b
################################################################################

#' @keywords internal
.rtrunc <- function (n, spec, a = -Inf, b = Inf, ...) {
  .qtrunc(runif(n, min = 0, max = 1), spec, a = a, b = b, ...)
}


#' @keywords internal
.qtrunc <- function (p, spec, a = -Inf, b = Inf, ...) {
  tt <- p
  G <- get(paste("p", spec, sep = ""), mode = "function")
  Gin <- get(paste("q", spec, sep = ""), mode = "function")
  G.a <- G(a, ...)
  G.b <- G(b, ...)
  pmin(pmax(a, Gin(G(a, ...) + p * (G(b, ...) - G(a, ...)), ...)), b)
}


#' @keywords internal
sim_trunc <- function(n, distribution, a, b, location = 0, scale = 1) {
  if (distribution == "norm") {
    .rtrunc(n, spec = distribution, a = a, b = b,
            mean = location, sd = scale)
  } else {
    .rtrunc(n, spec = distribution, a = a, b = b,
            location = location, scale = scale)
  }
}


################################################################################
# Gumbel distribution functions
################################################################################

# For log-log link

#' @keywords internal
pgumbel <- function(q, location = 0, scale = 1) {
  q <- (q - location) / scale
  exp(-exp(-q))
}


#' @keywords internal
qgumbel <- function(p, location = 0, scale = 1) {
  -scale * log(-log(p)) + location
}


#' @keywords internal
rgumbel <- function (n, location = 0, scale = 1) {
  qgumbel(runif(n, min = 0, max = 1), location = location, scale = scale)
}


# For complimentary log-log link

#' @keywords internal
pGumbel <- function(q, location = 0, scale = 1) {
  q <- (q - location) / scale
  1 - exp(-exp(q))
}


#' @keywords internal
qGumbel <- function(p, location = 0, scale = 1) {
  scale * log(-log(1 - p)) + location
}


#' @keywords internal
rGumbel <- function (n, location = 0, scale = 1) {
  qGumbel(runif(n, min = 0, max = 1), location = location, scale = scale)
}


################################################################################
# Surrogate and residual workhorse functions
################################################################################

#' @keywords internal
generate_surrogate <- function(object, method = c("latent", "jitter"),
                               jitter_scale = c("response", "probability"),
                               boot_id = NULL) {

  # Match arguments
  method <- match.arg(method)

  # Generate surrogate response values
  s <- if (method == "latent") {  # latent variable approach

    # Get distribution name (for sampling)
    distribution <- get_distribution_name(object)  # distribution name

    # Simulate surrogate response values from the appropriate truncated
    # distribution
    if (distribution %in% c("norm", "logis", "cauchy", "gumbel", "Gumbel")) {
      y <- get_response_values(object)
      if (is.null(boot_id)) {
        boot_id <- seq_along(y)
      }
      mean_response <- get_mean_response(object)  # mean response values
      if (!inherits(object, what = "lrm") && !inherits(object, what = "orm") &&
          inherits(object, what = "glm") &&
          object$family$family == "binomial" && all(object$prior.weights == 1L)) {
        sim_trunc(n = length(y), distribution = distribution,
                  # {0, 1} -> {1, 2}
                  a = ifelse(y[boot_id] == 1, yes = -Inf, no = 0),
                  b = ifelse(y[boot_id] == 2, yes =  Inf, no = 0),
                  location = mean_response[boot_id], scale = 1)  # surrogate values
      } else if (inherits(object, what = "glm") && !inherits(object, what = "lrm") && !inherits(object, what = "orm")) {
        # General GLM
        cdf <- get_glm_cdf(object)
        qfun <- get_quantile_function(object)
        p_lower <- cdf(y[boot_id], lower = TRUE)
        p_upper <- cdf(y[boot_id], lower = FALSE)
        p_lower <- pmax(pmin(p_lower, 1 - 1e-15), 1e-15)
        p_upper <- pmax(pmin(p_upper, 1 - 1e-15), 1e-15)

        a <- qfun(p_lower) + mean_response[boot_id]
        b <- qfun(p_upper) + mean_response[boot_id]
        sim_trunc(n = length(y), distribution = distribution,
                  a = a, b = b,
                  location = mean_response[boot_id], scale = 1)
      } else {
        trunc_bounds <- get_bounds(object)  # truncation bounds
        sim_trunc(n = length(y), distribution = distribution,
                  a = trunc_bounds[y[boot_id]],
                  b = trunc_bounds[y[boot_id] + 1L],
                  location = mean_response[boot_id], scale = 1)  # surrogate values
      }
    } else {
      stop("Distribution not supported.", call. = FALSE)
    }

  } else {  # jittering approach

    # Determine scale for jittering
    jitter_scale <- match.arg(jitter_scale)
    y <- get_response_values(object)
    if (is.null(boot_id)) {
      boot_id <- seq_along(y)
    }
    y <- y[boot_id]
    if (inherits(object, what = "glm") && !inherits(object, what = "lrm") && !inherits(object, what = "orm") && object$family$family != "binomial") {
      stop("Jittering is not supported for non-binomial GLMs.", call. = FALSE)
    }
    prob <- get_fitted_probs(object)[boot_id, , drop = FALSE]
    n_obs <- length(y)
    K <- ncol(prob)

    if (jitter_scale == "response") {  # jittering on the response scale
      runif(n_obs, min = y - 1, max = y)
    } else {  # jittering on the probability scale
      cum_prob <- cbind(0, t(apply(prob, 1, cumsum)))
      p_lower <- cum_prob[cbind(seq_len(n_obs), y)]
      p_upper <- cum_prob[cbind(seq_len(n_obs), y + 1L)]
      runif(n_obs, min = p_lower, max = p_upper)
    }

  }

  # Return results
  s

}



#' @keywords internal
generate_residuals <- function(object, method = c("latent", "jitter"),
                               jitter_scale = c("response", "probability"),
                               boot_id = NULL) {

  # Match arguments
  method <- match.arg(method)

  # Generate surrogate response values
  r <- if (method == "latent") {  # latent variable approach

    # Get distribution name (for sampling)
    distribution <- get_distribution_name(object)  # distribution name

    # Simulate surrogate response values from the appropriate truncated
    # distribution
    if (distribution %in% c("norm", "logis", "cauchy", "gumbel", "Gumbel")) {
      y <- get_response_values(object)
      if (is.null(boot_id)) {
        boot_id <- seq_along(y)
      }
      mean_response <- get_mean_response(object)  # mean response values
      s <- if (!inherits(object, what = "lrm") && !inherits(object, what = "orm") &&
               inherits(object, what = "glm") &&
               object$family$family == "binomial" && all(object$prior.weights == 1L)) {
        sim_trunc(n = length(y), distribution = distribution,
                  # {0, 1} -> {1, 2}
                  a = ifelse(y[boot_id] == 1, yes = -Inf, no = 0),
                  b = ifelse(y[boot_id] == 2, yes =  Inf, no = 0),
                  location = mean_response[boot_id], scale = 1)  # surrogate values
      } else if (inherits(object, what = "glm") && !inherits(object, what = "lrm") && !inherits(object, what = "orm")) {
        # General GLM
        cdf <- get_glm_cdf(object)
        qfun <- get_quantile_function(object)
        p_lower <- cdf(y[boot_id], lower = TRUE)
        p_upper <- cdf(y[boot_id], lower = FALSE)
        p_lower <- pmax(pmin(p_lower, 1 - 1e-15), 1e-15)
        p_upper <- pmax(pmin(p_upper, 1 - 1e-15), 1e-15)

        a <- qfun(p_lower) + mean_response[boot_id]
        b <- qfun(p_upper) + mean_response[boot_id]
        sim_trunc(n = length(y), distribution = distribution,
                  a = a, b = b,
                  location = mean_response[boot_id], scale = 1)
      } else {
        trunc_bounds <- get_bounds(object)  # truncation bounds
        sim_trunc(n = length(y), distribution = distribution,
                  a = trunc_bounds[y[boot_id]],
                  b = trunc_bounds[y[boot_id] + 1L],
                  location = mean_response[boot_id], scale = 1)  # surrogate values
      }
    } else {
      stop("Distribution not supported.", call. = FALSE)
    }
    s - mean_response[boot_id]  # surrogate residuals
  } else {  # jittering approach
    jitter_scale <- match.arg(jitter_scale)
    y <- get_response_values(object)
    if (is.null(boot_id)) {
      boot_id <- seq_along(y)
    }
    y <- y[boot_id]
    if (inherits(object, what = "glm") && !inherits(object, what = "lrm") && !inherits(object, what = "orm") && object$family$family != "binomial") {
      stop("Jittering is not supported for non-binomial GLMs.", call. = FALSE)
    }
    prob <- get_fitted_probs(object)[boot_id, , drop = FALSE]
    n_obs <- length(y)
    K <- ncol(prob)

    if (jitter_scale == "response") {  # jittering on the response scale
      s <- runif(n_obs, min = y - 1, max = y)
      j <- seq_len(K) - 0.5
      mean_response <- rowSums(matrix(j, nrow = n_obs, ncol = K, byrow = TRUE) * prob)
      r <- s - mean_response
    } else {  # jittering on the probability scale
      cum_prob <- cbind(0, t(apply(prob, 1, cumsum)))
      p_lower <- cum_prob[cbind(seq_len(n_obs), y)]
      p_upper <- cum_prob[cbind(seq_len(n_obs), y + 1L)]
      r <- runif(n_obs, min = p_lower, max = p_upper) - 0.5
    }
  }

  # Return results
  r

}
