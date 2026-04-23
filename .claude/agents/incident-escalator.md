# incident-escalator

## Description

Monitors SLOs, error budgets. Auto-escalates to on-call based on severity. Creates post-incident review templates.

---

## Purpose

Automate incident management workflows. Detect degradations before they become outages. Ensure appropriate escalation paths are followed for SLA compliance.

---

## Capabilities

- ⏱️ **SLO monitoring**: Error rate, latency, availability tracking
- 💰 **Error budget tracking**: Alert on budget burn rate
- 🚨 **Auto-escalation**: PagerDuty, Opsgenie, Slack routing
- 📝 **Post-mortem generation**: Structured blameless post-incident reports
- 📊 **MTTD/MTTR metrics**: Mean time to detect, resolve
- 📈 **Trend analysis**: Repeat issues, root cause patterns

---

## Commands

### Monitor SLOs

```bash
incident-escalator monitor --slos-file ./slos.yaml --interval 30s
```

### Auto-escalate

```bash
incident-escalator escalate --incident-id inc-abc123 --level page-on-call
```

### Generate Post-Mortem

```bash
incident-escalator postmortem --incident-id inc-abc123 --format markdown --output postmortem.md
```

### Check Error Budget

```bash
incident-escalator budget --service auth-service --error-budget 0.999
```

### Schedule Review

```bash
incident-escalator schedule-reviews --frequency monthly --include-critical-only
```

### Auto-close

```bash
incident-escalator auto-close --incident-id inc-abc123 --after-quiet-period-1h
```

---

## Exit Codes

- `0` - SLOs healthy ✅
- `1` - Alert triggered ✖️
- `2` - Escalation initiated ⚠️
- `3` - Monitor error ❌

---

## Output Format

```json
{
  "check_time": "2026-04-XXTXX:XX:Z",
  "services": {
    "auth-service": {
      "slo": {
        "error_budget": 0.999,
        "burn_rate_5d": 0.00012,
        "remaining_budget_hours": 48
      },
      "status": "healthy|burning|critical"
    },
    "api-gateway": {
      "latency_p99_ms": 120,
      "slo_target_ms": 200,
      "status": "healthy"
    }
  },
  "alerts": [
    {
      "type": "error-budget-burn|slo-degraded",
      "severity": "critical|high|medium|low",
      "message": "auth-service error budget burning 5x faster than target",
      "action_taken": "escalated_to_oncall"
    }
  ],
  "escalations": [],
  "pending_incidents": []
}
```

---

## Example Usage

```bash
# Continuous monitoring
incident-escalator monitor --config ./slos.yaml > /dev/null 2>&1 &

# Auto-escalate based on SLO degradation
incident-escalator monitor --action auto-escalate --threshold error-budget-burn-5x

# Generate post-mortem for recent incident
incident-escalator postmortem --incident-id inc-xyz789 --team sre
```

---

## Configuration

```yaml
# .incident-escalator.yaml
slos:
  - service: auth-service
    error_budget: 0.999
    window: 24h
    alert_burn_rate: 0.001
  - service: api-gateway
    latency_p99_ms: 200
    alert_threshold_ms: 150
escalation:
  levels:
    - name: notify
      action: slack
      delay_seconds: 30
    - name: page-on-call
      action: pagerduty
      delay_seconds: 60
    - name: executive
      action: email
      delay_seconds: 300
  routing_table:
    sre-team:
      - slack_webhook: ${SLACK_SRE}
      - pagerduty: ${PAGERDUTY_SRE}
postmortem:
  template: ./postmortem-templates/default.md
  auto_assign_reviewer: true
  notify_reviewers: true
quiet_period_hours: 4
auto_close_after_hours: 72
```

---

## Notes

- Integrates with PagerDuty, Opsgenie, Slack
- Supports Jira Service Management integration
- Auto-generates blameless post-mortems
- Tracks recurring incidents for root cause fixes
- Maintains incident timeline
