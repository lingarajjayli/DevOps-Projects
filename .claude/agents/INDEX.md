# DevOps Agents Index

Complete suite of 15 specialized agents for DevOps automation and infrastructure management.

---

## 📚 Agents Overview

| Agent | Purpose | Status |
|-------|---------|--------|
| `infra-validator` | Validates Terraform/Helmfile configs | ✅ |
| `pipeline-checker` | Monitors CI/CD pipelines | ✅ |
| `resource-cost-analyzer` | Identifies cost inefficiencies | ✅ |
| `security-scanner` | SAST/DAST for IaC files | ✅ |
| `terraform-planner` | Optimizes Terraform state | ✅ |
| `k8s-deploy-helper` | Kubernetes manifest validation | ✅ |
| `drill-commander` | Chaos engineering orchestration | ✅ |
| `release-manager` | Multi-env deployment coordination | ✅ |
| `compliance-auditor` | Policy/standard validation | ✅ |
| `incident-escalator` | SLO monitoring & auto-escalation | ✅ |
| `e2e-test-generator` | Auto-generate e2e tests | ✅ |
| `integration-test-runner` | Parallel test execution | ✅ |
| `perf-test-engine` | Load testing & performance | ✅ |
| `architect-docs-builder` | Diagrams & documentation | ✅ |
| `ops-playbook-writer` | Runbook & SOP generation | ✅ |

---

## 🎯 Quick Start

```bash
# All agents share similar CLI patterns
agent-name action --config .config.yaml --output output.json
```

## 📖 Detailed Documentation

Each agent includes:
- Purpose and capabilities
- CLI commands and examples
- Exit codes and output formats
- Configuration options
- Integration notes

---

## 🔗 Agent Groupings

### Infrastructure Management
- `infra-validator`
- `terraform-planner`
- `security-scanner`

### CI/CD Optimization
- `pipeline-checker`
- `release-manager`

### Cost & Compliance
- `resource-cost-analyzer`
- `compliance-auditor`

### Testing
- `e2e-test-generator`
- `integration-test-runner`
- `perf-test-engine`

### Kubernetes
- `k8s-deploy-helper`

### Chaos Engineering
- `drill-commander`

### Observability
- `incident-escalator`

### Documentation
- `architect-docs-builder`
- `ops-playbook-writer`

---

## 📊 Next Steps

1. **Select which agents** to implement first
2. **Define requirements** for each (language, framework)
3. **Create shell scripts** to run each agent
4. **Build CI/CD integrations**
5. **Configure monitoring**

---

## 📝 Notes

- All agents documented in Markdown
- Ready for shell script implementation
- Can be expanded with additional features
- Supports customization per team needs
