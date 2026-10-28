# Running the R exercises

Install R 4.3 or newer from [CRAN](https://cran.r-project.org/). RStudio is an optional editor; VS Code can also edit the .R files. R scripts use R, not the Python virtual environment.

Open the repository root folder in VS Code, then Terminal > New Terminal. Check:

```powershell
Rscript --version
```

If Windows does not find Rscript, use your installed R version's full path, for example (replace the version with yours):

```powershell
& "C:/Program Files/R/R-4.x.x/bin/Rscript.exe" 05-r-diabetes-analysis/analysis.R --demo
```

Run the three synthetic demonstrations from the repository root:

```powershell
Rscript 05-r-diabetes-analysis/analysis.R --demo
Rscript 06-r-app-store-cleaning/analysis.R --demo
Rscript 07-r-battery-regression/analysis.R --demo
```

For the original analyses, open an R/RStudio console and install packages as needed:

```r
install.packages(c("faraway", "mice", "nortest"), repos = "https://cloud.r-project.org")
```

Then run in PowerShell:

```powershell
Rscript 05-r-diabetes-analysis/analysis.R
Rscript 06-r-app-store-cleaning/analysis.R --data "D:/data science class/googleplaystore3.csv" --impute --date 2020-01-01
Rscript 07-r-battery-regression/analysis.R --data "D:/data science class/battery.csv"
```

If using an R console instead of PowerShell, call `system2("Rscript", c("05-r-diabetes-analysis/analysis.R", "--demo"))` from the repository root. Each command is a fresh script process; do not paste the full .R source into a partially initialized workspace.

Look under outputs/r-diabetes, outputs/r-app-store, and outputs/r-battery for CSV summaries, PDF plots and the session information. MICE additionally exports multiple_imputations.rds and one illustrative completed table. See each exercise README for interpretations and limitations.
