source("scripts/domain_discovery.R")

message("Generating fixed income domain coverage report")

if (!dir.exists("reports")) dir.create("reports", recursive = TRUE)

target_objects <- c(
  "CAO001_Institutional_Investment_Ecosystem",
  "CAO002_Institutional_Types_and_Mandates",
  "CAO003_Institutional_Investment_Process",
  "CAO004_Time_Value_of_Money",
  "CAO005_Interest_Rates",
  "CAO006_Cash_Flows",
  "CAO007_Bond_Pricing",
  "CAO008_Yield_Measures",
  "CAO009_Term_Structure",
  "CAO010_Duration",
  "CAO011_Convexity",
  "CAO012_Immunization",
  "CAO013_Portfolio_Management",
  "CAO014_Risk_Measurement",
  "CAO015_Fixed_Income_Strategy"
)

objects <- discover_objects()

is_complete <- function(object_id) {
  all(file.exists(required_cao_paths(object_id)))
}

complete_objects <- objects[vapply(objects, is_complete, logical(1))]
coverage_pct <- round(100 * length(complete_objects) / length(target_objects), 1)

coverage_lines <- c(
  "domain_coverage:",
  "  release: FI-DER-0005",
  paste0("  discovered_objects: ", length(objects)),
  paste0("  complete_objects: ", length(complete_objects)),
  paste0("  target_objects: ", length(target_objects)),
  paste0("  coverage_percent: ", coverage_pct),
  "  objects:"
)

for (target in target_objects) {
  object_id <- sub("_.*$", "", target)
  status <- if (object_id %in% complete_objects) "COMPLETE" else if (object_id %in% objects) "INCOMPLETE" else "NOT_STARTED"
  coverage_lines <- c(coverage_lines, paste0("    ", target, ": ", status))
}

writeLines(coverage_lines, "reports/domain_coverage.yaml")
message("Wrote reports/domain_coverage.yaml")
