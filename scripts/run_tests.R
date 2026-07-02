message("AOS Fixed Income Domain FI-DER-0008 validation")

source("scripts/domain_discovery.R")
source("scripts/validate_domain.R")
source("scripts/generate_manifest.R")
source("scripts/coverage_report.R")
source("scripts/generate_knowledge_graph.R")
source("scripts/generate_blueprints.R")
source("scripts/validate_blueprints.R")
source("scripts/generate_air.R")
source("scripts/validate_air.R")
source("scripts/generate_assets.R")
source("scripts/validate_assets.R")

required_paths <- c(
  "Readme.md",
  "docs/DOMAIN_ARCHITECTURE.md",
  "docs/DOMAIN_LEDGER.md",
  "policies/institutional.apl",
  "reports/domain_coverage.yaml",
  "reports/domain_knowledge_graph.yaml",
  "reports/blueprint_generation_report.yaml",
  "reports/air_generation_report.yaml",
  "reports/asset_generation_report.yaml"
)

objects <- discover_objects()
for (object_id in objects) {
  required_paths <- c(
    required_paths,
    file.path("objects", object_id, "metadata.yaml"),
    file.path("objects", object_id, "knowledge.yaml"),
    file.path("objects", object_id, "evidence.yaml"),
    file.path("objects", object_id, "professional.yaml"),
    file.path("objects", object_id, "learning.yaml"),
    file.path("objects", object_id, "manifest.yaml"),
    file.path("reports", paste0(object_id, "_knowledge_manifest.yaml")),
    file.path("generated", "blueprints", paste0(object_id, "_blueprint.json")),
    file.path("generated", "air", paste0(object_id, "_air.json")),
    file.path("generated", "assets", object_id, "slides.md"),
    file.path("generated", "assets", object_id, "workshop.md"),
    file.path("generated", "assets", object_id, "instructor_guide.md"),
    file.path("generated", "assets", object_id, "student_guide.md"),
    file.path("generated", "assets", object_id, "exercises.md"),
    file.path("generated", "assets", object_id, "solutions.md"),
    file.path("generated", "assets", object_id, "rubric.md"),
    file.path("generated", "assets", object_id, "dgpi.md"),
    file.path("generated", "assets", object_id, "toolbox.md")
  )
}

missing <- required_paths[!file.exists(required_paths)]
if (length(missing) > 0) {
  stop(paste("Missing required paths:", paste(missing, collapse = ", ")), call. = FALSE)
}

message("FI-DER-0008 STATUS: PASS")
