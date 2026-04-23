# integration-test-runner

## Description

Spins up isolated test environments. Runs parallel test suites. Generates coverage reports.

---

## Purpose

Automate integration testing across services. Ensure component interactions work correctly in isolated environments. Support CI/CD integration with parallel execution.

---

## Capabilities

- 🖥️ **Environment provisioning**: Docker, Kubernetes, ephemeral VMs
- 🔄 **Test isolation**: Fresh environments per test run
- 🚀 **Parallel execution**: Distribute test suites across machines
- 📊 **Coverage reports**: JaCoCo, Istanbul, Codecov
- 📝 **Artifacts**: Screenshots, logs, recordings
- ⏱️ **Timeout management**: Prevent CI queue jams

---

## Commands

### Run All Tests

```bash
integration-test-runner run --suite ./tests/ --env staging --parallel 4
```

### Spin Up Environment

```bash
integration-test-runner spin --env test-env-1 --config ./envs/test.yaml
```

### Tear Down

```bash
integration-test-runner tear-down --env test-env-1 --timeout 300
```

### Coverage Report

```bash
integration-test-runner coverage --suites ./tests/ --output coverage-report.html
```

### Generate Artifacts

```bash
integration-test-runner artifacts --suite ./tests/ --output ./artifacts/ --screenshots true
```

### Parallel Distribution

```bash
integration-test-runner parallel --workers 8 --envs ./envs/*.yaml --output ./results/
```

---

## Exit Codes

- `0` - Tests passed ✅
- `1` - Tests failed ✖️
- `2` - Coverage below threshold ⚠️
- `3` - Environment setup error ❌

---

## Output Format

```json
{
  "run_id": "run-abc123",
  "suite": "./tests",
  "env": "staging",
  "parallel_workers": 4,
  "results": {
    "total": 1250,
    "passed": 1230,
    "failed": 15,
    "skipped": 5,
    "duration_seconds": 420,
    "coverage": {
      "lines": 85,
      "functions": 72,
      "branches": 68,
      "statements": 84
    },
    "artifacts": {
      "screenshots": "./artifacts/screenshots/",
      "videos": "./artifacts/videos/",
      "logs": "./artifacts/logs/"
    },
    "artifacts_generated": {
      "screenshots_count": 12,
      "videos_count": 2
    }
  },
  "envs_used": [
    "test-env-1",
    "test-env-2"
  ]
}
```

---

## Example Usage

```bash
# Full CI workflow
integration-test-runner spin --env test-env-1 --config ./envs/test.yaml
integration-test-runner run --suite ./tests/ --env test-env-1 --parallel 8
integration-test-runner coverage --suites ./tests/ --output coverage.json
integration-test-runner artifacts --suite ./tests/ --screenshots true
integration-test-runner tear-down --env test-env-1
```

---

## Configuration

```yaml
# .integration-test-runner.yaml
test_suite:
  - path: ./tests/unit
    parallel: 4
  - path: ./tests/e2e
    parallel: 2
environment:
  provisioner: docker-compose|kubernetes|terraform
  cleanup:
    enabled: true
    timeout_minutes: 30
  parallel_workers: 8
coverage:
  enabled: true
  min_coverage_lines: 80
  output_format: cobertura|html
artifacts:
  screenshots:
    enabled: true
    on_failure: true
    on_always: false
  logs:
    enabled: true
    keep: 7200  # 2 hours
  recordings:
    enabled: false
```

---

## Notes

- Supports Kubernetes ephemeral environments
- Integrates with Jenkins, GitHub Actions, GitLab CI
- Distributes tests across multiple nodes
- Generates coverage reports for PRs
- Auto-cleanup of test environments
