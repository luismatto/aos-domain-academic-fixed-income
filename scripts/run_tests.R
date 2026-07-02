message("AOS Fixed Income Domain FI-DER-0004-MR001 validation")

source("scripts/domain_discovery.R")
source("scripts/validate_domain.R")
source("scripts/generate_manifest.R")
source("scripts/coverage_report.R")

objects <- discover_objects()
if (length(objects) < 2) stop("Expected at least CAO001 and CAO002", call. = FALSE)

for (object_id in objects) {
  manifest_path <- file.path("reports", paste0(object_id, "_knowledge_manifest.yaml"))
  if (!file.exists(manifest_path)) stop(paste("Missing generated manifest:", manifest_path), call. = FALSE)
}

required_paths <- c(
  "Readme.md", "docs/DOMAIN_ARCHITECTURE.md", "docs/DOMAIN_LEDGER.md",
  "policies/institutional.apl", "scripts/domain_discovery.R",
  "scripts/validate_domain.R", "scripts/generate_manifest.R",
  "scripts/coverage_report.R", "reports/domain_coverage.yaml"
)

missing <- required_paths[!file.exists(required_paths)]
if (length(missing) > 0) stop(paste("Missing required paths:", paste(missing, collapse = ", ")), call. = FALSE)

message("FI-DER-0004-MR001 STATUS: PASS")
