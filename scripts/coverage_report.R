message("Generating fixed income domain coverage report")

source("scripts/domain_discovery.R")

if (!dir.exists("reports")) dir.create("reports", recursive = TRUE)

objects <- discover_objects()
if (length(objects) == 0) stop("No canonical academic objects discovered under objects/", call. = FALSE)

inventory <- domain_object_inventory()
complete_count <- sum(inventory$complete)
total_count <- nrow(inventory)
coverage_pct <- round(100 * complete_count / total_count, 1)

lines <- c(
  "domain_coverage:",
  "  release: FI-DER-0004-MR001",
  paste0("  canonical_objects_discovered: ", total_count),
  paste0("  canonical_objects_complete: ", complete_count),
  paste0("  domain_coverage_pct: ", coverage_pct),
  "  objects:"
)

for (i in seq_len(nrow(inventory))) {
  key <- paste0("    ", inventory$object_id[[i]], "_", gsub("[^A-Za-z0-9]+", "_", inventory$title[[i]]))
  status <- ifelse(inventory$complete[[i]], "COMPLETE", "INCOMPLETE")
  lines <- c(lines, paste0(key, ": ", status))
}

writeLines(lines, "reports/domain_coverage.yaml")
message("Wrote reports/domain_coverage.yaml")
