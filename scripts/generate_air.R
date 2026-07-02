message("Generating fixed income domain AIR documents")
source("scripts/domain_discovery.R")

objects <- discover_objects()
if (!dir.exists("generated/air")) dir.create("generated/air", recursive = TRUE)
if (!dir.exists("reports")) dir.create("reports", recursive = TRUE)

read_scalar <- function(path, key, default = "") {
  lines <- readLines(path, warn = FALSE)
  hit <- grep(paste0("^", key, ":"), lines, value = TRUE)
  if (length(hit) == 0) return(default)
  trimws(sub(paste0("^", key, ":"), "", hit[[1]]))
}

count_pattern <- function(path, pattern) {
  if (!file.exists(path)) return(0L)
  sum(grepl(pattern, readLines(path, warn = FALSE), fixed = TRUE))
}

for (object_id in objects) {
  object_dir <- file.path("objects", object_id)
  metadata <- file.path(object_dir, "metadata.yaml")
  title <- read_scalar(metadata, "title", object_id)
  status <- read_scalar(metadata, "status", "unknown")
  dependencies <- grep("^  - CAO", readLines(metadata, warn = FALSE), value = TRUE)
  dependencies <- trimws(sub("^-", "", trimws(dependencies)))

  air <- list(
    air_document = list(
      id = paste0(object_id, "_AIR"),
      object_id = object_id,
      title = title,
      status = "READY_FOR_ASSET_GENERATION",
      source_blueprint = paste0("generated/blueprints/", object_id, "_blueprint.json"),
      canonical_layers = c("governance", "knowledge", "evidence", "professional", "learning"),
      dependencies = dependencies,
      statistics = list(
        knowledge_units = count_pattern(file.path(object_dir, "knowledge.yaml"), "    - id: K"),
        competencies = count_pattern(file.path(object_dir, "professional.yaml"), "    - id: PC"),
        professional_decisions = count_pattern(file.path(object_dir, "professional.yaml"), "    - id: PD"),
        learning_capabilities = count_pattern(file.path(object_dir, "learning.yaml"), "    - id: LC")
      ),
      generation = list(
        slides = "pending_asset_generator",
        workshop = "pending_asset_generator",
        instructor_guide = "pending_asset_generator",
        student_guide = "pending_asset_generator",
        exercises = "pending_asset_generator",
        solutions = "pending_asset_generator",
        rubric = "pending_asset_generator",
        dgpi = "pending_asset_generator"
      )
    )
  )

  out <- file.path("generated/air", paste0(object_id, "_air.json"))
  json <- jsonlite::toJSON(air, pretty = TRUE, auto_unbox = TRUE)
  writeLines(json, out)
  message("Wrote ", out)
}

report <- c(
  "air_generation_report:",
  "  release: FI-DER-0008",
  paste0("  objects: ", length(objects)),
  "  status: PASS"
)
writeLines(report, "reports/air_generation_report.yaml")
message("Wrote reports/air_generation_report.yaml")
