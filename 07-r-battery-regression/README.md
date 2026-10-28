# Battery Lifetime Regression and Diagnostics

Modernized R implementation of coursework exercise 3.

## Objective

Compare full and depth-only linear regressions; inspect raw and log response models, residual plots, leverage, Cook distance, externally studentized residuals, Bonferroni-adjusted outlier p-values, confidence intervals and variance inflation factors. Sample sizes and residual degrees of freedom are calculated from the fitted models.

## Run

Use R 4.3 or newer. Run commands from the repository root (the folder containing `R/common.R`). Python and pip are not used for these exercises. Install any needed R packages in the R or RStudio console:

```r
install.packages("nortest") # Optional Anderson-Darling residual check
```

In PowerShell or a terminal:

```powershell
Rscript 07-r-battery-regression/analysis.R --data "D:/data science class/battery.csv"
```

For an artificial demonstration without original data or extra packages:

```powershell
Rscript 07-r-battery-regression/analysis.R --demo
```

Outputs are written to `outputs/r-battery/`. Use `--output PATH` to change the location. Each run records `session-info.txt` and whether the input is synthetic.

## Data and outputs

Use a permitted local battery.csv with numeric cycles, charge, discharge, temp, endvolt, and depth. Original external datasets are excluded from Git. The demo is artificial and must not be presented as a result from the original dataset. CSV summaries and PDF plots can be opened independently of R.

## Interpretation and limitations

These are explanatory model diagnostics, not held-out prediction scores. Raw and log response residual errors have different units and should not be compared directly. Do not remove flagged observations automatically. VIF is computed using auxiliary numeric regressions; optional nortest adds an Anderson-Darling check.

## Original work

The original script is preserved under `reference/`. This version removes invalid question labels, replaces absolute paths with arguments, writes reproducible outputs and corrects fragile hard-coded indexing. See [R validation status](../docs/R-VALIDATION.md) and [R execution guide](../docs/RUNNING-R.md).
