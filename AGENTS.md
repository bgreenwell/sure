# Agent Context and Guidelines for `sure`

This file provides context, architectural design rules, and common commands for agentic workflows in the `sure` R package.

---

## 1. Package Overview & Architecture

`sure` is an R package designed to construct surrogate-based residuals and diagnostics for ordinal and general regression models (e.g., CLMs, GLMs, multinomial, and general ML classifiers).

### Design Philosophy
*   **Minimal Dependencies**: The package has **zero** non-base imports (with all third-party dependencies, including `tinyplot`, placed under `Suggests`). Keep it that way.
*   **Modular Generics**: The unexported helper generics (e.g., `get_bounds`, `get_mean_response`) are split into individual, single-purpose files under `R/` named after the generic (e.g., `R/get_bounds.R`).
*   **Exact Math**: The multinomial surrogate residual calculation uses a mathematically exact, direct Gumbel/multivariate-normal sampler (`calc_resid`) rather than slow rejection sampling.

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

### Testing Guidelines
*   **No `testthat`**: Do not introduce `testthat` code. Write all tests using the `tinytest` API in the `inst/tinytest/` directory.
*   **Avoid Masking in Tests**: When writing tests that load external packages (like `VGAM`), prefix Gumbel distribution functions with `sure:::` (e.g., `sure:::qgumbel`, `sure:::pgumbel`) to prevent masking conflicts.
*   **VGAM Links**: In `VGAM` model tests, specify link functions using the suffix-aware naming convention (e.g., `link = "logitlink"`, `link = "probitlink"`).
