# Retail Transaction Analysis

## Objective

Clean transaction records, audit missing values, and report order counts and unit totals by city and Gregorian year.

## Run

Install the dependencies from the repository root with `python -m pip install -r requirements.txt`, then run:

```sh
python 01-retail-analysis/analysis.py --data "../digi2.csv"
```

The command above is run from the repository root. You can use any absolute dataset path. Results are saved to `outputs/retail/` relative to your working directory.

## Data

Required schema: ID_Order, ID_Customer, ID_Item, DateTime_CartFinalize, city_name_fa, Quantity_item. External datasets are excluded from this repository; supply a permitted local copy. See [data notes](../data/README.md).

## Implementation

`analysis.py` is this exercise's entry point. The implementation lives in [portfolio.py](../exercises/portfolio.py) to share validation and evaluation utilities without duplicating code.

## Verification

Successfully run on 200,000 local transaction rows; 197,631 unique orders.

## Limitations

This is a modernized coursework example. See [review notes](../docs/REVIEW.md) for differences from the original drafts and [validation status](../docs/VALIDATION.md) for the checks actually completed.
