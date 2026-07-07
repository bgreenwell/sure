# Goodness-of-Fit Simulation

Simulate p-values from a goodness-of-fit test.

## Usage

``` r
gof(object, nsim = 10, test = c("ks", "ad", "cvm"), ...)

# Default S3 method
gof(object, nsim = 10, test = c("ks", "ad", "cvm"), ...)

# S3 method for class 'gof'
plot(x, ...)
```

## Arguments

- object:

  An object of class
  [`ordinal::clm()`](https://rdrr.io/pkg/ordinal/man/clm.html),
  [`stats::glm()`](https://rdrr.io/r/stats/glm.html),
  [`rms::lrm()`](https://rdrr.io/pkg/rms/man/lrm.html),
  [`rms::orm()`](https://rdrr.io/pkg/rms/man/orm.html),
  [`MASS::polr()`](https://rdrr.io/pkg/MASS/man/polr.html), or
  [`VGAM::vglm()`](https://rdrr.io/pkg/VGAM/man/vglm.html).

- nsim:

  Integer specifying the number of bootstrap replicates to use.

- test:

  Character string specifying which goodness-of-fit test to use. Current
  options include: `"ks"` for the Kolmogorov-Smirnov test, `"ad"` for
  the Anderson-Darling test, and `"cvm"` for the Cramer-Von Mises test.
  Default is `"ks"`.

- ...:

  Additional optional arguments. (Currently ignored.)

- x:

  An object of class `"gof"`.

## Value

A numeric vector of class `"gof", "numeric"` containing the simulated
p-values.

## Details

Under the null hypothesis, the distribution of the p-values should
appear uniformly distributed on the interval `[0, 1]`. This can be
visually investigated using the `plot` method. A 45 degree line is
indicative of a "good" fit.

## Examples

``` r
# See ?resids for an example
?resids
```
