# Data Science Coursework Portfolio

Python and R coursework covering data cleaning, exploratory statistics, principal component analysis, classification, and model selection. This repository contains runnable Python implementations of exercises 5–8 and modernized R implementations of exercises 1–3, alongside original drafts as reference text.

## Portfolio projects

- [Retail Transaction Analysis](01-retail-analysis/README.md)
- [Spine Data: Principal Component Analysis](02-spine-pca/README.md)
- [Block Classification](03-block-classification/README.md)
- [Handwritten Digit Recognition](04-digit-recognition/README.md)

## R exercises

- [Pima Diabetes Missingness and Group Comparisons](05-r-diabetes-analysis/README.md)
- [App Store Data Cleaning and Multiple Imputation](06-r-app-store-cleaning/README.md)
- [Battery Lifetime Regression and Diagnostics](07-r-battery-regression/README.md)

Each R exercise has an `analysis.R` entry point, an English explanation, and a synthetic demo. See [running R exercises](docs/RUNNING-R.md) and [R validation](docs/R-VALIDATION.md). R uses its own interpreter; Python and pip are not required.

```powershell
Rscript 05-r-diabetes-analysis/analysis.R --demo
Rscript 06-r-app-store-cleaning/analysis.R --demo
Rscript 07-r-battery-regression/analysis.R --demo
```

## Capstone project

[House Price Prediction and Property Recommendations](https://github.com/montazertirbati/house-price-advisor) is a separate repository with regression pipelines, a budget-constrained recommendation CLI, and a synthetic demo.

## Featured work

| Exercise | Skills | Runnable command |
|---|---|---|
| 5 · Retail analysis | deduplication, missing-value audit, datetime parsing, aggregate reporting | `retail --data PATH` |
| 6 · Spine PCA | median imputation, standardization, explained variance, loadings | `spine --data PATH` |
| 7 · Block classification | KNN, LDA, Gaussian NB, logistic regression, PCA, leakage-safe cross-validation | `blocks --data PATH` |
| 8 · Digit recognition | SVM, decision tree, random forest, grid search, confusion matrices | `digits` |

## Run locally

Use Python 3.11 or newer. Download and extract the repository, then open PowerShell in its root folder:

```powershell
py -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe 04-digit-recognition/analysis.py --quick
```

The digits example needs no external dataset file. These commands do not require activating the environment. If `py` is unavailable, use `python -m venv .venv` for the first command. On macOS/Linux create the environment with `python3` and use `.venv/bin/python`.

See the [step-by-step execution guide](docs/RUNNING.md) for Windows, local datasets, the housing capstone, and running checks through GitHub Actions.

Outputs are written under `outputs/<exercise>/`. `--quick` reduces classification search size for a smoke run; omit it for the wider search. Dependencies use compatible ranges; this is not a locked environment.

## Evaluation design

Classification uses a fixed, stratified 80/20 holdout and shuffled stratified cross-validation on training data. Imputation, scaling and PCA are fitted inside each CV fold through scikit-learn pipelines. Hyperparameters are selected by CV balanced accuracy. Test accuracy, test balanced accuracy and confusion matrices are reported separately. Holdout metrics compare fixed candidates; repeated selection against the holdout would require a fresh evaluation set. PCA on the spine data is descriptive and does not claim predictive performance.

## Repository contents

- `exercises/portfolio.py`: runnable, modernized exercises 5–8.
- `reference/`: original homework 1–3 and 5–8 saved as `.txt`, including incomplete code; these are provenance references, not executable examples.
- `docs/source-audit.json`: syntax audit and hashes of source code found in the local archive, including files outside this curated selection. Syntax success does not establish runtime correctness.
- `data/README.md`: required data schemas and data handling notes.
- `docs/REVIEW.md`: scope, corrections and known limitations.

Original course notes, recordings, certificates, documents and datasets are excluded. Source attribution is retained in reference scripts where present. No license is assigned to third-party material; verify ownership and permissions before public release. This is educational coursework, not a production system.
