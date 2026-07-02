message("Validating generated domain AIR documents")
source("scripts/domain_discovery.R")

objects <- discover_objects()
missing <- character(0)
invalid <- character(0)

for (object_id in objects) {
  path <- file.path("generated/air", paste0(object_id, "_air.json"))
  if (!file.exists(path)) {
    missing <- c(missing, path)
    next
  }
  lines <- readLines(path, warn = FALSE)
  checks <- c(
    any(grepl(paste0('"object_id": "', object_id, '"'), lines, fixed = TRUE)),
    any(grepl('"status": "READY_FOR_ASSET_GENERATION"', lines, fixed = TRUE)),
    any(grepl('"statistics"', lines, fixed = TRUE))
  )
  if (!all(checks)) invalid <- c(invalid, object_id)
  message(object_id, " AIR validation: PASS")
}

if (length(missing) > 0) stop(paste("Missing AIR documents:", paste(missing, collapse = ", ")), call. = FALSE)
if (length(invalid) > 0) stop(paste("Invalid AIR documents:", paste(invalid, collapse = ", ")), call. = FALSE)

message("Domain AIR validation: PASS")
