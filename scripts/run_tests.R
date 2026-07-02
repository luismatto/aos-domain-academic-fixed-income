message("AOS Fixed Income Domain FI-DER-0002 validation")

source("scripts/validate_domain.R")
source("scripts/generate_manifest.R")
source("scripts/coverage_report.R")

required_paths <- c(
  "Readme.md",
  "docs/DOMAIN_ARCHITECTURE.md",
  "docs/DOMAIN_LEDGER.md",
  "policies/institutional.apl",
  "objects/AC001_Institutional_Investment_Ecosystem/object.aal",
  "objects/AC001_Institutional_Investment_Ecosystem/dgpi.yaml",
  "objects/CAO001/metadata.yaml",
  "objects/CAO001/knowledge.yaml",
  "objects/CAO001/evidence.yaml",
  "objects/CAO001/professional.yaml",
  "objects/CAO001/learning.yaml",
  "objects/CAO001/manifest.yaml",
  "reports/CAO001_knowledge_manifest.yaml",
  "reports/domain_coverage.yaml"
)

missing <- required_paths[!file.exists(required_paths)]
if (length(missing) > 0) {
  stop(paste("Missing required paths:", paste(missing, collapse = ", ")), call. = FALSE)
}

message("FI-DER-0002 STATUS: PASS")
