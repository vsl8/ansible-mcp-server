# Graph Report - .  (2026-06-29)

## Corpus Check
- Corpus is ~27,685 words - fits in a single context window. You may not need a graph.

## Summary
- 149 nodes · 333 edges · 19 communities (16 shown, 3 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 6 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Core Server Infrastructure|Core Server Infrastructure]]
- [[_COMMUNITY_Project Documentation|Project Documentation]]
- [[_COMMUNITY_Graphify Knowledge Graph|Graphify Knowledge Graph]]
- [[_COMMUNITY_Inventory and Vault|Inventory and Vault]]
- [[_COMMUNITY_Galaxy and Bootstrap|Galaxy and Bootstrap]]
- [[_COMMUNITY_Troubleshooting Suite|Troubleshooting Suite]]
- [[_COMMUNITY_Health and Task Execution|Health and Task Execution]]
- [[_COMMUNITY_Inventory Management|Inventory Management]]
- [[_COMMUNITY_Playbook Execution|Playbook Execution]]
- [[_COMMUNITY_State Comparison|State Comparison]]
- [[_COMMUNITY_Log Analysis|Log Analysis]]
- [[_COMMUNITY_Transport Tests|Transport Tests]]
- [[_COMMUNITY_Log Fetching|Log Fetching]]
- [[_COMMUNITY_Host Diagnostics|Host Diagnostics]]
- [[_COMMUNITY_Remote Command Execution|Remote Command Execution]]
- [[_COMMUNITY_Fact Gathering|Fact Gathering]]
- [[_COMMUNITY_Package Init|Package Init]]
- [[_COMMUNITY_Remote Setup Script|Remote Setup Script]]
- [[_COMMUNITY_Package Metadata|Package Metadata]]

## God Nodes (most connected - your core abstractions)
1. `_compose_ansible_env()` - 23 edges
2. `ansible_task()` - 19 edges
3. `_run_command()` - 13 edges
4. `_load_config()` - 9 edges
5. `inventory_parse()` - 9 edges
6. `_run_vault_cmd()` - 9 edges
7. `/graphify Skill` - 9 edges
8. `galaxy_install()` - 8 edges
9. `project_run_playbook()` - 8 edges
10. `ansible_playbook()` - 8 edges

## Surprising Connections (you probably didn't know these)
- `Copilot Instructions for Ansible MCP Server` --semantically_similar_to--> `Claude Repository Guidance`  [INFERRED] [semantically similar]
  .github/copilot-instructions.md → CLAUDE.md
- `Troubleshooting Suite` --semantically_similar_to--> `Health Scoring Algorithm`  [INFERRED] [semantically similar]
  README.md → .github/skills/SKILLS.md
- `Ansible MCP Server Project Summary` --semantically_similar_to--> `Ansible MCP Server README`  [INFERRED] [semantically similar]
  Docs/project_summary.md → README.md
- `SSE Transport` --conceptually_related_to--> `Post-Commit Graph Rebuild Hook`  [INFERRED]
  README.md → .copilot/skills/graphify/references/hooks.md
- `Claude Repository Guidance` --references--> `uv Package Manager`  [EXTRACTED]
  CLAUDE.md → README.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Graphify Extraction Flow** — graphify_skill_structural_extraction, graphify_skill_semantic_extraction, references_extraction_spec_extraction_subagent_prompt, references_transcribe_video_transcription, references_update_incremental_update_pipeline, graphify_skill_graph_health_check [EXTRACTED 1.00]
- **Ansible MCP Documentation Set** — _github_copilot_instructions_ansible_mcp_server, skills_skills_ansible_mcp_server, claude_repository_guidance, docs_project_summary_ansible_mcp_server, readme_ansible_mcp_server [INFERRED 0.85]
- **Ansible MCP Transport Modes** — readme_model_context_protocol, readme_stdio_transport, readme_sse_transport [EXTRACTED 1.00]

## Communities (19 total, 3 thin omitted)

### Community 0 - "Core Server Infrastructure"
Cohesion: 0.15
Nodes (30): _config_path(), create_playbook(), create_role_structure(), _discover_playbooks(), _ensure_directory(), list_projects(), _load_config(), _project_env() (+22 more)

### Community 1 - "Project Documentation"
Cohesion: 0.30
Nodes (14): Copilot Instructions for Ansible MCP Server, Tool Definition Pattern, Claude Repository Guidance, Ansible MCP Server Project Summary, Ansible MCP Server README, bsahane/mcp-ansible, FastMCP Framework, Model Context Protocol (+6 more)

### Community 2 - "Graphify Knowledge Graph"
Cohesion: 0.19
Nodes (13): Existing Graph Fast Path, Graph Health Check, /graphify Skill, Semantic Extraction, Structural Extraction, Watch Mode, Graph Export Targets, Extraction Subagent Prompt (+5 more)

### Community 3 - "Inventory and Vault"
Cohesion: 0.29
Nodes (10): ansible_inventory(), _extract_hosts_from_inventory_json(), List Ansible inventory hosts and groups using the ansible-inventory CLI.      Ar, Validate YAML files; return parse errors with line/column if any., _run_vault_cmd(), validate_yaml(), vault_decrypt(), vault_encrypt() (+2 more)

### Community 4 - "Galaxy and Bootstrap"
Cohesion: 0.22
Nodes (10): _exists(), galaxy_install(), galaxy_lock(), project_bootstrap(), Install roles and collections from requirements files under the project root., Bootstrap a project: install galaxy deps and report Ansible environment details., Create a simple lock file for installed roles/collections under the project root, Validate playbook syntax using ansible-playbook --syntax-check.      Args: (+2 more)

### Community 5 - "Troubleshooting Suite"
Cohesion: 0.22
Nodes (9): ansible_auto_heal(), ansible_network_matrix(), ansible_security_audit(), ansible_service_manager(), _compose_ansible_env(), Manage services with status checking and log correlation.          Args:, Intelligent automated problem resolution with safety checks.          Args:, Comprehensive network connectivity matrix between hosts.          Args: (+1 more)

### Community 6 - "Health and Task Execution"
Cohesion: 0.22
Nodes (9): ansible_health_monitor(), ansible_performance_baseline(), ansible_ping(), ansible_task(), _dict_to_module_args(), Continuous health monitoring with trend analysis.          Args:         host_pa, Establish performance baselines and detect regressions.          Args:         h, Ping hosts using the Ansible ad-hoc ping module. (+1 more)

### Community 7 - "Inventory Management"
Cohesion: 0.22
Nodes (9): _inventory_cli(), inventory_diff(), inventory_find_host(), inventory_graph(), inventory_parse(), Parse inventory via ansible-inventory, merging group_vars/host_vars.      Args:, Return ansible-inventory --graph output using discovered config., Find a host, its groups, and merged variables across the resolved inventories. (+1 more)

### Community 8 - "Playbook Execution"
Cohesion: 0.25
Nodes (8): ansible_playbook(), ansible_role(), ansible_test_idempotence(), _parse_play_recap(), Run a playbook twice and ensure no changes on the second run. Returns recap and, Run an Ansible playbook.      Args:         playbook_path: Path to the playbook, Execute an Ansible role by generating a temporary playbook.      Args:         r, _sum_changed()

### Community 9 - "State Comparison"
Cohesion: 0.33
Nodes (6): ansible_capture_baseline(), ansible_compare_states(), _generate_snapshot_id(), Generate a unique snapshot ID., Capture comprehensive system state baseline for later comparison.          Args:, Compare current system state against a previously captured baseline.          Ar

### Community 10 - "Log Analysis"
Cohesion: 0.40
Nodes (5): ansible_log_hunter(), _extract_timestamp_from_log(), Advanced log hunting and correlation across multiple sources.          Args:, Extract timestamp from log line (simplified implementation)., datetime

### Community 11 - "Transport Tests"
Cohesion: 0.60
Nodes (4): main(), Test stdio transport (basic startup test), test_sse(), test_stdio()

### Community 12 - "Log Fetching"
Cohesion: 0.50
Nodes (4): _analyze_log_patterns(), ansible_fetch_logs(), Analyze log content for patterns and anomalies., Fetch and analyze log files from remote hosts.          Args:         host_patte

### Community 13 - "Host Diagnostics"
Cohesion: 0.50
Nodes (4): ansible_diagnose_host(), _calculate_health_score(), Calculate a health score based on system metrics., Comprehensive health assessment of target hosts.          Args:         host_pat

### Community 14 - "Remote Command Execution"
Cohesion: 0.50
Nodes (4): ansible_remote_command(), _parse_json_output(), Parse JSON output from Ansible modules that return structured data., Execute arbitrary shell commands on remote hosts with enhanced output parsing.

### Community 15 - "Fact Gathering"
Cohesion: 0.67
Nodes (3): ansible_gather_facts(), _parse_setup_stdout(), Gather facts using the setup module and return parsed per-host facts.

## Knowledge Gaps
- **7 isolated node(s):** `ansible-mcp`, `setup-remote.sh script`, `Structural Extraction`, `Graph Health Check`, `Graph Export Targets` (+2 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `_compose_ansible_env()` connect `Troubleshooting Suite` to `Core Server Infrastructure`, `Inventory and Vault`, `Galaxy and Bootstrap`, `Health and Task Execution`, `Inventory Management`, `Playbook Execution`, `State Comparison`, `Log Analysis`, `Log Fetching`, `Host Diagnostics`, `Remote Command Execution`, `Fact Gathering`?**
  _High betweenness centrality (0.022) - this node is a cross-community bridge._
- **Why does `ansible_task()` connect `Health and Task Execution` to `Core Server Infrastructure`, `Inventory and Vault`, `Galaxy and Bootstrap`, `Troubleshooting Suite`, `State Comparison`, `Log Analysis`, `Log Fetching`, `Host Diagnostics`, `Remote Command Execution`, `Fact Gathering`?**
  _High betweenness centrality (0.021) - this node is a cross-community bridge._
- **What connects `ansible-mcp`, `setup-remote.sh script`, `Ansible MCP Server - Advanced Ansible Model Context Protocol server.` to the rest of the system?**
  _51 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Core Server Infrastructure` be split into smaller, more focused modules?**
  _Cohesion score 0.14623655913978495 - nodes in this community are weakly interconnected._