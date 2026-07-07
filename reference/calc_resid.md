# Calculate surrogate residuals for multinomial/discrete choice models

Calculate surrogate residuals for multinomial logit and general discrete
choice models using a fast, exact conditional Gumbel simulation method.

## Usage

``` r
calc_resid(y, proba)
```

## Arguments

- y:

  Vector of observed classes (either a factor or a 1-based integer
  vector).

- proba:

  Matrix of predicted probabilities, where rows correspond to
  observations and columns correspond to classes.

## Value

A matrix of surrogate residuals of the same dimensions as `proba`.
