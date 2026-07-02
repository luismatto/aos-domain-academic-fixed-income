# CAO to Blueprint Generator

## Release

FI-DER-0006

## Purpose

The domain now generates an internal Blueprint JSON file for every discovered Canonical Academic Object.

## Source

```text
objects/<CAO_ID>/
```

## Output

```text
generated/blueprints/<CAO_ID>_blueprint.json
reports/blueprint_generation_report.yaml
```

## Rule

Blueprints are generated artifacts. They must not become the source of truth. The Canonical Academic Object remains the canonical source.
