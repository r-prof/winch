
<!-- README.md and index.md are generated from README.Rmd.
     Edit that file and render it the usual way: rmarkdown::render(),
     devtools::build_readme(), or the Knit button. The cynkratemplate
     package must be installed; it supplies the output format. -->

# winch

<!-- badges: start -->

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![R build status](https://github.com/r-prof/winch/workflows/rcc/badge.svg)](https://github.com/r-prof/winch/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/winch)](https://CRAN.R-project.org/package=winch)
<!-- badges: end -->

Winch provides stack traces for call chains that cross between R and C function calls.
This is a useful tool for developers of R packages where a substantial portion of the code is C or C++.

## Installation

Install the released version of winch from [CRAN](https://cran.r-project.org/) with:

``` r
install.packages("winch")
```

Install the development version from GitHub with:

``` r
# install.packages("pak")
pak::pak("r-prof/winch")
```

## Example

Below is an example where an R function calls into C which calls back into R.
Note the second-to-last entry in the trace:

``` r
library(winch)

foo <- function() {
  winch_call(bar)
}

bar <- function() {
  winch_trace_back()
}

trace <- foo()

# Keep the render reproducible: the instruction pointers are randomised by
# ASLR, and the shared object is loaded from a temporary directory whose
# name is new on every load -- and the varying path width re-aligns the
# whole table. Show the columns that are stable.
trace$ip <- NULL
trace$pathname <- basename(trace$pathname)
# A frame whose symbol the linker cannot resolve falls back to its address,
# which is randomised too.
trace$func <- sub("^[0-9a-f]{8,}$", "<unresolved>", trace$func)
trace
#>                       func  pathname is_libr
#> 1         winch_trace_back  winch.so   FALSE
#> 2              R_doDotCall   libR.so    TRUE
#> 3               do_dotcall   libR.so    TRUE
#> 4                  Rf_eval   libR.so    TRUE
#> 5                   do_set   libR.so    TRUE
#> 6                  Rf_eval   libR.so    TRUE
#> 7                 do_begin   libR.so    TRUE
#> 8                  Rf_eval   libR.so    TRUE
#> 9            R_execClosure   libR.so    TRUE
#> 10       applyClosure_core   libR.so    TRUE
#> 11         Rf_applyClosure   libR.so    TRUE
#> 12                 Rf_eval   libR.so    TRUE
#> 13                do_begin   libR.so    TRUE
#> 14                 Rf_eval   libR.so    TRUE
#> 15           R_execClosure   libR.so    TRUE
#> 16       applyClosure_core   libR.so    TRUE
#> 17         Rf_applyClosure   libR.so    TRUE
#> 18                 Rf_eval   libR.so    TRUE
#> 19           do_winch_call  winch.so   FALSE
#> 20              winch_call  winch.so   FALSE
#> 21             R_doDotCall   libR.so    TRUE
#> 22              do_dotcall   libR.so    TRUE
#> 23                 Rf_eval   libR.so    TRUE
#> 24                do_begin   libR.so    TRUE
#> 25                 Rf_eval   libR.so    TRUE
#> 26           R_execClosure   libR.so    TRUE
#> 27       applyClosure_core   libR.so    TRUE
#> 28         Rf_applyClosure   libR.so    TRUE
#> 29                 Rf_eval   libR.so    TRUE
#> 30                do_begin   libR.so    TRUE
#> 31                 Rf_eval   libR.so    TRUE
#> 32           R_execClosure   libR.so    TRUE
#> 33       applyClosure_core   libR.so    TRUE
#> 34         Rf_applyClosure   libR.so    TRUE
#> 35                 Rf_eval   libR.so    TRUE
#> 36                  do_set   libR.so    TRUE
#> 37                 Rf_eval   libR.so    TRUE
#> 38                 do_eval   libR.so    TRUE
#> 39             bcEval_loop   libR.so    TRUE
#> 40                  bcEval   libR.so    TRUE
#> 41                  bcEval   libR.so    TRUE
#> 42                 Rf_eval   libR.so    TRUE
#> 43            forcePromise   libR.so    TRUE
#> 44            forcePromise   libR.so    TRUE
#> 45                 Rf_eval   libR.so    TRUE
#> 46          do_withVisible   libR.so    TRUE
#> 47             do_internal   libR.so    TRUE
#> 48             bcEval_loop   libR.so    TRUE
#> 49                  bcEval   libR.so    TRUE
#> 50                  bcEval   libR.so    TRUE
#> 51                 Rf_eval   libR.so    TRUE
#> 52            forcePromise   libR.so    TRUE
#> 53            forcePromise   libR.so    TRUE
#> 54                 Rf_eval   libR.so    TRUE
#> 55            forcePromise   libR.so    TRUE
#> 56            forcePromise   libR.so    TRUE
#> 57                  getvar   libR.so    TRUE
#> 58             bcEval_loop   libR.so    TRUE
#> 59                  bcEval   libR.so    TRUE
#> 60                  bcEval   libR.so    TRUE
#> 61                 Rf_eval   libR.so    TRUE
#> 62           R_execClosure   libR.so    TRUE
#> 63       applyClosure_core   libR.so    TRUE
#> 64         Rf_applyClosure   libR.so    TRUE
#> 65                 Rf_eval   libR.so    TRUE
#> 66                 do_eval   libR.so    TRUE
#> 67             bcEval_loop   libR.so    TRUE
#> 68                  bcEval   libR.so    TRUE
#> 69                  bcEval   libR.so    TRUE
#> 70                 Rf_eval   libR.so    TRUE
#> 71           R_execClosure   libR.so    TRUE
#> 72       applyClosure_core   libR.so    TRUE
#> 73         Rf_applyClosure   libR.so    TRUE
#> 74                 Rf_eval   libR.so    TRUE
#> 75           R_execClosure   libR.so    TRUE
#> 76       applyClosure_core   libR.so    TRUE
#> 77         Rf_applyClosure   libR.so    TRUE
#> 78             bcEval_loop   libR.so    TRUE
#> 79                  bcEval   libR.so    TRUE
#> 80                  bcEval   libR.so    TRUE
#> 81                 Rf_eval   libR.so    TRUE
#> 82           R_execClosure   libR.so    TRUE
#> 83       applyClosure_core   libR.so    TRUE
#> 84         Rf_applyClosure   libR.so    TRUE
#> 85                 Rf_eval   libR.so    TRUE
#> 86             Rf_evalList   libR.so    TRUE
#> 87                 Rf_eval   libR.so    TRUE
#> 88                do_begin   libR.so    TRUE
#> 89                 Rf_eval   libR.so    TRUE
#> 90           R_execClosure   libR.so    TRUE
#> 91       applyClosure_core   libR.so    TRUE
#> 92         Rf_applyClosure   libR.so    TRUE
#> 93                 Rf_eval   libR.so    TRUE
#> 94        Rf_ReplIteration   libR.so    TRUE
#> 95           R_ReplConsole   libR.so    TRUE
#> 96           run_Rmainloop   libR.so    TRUE
#> 97            <unresolved>         R    TRUE
#> 98  __libc_start_call_main libc.so.6   FALSE
#> 99  __libc_start_main_impl libc.so.6   FALSE
#> 100           <unresolved>         R    TRUE
#> 101           <unresolved>         R    TRUE
```

`rlang::entrace()` checks if winch is installed, and adds a native backtrace.
As this cannot be easily demonstrated in a knitr document, the output is copied from a GitHub Actions run.

``` r
options(
  error = rlang::entrace,
  rlang_backtrace_on_error = "full",
  rlang_trace_use_winch = TRUE
)

vctrs::vec_as_location(quote, 2)
```

    Error: Must subset elements with a valid subscript vector.
    ✖ Subscript has the wrong type `function`.
    ℹ It must be logical, numeric, or character.
    Backtrace:
        █
     1. └─vctrs::vec_as_location(quote, 2)
     2.   └─`/vctrs.so`::vctrs_as_location()
     3.     └─`/vctrs.so`::vec_as_location_opts()

## How does it work?

winch uses a very simple heuristic.
R's traceback (and also profiling) infrastructure introduces the notion of a "context".
Every call to an R function opens a new context and closes it when execution of the function ends.
Unfortunately, no new context is established for native code called with `.Call()` or `.External()`.
Establishing contexts expends precious run time, so this may be the reason for the omission.

To work around this limitation, the source code of all R functions along the call chain is scanned for instances of `.Call` and `.External`.
The native call stack (obtained via [libunwind](https://github.com/libunwind/libunwind) or [libbacktrace](https://github.com/ianlancetaylor/libbacktrace)) is scanned for chunks of code outside of `libR.so` (R's main library) --
these are assumed to correspond to `.Call()` or `.External()`.
The native traces are embedded as artificial calls into the R stack trace.

## Limitations

- The matching will not be perfect, but it may still lead to faster discovery of the cause of an error.
- On Windows winch only works on x64, and there the traces can be obtained only for one shared library at a time.
  See `winch_init_library()` for details.

------------------------------------------------------------------------

## Code of Conduct

Please note that the winch project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
