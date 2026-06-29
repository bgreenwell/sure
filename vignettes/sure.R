## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE, 
                      fig.align = "center")

## -----------------------------------------------------------------------------
library(sure)  

# Simulate quadratic data
set.seed(977)
df1 <- sim_data(n = 2000, type = "quadratic")

# Fit a cumulative link model with probit link
library(MASS)  # for polr function
fit.polr <- polr(y ~ x + I(x ^ 2), data = df1, method = "probit")

## ----fig.width=7, fig.height=3.5, fig.cap="Figure 1: SBS residual plots for the (correctly specified) probit model fit to the simulated quadratic data. Left: Residual-vs-covariate plot with a nonparametric smooth (red curve). Right: Q-Q plot of the residuals."----
# Obtain the SBS/probability-scale residuals
library(PResiduals)
pres <- presid(fit.polr)

# Residual-vs-covariate plot and Q-Q plot
library(ggplot2)  # for plotting
p1 <- ggplot(data.frame(x = df1$x, y = pres), aes(x, y)) +
  geom_point(color = "#444444", shape = 19, size = 2, alpha = 0.5) +
  geom_smooth(color = "red", se = FALSE) +
  ylab("Probability-scale residual")

p2 <- ggplot(data.frame(y = pres), aes(sample = y)) +
  stat_qq(distribution = qunif, dparams = list(min = -1, max = 1), alpha = 0.5) +
  xlab("Sample quantile") +
  ylab("Theoretical quantile")

gridExtra::grid.arrange(p1, p2, ncol = 2)

## ----fig.width=7, fig.height=3.5, fig.cap="Figure 2: Surrogate residual plots for the (correctly specified) probit model fit to the simulated quadratic data. Left: Residual-vs-covariate plot with a nonparametric smooth (red curve). Right: Q-Q plot of the residuals."----
# for reproducibility
set.seed(101)  
sres <- resids(fit.polr)

# Residual-vs-covariate plot and Q-Q plot
op <- par(mfrow = c(1, 2))
plot(sres, what = "covariate", covariate = df1$x, xlab = "x")
plot(sres, what = "qq", distribution = qnorm)
par(op)

## ----fig.width=4, fig.height=3.5, fig.cap="Figure 3: plot option."------------
# for reproducibility
set.seed(101) 

# same as top right of Figure 2
plot(fit.polr, what = "qq")  

## ----fig.width=7, fig.height=3.5, fig.cap="Figure 4: Residual-vs-covariate plots with nonparametric smooths (red curves) for a probit model with a misspecified mean structure fit to the simulated quadratic data. Left: Surrogate residuals. Right: SBS residuals."----
# remove quadratic term
fit.polr <- update(fit.polr, y ~ x) 

set.seed(1055)
op <- par(mfrow = c(1, 2))
plot(fit.polr, what = "covariate", covariate = df1$x, alpha = 0.5,
     xlab = "x", ylab = "Surrogate residual", main = "")

# For comparison, we also plot the SBS residuals
pres_bad <- presid(fit.polr)
plot(x = df1$x, y = pres_bad, col = "#444444", pch = 19, cex = 1, alpha = 0.5,
     xlab = "x", ylab = "Probability-scale residual", main = "")
lines(lowess(df1$x, pres_bad), col = "red", lwd = 1.2)
par(op)

## -----------------------------------------------------------------------------
# Simulate heteroscedastic data
set.seed(108)
df2 <- sim_data(n = 2000, type = "heteroscedastic")

# Fit a cumulative link model with probit link
library(rms)  # for orm function
fit.orm <- orm(y ~ x, data = df2, family = "probit", x = TRUE)

