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

cao001_files <- file.path("objects/CAO001", required)
cao001_complete <- all(file.exists(cao001_files))

coverage <- c(
  "domain_coverage:",
  "  release: FI-DER-0002",
  "  objects:",
  paste0("    CAO001_Institutional_Investment_Ecosystem: ", ifelse(cao001_complete, "COMPLETE", "INCOMPLETE")),
  "    CAO002_Institutional_Types_and_Mandates: NOT_STARTED",
  "    CAO003_Institutional_Investment_Process: NOT_STARTED",
  "    CAO004_Time_Value_of_Money: NOT_STARTED"
)

writeLines(coverage, "reports/domain_coverage.yaml")
message("Wrote reports/domain_coverage.yaml")
