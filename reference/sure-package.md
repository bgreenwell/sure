# sure: An R package for constructing surrogate-based residuals and diagnostics for ordinal and general regression models.

The `sure` package provides surrogate-based residuals for fitted ordinal
and general (e.g., binary) regression models of class
[`ordinal::clm()`](https://rdrr.io/pkg/ordinal/man/clm.html),
[`stats::glm()`](https://rdrr.io/r/stats/glm.html),
[`rms::lrm()`](https://rdrr.io/pkg/rms/man/lrm.html),
[`rms::orm()`](https://rdrr.io/pkg/rms/man/orm.html),
[`MASS::polr()`](https://rdrr.io/pkg/MASS/man/polr.html), or
[`VGAM::vglm()`](https://rdrr.io/pkg/VGAM/man/vglm.html).

## Details

The development version can be found on GitHub:
<https://github.com/bgreenwell/sure>. As of right now, `sure` exports
the following functions:

- [`resids()`](https://bgreenwell.github.io/sure/reference/resids.md) -
  construct (surrogate-based) residuals;

- [`plot()`](https://rdrr.io/r/graphics/plot.default.html) - plot
  diagnostics using
  [`tinyplot::tinyplot()`](https://grantmcdermott.com/tinyplot/man/tinyplot.html)-based
  graphics;

- [`gof()`](https://bgreenwell.github.io/sure/reference/gof.md) -
  simulate p-values from a goodness-of-fit test.

## References

Liu, Dungang and Zhang, Heping. Residuals and Diagnostics for Ordinal
Regression Models: A Surrogate Approach. *Journal of the American
Statistical Association* (accepted).

## See also

Useful links:

- <https://github.com/bgreenwell/sure>

- <https://bgreenwell.github.io/sure/>

- <https://bgreenwell.r-universe.dev/sure>

- Report bugs at <https://github.com/bgreenwell/sure/issues>

## Author

**Maintainer**: Brandon Greenwell <greenwell.brandon@gmail.com>

Authors:

- Andrew McCarthy <mccarthyan@gmail.com>

- Boehmke Bradley <bradleyboehmke@gmail.com>

Other contributors:

- Liz Glaser <liz.glaser@gmail.com> \[contributor\]
