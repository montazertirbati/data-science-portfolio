# Homework 3: nested regression, residual diagnostics, and log response.
source("R/common.R")
fit_analysis <- function(df, output, logarithmic = FALSE) {
  response <- if (logarithmic) "log(cycles)" else "cycles"
  full <- lm(as.formula(paste(response, "~ charge + discharge + temp + endvolt + depth")), data = df)
  reduced <- lm(as.formula(paste(response, "~ depth")), data = df)
  capture.output(summary(full), file = file.path(output, "model-summary.txt"))
  capture.output(anova(reduced, full), file = file.path(output, "nested-model-comparison.txt"))
  capture.output(confint(full), file = file.path(output, "coefficient-intervals.txt"))
  # Externally studentized residuals have residual df minus one for the deleted fit.
  external <- rstudent(full)
  pvalues <- 2 * pt(abs(external), df = df.residual(full) - 1, lower.tail = FALSE)
  diagnostics <- data.frame(source_row = df$source_row, fitted = fitted(full), residual = residuals(full),
                            standardized_residual = rstandard(full), studentized_residual = external,
                            leverage = hatvalues(full), cooks_distance = cooks.distance(full),
                            outlier_p = pvalues, bonferroni_p = p.adjust(pvalues, "bonferroni"))
  write_table(diagnostics, output, "diagnostics.csv")
  predictors <- df[c("charge", "discharge", "temp", "endvolt", "depth")]
  vif <- sapply(names(predictors), function(v) {
    auxiliary <- lm(reformulate(setdiff(names(predictors), v), response = v), data = predictors)
    1 / (1 - summary(auxiliary)$r.squared)
  })
  write_table(data.frame(variable = names(vif), vif = unname(vif)), output, "vif.csv")
  pdf(file.path(output, "diagnostic-plots.pdf"), width = 9, height = 8)
  par(mfrow = c(2, 2)); plot(full, which = c(1, 2, 3, 5)); dev.off()
  if (requireNamespace("nortest", quietly = TRUE)) {
    capture.output(nortest::ad.test(residuals(full)), file = file.path(output, "anderson-darling.txt"))
  }
  data.frame(response = response, n = nobs(full), residual_df = df.residual(full),
             residual_standard_error = sigma(full), r_squared = summary(full)$r.squared,
             adjusted_r_squared = summary(full)$adj.r.squared)
}
main <- function() {
  args <- parse_args("outputs/r-battery")
  fields <- c("cycles", "charge", "discharge", "temp", "endvolt", "depth")
  if (args$demo) {
    set.seed(42); n <- 100
    df <- data.frame(charge = runif(n, 0.5, 2), discharge = runif(n, 1, 7), temp = runif(n, 15, 45),
                     endvolt = runif(n, 1.5, 2.5), depth = runif(n, 1, 10))
    df$cycles <- exp(5.5 + 0.1 * df$charge - 0.015 * df$temp - 0.04 * df$depth + rnorm(n, 0, 0.1))
  } else {
    if (is.null(args$data)) stop("Supply --data CSV or --demo")
    df <- read.csv(args$data)
  }
  require_columns(df, fields)
  if (!all(vapply(df[fields], is.numeric, logical(1)))) stop("All six battery columns must be numeric")
  df$source_row <- seq_len(nrow(df)) - 1L
  valid <- apply(df[fields], 1, function(row) all(is.finite(row))) & df$cycles > 0
  write_table(data.frame(input_rows = nrow(df), excluded_rows = sum(!valid)), args$output, "input-audit.csv")
  df <- df[valid, ]
  if (nrow(df) < 10 || qr(model.matrix(~ charge + discharge + temp + endvolt + depth, df))$rank < 6) stop("Need at least 10 complete rows and a full-rank design")
  summaries <- lapply(c(FALSE, TRUE), function(logarithmic) {
    output <- file.path(args$output, if (logarithmic) "log-response" else "raw-response")
    dir.create(output, recursive = TRUE, showWarnings = FALSE)
    fit_analysis(df, output, logarithmic)
  })
  write_table(do.call(rbind, summaries), args$output, "model-comparison.csv")
  record_session(args$output, args$demo)
  print(do.call(rbind, summaries))
}
main()
