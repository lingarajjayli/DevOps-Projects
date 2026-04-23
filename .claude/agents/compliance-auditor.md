# compliance-auditor

## Description

Checks infrastructure against policy-as-code rules. Validates CIS benchmarks, PCI-DSS, SOC2 requirements, and generates audit reports.

---

## Purpose

Ensure infrastructure meets compliance standards (PCI-DSS, SOC2, HIPAA, GDPR). Automate audit trails for regulators. Catch non-compliance before it becomes an issue.

---

## Capabilities

- 📋 **Policy validation**: OPA, Gatekeeper, Kyverno policies
- 📊 **Benchmark checks**: CIS AWS, CIS Kubernetes, NIST 800-53
- 🏥 **Industry standards**: PCI-DSS, HIPAA, SOC2, GDPR, ISO 27001
- 📝 **Audit trails**: Immutable logs for regulators
- 🔍 **Evidence collection**: Screenshots, configs, logs
- 📈 **Gap analysis**: Compare current state vs. requirements

---

## Commands

### Full Audit

```bash
compliance-auditor audit --standards pci-dss,soc2 --config policies/ --output audit-report.json
```

### CIS Check

```bash
compliance-auditor cis --framework aws-1.4 --version latest --output cis-compliance.csv
```

### Policy Check

```bash
compliance-auditor policy --opa-config ./policies/rego/ --input ./infra --output violations.json
```

### Generate Report

```bash
compliance-auditor report --format html --output compliance-report.html --include-evidence
```

### Schedule Audit

```bash
compliance-auditor schedule --frequency quarterly --standards pci-dss --time november-15
```

### Gap Analysis

```bash
compliance-auditor gap --standard pci-dss --current-config ./current/ --requirements ./requirements/
```

---

## Exit Codes

- `0` - Compliance met ✅
- `1` - Violations found ❌
- `2` - Warnings only ⚠️
- `3` - Audit error ❌

---

## Output Format

```json
{
  "audit_time": "2026-04-XXTXX:XX:Z",
  "auditor": "compliance-auditor",
  "standards": {
    "pci_dss_4.0": {
      "status": "compliant|non-compliant",
      "score": 87,
      "findings": [
        {
          "requirement": "PCI-DSS 3.3.1",
          "description": "Transmission of data secured",
          "control_id": "PCI-DSS-3.3.1",
          "result": "pass|fail",
          "evidence": "vpc-cfg.json:security_groups",
          "remediation": "Review security group inbound rules"
        }
      ]
    },
    "cis_aws_1.4": {
      "status": "compliant",
      "score": 94,
      "findings": []
    }
  },
  "summary": {
    "total_controls": 420,
    "passed": 398,
    "failed": 15,
    "warnings": 22
  },
  "evidence": [],
  "audit_trail_url": "s3://compliance-audits/20260422/pca-abc123.zip"
}
```

---

## Example Usage

```bash
# Pre-production compliance check
compliance-auditor audit --standards pci-dss,soc2 --strict

# Quarterly PCI audit
compliance-auditor audit --standards pci-dss --schedule quarterly

# Generate auditor evidence pack
compliance-auditor evidence --audit-id audit-abc123 --include-logs true
```

---

## Configuration

```yaml
# .compliance-auditor.yaml
standards:
  - pci-dss-4.0
  - soc2-type2
  - hipaa
  - cis-aws-1.4
  - nist-800-53
policy_engine: opa
policy_path: ./policies/rego/
evidence_collection:
  enabled: true
  max_size_mb: 100
  include_logs: true
  include_configs: true
  include_snapshots: true
schedule:
  audit_frequency: monthly
  deadline_days_before_deadline: 30
remediation:
  auto_flag_non_compliant: true
  notify_team: true
  ticket_integration: jira
```

---

## Notes

- Integrates with audit log services
- Supports custom control definitions
- Generates SOC2 Type II evidence
- Maintains chain of custody for logs
- Works with AWS Config Rules, Azure Policy, GCP Security Command Center
