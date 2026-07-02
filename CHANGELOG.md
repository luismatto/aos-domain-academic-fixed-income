# MR-001 Changelog

## Added
- `scripts/domain_discovery.R`
- Canonical Object Template under `templates/canonical_object/`

## Changed
- `validate_domain.R` now discovers CAO objects automatically.
- `generate_manifest.R` now generates manifests for every discovered CAO.
- `coverage_report.R` now computes coverage from discovered CAO objects.
- `run_tests.R` validates dynamic discovery instead of hard-coded CAO lists.

## Status
Validation candidate.
