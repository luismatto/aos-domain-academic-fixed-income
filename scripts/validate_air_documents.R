message("Validating generated domain AIR documents")

source("scripts/domain_discovery.R")

contains_text <- function(path, text) {
  any(grepl(text, readLines(path, warn = FALSE, encoding = "UTF-8"), fixed = TRUE))
}

objects <- discover_objects()
for (object_id in objects) {
  air_path <- file.path("generated/air", paste0(object_id, "_air.json"))
  if (!file.exists(air_path)) {
    stop(paste0("Missing AIR document for ", object_id, ": ", air_path), call. = FALSE)
  }

  checks <- c(
    contains_text(air_path, '"air_document"'),
    contains_text(air_path, paste0('"object_id": "', object_id, '"')),
    contains_text(air_path, '"status": "PASS"'),
    contains_text(air_path, '"compatible_with": "AOS_ER_0005"')
  )

  if (!all(checks)) {
    stop(paste0(object_id, " AIR validation checks failed"), call. = FALSE)
  }
  message(object_id, " AIR validation: PASS")
}

message("Domain AIR validation: PASS")
