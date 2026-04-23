# drill-commander

## Description

Orchestrates chaos engineering tests in staging. Runs failure simulations, recovery validation, and captures metrics for resilience reports.

---

## Purpose

Validate system resilience by simulating real-world failures. Help teams detect weak points and improve recovery procedures before they hit production.

---

## Capabilities

- 💥 **Failure injection**: Network latency, pod crashes, disk failures
- 🔧 **Recovery validation**: Confirm auto-healing, failover, retry logic
- 📊 **Metrics capture**: Before/after performance comparison
- ⏱️ **Recovery time measurement**: RTO/RPO validation
- 🔁 **Automated drills**: Scheduled chaos experiments
- 📝 **Lessons learned**: Document patterns from failures

---

## Commands

### Run Drill

```bash
drill-commander run --scenario network-partition --severity medium --staging-cluster prod-staging
```

### Scenario Library

```bash
drill-commander scenarios --list --category availability
```

### Schedule Drill

```bash
drill-commander schedule --scenario disk-full --frequency weekly --time sunday-02:00
```

### Generate Report

```bash
drill-commander report --drill-id drill-abc123 --format html --output drill-report.html
```

### Validate Recovery

```bash
drill-commander recovery --verify --threshold-error-rate 1%
```

---

## Exit Codes

- `0` - Drill completed successfully ✅
- `1` - Drill failed or recovery did not complete ✖️
- `2` - Warning: metrics insufficient ⚠️
- `3` - Unable to inject failure ❌

---

## Output Format

```json
{
  "drill_id": "drill-abc123",
  "scenario": "network-partition",
  "severity": "medium",
  "status": "completed|failed|in-progress",
  "injection": {
    "type": "network_latency",
    "target": "aws_load_balancer",
    "value": "500ms",
    "duration_minutes": 5
  },
  "recovery": {
    "initiated_at": "2026-04-XXTXX:XX:Z",
    "completed_at": "2026-04-XXTXX:XX:Z",
    "rto_minutes": 3.5,
    "target_rto_minutes": 5
  },
  "metrics": {
    "errors_before": 0,
    "errors_after": 12,
    "latency_p99_before_ms": 45,
    "latency_p99_during_ms": 550,
    "recovered_at": "2026-04-XXTXX:XX:Z"
  },
  "conclusions": []
}
```

---

## Example Usage

```bash
# Pre-release drill
drill-commander run --scenario pod-crash --severity high --staging-cluster staging

# Schedule monthly drills
drill-commander schedule --scenario cpu-saturation --frequency monthly

# Generate resilience report
drill-commander report --drills ./drills/*.json --output resilience-report.md
```

---

## Configuration

```yaml
# .drill-commander.yaml
severity_levels:
  - low
  - medium
  - high
  - critical
max_concurrent_drills: 3
drill_timeout_minutes: 30
recovery_validation:
  enabled: true
  error_rate_threshold: 1%
  latency_threshold_ms: 500
scenarios:
  - network_partition
  - disk_full
  - cpu_saturation
  - pod_crash
  - database_failover
```

---

## Notes

- Integrates with Chaos Mesh, LitmusChaos
- Requires staging/development clusters
- Does NOT run against production
- Supports custom failure injection scripts
- Stores drill history for trend analysis
