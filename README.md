
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
#>   [1] "/home/kirill/git/R/r-prof/winch/src/winch.so(winch_trace_back+0x1e) [0x7f8c46674b9e]"
#>   [2] "/usr/lib/R/lib/libR.so(+0xf92d4) [0x7f8c591792d4]"                                   
#>   [3] "/usr/lib/R/lib/libR.so(+0xf97a6) [0x7f8c591797a6]"                                   
#>   [4] "/usr/lib/R/lib/libR.so(Rf_eval+0x7d0) [0x7f8c591c3cc0]"                              
#>   [5] "/usr/lib/R/lib/libR.so(+0x147022) [0x7f8c591c7022]"                                  
#>   [6] "/usr/lib/R/lib/libR.so(Rf_eval+0x572) [0x7f8c591c3a62]"                              
#>   [7] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>   [8] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>   [9] "/usr/lib/R/lib/libR.so(Rf_eval+0x353) [0x7f8c591c3843]"                              
#>  [10] "/usr/lib/R/lib/libR.so(+0x147022) [0x7f8c591c7022]"                                  
#>  [11] "/usr/lib/R/lib/libR.so(Rf_eval+0x572) [0x7f8c591c3a62]"                              
#>  [12] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [13] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [14] "/usr/lib/R/lib/libR.so(Rf_eval+0x353) [0x7f8c591c3843]"                              
#>  [15] "/home/kirill/git/R/r-prof/winch/src/winch.so(winch_call+0x1c) [0x7f8c46674b1c]"      
#>  [16] "/usr/lib/R/lib/libR.so(+0xf92ac) [0x7f8c591792ac]"                                   
#>  [17] "/usr/lib/R/lib/libR.so(+0xf97a6) [0x7f8c591797a6]"                                   
#>  [18] "/usr/lib/R/lib/libR.so(Rf_eval+0x7d0) [0x7f8c591c3cc0]"                              
#>  [19] "/usr/lib/R/lib/libR.so(+0x147022) [0x7f8c591c7022]"                                  
#>  [20] "/usr/lib/R/lib/libR.so(Rf_eval+0x572) [0x7f8c591c3a62]"                              
#>  [21] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [22] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [23] "/usr/lib/R/lib/libR.so(Rf_eval+0x353) [0x7f8c591c3843]"                              
#>  [24] "/usr/lib/R/lib/libR.so(+0x147022) [0x7f8c591c7022]"                                  
#>  [25] "/usr/lib/R/lib/libR.so(Rf_eval+0x572) [0x7f8c591c3a62]"                              
#>  [26] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [27] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [28] "/usr/lib/R/lib/libR.so(Rf_eval+0x353) [0x7f8c591c3843]"                              
#>  [29] "/usr/lib/R/lib/libR.so(+0x149702) [0x7f8c591c9702]"                                  
#>  [30] "/usr/lib/R/lib/libR.so(+0x137086) [0x7f8c591b7086]"                                  
#>  [31] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [32] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [33] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [34] "/usr/lib/R/lib/libR.so(+0x13a909) [0x7f8c591ba909]"                                  
#>  [35] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [36] "/usr/lib/R/lib/libR.so(+0x14402c) [0x7f8c591c402c]"                                  
#>  [37] "/usr/lib/R/lib/libR.so(Rf_eval+0x454) [0x7f8c591c3944]"                              
#>  [38] "/usr/lib/R/lib/libR.so(+0x14a1ac) [0x7f8c591ca1ac]"                                  
#>  [39] "/usr/lib/R/lib/libR.so(+0x18714d) [0x7f8c5920714d]"                                  
#>  [40] "/usr/lib/R/lib/libR.so(+0x135344) [0x7f8c591b5344]"                                  
#>  [41] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [42] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [43] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [44] "/usr/lib/R/lib/libR.so(+0x13a909) [0x7f8c591ba909]"                                  
#>  [45] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [46] "/usr/lib/R/lib/libR.so(+0x14402c) [0x7f8c591c402c]"                                  
#>  [47] "/usr/lib/R/lib/libR.so(+0x144464) [0x7f8c591c4464]"                                  
#>  [48] "/usr/lib/R/lib/libR.so(+0x137754) [0x7f8c591b7754]"                                  
#>  [49] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [50] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [51] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [52] "/usr/lib/R/lib/libR.so(+0x13a909) [0x7f8c591ba909]"                                  
#>  [53] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [54] "/usr/lib/R/lib/libR.so(+0x14402c) [0x7f8c591c402c]"                                  
#>  [55] "/usr/lib/R/lib/libR.so(+0x144464) [0x7f8c591c4464]"                                  
#>  [56] "/usr/lib/R/lib/libR.so(+0x137754) [0x7f8c591b7754]"                                  
#>  [57] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [58] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [59] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [60] "/usr/lib/R/lib/libR.so(+0x13a909) [0x7f8c591ba909]"                                  
#>  [61] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [62] "/usr/lib/R/lib/libR.so(+0x14402c) [0x7f8c591c402c]"                                  
#>  [63] "/usr/lib/R/lib/libR.so(+0x144464) [0x7f8c591c4464]"                                  
#>  [64] "/usr/lib/R/lib/libR.so(+0x137754) [0x7f8c591b7754]"                                  
#>  [65] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [66] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [67] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [68] "/usr/lib/R/lib/libR.so(+0x13a909) [0x7f8c591ba909]"                                  
#>  [69] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [70] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [71] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [72] "/usr/lib/R/lib/libR.so(+0x13a909) [0x7f8c591ba909]"                                  
#>  [73] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [74] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [75] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [76] "/usr/lib/R/lib/libR.so(Rf_eval+0x353) [0x7f8c591c3843]"                              
#>  [77] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [78] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [79] "/usr/lib/R/lib/libR.so(+0x13a909) [0x7f8c591ba909]"                                  
#>  [80] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [81] "/usr/lib/R/lib/libR.so(+0x14402c) [0x7f8c591c402c]"                                  
#>  [82] "/usr/lib/R/lib/libR.so(+0x144464) [0x7f8c591c4464]"                                  
#>  [83] "/usr/lib/R/lib/libR.so(+0x137754) [0x7f8c591b7754]"                                  
#>  [84] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [85] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [86] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [87] "/usr/lib/R/lib/libR.so(+0x13a909) [0x7f8c591ba909]"                                  
#>  [88] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [89] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [90] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [91] "/usr/lib/R/lib/libR.so(+0x13a909) [0x7f8c591ba909]"                                  
#>  [92] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [93] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [94] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [95] "/usr/lib/R/lib/libR.so(+0x13a909) [0x7f8c591ba909]"                                  
#>  [96] "/usr/lib/R/lib/libR.so(Rf_eval+0x180) [0x7f8c591c3670]"                              
#>  [97] "/usr/lib/R/lib/libR.so(+0x14548f) [0x7f8c591c548f]"                                  
#>  [98] "/usr/lib/R/lib/libR.so(Rf_applyClosure+0x1c7) [0x7f8c591c6257]"                      
#>  [99] "/usr/lib/R/lib/libR.so(+0x189363) [0x7f8c59209363]"                                  
#> [100] "/usr/lib/R/lib/libR.so(+0x189814) [0x7f8c59209814]"                                  
#>  [ reached getOption("max.print") -- omitted 32 entries ]
```
