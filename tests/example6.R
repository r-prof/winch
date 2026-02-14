library(winch)

if (winch::winch_available() && requireNamespace("RSQLite") && requireNamespace("rlang")) {
  options(
    error = rlang::entrace,
    rlang_backtrace_on_error = "full",
    rlang_trace_use_winch = TRUE
  )

  con <- DBI::dbConnect(RSQLite::SQLite())
  tryCatch(DBI::dbGetQuery(con, "SELECT ? AS a, ? AS b", list(1)), error = identity)
}
