# Local datasets

Datasets are excluded from Git. Supply your own permitted local copies using `--data`.

| Exercise | Local source | Required fields |
|---|---|---|
| retail | digi2.csv | ID_Order, ID_Customer, ID_Item, DateTime_CartFinalize, city_name_fa, Quantity_item |
| spine | Spine.csv | PI, PT, LL, SS, PR, GS, Categories |
| blocks | homework7/blocks.csv | block plus ten numeric predictors |
| digits | bundled with scikit-learn | no external download |

Data provenance and redistribution permissions have not been established from the local archive. Do not upload the original datasets by default. Retail identifiers and transaction dates require particular care. The spine example is an educational statistical analysis.
