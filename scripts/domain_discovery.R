message("Loading domain discovery engine")

canonical_required_files <- function() {
  c("metadata.yaml", "knowledge.yaml", "evidence.yaml", "professional.yaml", "learning.yaml", "manifest.yaml")
}

discover_objects <- function(objects_dir = "objects") {
  if (!dir.exists(objects_dir)) return(character())
  candidates <- list.dirs(objects_dir, recursive = FALSE, full.names = FALSE)
  sort(candidates[grepl("^CAO[0-9]{3}$", candidates)])
}

object_path <- function(object_id, filename = NULL, objects_dir = "objects") {
  if (is.null(filename)) file.path(objects_dir, object_id) else file.path(objects_dir, object_id, filename)
}

object_title <- function(object_id, objects_dir = "objects") {
  metadata_path <- object_path(object_id, "metadata.yaml", objects_dir)
  if (!file.exists(metadata_path)) return(object_id)
  lines <- readLines(metadata_path, warn = FALSE)
  title_line <- lines[grepl("^title:", lines)]
  if (length(title_line) == 0) return(object_id)
  trimws(sub("^title:\\s*", "", title_line[[1]]))
}

object_release <- function(object_id, objects_dir = "objects") {
  metadata_path <- object_path(object_id, "metadata.yaml", objects_dir)
  if (!file.exists(metadata_path)) return(NA_character_)
  lines <- readLines(metadata_path, warn = FALSE)
  release_line <- lines[grepl("^release:", lines)]
  if (length(release_line) == 0) return(NA_character_)
  trimws(sub("^release:\\s*", "", release_line[[1]]))
}

object_is_complete <- function(object_id, objects_dir = "objects") {
  all(file.exists(file.path(objects_dir, object_id, canonical_required_files())))
}

discover_complete_objects <- function(objects_dir = "objects") {
  objects <- discover_objects(objects_dir)
  objects[vapply(objects, object_is_complete, logical(1), objects_dir = objects_dir)]
}

domain_object_inventory <- function(objects_dir = "objects") {
  objects <- discover_objects(objects_dir)
  data.frame(
    object_id = objects,
    title = vapply(objects, object_title, character(1), objects_dir = objects_dir),
    release = vapply(objects, object_release, character(1), objects_dir = objects_dir),
    complete = vapply(objects, object_is_complete, logical(1), objects_dir = objects_dir),
    stringsAsFactors = FALSE
  )
}
