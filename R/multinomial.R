#' Calculate surrogate residuals for multinomial/discrete choice models
#'
#' Calculate surrogate residuals for multinomial logit and general discrete choice models
#' using a fast, exact conditional Gumbel simulation method.
#'
#' @param y Vector of observed classes (either a factor or a 1-based integer vector).
#' @param proba Matrix of predicted probabilities, where rows correspond to
#' observations and columns correspond to classes.
#'
#' @return A matrix of surrogate residuals of the same dimensions as `proba`.
#'
#' @export
calc_resid <- function(y, proba) {
  n <- nrow(proba)
  K <- ncol(proba)
  g <- 0.57721566490153286

  # Ensure numerical stability
  proba <- pmax(proba, 1e-15)
  proba <- proba / rowSums(proba)

  # Convert y to 1-based integer indices
  if (is.factor(y)) {
    y <- as.integer(y)
  } else {
    y <- as.integer(as.factor(y))
  }

  if (length(y) != n) {
    stop("Length of y must match number of rows of proba.", call. = FALSE)
  }
  if (any(y < 1L | y > K)) {
    stop("Observed response values y must be within 1 and the number of classes.", call. = FALSE)
  }

  # Step 1: Sample maximum M ~ Gumbel(0, 1) for each observation
  u0 <- stats::runif(n)
  M <- -log(-log(u0))

  # Step 2: Sample U ~ Uniform(0, 1) matrix
  U <- matrix(stats::runif(n * K), nrow = n, ncol = K)

  # Step 3: Compute Z_k conditional on Z_k <= M for k != y
  m <- log(proba)
  Z <- m - log(-log(U) + exp(m - M))

  # Step 4: Set Z_y = M
  indices <- cbind(seq_len(n), y)
  Z[indices] <- M

  # Step 5: Subtract log probabilities and Euler-Mascheroni constant
  R <- Z - m - g
  return(R)
}
