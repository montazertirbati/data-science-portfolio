# Homework 2: typed cleaning, missingness audit, and optional MICE.
source("R/common.R")
parse_dates <- function(values) {
  result <- as.Date(rep(NA_character_, length(values)))
  for (format in c("%m/%d/%Y", "%Y-%m-%d", "%B %d, %Y", "%b %d, %Y")) {
    missing <- which(is.na(result) & !is.na(values))
    if (length(missing)) result[missing] <- as.Date(values[missing], format = format)
  }
  result
}
main <- function() {
  args <- parse_args("outputs/r-app-store")
  if (args$demo) {
    set.seed(42); n <- 200
    df <- data.frame(App = paste("Synthetic app", seq_len(n)), Category = sample(c("TOOLS", "GAME", "EDUCATION"), n, TRUE),
                     Rating = runif(n, 1, 5), Reviews = sample(1:10000, n, TRUE),
                     Type = sample(c("Free", "Paid"), n, TRUE), Last.Updated = rep(c("1/7/2018", "2018-06-01"), length.out = n),
                     Installs = sample(c("1,000+", "10,000+", "100,000+"), n, TRUE))
    for (v in c("Category", "Rating", "Reviews", "Type")) df[sample(n, 12), v] <- NA
  } else {
    if (is.null(args$data)) stop("Supply --data CSV or --demo")
    df <- read.csv(args$data, stringsAsFactors = FALSE)
  }
  fields <- c("Category", "Rating", "Reviews", "Type", "Last.Updated", "Installs")
  require_columns(df, fields)
  before <- colSums(is.na(df[fields]))
  for (v in c("Category", "Type", "Last.Updated", "Installs")) {
    df[[v]] <- trimws(as.character(df[[v]])); df[[v]][df[[v]] == ""] <- NA_character_
  }
  df$Rating <- suppressWarnings(as.numeric(df$Rating))
  df$Rating[!is.finite(df$Rating) | df$Rating < 0 | df$Rating > 5] <- NA_real_
  df$Reviews <- suppressWarnings(as.numeric(df$Reviews))
  df$Reviews[!is.finite(df$Reviews) | df$Reviews < 0] <- NA_real_
  df$Type[!df$Type %in% c("Free", "Paid")] <- NA_character_
  df$Type <- factor(df$Type, levels = c("Free", "Paid"))
  df$Category <- factor(df$Category)
  df$Last.Updated <- parse_dates(df$Last.Updated)
  snapshot <- as.Date(args$date, format = "%Y-%m-%d")
  if (is.na(snapshot)) stop("--date must be YYYY-MM-DD")
  df$Updates <- as.numeric(snapshot - df$Last.Updated)
  future_dates <- sum(df$Updates < 0, na.rm = TRUE)
  df$Updates[df$Updates < 0] <- NA_real_
  df$Installs <- suppressWarnings(as.numeric(gsub("[,+[:space:]]", "", df$Installs)))
  df$Installs[!is.finite(df$Installs) | df$Installs < 0] <- NA_real_
  write_table(data.frame(variable = fields, missing_before = before,
                         missing_after = colSums(is.na(df[fields]))), args$output, "missingness.csv")
  write_table(df, args$output, "cleaned_apps.csv")
  writeLines(c(paste("Fixed snapshot:", snapshot), paste("Dates after snapshot:", future_dates),
               paste("Rows:", nrow(df))), file.path(args$output, "cleaning-summary.txt"))
  pdf(file.path(args$output, "missingness.pdf"), width = 9, height = 6)
  barplot(colMeans(is.na(df[fields])), las = 2, ylab = "Fraction missing", main = "Missingness after cleaning")
  dev.off()
  if (args$impute) {
    if (!requireNamespace("mice", quietly = TRUE)) stop("Install mice to use --impute; cleaned outputs have already been written")
    subset <- df[c("Category", "Rating", "Reviews", "Type", "Updates")]
    if (any(colSums(!is.na(subset)) == 0)) stop("Cannot impute a wholly missing column")
    methods <- mice::make.method(subset)
    # make.method chooses PMM for numeric, logistic for binary, multinomial for unordered factors.
    imputed <- mice::mice(subset, m = 5, maxit = 5, method = methods, seed = 42, printFlag = FALSE)
    saveRDS(imputed, file.path(args$output, "multiple_imputations.rds"))
    write_table(mice::complete(imputed, 1), args$output, "completed_imputation_1.csv")
    write_table(data.frame(variable = names(methods), method = methods), args$output, "imputation_methods.csv")
    capture.output(imputed$loggedEvents, file = file.path(args$output, "imputation-events.txt"))
  }
  record_session(args$output, args$demo)
  print(colSums(is.na(df[fields])))
}
main()
