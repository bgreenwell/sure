# sure 0.3.0

## Added
* Added direct exact Gumbel and multivariate normal samplers for multinomial residuals.
* Added S3 methods `resids.multinom` and `resids.matrix` for multinomial and general ML classifiers.
* Added latent surrogate residual method for general, non-binary vanilla GLMs.
* Added case weights support (`prior.weights`) for Gaussian and Gamma GLMs.
* Added a new public function `sim_data()` to dynamically simulate datasets representing different model misspecifications.

## Changed
* Migrated residual diagnostic plots from `ggplot2`/`gridExtra` to `tinyplot` via standard S3 `plot()` methods.
* Simplified `plot.resid()` arguments to leverage standard base R graphical parameters (`col`, `pch`, `cex`, etc.).
* Refactored internal utilities from a single `utils.R` file into separate generic-specific files.
* Abstracted duplicate bootstrap replication loops into a single shared helper `run_bootstrap_reps()`.
* Upgraded minimum R dependency version from `3.1` to `4.0.0` in DESCRIPTION.

## Deprecated
* Deprecated the `ggplot2`-based `autoplot()` methods in favor of standard `plot()` S3 methods.

## Removed
* Removed `ggplot2` and `gridExtra` package dependencies from `Imports`.
* Removed `testthat` testing framework and rebuilt the entire test suite using `tinytest`.
* Removed the redundant `slowtests/` directory as its test cases are fully covered by the package vignette and the unit test suite.
* Removed the static datasets `df1` through `df5` and their documentation, replacing them completely with `sim_data()`.

## Fixed
* Fixed a bug in `gof()` validation checking due to operator precedence.
* Fixed a bug in the jittering methods where category interval mapping caused binary successes to collapse.
* Fixed `nsim > 1` bootstrap crashes on model classes that do not support `nobs()`.
* Fixed link function name matching for `vglm` models containing `"link"` suffixes.
* Fixed dimension mismatch crashes in `clm` and `polr` models with collinear (aliased) predictors.

# sure 0.2.2

* Incorporated [pkgdown website](https://koalaverse.github.io/sure/index.html).

* Added paper URLs and ORCIDs to DESCRIPTION file [(#30)](https://github.com/koalaverse/sure/issues/30).

* Added `sure` vignette

* incorporated autoplot methods for glm, lrm, orm, polr, vglm

* `autoplot()` can now return multiple plots [(#16)](https://github.com/koalaverse/sure/issues/16).

* Specifying `method = "latent"` now works for binomial GLMs [(27)](https://github.com/koalaverse/sure/issues/27).

* Specifying `method = "jittering"` now issues a warning (at least until it has been fully tested).


# sure 0.2.0

* New function `surrogate` for returning the surrogate response values used in calculating the surrogate-based residuals. The surrogate response values can be useful for checking the proportionality assumption of fitted cumulative link models, among other things.

* Jittering (on both the probability scale and the response scale) is now available for fitted cumulative link models based on packages `MASS`, `ordinal`, `rms`, and `VGAM` [(#18)](https://github.com/koalaverse/sure/issues/18).

* Added support for vector generalized additive models from the `VGAM` package (i.e., objects of class `"vgam"`).

* New data sets `df4` and `df5` for illustrating various uses of the surrogate residual for diagnostics an ordinal regression models.


# sure 0.1.2

* Initial release.
