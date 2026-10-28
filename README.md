# Data Science Coursework Portfolio

Python and R coursework covering data cleaning, exploratory statistics, principal component analysis, classification, and model selection. This repository contains modernized Python implementations of exercises 5–8 alongside the original homework code as reference text.

## Portfolio projects

- [Retail Transaction Analysis](01-retail-analysis/README.md)
- [Spine Data: Principal Component Analysis](02-spine-pca/README.md)
- [Block Classification](03-block-classification/README.md)
- [Handwritten Digit Recognition](04-digit-recognition/README.md)

## Featured work

| Exercise | Skills | Runnable command |
|---|---|---|
| 5 · Retail analysis | deduplication, missing-value audit, datetime parsing, aggregate reporting | `retail --data PATH` |
| 6 · Spine PCA | median imputation, standardization, explained variance, loadings | `spine --data PATH` |
| 7 · Block classification | KNN, LDA, Gaussian NB, logistic regression, PCA, leakage-safe cross-validation | `blocks --data PATH` |
| 8 · Digit recognition | SVM, decision tree, random forest, grid search, confusion matrices | `digits` |

## Run locally

Use Python 3.11 or newer. From this directory:

```sh
python -m venv .venv
# Windows PowerShell:
.venv\Scripts\Activate.ps1
# macOS/Linux: source .venv/bin/activate
python -m pip install -r requirements.txt
python exercises/portfolio.py digits --quick
python exercises/portfolio.py spine --data "../Spine.csv"
python exercises/portfolio.py blocks --data "../homework7/blocks.csv" --quick
python exercises/portfolio.py retail --data "../digi2.csv"
```

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
