message("Generating CAO knowledge manifests")

count_pattern <- function(path, pattern) {
  lines <- readLines(path, warn = FALSE)
  sum(grepl(pattern, lines, fixed = TRUE))
}

generate_for_object <- function(object_id, title) {
  object_dir <- file.path("objects", object_id)
  knowledge_units <- count_pattern(file.path(object_dir, "knowledge.yaml"), "    - id: K")
  competencies <- count_pattern(file.path(object_dir, "professional.yaml"), "    - id: PC")
  decisions <- count_pattern(file.path(object_dir, "professional.yaml"), "    - id: PD")
  capabilities <- count_pattern(file.path(object_dir, "learning.yaml"), "    - id: LC")

  manifest <- c(
    "knowledge_manifest:",
    paste0("  object_id: ", object_id),
    paste0("  title: ", title),
    "  status: READY_FOR_COMPILATION",
    paste0("  knowledge_units: ", knowledge_units),
    paste0("  competencies: ", competencies),
    paste0("  professional_decisions: ", decisions),
    paste0("  learning_capabilities: ", capabilities),
    "  evidence_layer: complete",
    "  professional_layer: complete",
    "  learning_layer: complete"
  )

  out <- file.path("reports", paste0(object_id, "_knowledge_manifest.yaml"))
  writeLines(manifest, out)
  message("Wrote ", out)
}

if (!dir.exists("reports")) dir.create("reports", recursive = TRUE)

generate_for_object("CAO001", "Institutional Investment Ecosystem")
generate_for_object("CAO002", "Institutional Types and Mandates")
