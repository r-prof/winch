
<!-- README.md is generated from README.Rmd. Please edit that file -->

# winch

<!-- badges: start -->

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
#>  20.   ├─winch::winch_call(bar)
#>  21.   └─(function () ...
#>  22.     └─winch::winch_trace_back()
#> [[1]]
#> rmarkdown::render("/home/kirill/git/R/r-prof/winch/README.Rmd", 
#>     encoding = "UTF-8")
#> 
#> [[2]]
#> knitr::knit(knit_input, knit_output, envir = envir, quiet = quiet)
#> 
#> [[3]]
#> process_file(text, output)
#> 
#> [[4]]
#> withCallingHandlers(if (tangle) process_tangle(group) else process_group(group), 
#>     error = function(e) {
#>         setwd(wd)
#>         cat(res, sep = "\n", file = output %n% "")
#>         message("Quitting from lines ", paste(current_lines(i), 
#>             collapse = "-"), " (", knit_concord$get("infile"), 
#>             ") ")
#>     })
#> 
#> [[5]]
#> process_group(group)
#> 
#> [[6]]
#> process_group.block(group)
#> 
#> [[7]]
#> call_block(x)
#> 
#> [[8]]
#> block_exec(params)
#> 
#> [[9]]
#> in_dir(input_dir(), evaluate(code, envir = env, new_device = FALSE, 
#>     keep_warning = !isFALSE(options$warning), keep_message = !isFALSE(options$message), 
#>     stop_on_error = if (options$error && options$include) 0L else 2L, 
#>     output_handler = knit_handlers(options$render, options)))
#> 
#> [[10]]
#> evaluate(code, envir = env, new_device = FALSE, keep_warning = !isFALSE(options$warning), 
#>     keep_message = !isFALSE(options$message), stop_on_error = if (options$error && 
#>         options$include) 0L else 2L, output_handler = knit_handlers(options$render, 
#>         options))
#> 
#> [[11]]
#> evaluate::evaluate(...)
#> 
#> [[12]]
#> evaluate_call(expr, parsed$src[[i]], envir = envir, enclos = enclos, 
#>     debug = debug, last = i == length(out), use_try = stop_on_error != 
#>         2L, keep_warning = keep_warning, keep_message = keep_message, 
#>     output_handler = output_handler, include_timing = include_timing)
#> 
#> [[13]]
#> timing_fn(handle(ev <- withCallingHandlers(withVisible(eval(expr, 
#>     envir, enclos)), warning = wHandler, error = eHandler, message = mHandler)))
#> 
#> [[14]]
#> handle(ev <- withCallingHandlers(withVisible(eval(expr, envir, 
#>     enclos)), warning = wHandler, error = eHandler, message = mHandler))
#> 
#> [[15]]
#> withCallingHandlers(withVisible(eval(expr, envir, enclos)), warning = wHandler, 
#>     error = eHandler, message = mHandler)
#> 
#> [[16]]
#> withVisible(eval(expr, envir, enclos))
#> 
#> [[17]]
#> eval(expr, envir, enclos)
#> 
#> [[18]]
#> eval(expr, envir, enclos)
#> 
#> [[19]]
#> foo()
#> 
#> [[20]]
#> winch_call(bar)
#> 
#> [[21]]
#> (function() {
#>   winch_trace_back()
#> })()
#> 
#> [[22]]
#> winch_trace_back()
#> NULL
```
