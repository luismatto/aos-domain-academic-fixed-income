message("Validating generated domain blueprints")
source("scripts/domain_discovery.R")

objects <- discover_objects()
expected <- file.path("generated/blueprints", paste0(objects, "_blueprint.json"))
missing <- expected[!file.exists(expected)]

if (length(missing) > 0) {
  stop(paste("Missing generated blueprints:", paste(missing, collapse = ", ")), call. = FALSE)
}

contains_text <- function(path, text) {
  any(grepl(text, readLines(path, warn = FALSE), fixed = TRUE))
}

for (object_id in objects) {
  path <- file.path("generated/blueprints", paste0(object_id, "_blueprint.json"))
  checks <- c(
    contains_text(path, paste0('"blueprint_id": "BP-', object_id, '"')),
    contains_text(path, '"source": "CanonicalAcademicObject"'),
    contains_text(path, '"nodes": ['),
    contains_text(path, '"edges": [')
  )
  if (!all(checks)) {
    stop(paste0(object_id, " blueprint validation failed"), call. = FALSE)
  }
  message(object_id, " blueprint validation: PASS")
}

message("Domain blueprint validation: PASS")
