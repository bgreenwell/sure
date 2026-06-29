#' Plot Residual Diagnostics
#'
#' Residual-based diagnostic plots for cumulative link and general regression
#' models using [tinyplot::tinyplot()] graphics.
#'
#' @param x An object of class `"resid"` (returned by [sure::resids()]),
#' or a fitted model object of class [ordinal::clm()],
#' [stats::glm()], [rms::lrm()], [rms::orm()],
#' [MASS::polr()], or [VGAM::vglm()].
#' @param y Ignored.
#' @param what Character string specifying what to plot. Default is `"qq"`
#' which produces a quantile-quantile plot of the residuals.
#' @param covariate A vector giving the covariate values to use for residual-by-
#' covariate plots (i.e., when `what = "covariate"`).
#' @param fit The fitted model from which the residuals were extracted. (Only
#' required if `what = "fitted"` and `x` inherits from class
#' `"resid"`.)
#' @param distribution Function that computes the quantiles for the reference
#' distribution to use in the quantile-quantile plot. Default is `qnorm`
#' which is only appropriate for models using a probit link function. When
#' `jitter_scale = "probability"`, the reference distribution is always
#' U(-0.5, 0.5).
#' @param ncol Integer specifying the number of columns to use for the plot
#' layout (if requesting multiple plots). Default is `NULL`.
#' @param alpha A single value in the interval \verb{[0, 1]} controlling the
#' opacity alpha of the plotted points. Only used when `nsim` > 1.
#' @param xlab Character string giving the text to use for the x-axis label.
#' Default is `NULL`.
#' @param ylab Character string giving the text to use for the y-axis label.
#' Default is `NULL`.
#' @param main Character string giving the plot title. Default is `NULL`.
#' @param smooth Logical indicating whether or not to add a nonparametric
#' smooth to certain plots. Default is `TRUE`.
#' @param ... Additional optional arguments to be passed onto
#' [tinyplot::tinyplot()] (e.g., `col`, `pch`, `cex`,
#' etc.) or [sure::resids()] (if calling the plot method directly on a
#' fitted model object).
#' @return No return value, called for plotting.
#'
#' @note
#' For `vglm` (and `vgam`) objects, the **VGAM** package defines its own S4 `plot`
#' method which will override this S3 method if **VGAM** is loaded. In such cases,
#' we recommend extracting the residuals first using `resids()` and then plotting the
#' resulting `resid` object (e.g. `plot(resids(fit))`), which will correctly dispatch
#' to `plot.resid()`.
#'
#' @rdname plot.resid
#'
#' @importFrom stats ppoints quantile lowess
#' @importFrom grDevices adjustcolor
#' @importFrom graphics par abline lines
#'
#' @method plot resid
#' @export
plot.resid <- function(
  x,
  y = NULL,
  what = c("qq", "fitted", "covariate"),
  covariate = NULL,
  fit = NULL,
  distribution = qnorm,
  ncol = NULL,
  alpha = 1,
  xlab = NULL,
  ylab = NULL,
  main = NULL,
  smooth = TRUE,
  ...
) {

  if (!requireNamespace("tinyplot", quietly = TRUE)) {
    stop("Package \"tinyplot\" is required for plotting. Please install it.",
         call. = FALSE)
  }

  # What type of plot to produce
  what <- match.arg(what, several.ok = TRUE)

  # Figure out number of plots and layout
  np <- length(what)
  if (np > 1L) {
    if (is.null(ncol)) {
      ncol <- np
    }
    nrow <- ceiling(np / ncol)
    op <- graphics::par(mfrow = c(nrow, ncol))
    on.exit(graphics::par(op))
  }

  # Check that fitted mean response values are available
  if ("fitted" %in% what) {
    if (is.null(fit)) {
      stop("Cannot extract mean response. Please supply the original fitted",
           " model object via the `fit` argument.")
    }
    mr <- get_mean_response(fit)
  }

  # Check that covariate values are supplied
  if ("covariate" %in% what) {
    if (is.null(covariate)) {
      stop("No covariate to plot. Please supply a vector of covariate values",
           " via the `covariate` argument")
    }
    if (is.null(xlab)) {
      xlab <- deparse(substitute(covariate))
    }
  }

  # Deal with bootstrap replicates
  if (is.null(attr(x, "boot_reps"))) {
    nsim <- 1
    res <- x
    if ("qq" %in% what) {
      res.med <- x
    }
  } else {
    res.mat <- attr(x, "boot_reps")
    res <- as.numeric(as.vector(res.mat))
    nsim <- ncol(res.mat)
    if ("qq" %in% what) {
      res.med <- apply(apply(res.mat, MARGIN = 2, FUN = sort,
                             decreasing = FALSE), MARGIN = 1, FUN = median)
    }
    if ("fitted" %in% what) {
      mr <- mr[as.vector(attr(x, "boot_id"))]
    }
    if ("covariate" %in% what) {
      covariate <- covariate[as.vector(attr(x, "boot_id"))]
    }
  }

  # Helper to call tinyplot with dots, handling color/alpha and defaults
  plot_points <- function(x, y, xlab, ylab, main, ...) {
    dots <- list(...)
    # Extract or default color
    col <- if ("col" %in% names(dots)) dots$col else "#444444"
    dots$col <- grDevices::adjustcolor(col, alpha.f = alpha)

    # Set default point symbol and size if not provided
    if (!"pch" %in% names(dots)) dots$pch <- 19
    if (!"cex" %in% names(dots)) dots$cex <- 1

    do.call(tinyplot::tinyplot, c(list(x = x, y = y, type = "p", xlab = xlab, ylab = ylab, main = main), dots))
  }

  # Quantile-quantile
  if ("qq" %in% what) {
    if (!is.null(attr(x, "jitter_scale"))) {
      if (attr(x, "jitter_scale") == "response") {
        stop("Q-Q plots are not available for jittering on the response scale.")
      }
    }
    distribution <- match.fun(distribution)
    xvals <- distribution(stats::ppoints(length(res.med)))[order(order(res.med))]
    qqline.y <- stats::quantile(res.med, probs = c(0.25, 0.75),
                                names = FALSE, na.rm = TRUE)
    qqline.x <- distribution(c(0.25, 0.75))
    slope <- diff(qqline.y) / diff(qqline.x)
    int <- qqline.y[1L] - slope * qqline.x[1L]

    plot_points(
      x = xvals, y = res.med,
      xlab = if (is.null(xlab)) "Theoretical quantile" else xlab,
      ylab = if (is.null(ylab)) "Sample quantile" else ylab,
      main = if (is.null(main)) "Q-Q Plot" else main,
      ...
    )
    graphics::abline(a = int, b = slope, col = "#888888", lty = "dashed", lwd = 1)
  }

  # Residual vs fitted value
  if ("fitted" %in% what) {
    plot_points(
      x = mr, y = res,
      xlab = if (is.null(xlab)) "Fitted value" else xlab,
      ylab = if (is.null(ylab)) "Surrogate residual" else ylab,
      main = if (is.null(main)) "Residual vs Fitted" else main,
      ...
    )
    if (smooth) {
      graphics::lines(stats::lowess(mr, res), col = "red", lty = 1, lwd = 1)
    }
  }

  # Residual vs covariate
  if ("covariate" %in% what) {
    if (is.factor(covariate)) {
      dots <- list(...)
      # Boxplot default labels
      x_label <- if (is.null(xlab)) "Covariate" else xlab
      y_label <- if (is.null(ylab)) "Surrogate residual" else ylab
      main_label <- if (is.null(main)) "Residual vs Covariate" else main

      if (!"col" %in% names(dots)) {
        tinyplot::tinyplot(
          x = covariate, y = res, type = "boxplot",
          by = covariate, legend = FALSE,
          xlab = x_label, ylab = y_label, main = main_label,
          ...
        )
      } else {
        tinyplot::tinyplot(
          x = covariate, y = res, type = "boxplot",
          xlab = x_label, ylab = y_label, main = main_label,
          ...
        )
      }
    } else {
      plot_points(
        x = covariate, y = res,
        xlab = if (is.null(xlab)) "Covariate" else xlab,
        ylab = if (is.null(ylab)) "Surrogate residual" else ylab,
        main = if (is.null(main)) "Residual vs Covariate" else main,
        ...
      )
      if (smooth) {
        graphics::lines(stats::lowess(covariate, res), col = "red", lty = 1, lwd = 1)
      }
    }
  }

  invisible(NULL)
}


#' @rdname plot.resid
#'
#' @method plot clm
#' @export
plot.clm <- function(
  x,
  y = NULL,
  what = c("qq", "fitted", "covariate"),
  covariate = NULL,
  fit = NULL,
  distribution = qnorm,
  ncol = NULL,
  alpha = 1,
  xlab = NULL,
  ylab = NULL,
  main = NULL,
  smooth = TRUE,
  ...
) {

  # Compute residuals
  res <- resids(x, ...)

  # Quantile function to use for Q-Q plots
  qfun <- if (is.null(attr(res, "jitter_scale"))) {
    get_quantile_function(x)
  } else {
    if ("qq" %in% what && attr(res, "jitter_scale") == "response") {
      stop("Quantile-quantile plots are not appropriate for residuals ",
           "obtained by jittering on the response scale.")
    }
    function(p) qunif(p, min = -0.5, max = 0.5)
  }

  # Default x-axis label
  if (is.null(xlab)) {
    xlab <- deparse(substitute(covariate))
  }

  # Call the default method
  plot.resid(
    res, what = what, covariate = covariate, distribution = qfun, fit = x, ncol = ncol,
    alpha = alpha, xlab = xlab, ylab = ylab, main = main, smooth = smooth, ...
  )

}


#' @rdname plot.resid
#'
#' @method plot glm
#' @export
plot.glm <- plot.clm


#' @rdname plot.resid
#'
#' @method plot lrm
#' @export
plot.lrm <- plot.clm


#' @rdname plot.resid
#'
#' @method plot orm
#' @export
plot.orm <- plot.clm


#' @rdname plot.resid
#'
#' @method plot polr
#' @export
plot.polr <- plot.clm


#' @rdname plot.resid
#'
#' @method plot vglm
#' @export
plot.vglm <- plot.clm
