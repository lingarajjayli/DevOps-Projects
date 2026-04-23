# infra-validator

## Description

Validates Terraform/Helmfile configurations before apply. Runs linting, syntax checks, security scanning, and outputs a "safe to deploy" report.

---

## Purpose

Prevent infrastructure drift, misconfigurations, and security issues before deployment by automatically validating all IaC files.

---

## Capabilities

- ✅ **Terraform validation**: `terraform validate`, `terraform fmt-check`
- ✅ **Helmfile linting**: Syntax, resource references, value schemas
- ✅ **Security scanning**: Check for hardcoded secrets, exposed credentials
- ✅ **Best practices**: Resource naming, tagging, IAM least privilege
- ✅ **Cost analysis**: Identify oversized instances, unused resources
- ✅ **Output**: Structured report with pass/fail status + actionable feedback

---

## Commands

### Full Validation

```bash
infra-validator validate --path . --format json
```

### Terraform-only

```bash
infra-validator validate --type terraform --path ./infra --lint
```

### Security Focus

```bash
infra-validator validate --mode security --path . --output report.md
```

### Dry-run

```bash
infra-validator validate --dry-run --plan-file plan.out
```

---

## Exit Codes

- `0` - All validations passed ✅
- `1` - Errors found ✖️
- `2` - Warnings only ⚠️ (configures CI to fail on --strict)
- `3` - Invalid input/unknown error ❌

---

## Output Format

```json
{
  "status": "passed|failed|warnings",
  "checks": {
    "terraform_syntax": "passed",
    "terraform_valid": "passed",
    "security_secrets": "passed",
    "resource_tagging": "passed",
    "iam_least_privilege": "passed"
  },
  "issues": [],
  "warnings": [],
  "report_url": null
}
```

---

## Example Usage

```bash
# Pre-deploy validation
infra-validator validate --path ./terraform

# CI pipeline
if ! infra-validator validate --dry-run; then
  echo "Infrastructure validation failed!"
  exit 1
fi

# With strict mode (fail on warnings)
infra-validator validate --strict --path ./k8s/manifests
```

---

## Configuration

```yaml
# .infra-validator.yaml
rules:
  - name: required-tags
    severity: error
    enabled: true
  - name: iam-policy-check
    severity: warning
    enabled: true
```

---

## Notes

- Runs pre-commit/pre-push hooks
- Integrates with CI/CD pipelines
- Generates audit trails for compliance
