if (requireNamespace("tinytest", quietly = TRUE)) {
  # test_package()'s own `at_home` default is FALSE (not tinytest::at_home()),
  # so calling it with no argument silently skips every at_home()-gated
  # expectation regardless of the ambient environment. Compute a real value:
  # a development version, or NOT_CRAN=true, or an explicit TT_AT_HOME=TRUE
  # all count as "at home".
  dev_version <- length(unclass(utils::packageVersion("sure"))[[1L]]) >= 4L
  home <- dev_version ||
    identical(tolower(Sys.getenv("NOT_CRAN")), "true") ||
    tinytest::at_home()
  tinytest::test_package("sure", at_home = home)
}
