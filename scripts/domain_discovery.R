message("Loading domain discovery engine")

discover_objects <- function(root = "objects") {
  if (!dir.exists(root)) {
    return(character())
  }
  dirs <- list.dirs(root, recursive = FALSE, full.names = FALSE)
  objects <- dirs[grepl("^CAO[0-9]{3}$", dirs)]
  sort(objects)
}

object_dir <- function(object_id, root = "objects") {
  file.path(root, object_id)
}

required_cao_files <- function() {
  c(
    "metadata.yaml",
    "knowledge.yaml",
    "evidence.yaml",
    "professional.yaml",
    "learning.yaml",
    "manifest.yaml"
  )
}

required_cao_paths <- function(object_id, root = "objects") {
  file.path(object_dir(object_id, root), required_cao_files())
}

contains_text <- function(path, text) {
  if (!file.exists(path)) return(FALSE)
  any(grepl(text, readLines(path, warn = FALSE), fixed = TRUE))
}

read_file_lines <- function(path) {
  if (!file.exists(path)) return(character())
  readLines(path, warn = FALSE)
}

count_pattern <- function(path, pattern) {
  lines <- read_file_lines(path)
  sum(grepl(pattern, lines, fixed = TRUE))
}

count_regex <- function(path, pattern) {
  lines <- read_file_lines(path)
  sum(grepl(pattern, lines))
}

extract_yaml_scalar <- function(path, key, default = "") {
  lines <- read_file_lines(path)
  pattern <- paste0("^", key, ":")
  hit <- lines[grepl(pattern, lines)]
  if (length(hit) == 0) return(default)
  trimws(sub(pattern, "", hit[[1]]))
}
