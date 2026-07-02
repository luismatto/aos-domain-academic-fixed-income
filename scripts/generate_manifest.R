message("Generating CAO001 knowledge manifest")

count_pattern <- function(path, pattern) {
  lines <- readLines(path, warn = FALSE)
  sum(grepl(pattern, lines, fixed = TRUE))
}

object_dir <- "objects/CAO001"
knowledge_units <- count_pattern(file.path(object_dir, "knowledge.yaml"), "    - id: K")
competencies <- count_pattern(file.path(object_dir, "professional.yaml"), "    - id: PC")
decisions <- count_pattern(file.path(object_dir, "professional.yaml"), "    - id: PD")
capabilities <- count_pattern(file.path(object_dir, "learning.yaml"), "    - id: LC")
assets <- count_pattern(file.path(object_dir, "learning.yaml"), "    - ")

if (!dir.exists("reports")) dir.create("reports", recursive = TRUE)

manifest <- c(
  "knowledge_manifest:",
  "  object_id: CAO001",
  "  title: Institutional Investment Ecosystem",
  "  status: READY_FOR_COMPILATION",
  paste0("  knowledge_units: ", knowledge_units),
  paste0("  competencies: ", competencies),
  paste0("  professional_decisions: ", decisions),
  paste0("  learning_capabilities: ", capabilities),
  "  evidence_layer: complete",
  "  professional_layer: complete",
  "  learning_layer: complete"
)

writeLines(manifest, "reports/CAO001_knowledge_manifest.yaml")
message("Wrote reports/CAO001_knowledge_manifest.yaml")
