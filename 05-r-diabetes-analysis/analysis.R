# Homework 1: missingness and descriptive comparisons in the Pima data.
source("R/common.R")
main <- function() {
  args <- parse_args("outputs/r-diabetes")
  if (args$demo) {
    set.seed(42)
    d <- data.frame(age = sample(21:70, 180, TRUE), diastolic = runif(180, 55, 95),
                    glucose = runif(180, 70, 200), triceps = runif(180, 10, 50),
                    bmi = runif(180, 18, 45), insulin = runif(180, 20, 250),
                    test = rep(0:1, 90))
    for (v in c("diastolic", "glucose", "triceps", "bmi", "insulin")) d[sample(nrow(d), 12), v] <- 0
  } else if (!is.null(args$data)) {
    d <- read.csv(args$data)
  } else {
    if (!requireNamespace("faraway", quietly = TRUE)) stop("Install faraway, provide --data CSV, or use --demo")
    env <- new.env()
    data("pima", package = "faraway", envir = env)
    d <- env$pima
  }
  required <- c("age", "diastolic", "glucose", "triceps", "bmi", "insulin", "test")
  require_columns(d, required)
  if (!all(vapply(d[required], is.numeric, logical(1)))) stop("Expected numeric Pima columns; test must be coded 0/1")
  if (!all(na.omit(d$test) %in% 0:1)) stop("test must contain only 0, 1 or NA")
  before <- colSums(is.na(d[required]))
  for (v in c("diastolic", "glucose", "triceps", "bmi", "insulin")) d[which(d[[v]] == 0), v] <- NA_real_
  write_table(data.frame(variable = required, missing_before = before,
                         missing_after = colSums(is.na(d[required]))), args$output, "missingness.csv")
  d$test <- factor(d$test, levels = c(0, 1), labels = c("negative", "positive"))
  groups <- lapply(levels(d$test), function(label) {
    values <- d$insulin[which(d$test == label & is.finite(d$insulin))]
    n <- length(values)
    mean_value <- if (n) mean(values) else NA_real_
    se <- if (n > 1) sd(values) / sqrt(n) else NA_real_
    margin <- if (n > 1) qt(0.975, df = n - 1) * se else NA_real_
    data.frame(group = label, n = n, mean_insulin = mean_value, sd = if (n > 1) sd(values) else NA_real_,
               lower_95 = mean_value - margin, upper_95 = mean_value + margin)
  })
  write_table(do.call(rbind, groups), args$output, "insulin_by_group.csv")
  threshold <- mean(d$insulin, na.rm = TRUE)
  valid <- is.finite(d$insulin) & is.finite(d$bmi)
  above <- d$bmi[which(valid & d$insulin > threshold)]
  below <- d$bmi[which(valid & d$insulin < threshold)]
  write_table(data.frame(group = c("above_mean_insulin", "below_mean_insulin"),
                         n = c(length(above), length(below)),
                         mean_bmi = c(if (length(above)) mean(above) else NA_real_,
                                      if (length(below)) mean(below) else NA_real_)), args$output, "bmi_comparison.csv")
  observed <- d[is.finite(d$insulin) & !is.na(d$test), ]
  if (all(table(observed$test) >= 2)) {
    capture.output(t.test(insulin ~ test, data = observed), file = file.path(args$output, "welch-comparison.txt"))
  }
  pdf(file.path(args$output, "plots.pdf"), width = 10, height = 5)
  on.exit(dev.off(), add = TRUE)
  par(mfrow = c(1, 2))
  for (missing in c(TRUE, FALSE)) {
    values <- d$age[is.na(d$triceps) == missing & is.finite(d$age)]
    if (length(values)) hist(values, xlab = "Age", main = if (missing) "Missing triceps" else "Observed triceps")
    else { plot.new(); title("No eligible ages") }
  }
  record_session(args$output, args$demo)
  print(do.call(rbind, groups))
}
main()
