message("Validating fixed income domain objects")

object_ids <- c("CAO001", "CAO002")
required_files <- c(
  "metadata.yaml",
  "knowledge.yaml",
  "evidence.yaml",
  "professional.yaml",
  "learning.yaml",
  "manifest.yaml"
)

required_paths <- c("policies/institutional.apl")
for (object_id in object_ids) {
  required_paths <- c(required_paths, file.path("objects", object_id, required_files))
}

missing <- required_paths[!file.exists(required_paths)]
if (length(missing) > 0) {
  stop(paste("Missing required paths:", paste(missing, collapse = ", ")), call. = FALSE)
}

contains_text <- function(path, text) {
  any(grepl(text, readLines(path, warn = FALSE), fixed = TRUE))
}

validate_object <- function(object_id) {
  object_dir <- file.path("objects", object_id)
  checks <- c(
    contains_text(file.path(object_dir, "metadata.yaml"), "status: ready_for_compilation"),
    contains_text(file.path(object_dir, "knowledge.yaml"), "coverage_target: complete"),
    contains_text(file.path(object_dir, "evidence.yaml"), "professional_practice:"),
    contains_text(file.path(object_dir, "professional.yaml"), "competencies:"),
    contains_text(file.path(object_dir, "learning.yaml"), "required_assets:"),
    contains_text(file.path(object_dir, "manifest.yaml"), "knowledge_layer: complete")
  )
  if (!all(checks)) {
    stop(paste0(object_id, " validation checks failed"), call. = FALSE)
  }
  message(object_id, " validation: PASS")
}

for (object_id in object_ids) {
  validate_object(object_id)
}
