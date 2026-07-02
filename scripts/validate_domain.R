source("scripts/domain_discovery.R")

message("Validating fixed income domain objects")

objects <- discover_objects()
if (length(objects) == 0) {
  stop("No Canonical Academic Objects found under objects/.", call. = FALSE)
}

if (!file.exists("policies/institutional.apl")) {
  stop("Missing required policy: policies/institutional.apl", call. = FALSE)
}

validate_object <- function(object_id) {
  paths <- required_cao_paths(object_id)
  missing <- paths[!file.exists(paths)]
  if (length(missing) > 0) {
    stop(paste("Missing required paths for", object_id, ":", paste(missing, collapse = ", ")), call. = FALSE)
  }

  object_path <- object_dir(object_id)
  checks <- c(
    contains_text(file.path(object_path, "metadata.yaml"), "status: ready_for_compilation"),
    contains_text(file.path(object_path, "knowledge.yaml"), "coverage_target: complete"),
    contains_text(file.path(object_path, "evidence.yaml"), "professional_practice:"),
    contains_text(file.path(object_path, "professional.yaml"), "competencies:"),
    contains_text(file.path(object_path, "professional.yaml"), "decisions:"),
    contains_text(file.path(object_path, "learning.yaml"), "required_assets:"),
    contains_text(file.path(object_path, "manifest.yaml"), "knowledge_layer: complete")
  )

  if (!all(checks)) {
    stop(paste0(object_id, " validation checks failed"), call. = FALSE)
  }

  message(object_id, " validation: PASS")
  TRUE
}

invisible(lapply(objects, validate_object))
message("Domain object validation: PASS")
