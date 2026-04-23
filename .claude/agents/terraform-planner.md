# terraform-planner

## Description

Analyzes Terraform state and configurations. Suggests improvements, proposes migration paths, module consolidations, and generates destroy/replace plans with impact analysis.

---

## Purpose

Optimize Terraform workflows, reduce drift, and plan infrastructure changes safely. Help teams maintain clean, efficient state files.

---

## Capabilities

- 🗺️ **State analysis**: Resource dependency graphs, drift detection
- 🔄 **Migration planning**: State splitting, moving providers
- 🧩 **Module consolidation**: Find redundant modules, suggest replacements
- 📋 **Plan generation**: Pre-evaluate terraform plan output
- ⚠️ **Impact analysis**: What changes will break? What depends on what?
- 🧹 **Cleanup**: Orphan resource detection, lifecycle cleanup rules

---

## Commands

### Analyze State

```bash
terraform-planner analyze --state=tfstate --config ./infra/
```

### Migration Plan

```bash
terraform-planner migrate --from-state ./old.tfstate --to-state ./new.tfstate
```

### Module Audit

```bash
terraform-planner modules --check-versions --check-redundancy
```

### Impact Analysis

```bash
terraform-planner impact --changes ./plan.out --format json
```

### Cleanup Plan

```bash
terraform-planner cleanup --dry-run --output cleanup.md
```

---

## Exit Codes

- `0` - Analysis complete ✅
- `1` - Issues found ⚠️
- `2` - Suggestions available 💡
- `3` - Analysis error ❌

---

## Output Format

```json
{
  "state_file": "./infra.tfstate",
  "resource_count": 42,
  "issues": [
    {
      "type": "orphan_resource|version_drift|module_unused",
      "resource": "aws_instance.web",
      "severity": "warning|error",
      "message": "Resource not referenced by any module",
      "suggestion": "Remove or reattach to a module"
    }
  ],
  "recommendations": [
    {
      "priority": "high|medium|low",
      "title": "Consolidate compute modules",
      "description": "Merge compute-a and compute-b into single module",
      "effort": "medium",
      "savings": "maintenance time"
    }
  ],
  "migration_path": null,
  "impact_map": null
}
```

---

## Example Usage

```bash
# Pre-deployment analysis
terraform-planner analyze --config ./infra --state ./state.tfstate

# Generate migration plan
terraform-planner migrate --from-backup ./backup.tfstate --to ./new-config/

# Audit modules for version updates
terraform-planner modules --update-available --output update-plan.md
```

---

## Configuration

```yaml
# .terraform-planner.yaml
providers:
  - name: terraform
    version: 1.5.0
  - name: helmfile
    version: 0.150.0
checks:
  - state_lock_file: true
  - resource_tags: true
  - provider_versions: true
output_formats:
  - json
  - markdown
```

---

## Notes

- Works with remote state backends (S3, Azure Blob)
- Integrates with Terraform Registry
- Supports multiple workspaces
- Generates step-by-step migration guides
