winch 0.1.1

## Cran Repository Policy

- [x] Reviewed CRP last edited 2024-02-17.

## R CMD check results

- [x] Checked locally, R 4.3.2
- [ ] Checked on CI system, R 4.3.2
- [ ] Checked on win-builder, R devel

Check the boxes above after successful execution and remove this line. Then run `fledge::release()`.

## Current CRAN check results

- [x] Checked on 2024-02-19, problems found: https://cran.r-project.org/web/checks/check_results_winch.html
- [ ] ERROR: r-devel-linux-x86_64-fedora-clang
     Running examples in ‘winch-Ex.R’ failed
     The error most likely occurred in:
     
     > ### Name: winch_trace_back
     > ### Title: Native stack trace
     > ### Aliases: winch_trace_back
     > 
     > ### ** Examples
     > 
     > ## Don't show: 
     > if (winch_available()) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
     + ## End(Don't show)
     + winch_trace_back()
     + 
     + foo <- function() {
     +   winch_call(bar)
     + }
     + 
     + bar <- function() {
     +   winch_trace_back()
     + }
     + 
     + foo()
     + ## Don't show: 
     + }) # examplesIf
     > winch_trace_back()
     Error in winch_trace_back() : unw_get_proc_name() error: -6540
     Calls: <Anonymous> ... source -> withVisible -> eval -> eval -> winch_trace_back
     Execution halted
- [ ] ERROR: r-devel-linux-x86_64-fedora-clang
     Running ‘example0.R’
     Running ‘example1.R’
     Running ‘example2.R’
     Running ‘example3.R’
     Running ‘example4.R’
     Running ‘example5.R’
     Running ‘example6.R’
     Running ‘example7.R’
     Running ‘example8.R’
     Running ‘testthat.R’
     Running the tests in ‘tests/example0.R’ failed.
     Complete output:
     > library(winch)
     > 
     > foo0 <- function() {
     +   winch_call(bar0)
     + }
     > 
     > bar0 <- function() {
     +   winch_call(baz0)
     + }
     > 
     > baz0 <- function() {
     +   winch_trace_back()
     + }
     > 
     > if (winch_available()) {
     +   foo0()
     + }
     Error in winch_trace_back() : unw_get_proc_name() error: -6540
     Calls: foo0 ... <Anonymous> -> winch_call -> <Anonymous> -> winch_trace_back
     Execution halted
     Running the tests in ‘tests/example1.R’ failed.
     Complete output:
     > library(winch)
     > 
     > foo0 <- function() {
     +   winch_call(bar0)
     + }
     > 
     > bar0 <- function() {
     +   winch_call(baz0)
     + }
     > 
     > baz0 <- function() {
     +   winch_add_trace_back()
     + }
     > 
     > if (winch_available()) {
     +   foo0()
     + }
     Error in winch_trace_back() : unw_get_proc_name() error: -6540
     Calls: foo0 ... <Anonymous> -> winch_add_trace_back -> winch_trace_back
     In addition: Warning message:
     `winch_add_trace_back()` was deprecated in winch 0.1.0. 
     Execution halted
     Running the tests in ‘tests/testthat.R’ failed.
     Complete output:
     > library(testthat)
     > library(winch)
     > 
     > test_check("winch")
     [ FAIL 1 | WARN 0 | SKIP 0 | PASS 2 ]
     
     ══ Failed tests ════════════════════════════════════════════════════════════════
     ── Error ('test-trace_back.R:4:3'): data structure ─────────────────────────────
     Error in `winch_trace_back()`: unw_get_proc_name() error: -6540
     Backtrace:
     ▆
     1. └─winch::winch_trace_back() at test-trace_back.R:4:3
     
     [ FAIL 1 | WARN 0 | SKIP 0 | PASS 2 ]
     Deleting unused snapshots:
     • add_trace_back.md
     Error: Test failures
     Execution halted
- [ ] ERROR: r-devel-linux-x86_64-fedora-clang
     Error(s) in re-building vignettes:
     --- re-building ‘report.Rmd’ using rmarkdown
     
     Quitting from lines 115-123 [unnamed-chunk-5] (report.Rmd)
     Error: processing vignette 'report.Rmd' failed with diagnostics:
     unw_get_proc_name() error: -6540
     --- failed re-building ‘report.Rmd’
     
     SUMMARY: processing the following file failed:
     ‘report.Rmd’
     
     Error: Vignette re-building failed.
     Execution halted

Check results at: https://cran.r-project.org/web/checks/check_results_winch.html
