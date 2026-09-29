# Time Series Analysis — Fall 2026

Forecasting & Time Series Analysis for 3rd-year Business & Data students at IE University.

This repo holds everything you need for the course: session-by-session materials, notes, data files, and a setup guide. It follows the textbook *Forecasting: Principles and Practice* (3rd ed.) — <https://otexts.com/fpp3/> — the chapters up to and including exponential smoothing, taught in **R**.

**[SYLLABUS.md](SYLLABUS.md) is the course document**: the 20-session program, assessment weights, the generative-AI and library policies, the retake rules and the bibliography. Read it once at the start of term.

The course's method is **build it by hand, then verify against the library** — you will implement classical decomposition, simple exponential smoothing, prediction intervals and the error metrics yourself before calling the function that does them. Doing those by hand is the point; reaching for a library call instead skips the learning.

---

## Before the first class

Please arrive with your environment ready. Full instructions are in **[setup/SETUP.md](setup/SETUP.md)** and take about 20 minutes:

1. Install **R**, then **RStudio Desktop** (order matters).
2. Install the course packages — in RStudio, run `install.packages("fpp3")`.
3. Get this repo (see below).

If you get stuck, don't worry: **Session 1 is a supported install day.** But the more you set up beforehand, the more class time we spend on forecasting instead of installers.

## The R primer is mandatory

Work through the seven short documents in **[self-study/00-r-basics/](self-study/00-r-basics/)** during the first two weeks of term. Everything after Session 2 assumes them. They are self-study: solutions are not distributed.

## Getting the materials

**Option A — Clone** (recommended; lets you pull updates with one command):

```
git clone https://github.com/aleberriz/tsa-fpp3-2026.git
```

**Option B — Download ZIP** (no Git needed):
Click the green **Code** button at the top of this page → **Download ZIP** → unzip somewhere you'll find it.

This repo is **updated throughout the term.** If you cloned it, run `git pull` before each class to get the latest materials. If you downloaded the ZIP, re-download every week or so.

### Your own files and `git pull`

`git pull` only ever updates the course materials. Files you create yourself — your homework `.qmd`, rendered `.html`, notes — are not tracked by git, so a pull never touches, overwrites or deletes them. If git ever refuses to pull with an *"untracked working tree file would be overwritten"* error, it is protecting one of your files: that file has the same name as something newly added to the course materials. Rename or move your file and pull again; nothing is lost.

Two optional habits, if you feel so inclined:

* **Keep your own work in a `homework/` folder in the repo root.** Git ignores that folder (it is in `.gitignore`), so nothing you put there can ever collide with course materials, even by name.
* **Never discard changes to make an error go away.** If a pull fails because you edited a course file (say, a session notebook) and it was also updated upstream, the safe move is `git stash`, pull, and then `git stash pop` to recover your edit. Clicking *Discard all changes* in RStudio's Git pane or GitHub Desktop deletes your edits for real.

Re-downloading the ZIP instead of pulling is also safe, but unzip it to a fresh folder rather than over the old one, and carry your `homework/` folder across with you.

## How the repo is organized

```
tsa-fpp3-2026/
├── README.md            ← you are here
├── SYLLABUS.md          ← the course document: program, assessment, policies
├── setup/SETUP.md       ← install guide (start here)
├── tsa.Rproj            ← open this in RStudio to work in the project
├── self-study/
│   └── 00-r-basics/     ← mandatory R primer to work through early
├── sessions/
│   ├── 01-intro-setup/
│   │   ├── README.md    ← textbook sections, focus, R functions, homework, outcome
│   │   └── ...          ← the notebooks/materials for that session
│   └── ...              ← one folder per session, 01–20
├── assignments/         ← the two group assignments
└── data/                ← data files several exercises need (see below)
```

Slides and notebooks for a session live **inside that session's folder**, so everything you need for a given class is in one place.

Open **`tsa.Rproj`** in RStudio first (File → Open Project). Working inside the project sets the working directory correctly, so the materials' code runs.

## Course data files

Many datasets come bundled in the `fpp3` packages, so those load directly in R — nothing to fetch. **But several in-class exercises and homeworks use external files that ship in this repo, in the [`data/`](data/) folder.** A few notebooks open a file picker with `read_csv(file.choose())`; when one does, just point it at the matching file in `data/`:

| File | Used in |
|---|---|
| `soi_recruitment.csv` | Session 3 |
| `Beijing_Pollution_TSeries.csv`, `Weekly Fuel Prices.xlsx` | Session 4 homework |
| `australian_imports_japan.csv`, `private_housing_US.csv` | Session 11 homework |
| `yhat_SES_test` | Session 16 |

Group Assignment 2 also uses an external file. It ships with the assignment in Session 17.

If you cloned the repo these are already on your machine; if you downloaded the ZIP, they're inside the unzipped folder under `data/`.

## Homework

Homework is submitted on **Blackboard**, not here. This repo is read-only course material — you don't push anything to it. Homework is due by 23:59 on the Sunday of the teaching week in which it was assigned, and is graded on completion and effort rather than on correctness. After each due date a common-errors note goes up on Blackboard and the main difficulties are reviewed at the start of the first session after the deadline; a rotating sample of submissions also receives individual written comments.

If you'd like to keep your *own* work under version control, create your own separate repo. It's good practice and entirely optional — your use of Git is not graded.

## The textbook

Free and online: **<https://otexts.com/fpp3/>**. This course covers the material **up to exponential smoothing**; the follow-up course, *Forecasting for Time Series*, covers regression, ARIMA and beyond.

## Credits

These materials are the joint work of **Prof. Juan Garbayo**, who created the course and authored the
original materials, and **Prof. Alejandro Berrizbeitia**, who adapted and extended them for 2026.

Licensed under CC BY-NC-SA 4.0 (materials) and MIT (R code) — see [LICENSE](LICENSE). Several
notebooks work through examples from *Forecasting: Principles and Practice* (3rd ed.) by Hyndman and
Athanasopoulos, whose text and figures remain their copyright.
