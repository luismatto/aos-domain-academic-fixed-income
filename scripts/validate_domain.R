message("Validating CAO001 domain object")

required_paths <- c(
  "objects/CAO001/metadata.yaml",
  "objects/CAO001/knowledge.yaml",
  "objects/CAO001/evidence.yaml",
  "objects/CAO001/professional.yaml",
  "objects/CAO001/learning.yaml",
  "objects/CAO001/manifest.yaml",
  "policies/institutional.apl"
)

missing <- required_paths[!file.exists(required_paths)]
if (length(missing) > 0) {
  stop(paste("Missing required paths:", paste(missing, collapse = ", ")), call. = FALSE)
}

contains_text <- function(path, text) {
  any(grepl(text, readLines(path, warn = FALSE), fixed = TRUE))
}

checks <- c(
  contains_text("objects/CAO001/metadata.yaml", "status: ready_for_compilation"),
  contains_text("objects/CAO001/knowledge.yaml", "coverage_target: complete"),
  contains_text("objects/CAO001/evidence.yaml", "professional_practice:"),
  contains_text("objects/CAO001/professional.yaml", "competencies:"),
  contains_text("objects/CAO001/learning.yaml", "required_assets:"),
  contains_text("objects/CAO001/manifest.yaml", "knowledge_layer: complete")
)

if (!all(checks)) {
  stop("CAO001 validation checks failed", call. = FALSE)
}

message("CAO001 validation: PASS")
