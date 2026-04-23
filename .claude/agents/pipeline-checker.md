# pipeline-checker

## Description

Monitors GitHub Actions pipelines for failures, slow jobs, or resource issues. Suggests optimizations and alerts on recurring problems.

---

## Purpose

Detect pipeline performance degradation, flaky tests, and resource waste. Help maintain fast, reliable CI/CD workflows.

---

## Capabilities

- ⏱️ **Timing analysis**: Track job durations, identify slow steps
- ❌ **Failure detection**: Find flaky tests, timeout-prone jobs
- 📊 **Resource monitoring**: Detect excessive CPU/memory usage
- 🐛 **Error correlation**: Group related failures by pattern
- 🔧 **Optimization suggestions**: Parallelize jobs, cache improvements
- 🔔 **Alerting**: Slack/email notifications for critical issues

---

## Commands

### Analyze Pipeline

```bash
pipeline-checker analyze --repo ./ --github-token GITHUB_TOKEN
```

### Check for Flaky Tests

```bash
pipeline-checker flaky --recent-runs 10 --timeout 300
```

### Performance Report

```bash
pipeline-checker report --format json --output perf-report.json
```

### Alert Config

```bash
pipeline-checker alert --channel slack --webhook-url SLACK_WEBHOOK
```

---

## Exit Codes

- `0` - Pipeline healthy ✅
- `1` - Issues found ✖️
- `2` - Warnings only ⚠️
- `3` - Unable to fetch pipeline data ❌

---

## Output Format

```json
{
  "repo": "owner/repo",
  "last_run": "2026-04-XXTXX:XX:Z",
  "status": "healthy|degraded|critical",
  "metrics": {
    "avg_duration_minutes": 12.5,
    "p95_duration_minutes": 15.2,
    "failure_rate": 0.02,
    "flaky_tests": 2
  },
  "issues": [
    {
      "type": "timeout|memory|failure",
      "job": "e2e-tests",
      "frequency": 5,
      "suggestion": "Increase timeout or parallelize steps"
    }
  ],
  "recommendations": []
}
```

---

## Example Usage

```bash
# Check pipeline health
pipeline-checker analyze --github-token $GITHUB_TOKEN

# Find flaky tests
pipeline-checker flaky --recent-runs 20

# Generate optimization report
pipeline-checker optimize --suggest-caching --suggest-parallelization
```

---

## Configuration

```yaml
# .pipeline-checker.yaml
check_interval: 300  # 5 minutes
alert_on_failure: true
alert_on_slow_job: 15  # minutes
cache_enabled: true
cache_ttl: 3600
```

---

## Notes

- Works with GitHub Actions, GitLab CI, Jenkins
- Supports multiple branches/tags
- Archives historical performance data
- Integrates with monitoring tools (Prometheus, DataDog)
