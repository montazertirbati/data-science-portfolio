# Review and scope

The local archive contains course examples, duplicate scripts, personal documents and multiple project drafts. This curated repository focuses on explicitly named homework directories. There is no homework 4 directory in the inspected archive; no solution was invented for it.

## Corrections in runnable versions

- Exercise 5: removed undefined `df1`, repaired invalid loops and indentation, added explicit datetime parsing and aggregate outputs. Years are Gregorian; an unfinished Jalali demonstration is not represented as a completed feature.
- Exercise 6: replaced interactive state with a complete PCA workflow; numeric aggregation excludes the class label. Original experimental plotting loops are not carried over.
- Exercise 7: all preprocessing and PCA are fitted inside training CV folds. A fixed stratified holdout replaces 1,000 repeated random splits. Original PCA fitting and malformed fit calls were removed. QDA is omitted from this curated comparison; LDA, NB, KNN and logistic models remain.
- Exercise 8: implemented classical model selection with explicit imports and deterministic seeds. The original CNN draft contains malformed code and obsolete wrapper usage; it remains reference-only and no CNN result is claimed. Bagging and AdaBoost are also reference-only.
- R exercises 1–3 are preserved as reference text and have not been executed or modernized. Original labels such as `a)` require editing before R execution.

No scores are hard-coded. Runtime results are recorded after local verification in `VALIDATION.md`. External datasets are not redistributed. Local house-price project variants and class examples were inventoried but are outside the runnable selection.
