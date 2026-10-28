# Spine Data: Principal Component Analysis

## Objective

Explore six numeric measurements using imputation, standardization, principal components, explained variance, and feature loadings.

## Run

Install the dependencies from the repository root with `python -m pip install -r requirements.txt`, then run:

```sh
python 02-spine-pca/analysis.py --data "../Spine.csv"
```

The command above is run from the repository root. You can use any absolute dataset path. Results are saved to `outputs/spine/` relative to your working directory.

## Data

Required schema: PI, PT, LL, SS, PR, GS, Categories. External datasets are excluded from this repository; supply a permitted local copy. See [data notes](../data/README.md).

## Implementation

`analysis.py` is this exercise's entry point. The implementation lives in [portfolio.py](../exercises/portfolio.py) to share validation and evaluation utilities without duplicating code.

## Verification

Syntax checked. Runtime verification pending because scikit-learn could not be downloaded in the preparation environment. No performance claim is made.

## Limitations

This is a modernized coursework example. See [review notes](../docs/REVIEW.md) for differences from the original drafts and [validation status](../docs/VALIDATION.md) for the checks actually completed.
