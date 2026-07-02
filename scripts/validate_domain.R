message("Validating fixed income domain objects")

source("scripts/domain_discovery.R")

contains_text <- function(path, text) {
  any(grepl(text, readLines(path, warn = FALSE), fixed = TRUE))
}

validate_object <- function(object_id, objects_dir = "objects") {
  object_dir <- file.path(objects_dir, object_id)
  required_paths <- file.path(object_dir, canonical_required_files())

  missing <- required_paths[!file.exists(required_paths)]
  if (length(missing) > 0) {
    stop(paste(object_id, "missing required paths:", paste(missing, collapse = ", ")), call. = FALSE)
  }

  checks <- c(
    contains_text(file.path(object_dir, "metadata.yaml"), "status: ready_for_compilation"),
    contains_text(file.path(object_dir, "knowledge.yaml"), "coverage_target: complete"),
    contains_text(file.path(object_dir, "evidence.yaml"), "professional_practice:"),
    contains_text(file.path(object_dir, "professional.yaml"), "competencies:"),
    contains_text(file.path(object_dir, "learning.yaml"), "required_assets:"),
    contains_text(file.path(object_dir, "manifest.yaml"), "knowledge_layer: complete")
  )

  if (!all(checks)) stop(paste0(object_id, " validation checks failed"), call. = FALSE)
  message(object_id, " validation: PASS")
  TRUE
}

objects <- discover_objects()
if (length(objects) == 0) stop("No canonical academic objects discovered under objects/", call. = FALSE)
if (!file.exists("policies/institutional.apl")) stop("Missing required policy: policies/institutional.apl", call. = FALSE)

for (object_id in objects) validate_object(object_id)

message("Domain object validation: PASS")
