# ops-playbook-writer

## Description

Creates standard operating procedures. Documents escalation paths. Validates runbooks are up-to-date with code.

---

## Purpose

Maintain accurate, actionable runbooks for common scenarios. Document on-call rotations, escalation procedures, and incident response steps. Keep them updated automatically.

---

## Capabilities

- 📖 **Runbook generation**: From code, post-mortems, incident data
- 📅 **Rotation schedules**: On-call, rotation tracking
- 🚨 **Escalation paths**: Severity, routing, contact info
- ✅ **Validation**: Verify runbook steps still work
- 🔗 **Link generation**: Connect to monitoring, chatops tools
- 📚 **Knowledge base**: Organized by scenario

---

## Commands

### Create Runbook

```bash
ops-playbook-writer create --scenario "database-failover" --steps ./steps/database-failover/*.sh --output runbooks/databases/database-failover.md
```

### Update from Incident

```bash
ops-playbook-writer update --from-incident ./incidents/20260415-postgres-failover.md --output ./runbooks/databases/failover.md
```

### Validate Runbooks

```bash
ops-playbook-writer validate --path ./runbooks/ --dry-run
```

### Generate Schedule

```bash
ops-playbook-writer schedule --rotation weekly --oncall ./oncall-teams/ --output ./schedules/oncall.md
```

### Escalation Path

```bash
ops-playbook-writer escalation --severity critical --path ./escalation-teams/ --output ./runbooks/escalation.md
```

### Link Monitoring

```bash
ops-playbook-writer link-monitoring --runbook ./runbooks/databases/database-failover.md --grafana ./grafana/dashboards/
```

---

## Exit Codes

- `0` - Runbook created/updated ✅
- `1` - Validation failed ✖️
- `2` - Warnings only ⚠️
- `3` - Input parsing error ❌

---

## Output Format

```markdown
# Database Failover Runbook

## Scenario
Primary PostgreSQL database becomes unresponsive, failover to replica required.

## Severity
P1 - Critical (Affects all users)

## Escalation Path
1. **0-5 min**: On-call engineer
2. **5-15 min**: Database team lead
3. **15-30 min**: SRE team
4. **30+ min**: VP of Engineering

## Prerequisites
- Access to AWS Console (S3, EC2, RDS)
- Access to EKS Console
- PagerDuty app installed

## Steps

### 1. Confirm Database Issue (2 min)
```bash
curl -I https://health-check.internal
# Check health endpoint returns 503

aws cloudwatch get-metric-statistics \
  --namespace RDS \
  --metric DatabaseConnectivityErrors \
  --start-time $(date -u +%Y-%m-%dT%H:%M:00Z) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:30Z) \
  --period 60
```

### 2. Check Replica Status
```bash
aws rds describe-db-instances \
  --db-instance-identifier db-primary \
  --query 'DBInstanceReadReplicas[*].DBInstanceStatus'
```

### 3. Force Failover
```bash
# Stop primary
aws rds stop-db-instance \
  --db-instance-identifier db-primary

# Promote replica
aws rds promote-read-replica \
  --db-instance-identifier db-primary-replica-1
```

### 4. Update Application
```bash
# Update connection string
kubectl set env deployment/api-gateway \
  DB_ENDPOINT=${NEW_DB_ENDPOINT}
```

### 5. Verify Recovery
- [ ] Application health checks passing
- [ ] No new errors in logs
- [ ] Database query latency normal
- [ ] Replication lag acceptable

## Post-Incident
- [ ] Update runbook if needed
- [ ] Create incident report
- [ ] Schedule post-mortem
- [ ] Document lessons learned
```

---

## Example Usage

```bash
# Create new runbook
ops-playbook-writer create --scenario "database-failover" --steps ./steps/database-failover/*.sh --output ./runbooks/databases/database-failover.md

# Update from recent incident
ops-playbook-writer update --from-incident ./incidents/20260415-postgres-failover.md

# Validate all runbooks
ops-playbook-writer validate --path ./runbooks/

# Generate on-call schedule
ops-playbook-writer schedule --rotation weekly --oncall ./oncall-teams/
```

---

## Configuration

```yaml
# .ops-playbook-writer.yaml
runbook_directory: ./runbooks/
templates:
  - path: ./runbooks/templates/
    formats:
      - markdown
      - wiki
categories:
  - infrastructure
  - applications
  - security
  - networking
escalation:
  enabled: true
  teams:
    p1:
      - team: sre
        oncall_slack: ${SLACK_SRE_ONCALL}
        phone: ${PAGERDUTY_SRE}
    p2:
      - team: platform
        oncall_slack: ${SLACK_PLATFORM_ONCALL}
validation:
  enabled: true
  run: true  # Execute steps in dry-run mode
  timeout_minutes: 5
links:
  grafana: ${GRAFANA_URL}
  pagerduty: ${PAGERDUTY_URL}
  slack: ${SLACK_URL}
```

---

## Notes

- Integrates with Runbookify, Opsgenie
- Supports custom step scripts
- Validates steps actually work
- Auto-updates from incident data
- Maintains version history
