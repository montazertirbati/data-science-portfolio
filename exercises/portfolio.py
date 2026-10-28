"""Reproducible versions of coursework exercises 5–8."""
from argparse import ArgumentParser
from pathlib import Path
import json
import numpy as np
import pandas as pd

SEED = 42

def load_table(path, required):
    if path is None:
        raise ValueError("Supply a CSV file with --data; see data/README.md")
    frame = pd.read_csv(path)
    missing = set(required) - set(frame.columns)
    if missing:
        raise ValueError(f"Missing columns: {sorted(missing)}")
    if frame.empty:
        raise ValueError("Dataset is empty")
    return frame

def retail(path, out):
    df = load_table(path, ["ID_Order", "ID_Customer", "ID_Item", "DateTime_CartFinalize", "city_name_fa", "Quantity_item"])
    df = df.drop_duplicates().copy()
    df["DateTime_CartFinalize"] = pd.to_datetime(df["DateTime_CartFinalize"], format="mixed", errors="coerce")
    df["Quantity_item"] = pd.to_numeric(df["Quantity_item"], errors="coerce")
    # Gregorian years are explicit; the original Jalali conversion was incomplete.
    df["year"] = df["DateTime_CartFinalize"].dt.year
    summary = {"rows_after_deduplication": len(df), "unique_orders": int(df.ID_Order.nunique()),
               "missing_values": df.isna().sum().to_dict()}
    df.groupby("city_name_fa").agg(orders=("ID_Order", "nunique"), units=("Quantity_item", "sum")).sort_values("orders", ascending=False).to_csv(out / "cities.csv")
    df.groupby("year").agg(orders=("ID_Order", "nunique"), units=("Quantity_item", "sum")).to_csv(out / "years.csv")
    # Export aggregate statistics only, without customer or item identifiers.
    return summary

def spine(path, out):
    from sklearn.datasets import load_digits
    from sklearn.decomposition import PCA
    from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.impute import SimpleImputer
    from sklearn.linear_model import LogisticRegression
    from sklearn.metrics import accuracy_score, balanced_accuracy_score, confusion_matrix
    from sklearn.model_selection import GridSearchCV, StratifiedKFold, train_test_split
    from sklearn.naive_bayes import GaussianNB
    from sklearn.neighbors import KNeighborsClassifier
    from sklearn.pipeline import Pipeline
    from sklearn.preprocessing import StandardScaler
    from sklearn.svm import SVC
    from sklearn.tree import DecisionTreeClassifier
    features = ["PI", "PT", "LL", "SS", "PR", "GS"]
    df = load_table(path, features + ["Categories"])
    x = df[features].apply(pd.to_numeric, errors="raise")
    if x.notna().sum().min() == 0 or len(x) < 6:
        raise ValueError("Need at least six rows and an observed value in each feature")
    pipeline = Pipeline([("impute", SimpleImputer(strategy="median")), ("scale", StandardScaler()), ("pca", PCA())])
    pipeline.fit(x)
    pca = pipeline.named_steps["pca"]
    pd.DataFrame({"component": np.arange(1, 7), "explained_variance_ratio": pca.explained_variance_ratio_, "cumulative": pca.explained_variance_ratio_.cumsum()}).to_csv(out / "pca_variance.csv", index=False)
    pd.DataFrame(pca.components_.T, index=features).to_csv(out / "pca_loadings.csv")
    df.groupby("Categories")[features].agg(["mean", "std"]).to_csv(out / "category_summary.csv")
    return {"rows": len(df), "first_two_components_variance": float(pca.explained_variance_ratio_[:2].sum())}

def classify(kind, path, out, quick):
    from sklearn.datasets import load_digits
    from sklearn.decomposition import PCA
    from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.impute import SimpleImputer
    from sklearn.linear_model import LogisticRegression
    from sklearn.metrics import accuracy_score, balanced_accuracy_score, confusion_matrix
    from sklearn.model_selection import GridSearchCV, StratifiedKFold, train_test_split
    from sklearn.naive_bayes import GaussianNB
    from sklearn.neighbors import KNeighborsClassifier
    from sklearn.pipeline import Pipeline
    from sklearn.preprocessing import StandardScaler
    from sklearn.svm import SVC
    from sklearn.tree import DecisionTreeClassifier
    if kind == "digits":
        x, y = load_digits(return_X_y=True)
        models = {"svm": (SVC(), {"model__C": [1, 10], "model__kernel": ["rbf"]}),
                  "tree": (DecisionTreeClassifier(random_state=SEED), {"model__max_depth": [8, 16]}),
                  "forest": (RandomForestClassifier(n_estimators=100, random_state=SEED, n_jobs=1), {"model__max_depth": [None, 16]})}
    else:
        df = load_table(path, ["block"])
        if df.block.isna().any():
            raise ValueError("Target block contains missing values")
        x = df.drop(columns="block").apply(pd.to_numeric, errors="raise")
        if x.shape[1] != 10 or x.notna().sum().min() == 0:
            raise ValueError("Expected ten nonempty numeric predictors")
        y = df.block
        models = {"knn": (KNeighborsClassifier(), {"model__n_neighbors": [3, 5, 9]}),
                  "lda": (LinearDiscriminantAnalysis(), {}), "naive_bayes": (GaussianNB(), {}),
                  "logistic": (LogisticRegression(max_iter=3000, random_state=SEED), {"model__C": [0.1, 1, 10]}),
                  "pca_logistic": (LogisticRegression(max_iter=3000, random_state=SEED), {"pca__n_components": [3, 6, 9], "model__C": [1]})}
    xtrain, xtest, ytrain, ytest = train_test_split(x, y, test_size=0.2, random_state=SEED, stratify=y)
    folds = 3 if quick else 5
    if pd.Series(ytrain).value_counts().min() < folds:
        raise ValueError(f"Each training class needs at least {folds} rows")
    cv = StratifiedKFold(n_splits=folds, shuffle=True, random_state=SEED)
    rows = []
    for name, (model, params) in models.items():
        steps = [("impute", SimpleImputer(strategy="median")), ("scale", StandardScaler())]
        if name == "pca_logistic":
            steps.append(("pca", PCA()))
        steps.append(("model", model))
        if quick:
            params = {key: values[:1] for key, values in params.items()}
        search = GridSearchCV(Pipeline(steps), params, cv=cv, scoring="balanced_accuracy", n_jobs=1, error_score="raise")
        search.fit(xtrain, ytrain)
        predicted = search.predict(xtest)
        labels = np.unique(y)
        pd.DataFrame(confusion_matrix(ytest, predicted, labels=labels), index=labels, columns=labels).to_csv(out / f"{name}_confusion.csv")
        rows.append({"model": name, "cv_balanced_accuracy": float(search.best_score_), "test_accuracy": float(accuracy_score(ytest, predicted)), "test_balanced_accuracy": float(balanced_accuracy_score(ytest, predicted)), "parameters": search.best_params_})
    return {"seed": SEED, "cv_folds": folds, "train_rows": len(ytrain), "test_rows": len(ytest), "models": rows}

def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("exercise", choices=["retail", "spine", "blocks", "digits"])
    parser.add_argument("--data", type=Path)
    parser.add_argument("--output", type=Path, default=Path("outputs"))
    parser.add_argument("--quick", action="store_true", help="Use three CV folds and smaller search grids")
    args = parser.parse_args()
    out = args.output / args.exercise
    out.mkdir(parents=True, exist_ok=True)
    try:
        result = retail(args.data, out) if args.exercise == "retail" else spine(args.data, out) if args.exercise == "spine" else classify(args.exercise, args.data, out, args.quick)
    except (ValueError, FileNotFoundError) as error:
        parser.error(str(error))
    result["exercise"] = args.exercise
    (out / "metrics.json").write_text(json.dumps(result, indent=2, ensure_ascii=False), encoding="utf-8")
    print(json.dumps(result, indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()
