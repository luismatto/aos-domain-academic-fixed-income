source("scripts/domain_discovery.R")

message("Generating CAO knowledge manifests")

if (!dir.exists("reports")) dir.create("reports", recursive = TRUE)

generate_for_object <- function(object_id) {
  object_path <- object_dir(object_id)
  title <- extract_yaml_scalar(file.path(object_path, "metadata.yaml"), "title", object_id)

  knowledge_units <- count_regex(file.path(object_path, "knowledge.yaml"), "^    - id: K")
  concepts <- count_regex(file.path(object_path, "knowledge.yaml"), "^        - ")
  relations <- count_regex(file.path(object_path, "knowledge.yaml"), "^        - .*")
  competencies <- count_regex(file.path(object_path, "professional.yaml"), "^    - id: PC")
  decisions <- count_regex(file.path(object_path, "professional.yaml"), "^    - id: PD")
  capabilities <- count_regex(file.path(object_path, "learning.yaml"), "^    - id: LC")
  learning_units <- count_regex(file.path(object_path, "learning.yaml"), "^    - id: LU")
  evidence_sources <- count_regex(file.path(object_path, "evidence.yaml"), "^    - id: ")

  manifest <- c(
    "knowledge_manifest:",
    paste0("  object_id: ", object_id),
    paste0("  title: ", title),
    "  status: READY_FOR_COMPILATION",
    paste0("  knowledge_units: ", knowledge_units),
    paste0("  concepts_and_relation_items: ", concepts),
    paste0("  relations_items: ", relations),
    paste0("  competencies: ", competencies),
    paste0("  professional_decisions: ", decisions),
    paste0("  learning_capabilities: ", capabilities),
    paste0("  learning_units: ", learning_units),
    paste0("  evidence_sources: ", evidence_sources),
    "  evidence_layer: complete",
    "  professional_layer: complete",
    "  learning_layer: complete"
  )

  out <- file.path("reports", paste0(object_id, "_knowledge_manifest.yaml"))
  writeLines(manifest, out)
  message("Wrote ", out)
}

objects <- discover_objects()
invisible(lapply(objects, generate_for_object))
