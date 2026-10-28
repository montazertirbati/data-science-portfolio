# Running the portfolio on Windows

## 1. Get the code

Open the repository on GitHub, choose **Code > Download ZIP**, and extract the ZIP. Alternatively, if Git is installed:

```powershell
git clone https://github.com/montazertirbati/data-science-portfolio.git
cd data-science-portfolio
```

For a downloaded ZIP, open the extracted folder in File Explorer, type `powershell` in its address bar, and press Enter. The current directory must contain README.md and requirements.txt.

## 2. Create a Python environment

Use Python 3.11 or newer. These commands use the environment's interpreter directly, so no environment activation or PowerShell policy change is needed:

```powershell
py -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

If the `py` launcher is unavailable, try `python -m venv .venv`. Installing dependencies requires internet access. A DNS error mentioning files.pythonhosted.org means package downloads could not reach their host; it is not a model result.

## 3. Run the example that needs no external data file

```powershell
.\.venv\Scripts\python.exe 04-digit-recognition/analysis.py --quick
```

This trains and evaluates classical digit classifiers. Results are printed and saved to `outputs/digits/metrics.json`; confusion matrices are saved alongside it. Open metrics.json in a text editor or the CSV outputs in a spreadsheet viewer. Outputs are local and ignored by Git.

## 4. Run exercises with your original local datasets

For the original archive paths on this computer:

```powershell
.\.venv\Scripts\python.exe 01-retail-analysis/analysis.py --data "D:/data science class/digi2.csv"
.\.venv\Scripts\python.exe 02-spine-pca/analysis.py --data "D:/data science class/Spine.csv"
.\.venv\Scripts\python.exe 03-block-classification/analysis.py --data "D:/data science class/homework7/blocks.csv" --quick
```

For another computer, replace the paths with permitted local copies. The original datasets are not bundled with the repository. Reference `.txt` files are historical incomplete drafts, not the runnable entry points.

## 5. Run the housing capstone

The capstone has its own repository and dependencies: [house-price-advisor](https://github.com/montazertirbati/house-price-advisor). Download or clone it separately, open PowerShell in that folder, then run:

```powershell
py -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe housing.py demo
```

The demo generates synthetic data. For the original course partition, follow the capstone README's `train` command. To get property recommendations from the supplied old prediction export without scikit-learn, the standalone `recommend.py` command needs only NumPy and pandas; those estimates remain legacy results.

## Run a verification in GitHub itself

GitHub stores the code; opening a Python file there does not execute it. The repository's **Actions** tab offers a verification workflow. Open **Verify portfolio**, choose **Run workflow**, select main, and run it. A green check means the workflow's checks passed. Open a run to read its logs and download any result artifacts. The portfolio workflow runs digits only; the housing workflow runs behavioral tests and a synthetic demonstration. Neither workflow trains on your private local files.
