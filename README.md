sure: Surrogate Residuals <img src="man/figures/sure-logo.png" align="right" width="130" height="150" />
========================================================================================================

[![r-universe status](https://bgreenwell.r-universe.dev/badges/sure)](https://bgreenwell.r-universe.dev/sure)
[![R-CMD-check](https://github.com/bgreenwell/sure/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/bgreenwell/sure/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/bgreenwell/sure/branch/master/graph/badge.svg)](https://codecov.io/gh/bgreenwell/sure)

Overview
--------

An R package for constructing **SU**rrogate-based **RE**siduals and
diagnostics for ordinal and general regression models; based on the
approach described in [Dungang and Zhang
(2017)](http://www.tandfonline.com/doi/abs/10.1080/01621459.2017.1292915?journalCode=uasa20).

Installation
------------

**sure** is no longer available on CRAN due to CRAN's stringent and ever-changing
policies. It is now hosted on [r-universe](https://bgreenwell.r-universe.dev/sure),
which provides a reliable alternative for distributing R packages.

``` r
# Install from r-universe (recommended):
install.packages("sure", repos = c("https://bgreenwell.r-universe.dev", "https://cloud.r-project.org"))

# Install the latest development version from GitHub:
if (!requireNamespace("pak")) {
  install.packages("pak")
}
pak::pak("bgreenwell/sure")
```

References
----------

Liu, D. and Zhang, H. Residuals and Diagnostics for Ordinal Regression
Models: A Surrogate Approach. *Journal of the American Statistical
Association* (accepted). URL
<http://www.tandfonline.com/doi/abs/10.1080/01621459.2017.1292915?journalCode=uasa20>

Greenwell, B.M., McCarthy, A.J., Boehmke, B.C. & Dungang, L. (2018)
“Residuals and diagnostics for binary and ordinal regression models: An
introduction to the sure package.” The R Journal (pre-print). URL
<https://journal.r-project.org/archive/2018/RJ-2018-004/index.html>
