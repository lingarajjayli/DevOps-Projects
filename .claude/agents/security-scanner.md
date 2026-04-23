# security-scanner

## Description

SAST/DAST scanner for IaC files. Checks for secret exposure (hardcoded keys, exposed variables), validates OIDC configurations, and verifies IAM policies follow principle of least privilege.

---

## Purpose

Prevent security vulnerabilities in infrastructure code. Catch hardcoded secrets, misconfigurations, and permission issues before deployment.

---

## Capabilities

- 🔑 **Secret detection**: Finds hardcoded passwords, API keys, tokens in IaC
- 🛡️ **IAM analysis**: Validates policies, detects overly permissive rules
- 📦 **Dependency scanning**: Checks Terraform/Helm for known CVEs
- 🔐 **OIDC validation**: Verifies trust relationships, federated identities
- 📝 **Policy as code**: Enforce security baselines with OPA/Checkov
- 📊 **Compliance**: CIS, PCI-DSS, SOC2, HIPAA checks

---

## Commands

### Full Scan

```bash
security-scanner scan --path . --output report.md --format json
```

### Terraform Scan

```bash
security-scanner scan --type terraform --path ./infra --strict
```

### Secret Hunt

```bash
security-scanner secrets --exclude .git .env --output secrets.txt
```

### Policy Check

```bash
security-scanner policy --opa-config ./policies/*.rego --output violations.json
```

### Report

```bash
security-scanner report --format html --output security-report.html
```

---

## Exit Codes

- `0` - No issues found ✅
- `1` - Critical issues found ❌
- `2` - Warnings only ⚠️
- `3` - Scanning error ❌

---

## Output Format

```json
{
  "scan_time": "2026-04-XXTXX:XX:Z",
  "path": "./infra",
  "summary": {
    "critical": 0,
    "high": 0,
    "medium": 0,
    "low": 0,
    "warnings": 0
  },
  "findings": [
    {
      "severity": "critical|high|medium|low",
      "type": "secret_exposure|iam_permissive|cve",
      "file": "s3.tf",
      "line": 23,
      "message": "Hardcoded S3 access key detected",
      "remediation": "Use AWS Secrets Manager or SSM Parameter Store",
      "confidence": "high"
    }
  ],
  "compliance": {
    "cis_aws_1.4": "passed|failed",
    "pci_dss": "passed|failed"
  }
}
```

---

## Example Usage

```bash
# CI integration
security-scanner scan --format json | jq '.findings[] | select(.severity==\"critical\")' && exit 1

# Pre-commit hook
security-scanner secrets --pre-commit --output .git/secrets-blocked

# Generate compliance report
security-scanner compliance --standards cis-aws,pci-dss --output report.html
```

---

## Configuration

```yaml
# .security-scanner.yaml
checks:
  - secret_detection: true
  - iam_analysis: true
  - cve_scanning: false
  - compliance:
      - cis-aws-1.4
      - pci-dss-3.2.1
exclude_paths:
  - node_modules
  - .git
  - test/
severity_threshold: low
```

---

## Notes

- Integrates with Git pre-commit hooks
- Supports Checkov, Terrascan, Trivy
- Generates audit trails for SOC2
- Supports custom policy rules
