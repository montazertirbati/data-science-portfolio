# Shared command-line helpers. Run scripts from the repository root.
parse_args <- function(default_output) {
  args <- commandArgs(trailingOnly = TRUE)
  result <- list(data = NULL, output = default_output, demo = FALSE,
                 impute = FALSE, date = "2020-01-01")
  i <- 1L
  while (i <= length(args)) {
    key <- sub("^--", "", args[i])
    if (key %in% c("demo", "impute")) {
      result[[key]] <- TRUE
    } else if (key %in% c("data", "output", "date") && i < length(args)) {
      i <- i + 1L
      result[[key]] <- args[i]
    } else {
      stop("Unknown or incomplete argument: ", args[i], call. = FALSE)
    }
    i <- i + 1L
  }
  if (result$demo && !is.null(result$data)) stop("Choose --demo or --data, not both")
  dir.create(result$output, recursive = TRUE, showWarnings = FALSE)
  result
}
require_columns <- function(data, columns) {
  missing <- setdiff(columns, names(data))
  if (length(missing)) stop("Missing columns: ", paste(missing, collapse = ", "))
  if (!nrow(data)) stop("Input data is empty")
}
write_table <- function(data, output, name) {
  write.csv(data, file.path(output, name), row.names = FALSE, na = "")
}
record_session <- function(output, demo) {
  capture.output(sessionInfo(), file = file.path(output, "session-info.txt"))
  writeLines(if (demo) "SYNTHETIC DEMONSTRATION: not original coursework results."
             else "Analysis of supplied local/course-package data; not synthetic.",
             file.path(output, "data-source.txt"))
}
