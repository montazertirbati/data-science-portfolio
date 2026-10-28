"""Run this portfolio exercise from any working directory."""
from pathlib import Path
import runpy
import sys

if __name__ == "__main__":
    sys.argv.insert(1, 'spine')
    runpy.run_path(str(Path(__file__).resolve().parents[1] / "exercises" / "portfolio.py"), run_name="__main__")
