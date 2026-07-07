# Simulate Data for Diagnostic Plots

Generate simulated data sets designed to illustrate various model
misspecifications and diagnostics for ordinal regression models, as
described in Liu and Zhang (2017).

## Usage

``` r
sim_data(
  n = 2000,
  type = c("quadratic", "heteroscedastic", "gumbel", "proportionality", "interaction"),
  ...
)
```

## Arguments

- n:

  Integer specifying the number of observations to simulate. Default is
  `2000`.

- type:

  Character string specifying the type of data/model to simulate.
  Default is `"quadratic"` (linear relation with a quadratic trend).
  Other options include: `"heteroscedastic"` (non-constant variance),
  `"gumbel"` (Gumbel error distribution), `"proportionality"`
  (non-proportional hazards), and `"interaction"` (interaction effect).

- ...:

  Additional optional arguments (currently ignored).

## Value

A data frame containing the simulated predictor(s) and the ordered
factor response variable `y`.

## References

Liu, Dungang and Zhang, Heping. Residuals and Diagnostics for Ordinal
Regression Models: A Surrogate Approach. *Journal of the American
Statistical Association* (accepted).

## Examples

``` r
# Simulate quadratic data
set.seed(101)
df <- sim_data(n = 500, type = "quadratic")
head(df)
#>   y        x
#> 1 2 3.233190
#> 2 3 1.262949
#> 3 2 5.258104
#> 4 2 4.946142
#> 5 2 2.499134
#> 6 2 2.800329
```
