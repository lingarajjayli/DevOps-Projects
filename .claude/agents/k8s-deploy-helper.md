# k8s-deploy-helper

## Description

Validates Kubernetes manifests, generates rollout plans with rollback strategies, verifies resource quotas, limits, and security contexts.

---

## Purpose

Ensure Kubernetes deployments are safe, compliant, and follow best practices. Prevent crashes, resource starvation, and security issues before deployment.

---

## Capabilities

- ✅ **Manifest validation**: kubeval, kubectl dry-run, CRD checks
- 📊 **Resource analysis**: CPU/memory limits, pod topology
- 🔐 **Security validation**: RBAC, NetworkPolicies, securityContext
- 🔄 **Rollout planning**: Canary, blue-green, strategy validation
- 📏 **Quota validation**: Namespace resource limits
- 🎯 **Helmfile integration**: Chart validation, value schema checking

---

## Commands

### Validate Manifests

```bash
k8s-deploy-helper validate --path ./manifests/ --format json
```

### Resource Check

```bash
k8s-deploy-helper resources --path ./manifests/ --min-cpu 100m --min-memory 128Mi
```

### Security Scan

```bash
k8s-deploy-helper security --check-scc --check-rbac --check-secrets
```

### Generate Rollout Plan

```bash
k8s-deploy-helper rollout --strategy canary --percentage 10 --max-burst 5
```

### Rollback Strategy

```bash
k8s-deploy-helper rollback --version-history 5 --point-in-time restore
```

---

## Exit Codes

- `0` - All checks passed ✅
- `1` - Critical issues found ❌
- `2` - Warnings only ⚠️
- `3` - Validation error ❌

---

## Output Format

```json
{
  "validation_time": "2026-04-XXTXX:XX:Z",
  "namespace": "default",
  "status": "valid|invalid",
  "resources": {
    "pods": 15,
    "deployments": 8,
    "services": 6
  },
  "issues": [
    {
      "resource": "deployment/frontend",
      "field": "spec.template.spec.containers[0].resources.limits.cpu",
      "value": "100m",
      "recommended": "500m",
      "reason": "Below minimum threshold for stability",
      "severity": "warning"
    }
  ],
  "security": {
    "rbac_valid": true,
    "secrets_encrypted": true,
    "privileged_containers": 0
  },
  "rollout_plan": {
    "strategy": "canary",
    "stages": [
      { "percentage": 5, "duration_minutes": 10 },
      { "percentage": 25, "duration_minutes": 10 },
      { "percentage": 100, "duration_minutes": null }
    ],
    "rollback_trigger": "error_rate > 1% or latency_p99 > 2s"
  }
}
```

---

## Example Usage

```bash
# Pre-deploy validation
k8s-deploy-helper validate --path ./k8s/ --strict

# Generate rollout plan
k8s-deploy-helper rollout --strategy blue-green --cluster prod-cluster

# Security compliance check
k8s-deploy-helper security --check-cis-kubernetes-benchmark
```

---

## Configuration

```yaml
# .k8s-deploy-helper.yaml
min_cpu: 100m
min_memory: 128Mi
max_replicas_per_ns: 50
security:
  - check_secrets: true
  - check_rbac: true
  - check_seccomp: true
rollout:
  - canary
  - blue-green
  - rolling
max_burst: 5
rollback_threshold:
  - error_rate: 1%
  - latency_p99: 2s
```

---

## Notes

- Works with Helmfile, Kustomize
- Integrates with Argo Rollouts, Flagger
- Supports multiple clusters
- Generates step-by-step deployment scripts
