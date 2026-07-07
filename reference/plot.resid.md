# Plot Residual Diagnostics

Residual-based diagnostic plots for cumulative link and general
regression models using
[`tinyplot::tinyplot()`](https://grantmcdermott.com/tinyplot/man/tinyplot.html)
graphics.

## Usage

``` r
# S3 method for class 'resid'
plot(
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
)

# S3 method for class 'clm'
plot(
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
)

# S3 method for class 'glm'
plot(
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
)

# S3 method for class 'lrm'
plot(
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
)

# S3 method for class 'orm'
plot(
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
)

# S3 method for class 'polr'
plot(
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
)

# S3 method for class 'vglm'
plot(
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
)
```

## Arguments

- x:

  An object of class `"resid"` (returned by
  [`resids()`](https://bgreenwell.github.io/sure/reference/resids.md)),
  or a fitted model object of class
  [`ordinal::clm()`](https://rdrr.io/pkg/ordinal/man/clm.html),
  [`stats::glm()`](https://rdrr.io/r/stats/glm.html),
  [`rms::lrm()`](https://rdrr.io/pkg/rms/man/lrm.html),
  [`rms::orm()`](https://rdrr.io/pkg/rms/man/orm.html),
  [`MASS::polr()`](https://rdrr.io/pkg/MASS/man/polr.html), or
  [`VGAM::vglm()`](https://rdrr.io/pkg/VGAM/man/vglm.html).

- y:

  Ignored.

- what:

  Character string specifying what to plot. Default is `"qq"` which
  produces a quantile-quantile plot of the residuals.

- covariate:

  A vector giving the covariate values to use for residual-by- covariate
  plots (i.e., when `what = "covariate"`).

- fit:

  The fitted model from which the residuals were extracted. (Only
  required if `what = "fitted"` and `x` inherits from class `"resid"`.)

- distribution:

  Function that computes the quantiles for the reference distribution to
  use in the quantile-quantile plot. Default is `qnorm` which is only
  appropriate for models using a probit link function. When
  `jitter_scale = "probability"`, the reference distribution is always
  U(-0.5, 0.5).

- ncol:

  Integer specifying the number of columns to use for the plot layout
  (if requesting multiple plots). Default is `NULL`.

- alpha:

  A single value in the interval `[0, 1]` controlling the opacity alpha
  of the plotted points. Only used when `nsim` \> 1.

- xlab:

  Character string giving the text to use for the x-axis label. Default
  is `NULL`.

- ylab:

  Character string giving the text to use for the y-axis label. Default
  is `NULL`.

- main:

  Character string giving the plot title. Default is `NULL`.

- smooth:

  Logical indicating whether or not to add a nonparametric smooth to
  certain plots. Default is `TRUE`.

- ...:

  Additional optional arguments to be passed onto
  [`tinyplot::tinyplot()`](https://grantmcdermott.com/tinyplot/man/tinyplot.html)
  (e.g., `col`, `pch`, `cex`, etc.) or
  [`resids()`](https://bgreenwell.github.io/sure/reference/resids.md)
  (if calling the plot method directly on a fitted model object).

## Value

No return value, called for plotting.

## Note

For `vglm` (and `vgam`) objects, the **VGAM** package defines its own S4
`plot` method which will override this S3 method if **VGAM** is loaded.
In such cases, we recommend extracting the residuals first using
[`resids()`](https://bgreenwell.github.io/sure/reference/resids.md) and
then plotting the resulting `resid` object (e.g. `plot(resids(fit))`),
which will correctly dispatch to `plot.resid()`.
