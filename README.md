
<!-- README.md is generated from README.Rmd. Please edit that file -->

# winch

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of winch is to provide stack traces that combine R and C
function calls.

## Installation

Once on CRAN, you can install the released version of winch from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("winch")
```

## Example

This is an example where an R function calls into C which calls back
into R:

``` r
library(winch)

foo <- function() {
  winch_call(bar)
}

bar <- function() {
  winch_trace_back()
}

foo()
#>      █
#>   1. ├─rmarkdown::render(...)
#>   2. │ └─knitr::knit(knit_input, knit_output, envir = envir, quiet = quiet)
#>   3. │   └─knitr:::process_file(text, output)
#>   4. │     ├─base::withCallingHandlers(...)
#>   5. │     ├─knitr:::process_group(group)
#>   6. │     └─knitr:::process_group.block(group)
#>   7. │       └─knitr:::call_block(x)
#>   8. │         └─knitr:::block_exec(params)
#>   9. │           ├─knitr:::in_dir(...)
#>  10. │           └─knitr:::evaluate(...)
#>  11. │             └─evaluate::evaluate(...)
#>  12. │               └─evaluate:::evaluate_call(...)
#>  13. │                 ├─evaluate:::timing_fn(...)
#>  14. │                 ├─base:::handle(...)
#>  15. │                 ├─base::withCallingHandlers(...)
#>  16. │                 ├─base::withVisible(eval(expr, envir, enclos))
#>  17. │                 └─base::eval(expr, envir, enclos)
#>  18. │                   └─base::eval(expr, envir, enclos)
#>  19. └─global::foo()
#>  20.   └─winch::winch_call(bar)
#>  21.     └─`winch.so(winch_call+0x1c) [0x7f673e6e7cac]`()
#>  22.       └─(function () ...
```

`winch_entrace()` is a drop-in replacement for `rlang::entrace()`. This
cannot be easily demonstrated in a knitr document, see [this GitHub
Actions
run](https://github.com/r-prof/winch/runs/895384993?check_suite_focus=true#step:11:24)
for an example.

``` r
library(winch)

options(error = winch_entrace, rlang_backtrace_on_error = "full")

foo <- function() {
  winch_call(bar)
}

bar <- function() {
  stop("oops")
}

foo()
```
