message("Loading domain blueprint generator")
source("scripts/domain_discovery.R")

parse_simple_yaml_value <- function(path, key) {
  lines <- readLines(path, warn = FALSE)
  pattern <- paste0("^", key, ":")
  hit <- lines[grepl(pattern, lines)]
  if (length(hit) == 0) return(NA_character_)
  trimws(sub(pattern, "", hit[[1]]))
}

count_pattern <- function(path, pattern) {
  lines <- readLines(path, warn = FALSE)
  sum(grepl(pattern, lines, fixed = TRUE))
}

extract_ids <- function(path, prefix) {
  lines <- readLines(path, warn = FALSE)
  pattern <- paste0("    - id: ", prefix)
  ids <- trimws(lines[grepl(pattern, lines, fixed = TRUE)])
  ids <- sub("^- id: ", "", ids)
  ids <- sub("^id: ", "", ids)
  ids
}

json_escape <- function(x) {
  x <- gsub("\\\\", "\\\\\\\\", x)
  x <- gsub('"', '\\"', x)
  x
}

json_array <- function(values, indent = "      ") {
  if (length(values) == 0) return("[]")
  entries <- paste0(indent, '"', json_escape(values), '"')
  paste0("[\n", paste(entries, collapse = ",\n"), "\n", substr(indent, 1, max(0, nchar(indent)-2)), "]")
}

generate_blueprint_for_object <- function(object_id) {
  object_dir <- file.path("objects", object_id)
  metadata_path <- file.path(object_dir, "metadata.yaml")
  knowledge_path <- file.path(object_dir, "knowledge.yaml")
  professional_path <- file.path(object_dir, "professional.yaml")
  learning_path <- file.path(object_dir, "learning.yaml")

  title <- parse_simple_yaml_value(metadata_path, "title")
  version <- parse_simple_yaml_value(metadata_path, "version")
  domain <- parse_simple_yaml_value(metadata_path, "domain")

  knowledge_ids <- extract_ids(knowledge_path, "K")
  competency_ids <- extract_ids(professional_path, "PC")
  decision_ids <- extract_ids(professional_path, "PD")
  capability_ids <- extract_ids(learning_path, "LC")

  nodes <- c(
    paste0('    {"id": "', object_id, '", "type": "academic_object", "title": "', json_escape(title), '"}'),
    paste0('    {"id": "', object_id, '-KNOWLEDGE", "type": "knowledge_layer", "title": "Knowledge Layer"}'),
    paste0('    {"id": "', object_id, '-PROFESSIONAL", "type": "professional_layer", "title": "Professional Layer"}'),
    paste0('    {"id": "', object_id, '-LEARNING", "type": "learning_layer", "title": "Learning Layer"}')
  )

  edges <- c(
    paste0('    {"source": "', object_id, '", "target": "', object_id, '-KNOWLEDGE", "relation": "has_layer"}'),
    paste0('    {"source": "', object_id, '", "target": "', object_id, '-PROFESSIONAL", "relation": "has_layer"}'),
    paste0('    {"source": "', object_id, '", "target": "', object_id, '-LEARNING", "relation": "has_layer"}')
  )

  blueprint <- c(
    "{",
    paste0('  "blueprint_id": "BP-', object_id, '",'),
    paste0('  "object_id": "', object_id, '",'),
    paste0('  "title": "', json_escape(title), '",'),
    paste0('  "version": "', json_escape(version), '",'),
    paste0('  "domain": "', json_escape(domain), '",'),
    '  "source": "CanonicalAcademicObject",',
    '  "compiler_target": "AOS Core ER-0005",',
    '  "metadata": {',
    paste0('    "knowledge_units": ', length(knowledge_ids), ','),
    paste0('    "competencies": ', length(competency_ids), ','),
    paste0('    "professional_decisions": ', length(decision_ids), ','),
    paste0('    "learning_capabilities": ', length(capability_ids)),
    '  },',
    '  "ids": {',
    paste0('    "knowledge": ', json_array(knowledge_ids, "      "), ','),
    paste0('    "competencies": ', json_array(competency_ids, "      "), ','),
    paste0('    "professional_decisions": ', json_array(decision_ids, "      "), ','),
    paste0('    "learning_capabilities": ', json_array(capability_ids, "      ")),
    '  },',
    '  "nodes": [',
    paste(nodes, collapse = ",\n"),
    '  ],',
    '  "edges": [',
    paste(edges, collapse = ",\n"),
    '  ]',
    "}"
  )

  if (!dir.exists("generated/blueprints")) dir.create("generated/blueprints", recursive = TRUE)
  out <- file.path("generated/blueprints", paste0(object_id, "_blueprint.json"))
  writeLines(blueprint, out)
  message("Wrote ", out)
  out
}

generate_all_blueprints <- function() {
  objects <- discover_objects()
  outputs <- vapply(objects, generate_blueprint_for_object, character(1))
  if (!dir.exists("reports")) dir.create("reports", recursive = TRUE)
  report <- c(
    "blueprint_generation_report:",
    "  release: FI-DER-0006",
    paste0("  objects_discovered: ", length(objects)),
    paste0("  blueprints_generated: ", length(outputs)),
    "  status: PASS",
    "  outputs:"
  )
  report <- c(report, paste0("    - ", outputs))
  writeLines(report, "reports/blueprint_generation_report.yaml")
  message("Wrote reports/blueprint_generation_report.yaml")
}

generate_all_blueprints()
