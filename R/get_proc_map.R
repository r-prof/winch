#' @export
winch_get_proc_map <- function(path = "/proc/self/maps") {
  # FIXME: Use gperftools code:
  # - Build in macOS without warnings
  # - Test on Windows, is libunwind included?
  # - Autogenerate config.h

  lines <- .Call(winch_c_get_proc_map)
  lines <- gsub(" +", " ", lines)

  data <- read.delim(text = lines, sep = " ", header = FALSE)
  # https://stackoverflow.com/a/1401595/946850
  names(data) <- c("address", "perms", "offset", "dev", "inode", "pathname")

  address_range <- strsplit(data[[1]], "-", fixed = TRUE)
  from <- vapply(address_range, `[[`, 1L, FUN.VALUE = character(1))
  from <- gsub(" ", "0", format(from, width = 16, justify = "right"), fixed = TRUE)
  to <- vapply(address_range, `[[`, 2L, FUN.VALUE = character(1))
  to <- gsub(" ", "0", format(to, width = 16, justify = "right"), fixed = TRUE)

  split <- data.frame(from, to, data[-1], stringsAsFactors = FALSE)
  split
}
