message("AOS Fixed Income Domain FI-DER-0001 validation")

required_paths <- c(
  "Readme.md",
  "docs/DOMAIN_ARCHITECTURE.md",
  "docs/DOMAIN_LEDGER.md",
  "policies/institutional.apl",
  "objects/AC001_Institutional_Investment_Ecosystem/object.aal",
  "objects/AC001_Institutional_Investment_Ecosystem/dgpi.yaml"
)

missing <- required_paths[!file.exists(required_paths)]
if (length(missing) > 0) {
  stop(paste("Missing required paths:", paste(missing, collapse = ", ")), call. = FALSE)
}

message("FI-DER-0001 STATUS: PASS")
