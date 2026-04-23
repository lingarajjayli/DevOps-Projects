# release-manager

## Description

Coordinates multi-environment deployments. Manages feature flags, canary rollouts, and generates release notes from commit history.

---

## Purpose

Orchestrate safe, controlled releases across dev → staging → production. Automate deployment steps, manage feature flags, and provide rollback capabilities.

---

## Capabilities

- 🔄 **Multi-environment**: Staging → Prod → Partner environments
- 🚩 **Feature flags**: Launch darkly, Unleash, Flagsmith integration
- 🦋 **Canary rollouts**: Gradual percentage-based deployments
- 📝 **Release notes**: Auto-generate from commits, changelogs
- ⏱️ **Scheduling**: Time releases for off-peak hours
- 📱 **Notifications**: Slack, PagerDuty, Opsgenie alerts
- 🔙 **Rollback**: One-command undo with point-in-time restore

---

## Commands

### Deploy

```bash
release-manager deploy --env production --version 2.1.0 --strategy canary --percentage 25
```

### Approve Release

```bash
release-manager approve --release-id rel-abc123 --checks all
```

### Rollback

```bash
release-manager rollback --release-id rel-abc123 --strategy point-in-time
```

### Generate Notes

```bash
release-manager notes --since last-release --format markdown --output release-notes.md
```

### Schedule Release

```bash
release-manager schedule --env production --version 2.2.0 --time tuesday-02:00 --notify 30m
```

### Release Gate

```bash
release-manager gate --conditions "staging-ok && smoke-tests-passed && budget-ok"
```

---

## Exit Codes

- `0` - Release deployed successfully ✅
- `1` - Release failed or rejected ✖️
- `2` - Warnings only ⚠️
- `3` - Deployment error ❌

---

## Output Format

```json
{
  "release_id": "rel-abc123",
  "version": "2.1.0",
  "env": "production",
  "status": "deploying|deployed|failed|rolled-back",
  "strategy": "canary|blue-green|rolling",
  "progress": {
    "envs": [
      {
        "env": "staging",
        "status": "deployed",
        "deployed_at": "2026-04-XXTXX:XX:Z",
        "verified_at": "2026-04-XXTXX:XX:Z"
      },
      {
        "env": "production",
        "status": "deploying",
        "percentage": 25,
        "deployed_at": "2026-04-XXTXX:XX:Z"
      }
    ],
    "overall_percentage": 15
  },
  "feature_flags": {
    "updated": true,
    "flags_changed": ["dark-mode", "new-checkout"]
  },
  "release_notes_url": "https://github.com/owner/repo/releases/tag/v2.1.0",
  "rollback_available": true,
  "rollback_version": "2.0.8"
}
```

---

## Example Usage

```bash
# Full release flow
release-manager deploy --env staging --version 2.1.0 --verify
release-manager gate --conditions "smoke-tests-passed && integration-tests-passed"
release-manager deploy --env production --version 2.1.0 --strategy canary --percentage 10
release-manager gate --conditions "error-rate-ok && latency-ok"
release-manager deploy --env production --version 2.1.0 --strategy canary --percentage 100
```

---

## Configuration

```yaml
# .release-manager.yaml
environments:
  - name: staging
    cluster: staging-cluster.k8s
    approval_required: false
  - name: production
    cluster: prod-cluster.k8s
    approval_required: true
    require_safety_checks: true
    canary:
      enabled: true
      stages:
        - percentage: 5
          duration_minutes: 10
        - percentage: 25
          duration_minutes: 15
        - percentage: 100
          duration_minutes: 10
feature_flags:
  provider: flagsmith
  api_key: ${FLAGS_API_KEY}
  environment: production
notifications:
  slack_webhook: ${SLACK_WEBHOOK}
  pagerduty_service_key: ${PAGERDUTY_KEY}
smoke_tests:
  - endpoint: /health
  - endpoint: /api/v1/status
budget_check:
  enabled: true
  max_deployment_cost_per_hour: $500
```

---

## Notes

- Integrates with Argo Rollouts, Flux, Spinnaker
- Supports Helmfile, Kustomize manifests
- Auto-generates release notes from commit messages
- Feature flags sync with LaunchDarkly, Unleash, Flagsmith
- Rollback uses GitOps history or image tag restore
