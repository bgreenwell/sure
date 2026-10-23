## Submission summary

This is an update of sure 0.2.0, the version on CRAN since 2017. The package
was modernized in the meantime; the user-visible changes since 0.2.0 are:

* Plots now use base graphics via 'tinyplot' (in Suggests) through standard
  `plot()` S3 methods. 'ggplot2' and 'gridExtra' were dropped from Imports,
  and the old `autoplot()` methods were removed. The package now has no
  non-base hard dependencies.
* The example data sets `df1` to `df5` were removed in favor of a new
  `sim_data()` function.
* New support for multinomial models, general classifiers (a matrix of
  predicted class probabilities), and non-binary GLMs.
* The minimum R version is now 4.0.0.

### Behavior change

Surrogate residuals for binary `glm()` fits with a `cloglog` link used the
wrong orientation of the Gumbel latent distribution, so they did not match
the fitted model. They are now correct, which means results for these
models differ from earlier versions.

## R CMD check results

0 errors | 0 warnings | 0 notes

* Local: macOS (aarch64), R 4.5.2, `--as-cran` with incoming checks.
* GitHub Actions: macOS and Windows (R release); Ubuntu (R devel, release,
  oldrel-1).
* win-builder: R-devel. RESULT

## Reverse dependencies

We checked 1 reverse dependency (weightedCL), comparing R CMD check results
across the CRAN and dev versions of this package.

* We saw 0 new problems
* We failed to check 0 packages
