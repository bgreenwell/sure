# Test sim_data function

df1 <- sim_data(type = "quadratic")
df2 <- sim_data(type = "heteroscedastic")
df3 <- sim_data(type = "gumbel")
df4 <- sim_data(type = "proportionality")
df5 <- sim_data(type = "interaction")

expect_equal(nrow(df1), 2000)
expect_equal(ncol(df1), 2)
expect_inherits(df1$y, "ordered")

expect_equal(nrow(df2), 2000)
expect_equal(ncol(df2), 2)
expect_inherits(df2$y, "ordered")

expect_equal(nrow(df3), 2000)
expect_equal(ncol(df3), 2)
expect_inherits(df3$y, "ordered")

expect_equal(nrow(df4), 2000)
expect_equal(ncol(df4), 2)
expect_inherits(df4$y, "ordered")

expect_equal(nrow(df5), 2000)
expect_equal(ncol(df5), 3)
expect_inherits(df5$y, "ordered")
expect_inherits(df5$x2, "factor")
