message("Loading domain discovery engine")
source("scripts/domain_discovery.R")

message("Generating fixed income domain knowledge graph")

objects <- discover_objects()

if (!dir.exists("reports")) dir.create("reports", recursive = TRUE)

read_lines_safe <- function(path) {
  if (!file.exists(path)) return(character())
  readLines(path, warn = FALSE, encoding = "UTF-8")
}

extract_title <- function(object_id) {
  path <- file.path("objects", object_id, "metadata.yaml")
  lines <- read_lines_safe(path)
  title_line <- lines[grepl("^title:", lines)]
  if (length(title_line) == 0) return(object_id)
  trimws(sub("^title:\\s*", "", title_line[[1]]))
}

extract_dependencies <- function(object_id) {
  path <- file.path("objects", object_id, "metadata.yaml")
  lines <- read_lines_safe(path)
  if (!any(grepl("^dependencies:", lines))) return(character())
  start <- which(grepl("^dependencies:", lines))[1]
  tail_lines <- lines[(start + 1):length(lines)]
  deps <- trimws(sub("^-\\s*", "", tail_lines[grepl("^\\s*-\\s*CAO", tail_lines)]))
  deps[nzchar(deps)]
}

extract_ids <- function(object_id, file, prefix) {
  path <- file.path("objects", object_id, file)
  lines <- read_lines_safe(path)
  ids <- trimws(sub("^.*- id:\\s*", "", lines[grepl(paste0("- id: ", prefix), lines, fixed = TRUE)]))
  ids[nzchar(ids)]
}

graph <- c(
  "domain_knowledge_graph:",
  "  release: FI-DER-0006",
  "  generated_from: CanonicalAcademicObjects",
  "  nodes:"
)

for (object_id in objects) {
  graph <- c(
    graph,
    paste0("    - id: ", object_id),
    paste0("      title: ", extract_title(object_id)),
    "      type: CanonicalAcademicObject",
    paste0("      knowledge_units: ", length(extract_ids(object_id, "knowledge.yaml", "K"))),
    paste0("      competencies: ", length(extract_ids(object_id, "professional.yaml", "PC"))),
    paste0("      learning_capabilities: ", length(extract_ids(object_id, "learning.yaml", "LC")))
  )
}

graph <- c(graph, "  edges:")

edge_count <- 0
for (object_id in objects) {
  deps <- extract_dependencies(object_id)
  for (dep in deps) {
    edge_count <- edge_count + 1
    graph <- c(
      graph,
      paste0("    - source: ", dep),
      paste0("      target: ", object_id),
      "      relation: prerequisite_of"
    )
  }
}

if (edge_count == 0) {
  graph <- c(graph, "    []")
}

writeLines(graph, "reports/domain_knowledge_graph.yaml", useBytes = TRUE)
message("Wrote reports/domain_knowledge_graph.yaml")
