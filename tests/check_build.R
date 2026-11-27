stopifnot(file.exists("generated/packages/LU001/manifest.yaml"),
          file.exists("generated/module/fixed_income_module_v1/module_manifest.yaml"),
          file.exists("reports/module_build_report.yaml"))
for (id in c("CAO001", "CAO002")) {
  stopifnot(file.exists(file.path("generated/packages/LU001", id, "student_guide.md")))
}
