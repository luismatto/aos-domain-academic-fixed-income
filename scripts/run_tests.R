message("AOS Fixed Income Domain FI-DER-0005 validation")

source("scripts/validate_domain.R")
source("scripts/generate_manifest.R")
source("scripts/coverage_report.R")
source("scripts/domain_graph.R")

objects <- discover_objects()
required_generated <- c(
  file.path("reports", paste0(objects, "_knowledge_manifest.yaml")),
  "reports/domain_coverage.yaml",
  "reports/domain_knowledge_graph.yaml"
)

missing <- required_generated[!file.exists(required_generated)]
if (length(missing) > 0) {
  stop(paste("Missing generated outputs:", paste(missing, collapse = ", ")), call. = FALSE)
}

expected_objects <- c("CAO001", "CAO002", "CAO003", "CAO004")
missing_objects <- expected_objects[!(expected_objects %in% objects)]
if (length(missing_objects) > 0) {
  stop(paste("Missing expected CAO objects:", paste(missing_objects, collapse = ", ")), call. = FALSE)
}

message("FI-DER-0005 STATUS: PASS")
