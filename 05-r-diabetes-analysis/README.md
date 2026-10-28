# Pima Diabetes Missingness and Group Comparisons

Modernized R implementation of coursework exercise 1.

## Objective

Replace implausible zero values only in the five measurements identified by the original exercise; examine age distributions by triceps missingness, compare BMI above/below observed mean insulin, summarize insulin by test group with 95% t intervals, and compute a Welch comparison when both groups have enough observations.

## Run

Use R 4.3 or newer. Run commands from the repository root (the folder containing `R/common.R`). Python and pip are not used for these exercises. Install any needed R packages in the R or RStudio console:

```r
install.packages("faraway")
```

In PowerShell or a terminal:

```powershell
Rscript 05-r-diabetes-analysis/analysis.R
```

For an artificial demonstration without original data or extra packages:

```powershell
Rscript 05-r-diabetes-analysis/analysis.R --demo
```

Outputs are written to `outputs/r-diabetes/`. Use `--output PATH` to change the location. Each run records `session-info.txt` and whether the input is synthetic.

## Data and outputs

faraway supplies the original pima dataset. An optional --data CSV must contain age, diastolic, glucose, triceps, bmi, insulin, and test (coded 0/1). Original external datasets are excluded from Git. The demo is artificial and must not be presented as a result from the original dataset. CSV summaries and PDF plots can be opened independently of R.

## Interpretation and limitations

Group summaries describe observed values; complete-case comparisons can be biased when missingness is not random. Confidence intervals refer to group means, not individual insulin measurements. They are descriptive coursework results.

## Original work

The original script is preserved under `reference/`. This version removes invalid question labels, replaces absolute paths with arguments, writes reproducible outputs and corrects fragile hard-coded indexing. See [R validation status](../docs/R-VALIDATION.md) and [R execution guide](../docs/RUNNING-R.md).
