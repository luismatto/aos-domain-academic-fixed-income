message("Generating fixed income domain coverage report")

if (!dir.exists("reports")) dir.create("reports", recursive = TRUE)

required <- c(
  "metadata.yaml",
  "knowledge.yaml",
  "evidence.yaml",
  "professional.yaml",
  "learning.yaml",
  "manifest.yaml"
)

is_complete <- function(object_id) {
  all(file.exists(file.path("objects", object_id, required)))
}

coverage <- c(
  "domain_coverage:",
  "  release: FI-DER-0003",
  "  objects:",
  paste0("    CAO001_Institutional_Investment_Ecosystem: ", ifelse(is_complete("CAO001"), "COMPLETE", "INCOMPLETE")),
  paste0("    CAO002_Institutional_Types_and_Mandates: ", ifelse(is_complete("CAO002"), "COMPLETE", "INCOMPLETE")),
  "    CAO003_Institutional_Investment_Process: NOT_STARTED",
  "    CAO004_Time_Value_of_Money: NOT_STARTED"
)

writeLines(coverage, "reports/domain_coverage.yaml")
message("Wrote reports/domain_coverage.yaml")
