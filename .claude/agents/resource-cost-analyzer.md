# resource-cost-analyzer

## Description

Scans AWS/Terraform configurations for cost inefficiencies. Identifies unused resources, oversized instances, and suggests cost-saving optimizations.

---

## Purpose

Reduce cloud spending by finding waste. Help teams stay within budgets and optimize infrastructure costs before and after deployment.

---

## Capabilities

- 💰 **Idle detection**: Find unattached EBS, unused load balancers, orphaned RDS instances
- 📏 **Sizing analysis**: Identify over-provisioned instances, storage, databases
- 🗑️ **Cleanup opportunities**: Stale snapshots, IAM roles, security groups
- 🔄 **Rightsizing suggestions**: Recommend smaller instance types, reserved instances
- 📊 **Forecasting**: Estimate monthly cost impact of changes
- 🏷️ **Tag validation**: Check for proper cost allocation tags

---

## Commands

### Analyze Infrastructure

```bash
resource-cost-analyzer analyze --config terraform.tfvars --aws-role ARN
```

### Scan AWS Account

```bash
resource-cost-analyzer scan-account --region us-east-1 --profile default
```

### Generate Report

```bash
resource-cost-analyzer report --format markdown --output cost-report.md
```

### Budget Alerts

```bash
resource-cost-analyzer alert-config --monthly-budget $500 --threshold 80
```

---

## Exit Codes

- `0` - Analysis complete ✅
- `1` - Savings found ⚠️ (configures CI to fail on --strict)
- `2` - No savings detected ✅
- `3` - AWS API access error ❌

---

## Output Format

```json
{
  "status": "analyzed",
  "total_monthly_cost": 1250.00,
  "potential_savings": 340.00,
  "recommendations": [
    {
      "resource": "i-large-4096-ec2",
      "type": "oversized-instance",
      "current_monthly": 120.00,
      "recommended_monthly": 45.00,
      "recommendation": "Downsize to t3.large or use burstable",
      "priority": "high"
    }
  ],
  "cleanup_opportunities": 15,
  "tag_coverage": 0.65
}
```

---

## Example Usage

```bash
# Full analysis
resource-cost-analyzer analyze --config terraform.tfvars --aws-role arn:aws:iam::123456789:role/audit

# Strict mode (fail CI on savings)
resource-cost-analyzer analyze --strict --output fail-if-savings.json

# Generate budget report
resource-cost-analyzer budget-report --account-id 123456789 --format json
```

---

## Configuration

```yaml
# .resource-cost-analyzer.yaml
regions:
  - us-east-1
  - us-west-2
checks:
  - idle_resources: true
  - oversizing: true
  - tagging: true
savings_threshold: 50  # minimum dollar amount to report
```

---

## Notes

- Integrates with AWS Cost Explorer
- Supports Terraform plan parsing
- Provides step-by-step optimization plan
- Exports data for financial reporting
