"""
plot_sweep.py -- G1(c) figure for Project 1 (variant E0E201)

Reads sweep.csv and draws two log-log panels:
  (i)  cycles vs. n for the original and optimized programs
  (ii) speedup vs. n, with a reference line at 10x (and 1x = break-even)

Smooth curves come from the instruction-mix cycle formulas (machine-A CPI table);
markers are the measured rows in sweep.csv, so the two should sit on top of each other.

Usage:   python plot_sweep.py              (sweep.csv in the same folder)
Output:  sweep_plot.png  (300 dpi, ready for the report)
Needs:   pip install matplotlib numpy
"""

import csv
import numpy as np
import matplotlib.pyplot as plt

# ---- 1. Inputs ---------------------------------------------------------------
CSV_PATH = "sweep.csv"
OUT_PATH = "sweep_plot.png"

ORIG_COLOR = "#2a78d6"   # blue   (series 1)
OPT_COLOR = "#eb6834"    # orange (series 2)
INK = "#333333"          # text / reference lines
GRID = "#dddddd"


def orig_cycles(n):
    """Original program: 7n^2 + 81n + 106 cycles (from the C4 instruction mix)."""
    return 7 * n**2 + 81 * n + 106


def opt_cycles(n):
    """Optimized program: constant 177 cycles (11 ALU, 3 MulDiv, 1 branch, 4 ecall)."""
    return np.full_like(np.asarray(n, dtype=float), 177.0)


# ---- 2. Load the measured table ----------------------------------------------
rows = []
with open(CSV_PATH, newline="") as f:
    for r in csv.DictReader(f):
        rows.append({k: float(v) for k, v in r.items()})

n_all = np.array([r["n"] for r in rows])
orig_all = np.array([r["orig_cycles"] for r in rows])
opt_all = np.array([r["opt_cycles"] for r in rows])
speedup_all = np.array([r["speedup"] for r in rows])

# Sanity check: the table must agree with the formulas.
assert np.allclose(orig_all, orig_cycles(n_all)), "orig_cycles column != 7n^2+81n+106"
assert np.allclose(opt_all, opt_cycles(n_all)), "opt_cycles column != 177"

# log axes cannot show n = 0, so plot n >= 1 and report n = 0 in a note.
keep = n_all > 0
n, orig, opt, speedup = n_all[keep], orig_all[keep], opt_all[keep], speedup_all[keep]
speedup_n0 = speedup_all[n_all == 0][0] if (n_all == 0).any() else None

# Smooth curves for the formulas.
n_fit = np.logspace(0, np.log10(n.max()), 300)

# ---- 3. Figure ----------------------------------------------------------------
plt.rcParams.update({"font.size": 10, "axes.edgecolor": "#999999",
                     "axes.labelcolor": INK, "xtick.color": INK, "ytick.color": INK})
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(11, 4.6), constrained_layout=True)

# ---- (i) cycles vs n ---------------------------------------------------------
ax1.plot(n_fit, orig_cycles(n_fit), color=ORIG_COLOR, lw=2)
ax1.plot(n_fit, opt_cycles(n_fit), color=OPT_COLOR, lw=2, ls="--")
ax1.plot(n, orig, "o", color=ORIG_COLOR, ms=7, mec="white", mew=1.5,
         label="original  (7n² + 81n + 106)")
ax1.plot(n, opt, "s", color=OPT_COLOR, ms=7, mec="white", mew=1.5,
         label="optimized (177, constant)")

ax1.annotate("O(n²)  slope 2", xy=(200, orig_cycles(200)), xytext=(12, 1.5e6),
             color=ORIG_COLOR, fontweight="bold",
             arrowprops=dict(arrowstyle="-", color=ORIG_COLOR, lw=1))
ax1.text(30, 177 * 1.6, "O(1)  flat", color=OPT_COLOR, fontweight="bold")
ax1.text(1.15, 900, "curves nearly meet\nat n = 1 (194 vs 177)", color=INK, fontsize=9)

ax1.set_xscale("log")
ax1.set_yscale("log")
ax1.set_xlabel("input n")
ax1.set_ylabel("cycles (machine A CPI table)")
ax1.set_title("(i) Cycles vs. n", loc="left", fontweight="bold", color=INK)
ax1.grid(True, which="major", color=GRID, lw=0.8)
ax1.legend(frameon=False, loc="upper left")

# ---- (ii) speedup vs n -------------------------------------------------------
ax2.plot(n_fit, orig_cycles(n_fit) / 177.0, color=INK, lw=2)
ax2.plot(n, speedup, "o", color=INK, ms=7, mec="white", mew=1.5,
         label="speedup = orig_cycles / 177")
ax2.axhline(10, color=OPT_COLOR, lw=1.5, ls="--")
ax2.text(1.1, 10 * 1.25, "10×", color=OPT_COLOR, fontweight="bold")
ax2.axhline(1, color="#999999", lw=1, ls=":")
ax2.text(150, 1 * 1.25, "1× (break-even)", color="#777777", fontsize=9)

# Mark the G1 crossover (first table n with speedup >= 10).
cross_n = n[speedup >= 10][0]
cross_s = speedup[speedup >= 10][0]
ax2.annotate(f"first n ≥ 10×: n = {int(cross_n)}  ({cross_s:.1f}×)",
             xy=(cross_n, cross_s), xytext=(40, 3.0), color=INK, fontsize=9,
             arrowprops=dict(arrowstyle="->", color=INK, lw=1))
ax2.text(60, 2500, "≈ O(n²)  slope 2", color=INK, fontweight="bold")

ax2.set_xscale("log")
ax2.set_yscale("log")
ax2.set_xlabel("input n")
ax2.set_ylabel("speedup (×)")
ax2.set_title("(ii) Speedup vs. n", loc="left", fontweight="bold", color=INK)
ax2.grid(True, which="major", color=GRID, lw=0.8)
ax2.legend(frameon=False, loc="upper left")

if speedup_n0 is not None:
    ax2.text(0.03, 0.88,
             f"n = 0 not shown on log axes:\nspeedup = {speedup_n0:.2f}× (optimized is slower)",
             transform=ax2.transAxes, ha="left", va="top", fontsize=8.5, color="#777777")

fig.savefig(OUT_PATH, dpi=300)
print(f"saved {OUT_PATH}")
plt.show()
