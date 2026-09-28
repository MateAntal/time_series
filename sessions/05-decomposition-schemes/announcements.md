# Course admin update: Session 05

**Monday 21 September 2026**

Three adjustments to the calendar, the midterm scope, and the homework deadlines, and the
reasoning behind each. The syllabus ([`../../SYLLABUS.md`](../../SYLLABUS.md)) is the authority;
this note explains why it reads the way it does.

---

## Why the calendar looks the way it does

September is packed: eight sessions in four weeks, every Monday and Wednesday. The back half of the
term is sparser, and that is not by choice. Four Spanish national holidays fall in October to
December 2026, three of them on Mondays:

| Date | Holiday | Effect on the schedule |
|---|---|---|
| Mon 12 Oct | Fiesta Nacional de España | No Monday session; the midterm (Session 10) moves to Wed 14 Oct |
| Mon 2 Nov | All Saints (1 Nov is Sunday, observed Monday) | Session 14 slides to Wed 4 Nov |
| Mon 7 Dec | Constitution Day (6 Dec is Sunday, observed Monday) | No session that week |
| Tue 8 Dec | Inmaculada Concepción | No session that week |

Four teaching Mondays disappear in the back half of the term. The course is front-loaded into
September so the decomposition block (Sessions 5 to 7) and the midterm revision land before the
calendar thins out. That is also why two September weeks carry two sessions sharing one homework
deadline: there is no spare Monday later to spread them onto.

### The full session calendar

| Session | Date | |
|---|---|---|
| 01 | Wed 2 Sep | intro and setup |
| 02 | Mon 7 Sep | stochastic process; tsibble |
| 03 | Wed 9 Sep | time plots, seasonal plots, scatterplots |
| 04 | Mon 14 Sep | lag plots, autocorrelation, white noise |
| 05 | Mon 21 Sep | decomposition schemes |
| 06 | Wed 23 Sep | moving averages |
| 07 | Mon 28 Sep | classical decomposition and STL (Group Assignment 1 released) |
| 08 | Wed 30 Sep | benchmark methods, fitted values |
| 09 | Mon 5 Oct | residual diagnostics (also midterm revision) |
| 10 | Wed 14 Oct | **midterm** (Mon 12 Oct is a holiday) |
| 11 | Mon 19 Oct | transformations, Box–Cox |
| 12 | Wed 21 Oct | prediction intervals |
| 13 | Mon 26 Oct | train/test splits, error metrics |
| 14 | Wed 4 Nov | cross-validation (Mon 2 Nov is a holiday) |
| 15 | Wed 11 Nov | simple exponential smoothing: the equations |
| 16 | Mon 16 Nov | fitting SES from scratch |
| 17 | Mon 23 Nov | Holt, damped trend (Group Assignment 2 released) |
| 18 | Wed 25 Nov | Holt–Winters |
| 19 | Mon 30 Nov | ETS taxonomy, model selection |
| — | Mon 7 / Tue 8 Dec | **no session** (Constitution Day and Inmaculada Concepción) |
| 20 | Mon 14 Dec | **final exam** |

---

## What changed

### 1. The midterm covers Sessions 1–8

Was Sessions 1–9. The exam is 20 multiple-choice questions, four options each, on Wednesday 14
October. Session 9 (residual diagnostics) moves to the final exam, where it sits with train/test
accuracy (Session 13) and cross-validation (Session 14). The three sessions that answer "is this
model believable?" are now examined together rather than split across two exams.

Session 9 still matters. It is the most-used skill in the second half of the course, and Group
Assignment 2 depends on it. It is deferred, not dropped. It also becomes a revision session for the
midterm: the first half teaches diagnostics, the second half is a sweep of Sessions 1 to 8 driven by
your questions. Bring questions rather than notes.

### 2. Homework is due on Sundays

From Session 05 onward, each homework is due at 23:59 on the Sunday of the teaching week in which it
was assigned. Sessions 01 to 04 keep the deadlines already posted on Blackboard. If a date on
Blackboard disagrees with anything here, Blackboard is the authority.

Two September weeks have a Monday and a Wednesday session sharing one Sunday deadline:

| Assigned | Session | Due (23:59) |
|---|---|---|
| Mon 21 Sep | 05 · decomposition schemes | Sun 27 Sep |
| Wed 23 Sep | 06 · moving averages | Sun 27 Sep |
| Mon 28 Sep | 07 · classical decomposition and STL | Sun 4 Oct |
| Wed 30 Sep | 08 · benchmark methods | Sun 4 Oct |
| Mon 5 Oct | 09 · residual diagnostics | Sun 11 Oct |

Both shorter assignments in the shared-deadline weeks were trimmed on purpose so the combined load
stays manageable.

### 3. Group Assignment 1 is due after the midterm

Released Session 07 (Mon 28 Sep), due Sunday 25 Oct. Four weeks, after the midterm, so exam revision
and a from-scratch implementation do not compete for the same fortnight. Start reading the brief the
week it is released: choosing your series is half the work.

### 4. Feedback, not published solutions

Worked solutions are not posted. After each due date:

- a cohort-wide common-errors note goes up on Blackboard, built from what the class actually got wrong;
- the first ten minutes of the next session review it live;
- individual written comments go to a different slice of the class each week, so everyone is commented
  on individually several times over the term.

Most exercises are self-verifying by design: you compute by hand and check against R's own answer with
`isTRUE(all.equal(x, y))`. That check is the feedback, and it arrives while you are still working.

One exception: Session 09's homework is reviewed at Session 11, not at the next session, because the
next session is the midterm. That week splits in two. The written note goes up on Blackboard on
Monday 12 Oct, two days before the exam, and the live review happens at the start of Session 11 on
Monday 19 Oct.

### 5. Workload and the AI policy

Plan for about 1.5 hours per session outside class, covering the pre-session reading and the
homework. The decomposition block (Sessions 5 to 7) and the weeks around each group assignment run
heavier than that. Read the assigned fpp3 sections before class, not after; every session README
names them.

Homework must be your own individual attempt. The policy on generative AI is strict: AI-generated
code or results are not allowed. See [`../../SYLLABUS.md`](../../SYLLABUS.md).

### 6. Verification of individual understanding

As part of normal assessment, the professor may ask any student, at any point in the term, for a
short individual conversation about their submitted work, to explain the reasoning behind it and the
concepts it relies on. These conversations are routine; a request is not in itself an indication of
concern, and no separate preparation is expected if the work reflects your own understanding.

---

## The five-line version

- **Midterm covers Sessions 1–8**, Wednesday 14 October. No retake.
- **Session 9 is examined in the final** and doubles as midterm revision.
- **From Session 05 on, homework is due 23:59 on the Sunday of its teaching week.** Two September
  weeks share one deadline. Sessions 01–04 keep the dates already posted.
- **Group Assignment 1 is due Sunday 25 October**, after the midterm.
- **No solutions are published.** Cohort note, live review, rotating individual comments.
