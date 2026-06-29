# Graph Report - .  (2026-06-29)

## Corpus Check
- 3 files · ~31,216 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 176 nodes · 381 edges · 11 communities (8 shown, 3 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 16 edges (avg confidence: 0.89)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_MCP Transport Modes|MCP Transport Modes]]
- [[_COMMUNITY_Ansible Integration|Ansible Integration]]
- [[_COMMUNITY_Configuration & Setup|Configuration & Setup]]
- [[_COMMUNITY_Docker & Deployment|Docker & Deployment]]
- [[_COMMUNITY_MCP Transport Modes|MCP Transport Modes]]
- [[_COMMUNITY_Health & Monitoring|Health & Monitoring]]
- [[_COMMUNITY_Ansible Integration|Ansible Integration]]
- [[_COMMUNITY_MCP Transport Modes|MCP Transport Modes]]
- [[_COMMUNITY_Ansible Integration|Ansible Integration]]
- [[_COMMUNITY_Configuration & Setup|Configuration & Setup]]
- [[_COMMUNITY_Ansible Integration|Ansible Integration]]

## God Nodes (most connected - your core abstractions)
1. `_compose_ansible_env()` - 23 edges
2. `ansible_task()` - 19 edges
3. `_run_command()` - 13 edges
4. `ansible-mcp-sse` - 11 edges
5. `_load_config()` - 9 edges
6. `inventory_parse()` - 9 edges
7. `_run_vault_cmd()` - 9 edges
8. `/graphify Skill` - 9 edges
9. `ansible-mcp-stdio` - 9 edges
10. `galaxy_install()` - 8 edges

## Surprising Connections (you probably didn't know these)
- `Copilot Instructions for Ansible MCP Server` --semantically_similar_to--> `Claude Repository Guidance`  [INFERRED] [semantically similar]
  .github/copilot-instructions.md → CLAUDE.md
- `Environment Variables Reference` --semantically_similar_to--> `Docker Environment Variables`  [INFERRED] [semantically similar]
  Docs/project_summary.md → docs/DOCKER.md
- `Nginx Reverse Proxy` --semantically_similar_to--> `Production Considerations`  [INFERRED] [semantically similar]
  Docs/project_summary.md → docs/DOCKER.md
- `Troubleshooting Suite` --semantically_similar_to--> `Health Scoring Algorithm`  [INFERRED] [semantically similar]
  README.md → .github/skills/SKILLS.md
- `stdio Transport` --semantically_similar_to--> `Stdio Mode`  [INFERRED] [semantically similar]
  Docs/project_summary.md → docs/DOCKER.md

## Import Cycles
- None detected.

## Communities (11 total, 3 thin omitted)

### Community 0 - "MCP Transport Modes"
Cohesion: 0.08
Nodes (42): _analyze_log_patterns(), ansible_auto_heal(), ansible_capture_baseline(), ansible_compare_states(), ansible_diagnose_host(), ansible_fetch_logs(), ansible_gather_facts(), ansible_health_monitor() (+34 more)

### Community 1 - "Ansible Integration"
Cohesion: 0.10
Nodes (35): ansible_inventory(), ansible_playbook(), ansible_test_idempotence(), _extract_hosts_from_inventory_json(), _extract_timestamp_from_log(), galaxy_lock(), _inventory_cli(), inventory_diff() (+27 more)

### Community 2 - "Configuration & Setup"
Cohesion: 0.11
Nodes (29): _config_path(), create_role_structure(), _discover_playbooks(), _ensure_directory(), _exists(), galaxy_install(), list_projects(), _load_config() (+21 more)

### Community 3 - "Docker & Deployment"
Cohesion: 0.14
Nodes (27): ansible-control, ansible-mcp-sse, ansible-mcp-stdio, ansible-network, /workspace Mount, ANSIBLE_CONFIG_DIR, Docker Configuration, Docker Compose Services (+19 more)

### Community 4 - "MCP Transport Modes"
Cohesion: 0.27
Nodes (13): Copilot Instructions for Ansible MCP Server, Tool Definition Pattern, Claude Repository Guidance, Ansible MCP Server README, bsahane/mcp-ansible, FastMCP Framework, Model Context Protocol, SSE Transport (+5 more)

### Community 5 - "Health & Monitoring"
Cohesion: 0.19
Nodes (13): Existing Graph Fast Path, Graph Health Check, /graphify Skill, Semantic Extraction, Structural Extraction, Watch Mode, Graph Export Targets, Extraction Subagent Prompt (+5 more)

### Community 6 - "Ansible Integration"
Cohesion: 0.40
Nodes (5): ansible_role(), create_playbook(), Create an Ansible playbook from YAML string or object.      Args:         playbo, Execute an Ansible role by generating a temporary playbook.      Args:         r, _serialize_playbook()

### Community 7 - "MCP Transport Modes"
Cohesion: 0.60
Nodes (4): main(), Test stdio transport (basic startup test), test_sse(), test_stdio()

## Knowledge Gaps
- **9 isolated node(s):** `ansible-mcp`, `setup-remote.sh script`, `Structural Extraction`, `Graph Health Check`, `Graph Export Targets` (+4 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `_compose_ansible_env()` connect `MCP Transport Modes` to `Ansible Integration`, `Configuration & Setup`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **Why does `ansible_task()` connect `MCP Transport Modes` to `Ansible Integration`, `Configuration & Setup`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **What connects `ansible-mcp`, `setup-remote.sh script`, `Ansible MCP Server - Advanced Ansible Model Context Protocol server.` to the rest of the system?**
  _53 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `MCP Transport Modes` be split into smaller, more focused modules?**
  _Cohesion score 0.08478513356562137 - nodes in this community are weakly interconnected._
- **Should `Ansible Integration` be split into smaller, more focused modules?**
  _Cohesion score 0.09523809523809523 - nodes in this community are weakly interconnected._
- **Should `Configuration & Setup` be split into smaller, more focused modules?**
  _Cohesion score 0.11330049261083744 - nodes in this community are weakly interconnected._
- **Should `Docker & Deployment` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._