message("Building executable learning package LU001")

source("scripts/domain_discovery.R")

ensure_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
}

copy_if_exists <- function(from, to) {
  if (file.exists(from)) {
    ensure_dir(dirname(to))
    file.copy(from, to, overwrite = TRUE)
    return(TRUE)
  }
  FALSE
}

object_id <- "CAO001"
package_id <- "LU001"
object_dir <- file.path("objects", object_id)
air_file <- file.path("generated", "air", paste0(object_id, "_air.json"))
blueprint_file <- file.path("generated", "blueprints", paste0(object_id, "_blueprint.json"))
asset_dir <- file.path("generated", "assets", object_id)

package_dir <- file.path("generated", "packages", package_id)
ensure_dir(package_dir)
ensure_dir(file.path(package_dir, "source"))
ensure_dir(file.path(package_dir, "assets"))
ensure_dir(file.path(package_dir, "reports"))

required_sources <- c(
  file.path(object_dir, "metadata.yaml"),
  file.path(object_dir, "knowledge.yaml"),
  file.path(object_dir, "evidence.yaml"),
  file.path(object_dir, "professional.yaml"),
  file.path(object_dir, "learning.yaml"),
  file.path(object_dir, "manifest.yaml"),
  blueprint_file,
  air_file
)

missing <- required_sources[!file.exists(required_sources)]
if (length(missing) > 0) {
  stop(paste("Cannot build LU001 package. Missing:", paste(missing, collapse = ", ")), call. = FALSE)
}

for (src in required_sources) {
  copy_if_exists(src, file.path(package_dir, "source", basename(src)))
}

if (dir.exists(asset_dir)) {
  asset_files <- list.files(asset_dir, full.names = TRUE, recursive = TRUE)
  for (src in asset_files) {
    if (!dir.exists(src)) {
      rel <- substring(src, nchar(asset_dir) + 2)
      copy_if_exists(src, file.path(package_dir, "assets", rel))
    }
  }
}

manifest <- c(
  "learning_package:",
  paste0("  id: ", package_id),
  "  title: Institutional Investment Ecosystem",
  "  source_object: CAO001",
  "  release: FI-DER-0009",
  "  status: EXECUTABLE",
  "  compiler_stage:",
  "    object: complete",
  "    blueprint: complete",
  "    air: complete",
  "    assets: complete",
  "  required_assets:",
  "    - slides",
  "    - workshop",
  "    - instructor_guide",
  "    - student_guide",
  "    - exercises",
  "    - solutions",
  "    - rubric",
  "    - dgpi",
  "  package_contents:",
  "    source: true",
  "    assets: true",
  "    reports: true"
)

writeLines(manifest, file.path(package_dir, "package_manifest.yaml"))

readme <- c(
  "# LU001 Executable Learning Package",
  "",
  "## Title",
  "",
  "Institutional Investment Ecosystem",
  "",
  "## Source Object",
  "",
  "CAO001",
  "",
  "## Status",
  "",
  "EXECUTABLE",
  "",
  "## Contents",
  "",
  "- Canonical Academic Object sources",
  "- Generated Blueprint",
  "- Generated AIR",
  "- Generated academic assets",
  "- Package manifest",
  "",
  "## Validation",
  "",
  "Run from the repository root:",
  "",
  "```r",
  "source(\"scripts/run_tests.R\")",
  "```"
)

writeLines(readme, file.path(package_dir, "README.md"))

report <- c(
  "learning_package_report:",
  "  release: FI-DER-0009",
  "  package_id: LU001",
  "  source_object: CAO001",
  "  status: BUILT",
  paste0("  source_files: ", length(required_sources)),
  paste0("  asset_files: ", ifelse(dir.exists(asset_dir), length(list.files(asset_dir, recursive = TRUE)), 0))
)

ensure_dir("reports")
writeLines(report, "reports/learning_package_generation_report.yaml")

message("Wrote generated/packages/LU001")
message("Wrote reports/learning_package_generation_report.yaml")
