source("scripts/domain_discovery.R")

message("Generating fixed income domain knowledge graph")

if (!dir.exists("reports")) dir.create("reports", recursive = TRUE)

objects <- discover_objects()

dependency_edges <- character()
for (object_id in objects) {
  metadata <- read_file_lines(file.path(object_dir(object_id), "metadata.yaml"))
  dep_lines <- metadata[grepl("^  - CAO", metadata)]
  if (length(dep_lines) > 0) {
    deps <- trimws(sub("^-", "", trimws(dep_lines)))
    for (dep in deps) {
      dependency_edges <- c(
        dependency_edges,
        paste0("    - from: ", dep, "\n      to: ", object_id, "\n      relation: prerequisite_of")
      )
    }
  }
}

if (length(dependency_edges) == 0) {
  dependency_edges <- "    []"
}

graph <- c(
  "domain_knowledge_graph:",
  "  release: FI-DER-0005",
  "  nodes:"
)

for (object_id in objects) {
  title <- extract_yaml_scalar(file.path(object_dir(object_id), "metadata.yaml"), "title", object_id)
  graph <- c(graph, paste0("    - id: ", object_id), paste0("      title: ", title))
}

graph <- c(graph, "  dependency_edges:", dependency_edges)

writeLines(graph, "reports/domain_knowledge_graph.yaml")
message("Wrote reports/domain_knowledge_graph.yaml")
