# Handwritten Digit Recognition

## Objective

Compare SVM, decision tree, and random forest models on the bundled scikit-learn digits dataset.

## Run

Install the dependencies from the repository root with `python -m pip install -r requirements.txt`, then run:

```sh
python 04-digit-recognition/analysis.py --quick
```

The command above is run from the repository root. You can use any absolute dataset path. Results are saved to `outputs/digits/` relative to your working directory.

## Data

Required schema: Bundled scikit-learn digits dataset; no external file required. External datasets are excluded from this repository; supply a permitted local copy. See [data notes](../data/README.md).

## Implementation

`analysis.py` is this exercise's entry point. The implementation lives in [portfolio.py](../exercises/portfolio.py) to share validation and evaluation utilities without duplicating code.

## Verification

Syntax checked. Runtime verification pending because scikit-learn could not be downloaded in the preparation environment. No performance claim is made.

## Limitations

This is a modernized coursework example. See [review notes](../docs/REVIEW.md) for differences from the original drafts and [validation status](../docs/VALIDATION.md) for the checks actually completed.
