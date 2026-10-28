# R validation

Three standalone R exercises were added on 2026-10-28. Rscript was not available on the local command path.

## Verified on GitHub Actions

[Successful R verification run](https://github.com/montazertirbati/data-science-portfolio/actions/runs/40761590276) for commit `1e1d9b7c3e914a919198ce21b6bb4dfc909d5ac3`:

- All three R scripts completed using their synthetic `--demo` inputs.
- CSV summaries, PDF plots and session information were generated.
- Output invariants passed: increased missingness after zero handling, valid group mean intervals, correct numeric install counts, nonnegative update ages, expected regression row counts and degrees of freedom, bounded leverage and valid Bonferroni adjustments.
- Results were uploaded as the `r-demo-results` workflow artifact.

These checks use base R and artificial data. They do not verify the original local CSV files, the faraway package data-loading branch, optional MICE imputation, or the optional nortest residual test. No original-data results or pooled imputation inference are claimed. Each exercise README states its dependencies and scope.
