#' Components:
#'
#' - stack trace:
#'     - libunwind: Linux + macOS, not on Windows
#'     - libbacktrace: Linux + Windows, not on macOS
#' - module name: procmaps
#' - file + line: via libbacktrace

procmaps::procmap_get()
View(procmaps::procmap_get())
