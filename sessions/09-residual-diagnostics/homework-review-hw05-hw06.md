# Homework review: what to take from HW05 and HW06

Compiled from HW05 (additive and multiplicative schemes) and HW06 (moving averages). There is
no class time for this one, so it is written to be read on your own: about fifteen minutes.
Sessions 5 and 6 are on the midterm, so it is also revision.

As before, none of this is about getting it wrong. These are the points where the most useful
lesson was hiding.

---

## First, what went well

You do not need to review any of these:

* **Division throughout the multiplicative example.** Everyone who did Example 2 divided where
  Example 1 subtracted.
* **Comparing decimals.** Nobody used `==`, and nobody reached for `round()` to force a check to
  pass.
* **File paths.** Not a single absolute path. In HW03 it was about half of you.
* **The 2x12-MA.** About four in five computed it exactly right.
* **The 3x7-MA derivation.** Nearly everyone got it right, almost always with the windows
  written out first, which is the right way to do it.
* **The 2x8-MA.** Nobody read "2x8" as a window of sixteen points.

---

## 1. A seasonal factor is a ratio, not a quantity

**What happened.** HW05 closed by asking what you would have seen if you had used the additive
arithmetic, `Cost - seasonal`, on the multiplicative series. About a quarter of you described
what actually happens. About half gave a textbook reason ("the seasonal swings would not scale
with the level") that does not describe the plot you get, and that includes several of you who
ran the code and had that plot in front of you.

**Why it matters.** The units of each component depend on the scheme:

| Scheme | The seasonal component is | Typical values for `a10` |
|---|---|---|
| Additive | a quantity, in the units of the series | not applicable |
| Multiplicative | a factor, with no units, around 1 | 0.78, 0.98, 1.23, 1.33 |

`a10`'s `Cost` is in millions of dollars and runs from about 3 to about 30. Subtracting a number
close to 1 from it moves the whole series down by roughly one million and leaves the seasonal
pattern almost untouched. The line looks just like the original, shifted down a little. Nothing
gets removed, because a factor around 1 is the wrong kind of number to subtract.

**The habit.** When a question says "you may run it to find out", run it, and then describe your
own plot rather than what you expected to see.

**Takeaway:** multiplicative components are ratios, so you divide by them. Subtracting one barely
moves the series.

---

## 2. `all.equal()`: a string means a real difference, so check what you think you checked

**What happened.** Three separate slips, all in the verification step:

* **Reading the string backwards.** A few of you wrote that if `all.equal()` returns a string,
  the difference is "just floating-point rounding". It is the other way round. Rounding noise
  falls *inside* the tolerance (about `1.5e-8`), and for that `all.equal()` returns `TRUE`. A
  string such as `"Mean relative difference: 0.15"` means the two columns really disagree.
* **Checking the same example twice.** The notebook reuses the name `classical_dcmp` for both
  examples. Several scripts built Example 2 into that same object and only then ran both checks,
  so both checks ran on `a10`. The output said `TRUE` twice, and Example 1 was never checked.
* **Only one of the two lines.** Some of you ran `isTRUE(all.equal(...))` and never the plain
  `all.equal(...)`. The task asked for both, so that you would see the string form at least
  once.

**The fix for the second slip.** Give each example its own name, or run each check straight
after its own example:

```r
dcmp_retail <- us_retail_employment |> model(...) |> components()
dcmp_a10    <- a10 |> model(...) |> components()
```

**Takeaway:** `TRUE` means equal within tolerance. A string means a real gap, so stop and look.
And a check only counts if it compares the object you meant.

---

## 3. A centred moving average leaves the same gap at both ends

**What happened.** Most of you used the notebook's two-window method for the 2x12-MA, and it
went well. A handful took a different route: a 12-MA first, then a 2-MA of it. That route is
perfectly valid, but most of the people who took it pointed the 2-MA the wrong way, with
`.before = 0, .after = 1`. The result looks right on a plot. It is one full month early.

**Why.** A 12-point window has no middle point, so a 12-MA is never centred on a month: it sits
half a step to one side. The second averaging step exists to cancel that half step. Average it
with the neighbour on the *other* side and you land on `t`. Average it with the neighbour on the
same side and the two half steps add up to a whole one.

**How to catch it yourself.** Count the missing values. A centred moving average needs the same
number of points on each side, so it is missing the same number at the start and at the end. The
notebook's 2x4-MA of beer is missing 2 and 2. The same calculation with the 2-MA pointed forward
is missing 1 at the start and 3 at the end. Unequal gaps mean the filter is not centred.

Two related slips:

* **`.complete = TRUE` left out.** There are no gaps at all, which looks like success. In fact
  the first and last values are averages over partial windows, and nothing warns you.
* **Answering from the rule instead of the output.** The question asked how many values are
  missing in *your* 2x12-MA. Some of you gave the theoretical count while your own output showed
  something else. Look before you answer:

  ```r
  sum(is.na(my_ma))   # or head() and tail()
  ```

**Takeaway:** equal gaps at both ends, or the average is not centred.

---

## 4. Do the weight check; do not just claim it

**What happened.** The derivations went well overall. Every real error was in a submission that
skipped the check, or that wrote "symmetric and sums to 1" without doing the sum. One answer had
a coefficient missing and summed to less than 1. Another dropped two terms while collecting
coefficients and came out lopsided.

**The check.** Both properties are in the notebook, and each takes ten seconds:

* **The weights sum to 1.** Add them up on the page. If they do not, a term is missing or
  doubled.
* **The weights are symmetric.** Read the list forwards and backwards. If it changes, a window
  is off-centre or a term was collected into the wrong place.

**The question about the rule.** HW06 asked which of your two derivations follows the 2xm rule
(m+1 points, 1/m inside, 1/(2m) at the ends) and why the other does not. About half of you
skipped it, and only a couple gave the reason, which is this:

* An **even** window (4, 8 or 12 points) has no middle point, so an m-MA sits half a step off
  `t`. The "2x" averages two neighbours, one half a step either side, and that puts it back on
  `t`. The rule describes the weights this produces.
* An **odd** window (7 points) has a middle point and is already centred at `t`. The "3x" in a
  3x7-MA is not centring anything. It is a second round of smoothing, so the weights follow a
  different pattern, and the 2xm rule does not apply.

**Takeaway:** sum to 1, symmetric, every time. "2x" fixes centring for even windows; an odd
window does not need it.

---

## 5. Before you submit: run it in a clean session

In each homework about one in eight scripts did not run from top to bottom on its own:

* objects like `us_retail_employment` or `a10` used but never built, because they were still in
  memory from the notebook;
* a typo or a missing comma;
* a `.qmd` that linked to photos that were never uploaded, so the handwritten work was missing.

**The check.** In RStudio, *Session > Restart R*, then run the whole script. Or press **Render**
on your `.qmd`, which does the same thing for you (see the Session 8 review). If you link images
from a `.qmd`, upload the images too, or submit the rendered `.html`.

**Takeaway:** if it does not run in a fresh session, nobody else can run it either.

---

## In one line each

* Multiplicative components are ratios. Divide by them; subtracting one barely moves the series.
* `all.equal()` returns `TRUE` or a sentence, and the sentence means a real difference.
* A centred moving average is missing the same number of values at both ends.
* Weights sum to 1 and are symmetric. Check both, on the page.
* Restart R and run everything before you submit.
