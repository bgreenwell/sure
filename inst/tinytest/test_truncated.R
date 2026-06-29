# Test Truncated distributions

set.seed(101)
x <- sure:::.rtrunc(1000, spec = "norm", a = 0)
expect_true(min(x) > 0)
expect_identical(sure:::.qtrunc(0.5, spec = "norm"), 0)
