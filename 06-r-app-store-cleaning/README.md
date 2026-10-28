# App Store Data Cleaning and Multiple Imputation

Modernized R implementation of coursework exercise 2.

## Objective

Preserve category labels, clean numeric fields and install counts, parse dates, audit missingness, and optionally run five MICE imputations with seed 42. A fixed reference date (default 2020-01-01) makes update ages reproducible. Dates after that snapshot are flagged and their ages set missing.

## Run

Use R 4.3 or newer. Run commands from the repository root (the folder containing `R/common.R`). Python and pip are not used for these exercises. Install any needed R packages in the R or RStudio console:

```r
install.packages("mice")
```

In PowerShell or a terminal:

```powershell
Rscript 06-r-app-store-cleaning/analysis.R --data "D:/data science class/googleplaystore3.csv" --date 2020-01-01 --impute
```

For an artificial demonstration without original data or extra packages:

```powershell
Rscript 06-r-app-store-cleaning/analysis.R --demo
```

Outputs are written to `outputs/r-app-store/`. Use `--output PATH` to change the location. Each run records `session-info.txt` and whether the input is synthetic.

## Data and outputs

Use a permitted local googleplaystore3.csv. Required columns: Category, Rating, Reviews, Type, Last.Updated, Installs. Original external datasets are excluded from Git. The demo is artificial and must not be presented as a result from the original dataset. CSV summaries and PDF plots can be opened independently of R.

## Interpretation and limitations

The default command without --impute cleans and audits data only. --impute requires mice. The RDS file retains all five imputations; completed_imputation_1.csv is an illustration of one completion, not pooled inference. Inspect logged events. Analyses across imputed data require an explicit analysis model and pooling, which this exercise does not claim. Supported dates are month/day/year, ISO year-month-day, or English month names; ambiguous slash dates use month/day order.

MICE selects methods by variable type; see the [official method documentation](https://amices.org/mice/reference/make.method.html).

## Original work

The original script is preserved under `reference/`. This version removes invalid question labels, replaces absolute paths with arguments, writes reproducible outputs and corrects fragile hard-coded indexing. See [R validation status](../docs/R-VALIDATION.md) and [R execution guide](../docs/RUNNING-R.md).
