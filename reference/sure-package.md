# sure: Surrogate Residuals for Ordinal and General Regression Models

The `sure` package provides surrogate-based residuals for fitted ordinal
and general (e.g., binary) regression models of class
[`ordinal::clm()`](https://rdrr.io/pkg/ordinal/man/clm.html),
[`stats::glm()`](https://rdrr.io/r/stats/glm.html),
[`rms::lrm()`](https://rdrr.io/pkg/rms/man/lrm.html),
[`rms::orm()`](https://rdrr.io/pkg/rms/man/orm.html),
[`MASS::polr()`](https://rdrr.io/pkg/MASS/man/polr.html), or
[`VGAM::vglm()`](https://rdrr.io/pkg/VGAM/man/vglm.html), as well as
multinomial models and general classifiers via a matrix of predicted
class probabilities. Start with
[`resids()`](https://bgreenwell.github.io/sure/reference/resids.md),
then plot the result with
[`plot.resid()`](https://bgreenwell.github.io/sure/reference/plot.resid.md).

## References

Liu, Dungang and Zhang, Heping. Residuals and Diagnostics for Ordinal
Regression Models: A Surrogate Approach. *Journal of the American
Statistical Association*, 113(522), 845-854, 2018.
[doi:10.1080/01621459.2017.1292915](https://doi.org/10.1080/01621459.2017.1292915)

Greenwell, Brandon M., McCarthy, Andrew J., Boehmke, Bradley C. and Liu,
Dungang. Residuals and Diagnostics for Binary and Ordinal Regression
Models: An Introduction to the sure Package. *The R Journal*, 10(1),
2018. [doi:10.32614/RJ-2018-004](https://doi.org/10.32614/RJ-2018-004)

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

- Bradley Boehmke <bradleyboehmke@gmail.com>

Other contributors:

- Liz Glaser <liz.glaser@gmail.com> \[contributor\]
