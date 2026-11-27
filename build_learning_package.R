# Reconstruct the technical LU001 package from canonical generated assets.
source("scripts/domain_discovery.R")
ids <- c("CAO001", "CAO002")
assets <- c("slides", "workshop", "instructor_guide", "student_guide", "exercises", "solutions", "rubric", "dgpi", "toolbox")
out <- "generated/packages/LU001"
dir.create(out, recursive = TRUE, showWarnings = FALSE)
for (id in ids) {
  stopifnot(all(file.exists(required_cao_paths(id))))
  src <- file.path("generated/assets", id, paste0(assets, ".md"))
  stopifnot(all(file.exists(src)))
  dest <- file.path(out, id)
  dir.create(dest, showWarnings = FALSE)
  stopifnot(all(file.copy(src, dest, overwrite = TRUE)))
}
writeLines(c("id: LU001", "title: Institutional Investment Ecosystem", "status: technical_package", "objects:", paste0("  - ", ids)), file.path(out, "manifest.yaml"))
message("LU001 technical package built")
