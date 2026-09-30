# Homework review: the three things that cost you the most time

Compiled from HW02, HW03 and HW04. From now on, the first minutes of a session go over the
difficulties that came up most often in the homework just handed in. Nothing here is about
getting it wrong. These are the points where the course materials were not clear enough, and
they are fixed in five minutes each.

---

## 1. Loading a data file from disk

**What happened.** About half of the submissions ended up with an absolute path in them,
something along the lines of:

```r
read_csv("C:/Users/yourname/Downloads/soi_recruitment.csv")
read_csv("/Users/yourname/Library/CloudStorage/OneDrive-Personal/IE/Year 3/...")
```

This is a very reasonable thing to reach for when the path in the materials throws an error,
and some of you may also have been working from a notebook downloaded on its own or from an
earlier copy of the repo, where the relative path could not resolve at all. It is worth knowing
the alternative, because a path like that only resolves on the machine it was written on, so it
breaks when you share a file with your group.

**Why it happened.** R resolves a relative path from the *working directory*, and the working
directory is not always where you think it is.

```r
getwd()   # run this any time you are unsure
```

**The rule.**

* Open **`tsa.Rproj`** first (File > Open Project). The working directory is then the repo root.
* From the **console**, the path from the repo root is:

  ```r
  read_csv("data/soi_recruitment.csv")
  ```

* From inside a **`.qmd` or `.R` file saved in a session folder**, the code runs from that
  folder, so you have to climb two levels out. This is why the session scripts read:

  ```r
  read_csv("../../data/soi_recruitment.csv")
  ```

* If you are stuck, `file.choose()` always works. It opens a file picker:

  ```r
  read_csv(file.choose())
  ```

**Takeaway:** relative path plus the project, not an absolute path.

---

## 2. A loess curve is not a correlation coefficient

**What happened.** In the HW03 scatterplot matrix, the question was whether any relationship
between recruitment and the SOI lags is *non-linear* in a way the correlation coefficient
misses. A number of answers described something else: how the *strength* of the correlation
changes from lag 5 to lag 8.

That observation is true. It is also an answer to a different question.

**What a loess curve is.** A loess curve is a smoother: a line drawn through a scatterplot that
follows the data wherever it goes, without being forced into a straight line. It is many local
regressions stitched together, where a correlation coefficient describes one global line.

**The distinction.**

| The correlation coefficient tells you | The scatterplot tells you |
|---|---|
| How strong a **straight-line** relationship is | Whether the relationship is a straight line **at all** |
| One number | Curvature, clusters, outliers, changes in spread |

A relationship can be strong, obvious and visible to the eye while `r` sits near zero, because
`r` only measures the straight-line part of it.

**What a correct answer looks like.** Point at the smoother and describe its *shape*: the loess
line bends, it is steeper at low recruitment and flattens out at high values, it rises and then
turns over. Shape, not strength.

**Takeaway:** read the scatterplots first and the coefficients second.

---

## 3. Declaring a tsibble's index and key

**What happened.** On HW02, the tsibble was missing from about a quarter of submissions. The
fifteen dplyr exercises were done almost universally, and then the second deliverable, the one
the homework called the one that matters most, did not appear. In other cases `as_tsibble()`
was called without `index =` or `key =`.

**Why it matters.** The tsibble is the container everything downstream needs. `index_by()`,
`autoplot()`, `ACF()`, `model()` and every function in the rest of the course read the index
and the key off the object. Get the container wrong and nothing after it behaves.

**The two things you must declare.**

```r
my_tsibble <-
  my_data |>
  mutate(ym = yearmonth(date_column)) |>       # 1. a proper time type
  as_tsibble(index = ym, key = c(state, industry))
```

* **`index`** is the time column, and there is exactly one. It must be a time type
  (`yearmonth()`, `yearquarter()`, `yearweek()`, `Date`, `make_datetime()`), not text.
* **`key`** is the column or columns that identify separate series in the same table. No key
  means one single series.

**Read the header.** Print the object and check the first two lines before going further:

```
# A tsibble: 3,012 x 4 [1M]
# Key:       state, industry [8]
```

`[1M]` is the interval that was detected, monthly here. `[8]` is the number of distinct series.
If the interval says `[?]`, or the number of series is not what you expect, stop and fix the
tsibble before writing another line.

**Takeaway:** every tsibble needs an index, and a key whenever the table holds more than one
series.

---

## 4. Going forward, a strong recommendation: write your work in a `.qmd`

This is the best way to do the homework and the assignments, and it is what Group Assignment 1
is written in. A Quarto document holds your prose, your code and your output in one file, in the
order you wrote them.

It also makes your work much easier to give feedback on. Code that arrives as text can be read,
searched and run; code that arrives as an image cannot, so any comment on it has to stop at what
is visible in the picture.

**The whole workflow, in RStudio.**

1. **Get the latest materials.** In the terminal, from the repo folder:

   ```
   git pull
   ```

   (Or re-download the ZIP if you did not clone.)

2. **Open `tsa.Rproj`.** File > Open Project. Everything below assumes the project is open.

3. **Make a new document.** File > New File > Quarto Document. Give it a title, leave the format
   as HTML, and create it. You get a file that starts with a header like this:

   ```
   ---
   title: "TSA homework 5"
   format: html
   ---
   ```

4. **Write prose in a markdown block.** Just type. `##` starts a section heading, `**bold**` is
   bold, a blank line separates paragraphs. This is where your interpretation goes, and the
   interpretation is most of the grade.

5. **Write code in an R block.** Insert one with the green **+C** button, or Ctrl+Alt+I
   (Cmd+Option+I on a Mac):

   ````
   ```{r}
   library(fpp3)

   aus_retail |>
     filter(State == "Victoria") |>
     autoplot(Turnover)
   ```
   ````

   Run it with the green arrow at the top right of the block, or Ctrl+Shift+Enter. The plot
   appears right underneath.

6. **Render it, optionally.** Press **Render** at the top of the editor. Quarto runs every block
   from top to bottom in a clean session and produces a single `.html` file with your text, your
   code and every result in it. Open it in a browser.

   Rendering is also a free correctness check: if it renders, your code runs start to finish on
   a machine that is not yours.

**What to submit.** The recommended submission is the rendered `.html`, since it carries your
text, your code and every result in one file, with the `.qmd` kept as your working file. A plain
`.R` script is perfectly acceptable for the short homework. If you do end up submitting images,
paste the code in as text as well wherever you can, so it can be read and run.

---

## In one line each

* Open the project and use relative paths, rather than an absolute `C:/Users/...` one.
* The coefficient measures a straight line. The picture shows you whether there is one.
* Every tsibble gets an `index`, and a `key` if the table holds several series.
* Strongly recommended: write it in a `.qmd`, render it, submit the result.
