library(winch)

if (winch::winch_available() && requireNamespace("RSQLite") && requireNamespace("rlang")) {
  options(
    error = rlang::entrace,
    rlang_backtrace_on_error = "full",
    rlang_trace_use_winch = 1L
  )

  winch::winch_init_library(RSQLite:::"_RSQLite_init_logging"$dll[["path"]])

  con <- DBI::dbConnect(RSQLite::SQLite())
  DBI::dbGetQuery(con, "SELECT ? AS a, ? AS b", list(1))
}
