# perf-test-engine

## Description

Configures k6/Locust load tests. Simulates production traffic patterns. Correlates results with infrastructure changes.

---

## Purpose

Validate system performance under load. Identify bottlenecks before they impact users. Generate performance baselines and SLAs.

---

## Capabilities

- 🚀 **Load testing**: k6, Locust, Gatling, JMeter
- 📊 **Metrics correlation**: Link load test results with infra changes
- 🔄 **Baseline tracking**: Compare performance over time
- 🎯 **Synthetic monitoring**: Simulate user journeys from various locations
- 🌍 **Geo distribution**: Test from multiple global regions
- 📈 **Trend analysis**: Performance degradation detection

---

## Commands

### Create Test

```bash
perf-test-engine create --scenario checkout-flow --rps 1000 --duration 30m --output ./test.js
```

### Run Load Test

```bash
perf-test-engine run --scenario checkout-flow --users 500 --rps 1000 --duration 30m
```

### Baseline Comparison

```bash
perf-test-engine baseline --test ./test.js --baseline ./baselines/checkout-flow-v1.json
```

### Synthetic Monitor

```bash
perf-test-engine synthetic --endpoint /api/health --interval 5m --locations us-east-1,eu-west-1
```

### Generate Report

```bash
perf-test-engine report --test ./test.js --format html --output perf-report.html
```

---

## Exit Codes

- `0` - Test completed ✅
- `1` - Performance SLO failed ❌
- `2` - Warning: performance degradation ⚠️
- `3` - Test error ❌

---

## Output Format

```json
{
  "test_id": "test-abc123",
  "scenario": "checkout-flow",
  "config": {
    "users": 500,
    "rps": 1000,
    "duration_minutes": 30,
    "locations": ["us-east-1", "eu-west-1"]
  },
  "results": {
    "success_rate": 0.998,
    "latency_p50_ms": 45,
    "latency_p95_ms": 120,
    "latency_p99_ms": 250,
    "errors": 15,
    "throughput_rps": 987,
    "infrastructure": {
      "instance_type": "t3.large",
      "cpu_utilization_avg": 45,
      "memory_utilization_avg": 60,
      "network_io_mbps": 150
    }
  },
  "baseline_comparison": {
    "previous_latency_p99_ms": 300,
    "current_latency_p99_ms": 250,
    "improvement_percent": 16.7,
    "trend": "improving"
  },
  "recommendations": [
    "Consider adding caching for product list endpoint",
    "Database connection pool at 80% - consider scaling"
  ]
}
```

---

## Example Usage

```bash
# Create and run checkout flow test
perf-test-engine create --scenario checkout-flow --rps 1000 --duration 30m --output ./test.js
perf-test-engine run --test ./test.js --output ./results/

# Compare against baseline
perf-test-engine baseline --test ./test.js --baseline ./baselines/checkout-flow-v1.json

# Generate performance report
perf-test-engine report --test ./test.js --output perf-report.html
```

---

## Configuration

```yaml
# .perf-test-engine.yaml
test_frameworks:
  - k6
  - locust
  - gatling
synthetic_locations:
  - region: us-east-1
    provider: browser
  - region: eu-west-1
    provider: browser
  - region: ap-south-1
    provider: browser
performance_slos:
  - endpoint: /api/checkout
    latency_p99_ms: 500
    success_rate: 0.999
  - endpoint: /api/products
    latency_p95_ms: 100
    success_rate: 1.0
load_test_config:
  ramp_up_seconds: 30
  duration_minutes: 30
  users: 500
  think_time_seconds: 5
correlation:
  enabled: true
  track_infra_changes: true
  output_file: ./perf-correlation.json
```

---

## Notes

- Integrates with Grafana, Datadog, Prometheus
- Supports k6, Locust, Gatling test scripts
- Correlates with Terraform changes
- Maintains performance baselines per release
- Auto-generates SLA violation reports
