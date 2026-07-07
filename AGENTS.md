# Agent Context and Guidelines for `sure`

This file provides context, architectural design rules, and common commands for agentic workflows in the `sure` R package.

---

## 1. Package Overview & Architecture

`sure` is an R package designed to construct surrogate-based residuals and diagnostics for ordinal and general regression models (e.g., CLMs, GLMs, multinomial, and general ML classifiers).

### Design Philosophy
*   **Minimal Dependencies**: The package has **zero** non-base imports (with all third-party dependencies, including `tinyplot`, placed under `Suggests`). Keep it that way.
*   **Modular Generics**: The unexported helper generics (e.g., `get_bounds`, `get_mean_response`) are split into individual, single-purpose files under `R/` named after the generic (e.g., `R/get_bounds.R`). A couple of these (`get_distribution_function`, `get_quantile_function`) are no longer S3 generics — they collapsed to plain functions indexing a shared lookup table keyed on `get_distribution_name()` — but still keep their own one-file-per-concern home.
*   **Exact Math**: The multinomial surrogate residual calculation uses a mathematically exact, direct Gumbel/multivariate-normal sampler (`calc_resid`) rather than slow rejection sampling.

## Branches & releases

*   **`devel`** (default): all development and PRs. Version carries a `.9000` suffix; NEWS.md starts with `# sure (development version)`.
*   **`main`**: stable releases only, tagged `vX.Y.Z`. r-universe (pinned to `main` in `bgreenwell/bgreenwell.r-universe.dev`) and the pkgdown site both build from `main` — never push experimental work there.
*   Release: merge devel → main (`--no-ff`), drop the `.9000` suffix and dev NEWS heading, tag, push, `gh release create`; then **merge main back into devel** (else the release merge commit leaves devel "behind" main) and bump devel to the next `.9000`.
*   Shared fixes that main needs immediately: commit to **main first, then merge main → devel**. Never cherry-pick devel → main — it duplicates commits and makes main appear "ahead" of devel.

---

## 2. Key Commands

Always run these commands from the package root directory.

### Document and Rebuild Namespace
To update `NAMESPACE`, register S3 methods, and regenerate Rd files:
```bash
Rscript -e "devtools::document()"
```

### Run the Test Suite
The package uses the lightweight `tinytest` framework. Run all tests with:
```bash
Rscript -e "pkgload::load_all('.'); tinytest::test_all('.')"
```
Note: `tinytest::test_all()`/`run_test_dir()` default `at_home = TRUE`, so this
always runs the full gated suite regardless of environment variables — that's
the right command for local dev. `tests/tinytest.R` (what `R CMD check` and CI
actually run) computes its own `at_home` value instead; see Gotchas below.

### Load the Package in Development Mode
```bash
Rscript -e "devtools::load_all()"
```

---

## 3. Development Rules & Guidelines

### Dependency Management
*   **No New Imports**: Do not add new packages to `Imports` in `DESCRIPTION` unless explicitly requested.
*   **Conditional Suggests**: If a package is listed in `Suggests` (e.g., `goftest`), always wrap its usage in a conditional check:
    ```r
    if (!requireNamespace("package_name", quietly = TRUE)) {
      stop("Package 'package_name' is required for this feature. Please install it.", call. = FALSE)
    }
    ```

### Code Style & Naming Conventions
*   **snake_case**: Use `snake_case` for all new functions, internal helpers, and arguments (e.g., `jitter_scale`, `get_mean_response`).
*   **Preserve S3 Registration**: When adding or modifying S3 methods, ensure you include the `#' @export` tag in the Roxygen block so they are correctly registered in the `NAMESPACE` file.
*   **Alias identical methods**: when two model classes need identical logic (e.g., `lrm`/`orm` share several methods), assign the method directly rather than duplicating the body — `get_bounds.orm <- get_bounds.lrm` — following the pattern already used for `plot.*`.

### Testing Guidelines
*   **No `testthat`**: Do not introduce `testthat` code. Write all tests using the `tinytest` API in the `inst/tinytest/` directory.
*   **Avoid Masking in Tests**: When writing tests that load external packages (like `VGAM`), prefix Gumbel distribution functions with `sure:::` (e.g., `sure:::qgumbel`, `sure:::pgumbel`) to prevent masking conflicts.
*   **VGAM Links**: In `VGAM` model tests, specify link functions using the suffix-aware naming convention (e.g., `link = "logitlink"`, `link = "probitlink"`).

## Gotchas

*   **`tinytest::test_package()`'s `at_home` parameter defaults to `FALSE`**, not `tinytest::at_home()`, and overrides the ambient `TT_AT_HOME`/`NOT_CRAN` env vars entirely. `tests/tinytest.R` must compute a real value itself (dev version, or `NOT_CRAN=true`, or an explicit `TT_AT_HOME=TRUE`) or `R CMD check`/CI will silently skip every `at_home()`-gated expectation — this was happening for ~63% of the suite before it was fixed. Don't call `test_package("sure")` with no `at_home` argument.
*   **R files load alphabetically** (no `Collate` field in `DESCRIPTION`), so a top-level lookup table referencing a function defined in a later-sourced file (e.g., `pgumbel`, defined in `R/utils.R`) will fail with "object not found" at install/load time. Build such tables lazily inside the function body instead of at the top level of the file.
*   **`R/get_nobs.R`'s `get_glm_cdf()`** calls `stats::pgamma`/`pnbinom`/`ppois` unqualified — keep them in the `@importFrom stats` block in `R/sure-package.R`, or `R CMD check` flags them.
