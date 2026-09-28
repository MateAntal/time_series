# Setup guide — Time Series Analysis (Fall 2026)

You'll install three things, **in this order**:

1. **R** — the language (from CRAN).
2. **RStudio Desktop** — the editor we use in class (from Posit).
3. **The `fpp3` packages** — the course toolkit (from inside RStudio).

R must be installed **before** RStudio, because RStudio is just a front-end that looks for an R already on your machine.

Budget ~20 minutes. If anything breaks, skip to [Troubleshooting](#troubleshooting) — and remember Session 1 is a supported install day, so you won't fall behind.

---

## 1. Install R

Go to **<https://cran.r-project.org/>** and pick your system.

### Windows
- Download and run the latest R installer; accept the defaults.
- **Also install Rtools** (same CRAN page → "Rtools"). Choose the Rtools version that **matches your R version** (for example, Rtools45 for R 4.5.x). Rtools lets R build the occasional package from source — without it, some installs fail. Accept the defaults so it's added to your PATH.

### macOS
- On the CRAN macOS page, pick the build for **your chip**:
  - **Apple Silicon (M1/M2/M3/M4)** → the **arm64** build.
  - **Older Intel Macs** → the **x86_64** build.
- Installing the wrong architecture is the most common Mac problem — check  → About This Mac if you're unsure.
- Optional, and only if a package later asks to compile: run `xcode-select --install` in Terminal.

### Fedora
- ```
  sudo dnf install R
  ```
- This also pulls in the compiler toolchain R needs.

### Ubuntu / Debian
Ubuntu's own repositories ship an older R that can lag CRAN by a full release. To get the
current R (the 4.6.\* series), add CRAN's official APT repository first:

```
# update indices
sudo apt update -qq

# helper packages needed to add the repo
sudo apt install --no-install-recommends software-properties-common dirmngr

# add CRAN's signing key
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
  | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc

# add the CRAN repo -- lsb_release picks your Ubuntu release (noble, jammy, ...) automatically
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

# install R
sudo apt install --no-install-recommends r-base
```

> **Note:** `cran40` is not R 4.0 — it marks the R 4.0 binary-compatibility line and serves
> the current R 4.6.\* series. `$(lsb_release -cs)` fills in your Ubuntu codename for you.

If you're on Debian rather than Ubuntu, or you just want R quickly and don't mind an
older version, `sudo apt install r-base` on its own works too — but for this course the
CRAN repo above is recommended so everyone is on a current R.

## 2. Install RStudio Desktop

Download from **<https://posit.co/download/rstudio-desktop/>** and install for your OS.

- **Windows / macOS:** run the installer, or drag RStudio to Applications. On macOS, if it won't open the first time, right-click the app → **Open** (this clears Gatekeeper; you only do it once).
- **Fedora:** download the RStudio Desktop `.rpm`, then install it with:
  ```
  sudo dnf install ./rstudio-*.rpm
  ```
  **Then, before installing any R package, install the development headers:**
  ```
  sudo dnf install gcc gcc-c++ make \
    libcurl-devel openssl-devel libxml2-devel libuv-devel \
    fontconfig-devel freetype-devel harfbuzz-devel fribidi-devel \
    libpng-devel libtiff-devel libjpeg-turbo-devel
  ```
- **Ubuntu / Debian:** download the RStudio Desktop `.deb`, then install it with:
  ```
  sudo apt install ./rstudio-*.deb
  ```
  **Then, before installing any R package, install the development headers:**
  ```
  sudo apt install build-essential \
    libcurl4-openssl-dev libssl-dev libxml2-dev libuv1-dev \
    libfontconfig1-dev libfreetype6-dev libharfbuzz-dev libfribidi-dev \
    libpng-dev libtiff-dev libjpeg-dev
  ```

This step is **not optional on Linux.** Windows and macOS download ready-built
packages from CRAN, but CRAN publishes no Linux builds, so on Fedora and Ubuntu every
package is compiled on your machine from source — and compiling needs these headers.
Skip it and installs fail with messages like `dependencies 'httr', 'xml2' are not available`,
or with a package (e.g. `fs`) failing to build with `fatal error: uv.h: No such file or directory`.

## 3. Install the course packages

Open RStudio and, in the **Console** (bottom-left), run:

```r
install.packages("fpp3")

install.packages(c(
  "tidyverse", "nycflights13", "babynames",   # the R primer in self-study/
  "urca",                                     # needed by ARIMA()
  "GGally", "fma", "patchwork",               # sessions 3, 7, 9 and 12
  "cowplot", "seasonal"                       # sessions 12 and 7
))
```

The first line installs the forecasting toolkit — `tsibble`, `feasts`, `fable`, `tsibbledata`, and their dependencies. It can take a few minutes. Watch for red **error** lines; plain warnings are usually fine.

**Please don't skip the second line.** These packages are used by the course materials but are *not* pulled in by `fpp3`, so you have to ask for them by name. Installing them now means nothing stops halfway through a session later:

| Package | First needed | Why `fpp3` doesn't cover it |
|---|---|---|
| `tidyverse` | the R primer, **your first homework** | see the note below |
| `nycflights13`, `babynames` | the R primer | example datasets it uses |
| `urca` | Session 1 | `ARIMA()`'s unit-root test |
| `GGally`, `fma`, `patchwork` | Session 3 onwards | plotting and extra datasets |
| `cowplot`, `seasonal` | Sessions 12 and 7 | loaded by those notebooks |

> **"Doesn't `fpp3` already give me the tidyverse?"** Not quite, and the distinction bites.
> Loading `fpp3` attaches **five** tidyverse member packages — `dplyr`, `tibble`, `tidyr`,
> `lubridate` and `ggplot2` — which is why its startup message mentions the tidyverse. But
> the `tidyverse` package *itself* is not among them, so `library(tidyverse)` fails until
> you install it. Two of its members you will definitely need are missing too: **`readr`**
> (for `read_csv()`, used in Sessions 3, 4 and 11) and **`readxl`** (for `read_xlsx()`, in
> the Session 4 homework). Installing `tidyverse` brings both.

> **If R ever stops and shows `Selection:` or `Enter an item from the menu`,** it is asking whether to install something. Type `0` and press Enter to get back to the `>` prompt, then install the package it named with `install.packages("<name>")`.

You will not need to install **Quarto** separately — RStudio already includes it.

## 4. Get the course materials

**Clone (recommended):**

```
git clone https://github.com/aleberriz/tsa-fpp3-2026.git
```

**Or Download ZIP:** green **Code** button on the repo → **Download ZIP** → unzip.

Then open **`tsa.Rproj`** in RStudio (File → Open Project). Working inside the project keeps file paths tidy, so the materials' code runs without edits.

> **Course data files:** some exercises load a local file with `read_csv(file.choose())`. When that happens, point the file picker at the matching file in this repo's **`data/`** folder — they're already on your machine once you've cloned or unzipped. (See the table in the repo README for which file each exercise needs.)

## 5. Verify everything works

Open `sessions/01-intro-setup/`'s first notebook, or just paste this into the Console:

```r
library(fpp3)

aus_production |>
  autoplot(Beer)

setdiff(c("tidyverse", "nycflights13", "babynames", "urca",
          "GGally", "fma", "patchwork", "cowplot", "seasonal"),
        rownames(installed.packages()))
```

If a plot of Australian beer production appears in the bottom-right pane **and** that last line prints `character(0)`, you're ready for class. 🎉

If it lists any package names, those are the ones still missing — install them with `install.packages("<name>")` and check again.

> **Seeing a "Conflicts" block when you load a package?** That's normal. When you run
> `library(tidyverse)` (or load `fpp3`), R may print lines like
> `dplyr::filter() masks stats::filter()`. This is *namespace masking*, not an error:
> two attached packages define a function with the same name, and the one loaded most
> recently wins for the bare name. Nothing is broken and nothing is lost — the masked
> version is still there whenever you want it, spelled out in full as `stats::filter()`.
> **One thing to remember in this course:** `stats::filter()` and `stats::lag()` are real
> time-series functions, so if a notebook needs the base-R versions while the tidyverse is
> loaded, write `stats::filter()` / `stats::lag()` explicitly.

---

## Troubleshooting

**Windows — `install.packages` fails while building a package**
Rtools is probably missing or the wrong version. Install the Rtools that matches your R version from the CRAN page, then restart RStudio and try again.

**Windows — odd library/path errors, or an install that silently does nothing**
Two culprits that specifically affect our cohort:
- An **accented character in your Windows username** (á, é, í, ó, ú, ñ) can break R's default library path. If that's you, tell the instructor — we'll point R at a plain library folder.
- A home folder synced by **OneDrive** can interfere with installs. Prefer a local, non-synced location.

**macOS — package won't install, or an "architecture" error**
You likely installed the wrong R build. Reinstall the **arm64** (Apple Silicon) or **x86_64** (Intel) build to match your Mac.

**macOS — RStudio won't open ("unidentified developer")**
Right-click the app → **Open** → confirm. One time only.

**Fedora / Ubuntu — compile errors mentioning curl, ssl, xml2, or libuv/uv.h**
Install the dev headers listed in step 2 for your distro. A common symptom is a package (often `fs`, a `tidyverse` dependency) failing with `fatal error: uv.h: No such file or directory` — that means `libuv-devel` (Fedora) or `libuv1-dev` (Ubuntu) is missing.

**Still stuck?**
Bring it to Session 1. It's a supported install day and no one gets left behind.