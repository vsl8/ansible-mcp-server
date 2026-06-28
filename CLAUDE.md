# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
uv sync                          # production
uv sync --all-extras             # with dev tools

# Run server
uv run python src/ansible_mcp/server.py                                          # stdio (local)
uv run python src/ansible_mcp/server.py --transport sse --host 0.0.0.0 --port 8000  # SSE (remote)

# Test with MCP inspector
npx @modelcontextprotocol/inspector uv run python src/ansible_mcp/server.py

# Lint / type check
uv run ruff check src/
uv run ruff check --fix src/
uv run ruff format src/
uv run mypy src/

# Tests (no tests exist yet; when added)
uv run pytest
uv run pytest tests/test_file.py::test_name
```

## Architecture

All 38 MCP tools live in a single file: `src/ansible_mcp/server.py` (~2,300 lines). Do not split into modules unless explicitly asked.

### Key helpers
- `_run_command(cmd, cwd, env)` — safe subprocess; never use `shell=True`
- `_compose_ansible_env(ansible_cfg_path, project_root, extra_env)` — builds Ansible env + cwd
- `_inventory_cli(inventory_paths)` — generates `-i` CLI args
- `_calculate_health_score(metrics)` — 100-point health scoring

### Config
- File: `~/.config/mcp-ansible/config.json` or `mcp_ansible.config.json` in project root
- Env vars: `MCP_ANSIBLE_PROJECT_ROOT`, `MCP_ANSIBLE_INVENTORY`, `MCP_ANSIBLE_PROJECT_NAME`, `MCP_ANSIBLE_ROLES_PATH`, `MCP_ANSIBLE_COLLECTIONS_PATHS`, `MCP_ANSIBLE_ENV_<KEY>`
- `ProjectDefinition` and `ServerConfiguration` dataclasses manage multi-project config

### Tool request flow
1. Tool receives params → `_compose_ansible_env()` → build `cmd` list → `_run_command()` → return dict

### Tool categories
1. **Core Ansible (17)**: create-playbook, ansible-playbook, ansible-task, ansible-role, ansible-inventory, register-project, ansible-ping, galaxy-*, etc.
2. **Inventory Management (6)**: inventory-parse, inventory-graph, inventory-find-host, inventory-diff, ansible-test-idempotence, vault-*
3. **Troubleshooting Suite (13)**: ansible-diagnose-host, ansible-auto-heal, ansible-network-matrix, ansible-security-audit, ansible-health-monitor, ansible-log-hunter, etc.

## Code Conventions

### New tool pattern
```python
@mcp.tool(name="kebab-case-name")
def tool_name(
    required_param: str,
    optional_param: Optional[int] = None,
    project_root: Optional[str] = None,
    ansible_cfg_path: Optional[str] = None,
    inventory_paths: Optional[List[str]] = None,
) -> dict[str, Any]:
    """Concise description for LLMs."""
    env, cwd = _compose_ansible_env(ansible_cfg_path, project_root, None)
    inventory_args = _inventory_cli(inventory_paths)
    cmd = ["ansible", required_param] + inventory_args
    rc, stdout, stderr = _run_command(cmd, cwd=cwd, env=env)
    return {"ok": rc == 0, "rc": rc, "stdout": stdout, "stderr": stderr, "command": shlex.join(cmd)}
```

### Rules
- **Never print to stdout** — breaks MCP protocol; use `print(..., file=sys.stderr)`
- **Never use `shell=True`** in subprocess calls
- **Never raise exceptions** from tool functions — return `{"ok": False, "error": "..."}`
- Use `uv` for all package management (never pip, never `requirements.txt`)
- Quote user input with `shlex.quote()`; build commands as lists, not strings
- Use `Path(...).expanduser().resolve()` for all path handling
- Tool names are kebab-case; Python functions are snake_case
- All responses must be JSON-serializable dicts with an `"ok"` field

### When adding a new tool
1. Follow the tool definition pattern above
2. Add to `.github/skills/SKILLS.md` under the appropriate category
3. Add to README.md tool list and update the count
