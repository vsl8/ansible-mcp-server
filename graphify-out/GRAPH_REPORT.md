# Graph Report - .  (2026-06-29)

## Corpus Check
- 3 files · ~32,066 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 174 nodes · 379 edges · 13 communities (10 shown, 3 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 11 edges (avg confidence: 0.9)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Core Task & CLI Tools|Core Task & CLI Tools]]
- [[_COMMUNITY_Playbook & Config Management|Playbook & Config Management]]
- [[_COMMUNITY_Command Execution & Galaxy|Command Execution & Galaxy]]
- [[_COMMUNITY_Docker & SSE Transport|Docker & SSE Transport]]
- [[_COMMUNITY_Project Documentation|Project Documentation]]
- [[_COMMUNITY_Graphify Integration|Graphify Integration]]
- [[_COMMUNITY_Inventory Management|Inventory Management]]
- [[_COMMUNITY_System Baseline & Snapshots|System Baseline & Snapshots]]
- [[_COMMUNITY_Log Analysis & Hunting|Log Analysis & Hunting]]
- [[_COMMUNITY_Transport Testing|Transport Testing]]
- [[_COMMUNITY_Module Initialization|Module Initialization]]
- [[_COMMUNITY_Remote Setup Script|Remote Setup Script]]
- [[_COMMUNITY_Project Identity|Project Identity]]

## God Nodes (most connected - your core abstractions)
1. `_compose_ansible_env()` - 23 edges
2. `ansible_task()` - 19 edges
3. `_run_command()` - 13 edges
4. `ansible-mcp-sse` - 10 edges
5. `inventory_parse()` - 10 edges
6. `/graphify Skill` - 9 edges
7. `_load_config()` - 9 edges
8. `_run_vault_cmd()` - 9 edges
9. `ansible-mcp-stdio` - 8 edges
10. `galaxy_install()` - 8 edges

## Surprising Connections (you probably didn't know these)
- `Copilot Instructions for Ansible MCP Server` --semantically_similar_to--> `Claude Repository Guidance`  [INFERRED] [semantically similar]
  .github/copilot-instructions.md → CLAUDE.md
- `Troubleshooting Suite` --semantically_similar_to--> `Health Scoring Algorithm`  [INFERRED] [semantically similar]
  README.md → .github/skills/SKILLS.md
- `SSE Transport` --conceptually_related_to--> `Post-Commit Graph Rebuild Hook`  [INFERRED]
  README.md → .copilot/skills/graphify/references/hooks.md
- `ansible-mcp-sse` --shares_data_with--> `MCP_HOST`  [INFERRED]
  docker-compose.yml → docs/DOCKER.md
- `ansible-mcp-sse` --shares_data_with--> `MCP_PORT`  [INFERRED]
  docker-compose.yml → docs/DOCKER.md

## Import Cycles
- None detected.

## Communities (13 total, 3 thin omitted)

### Community 0 - "Core Task & CLI Tools"
Cohesion: 0.09
Nodes (41): _analyze_log_patterns(), ansible_auto_heal(), ansible_diagnose_host(), ansible_fetch_logs(), ansible_gather_facts(), ansible_health_monitor(), ansible_network_matrix(), ansible_performance_baseline() (+33 more)

### Community 1 - "Playbook & Config Management"
Cohesion: 0.12
Nodes (29): ansible_playbook(), ansible_role(), ansible_test_idempotence(), _config_path(), _discover_playbooks(), list_projects(), _load_config(), _parse_play_recap() (+21 more)

### Community 2 - "Command Execution & Galaxy"
Cohesion: 0.12
Nodes (24): ansible_inventory(), create_playbook(), create_role_structure(), _ensure_directory(), _exists(), _extract_hosts_from_inventory_json(), galaxy_install(), galaxy_lock() (+16 more)

### Community 3 - "Docker & SSE Transport"
Cohesion: 0.19
Nodes (19): ansible-control, ansible-mcp-sse, ansible-mcp-stdio, ansible-network, /workspace Mount, ANSIBLE_CONFIG_DIR, Docker Configuration, Docker Compose Services (+11 more)

### Community 4 - "Project Documentation"
Cohesion: 0.27
Nodes (13): Copilot Instructions for Ansible MCP Server, Tool Definition Pattern, Claude Repository Guidance, Ansible MCP Server README, bsahane/mcp-ansible, FastMCP Framework, Model Context Protocol, SSE Transport (+5 more)

### Community 5 - "Graphify Integration"
Cohesion: 0.19
Nodes (13): Existing Graph Fast Path, Graph Health Check, /graphify Skill, Semantic Extraction, Structural Extraction, Watch Mode, Graph Export Targets, Extraction Subagent Prompt (+5 more)

### Community 6 - "Inventory Management"
Cohesion: 0.18
Nodes (12): _add_host_to_ini_inventory(), _add_host_to_yaml_inventory(), inventory_add_host(), inventory_diff(), inventory_find_host(), inventory_parse(), Parse inventory via ansible-inventory, merging group_vars/host_vars.      Args:, Find a host, its groups, and merged variables across the resolved inventories. (+4 more)

### Community 7 - "System Baseline & Snapshots"
Cohesion: 0.33
Nodes (6): ansible_capture_baseline(), ansible_compare_states(), _generate_snapshot_id(), Generate a unique snapshot ID., Capture comprehensive system state baseline for later comparison.          Args:, Compare current system state against a previously captured baseline.          Ar

### Community 8 - "Log Analysis & Hunting"
Cohesion: 0.40
Nodes (5): ansible_log_hunter(), _extract_timestamp_from_log(), Advanced log hunting and correlation across multiple sources.          Args:, Extract timestamp from log line (simplified implementation)., datetime

### Community 9 - "Transport Testing"
Cohesion: 0.60
Nodes (4): main(), Test stdio transport (basic startup test), test_sse(), test_stdio()

## Knowledge Gaps
- **9 isolated node(s):** `ansible-mcp`, `setup-remote.sh script`, `Structural Extraction`, `Graph Health Check`, `Graph Export Targets` (+4 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `_compose_ansible_env()` connect `Core Task & CLI Tools` to `Playbook & Config Management`, `Command Execution & Galaxy`, `Inventory Management`, `System Baseline & Snapshots`, `Log Analysis & Hunting`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **Why does `ansible_task()` connect `Core Task & CLI Tools` to `Log Analysis & Hunting`, `Playbook & Config Management`, `Command Execution & Galaxy`, `System Baseline & Snapshots`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **What connects `ansible-mcp`, `setup-remote.sh script`, `Ansible MCP Server - Advanced Ansible Model Context Protocol server.` to the rest of the system?**
  _56 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Core Task & CLI Tools` be split into smaller, more focused modules?**
  _Cohesion score 0.08902439024390243 - nodes in this community are weakly interconnected._
- **Should `Playbook & Config Management` be split into smaller, more focused modules?**
  _Cohesion score 0.12413793103448276 - nodes in this community are weakly interconnected._
- **Should `Command Execution & Galaxy` be split into smaller, more focused modules?**
  _Cohesion score 0.12318840579710146 - nodes in this community are weakly interconnected._