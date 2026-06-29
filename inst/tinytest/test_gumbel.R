# Test Gumbel distribution functions

expect_equal(sure:::qgumbel(sure:::pgumbel(3)), 3)
expect_equal(sure:::qGumbel(sure:::pGumbel(3)), 3)
expect_equal(length(sure:::rgumbel(10)), 10)
expect_equal(length(sure:::rGumbel(10)), 10)
