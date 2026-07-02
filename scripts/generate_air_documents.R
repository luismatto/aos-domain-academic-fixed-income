message("Generating fixed income domain AIR documents")

source("scripts/domain_discovery.R")

safe_read <- function(path) {
  paste(readLines(path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
}

extract_json_string <- function(text, field) {
  pattern <- paste0("\"", field, "\"[[:space:]]*:[[:space:]]*\"([^\"]*)\"")
  match <- regexec(pattern, text)
  value <- regmatches(text, match)[[1]]
  if (length(value) >= 2) value[[2]] else NA_character_
}

json_escape <- function(x) {
  x <- gsub("\\\\", "\\\\\\\\", x)
  x <- gsub("\"", "\\\\\"", x)
  x
}

if (!dir.exists("generated/air")) dir.create("generated/air", recursive = TRUE)
if (!dir.exists("reports")) dir.create("reports", recursive = TRUE)

objects <- discover_objects()
generated <- character(0)

for (object_id in objects) {
  blueprint_path <- file.path("generated/blueprints", paste0(object_id, "_blueprint.json"))
  if (!file.exists(blueprint_path)) {
    stop(paste0("Missing blueprint for ", object_id, ": ", blueprint_path), call. = FALSE)
  }

  blueprint_text <- safe_read(blueprint_path)
  blueprint_id <- extract_json_string(blueprint_text, "blueprint_id")
  title <- extract_json_string(blueprint_text, "title")
  if (is.na(blueprint_id)) blueprint_id <- paste0("BP-", object_id)
  if (is.na(title)) title <- object_id

  air_path <- file.path("generated/air", paste0(object_id, "_air.json"))
  air <- c(
    "{",
    paste0('  "air_document": "', json_escape(paste0("AIR-", object_id)), '",'),
    paste0('  "object_id": "', json_escape(object_id), '",'),
    paste0('  "blueprint_id": "', json_escape(blueprint_id), '",'),
    paste0('  "title": "', json_escape(title), '",'),
    '  "air_version": "0.1.0",',
    '  "source": "domain_blueprint",',
    '  "status": "PASS",',
    '  "compiler_contract": {',
    '    "input": "domain_blueprint",',
    '    "output": "air_document",',
    '    "compatible_with": "AOS_ER_0005"',
    '  },',
    '  "sections": [',
    '    "metadata",',
    '    "knowledge",',
    '    "evidence",',
    '    "professional",',
    '    "learning",',
    '    "manifest"',
    '  ]',
    "}"
  )

  writeLines(air, air_path, useBytes = TRUE)
  generated <- c(generated, air_path)
  message("Wrote ", air_path)
}

report <- c(
  "air_generation_report:",
  "  release: FI-DER-0007",
  paste0("  generated_air_documents: ", length(generated)),
  "  status: PASS",
  "  files:"
)
for (path in generated) {
  report <- c(report, paste0("    - ", path))
}
writeLines(report, "reports/air_generation_report.yaml", useBytes = TRUE)
message("Wrote reports/air_generation_report.yaml")
