# GitHub Copilot Instructions for Ansible MCP Server

These instructions help GitHub Copilot provide better, context-aware suggestions for this project.

## Project Context

This is an **Ansible MCP Server** - a Model Context Protocol server that exposes 36 Ansible automation tools to AI assistants (VS Code, Cursor, Claude, GitHub Copilot CLI, etc.).

**Key Technologies:**
- Python 3.10+ with type hints
- FastMCP framework for MCP protocol
- uv package manager (not pip)
- Ansible Core 2.16+
- Stdio-based JSON-RPC communication

## Code Style and Conventions

### 1. Tool Definition Pattern
When creating new MCP tools, ALWAYS follow this pattern:

```python
@mcp.tool(name="tool-name")  # kebab-case
def tool_name(
    required_param: str,
    optional_param: Optional[int] = None,
    project_root: Optional[str] = None,
    ansible_cfg_path: Optional[str] = None,
    inventory_paths: Optional[List[str]] = None
) -> dict[str, Any]:
    """Clear, concise description for LLM to understand when to use this tool.
    
    Args:
        required_param: Description of what this parameter does
        optional_param: Description with default behavior
        project_root: Project root directory
        ansible_cfg_path: Ansible config file path
        inventory_paths: Inventory file paths
    
    Returns:
        Dict containing:
        - ok (bool): Success indicator
        - rc (int): Return code if applicable
        - stdout (str): Command output
        - stderr (str): Error output
        - command (str): Command executed
    """
    # Implementation
    env, cwd = _compose_ansible_env(ansible_cfg_path, project_root, None)
    cmd = ["ansible", "command"]
    rc, stdout, stderr = _run_command(cmd, cwd=cwd, env=env)
    
    return {
        "ok": rc == 0,
        "rc": rc,
        "stdout": stdout,
        "stderr": stderr,
        "command": shlex.join(cmd)
    }
```

### 2. Type Hints
- ALWAYS use type hints for all parameters and return types
- Use `Optional[T]` for nullable types (from typing)
- Use `Dict[str, Any]` for flexible dictionaries
- Use `List[str]` for string lists
- Use modern syntax: `dict[str, Any]` (Python 3.10+)

### 3. Command Execution
```python
# GOOD - Safe command execution
cmd = ["ansible-playbook", playbook_path]
if inventory:
    cmd.extend(["-i", inventory])
rc, stdout, stderr = _run_command(cmd, cwd=cwd, env=env)

# BAD - Never use shell=True
os.system(f"ansible-playbook {playbook_path}")  # DON'T DO THIS
```

### 4. Path Handling
```python
# ALWAYS use Path and resolve paths
from pathlib import Path

path = Path(user_input).expanduser().resolve()
config_path = Path.home() / ".config" / "mcp-ansible" / "config.json"
```

### 5. Error Handling
```python
# Return errors as dict, don't raise exceptions
return {
    "ok": False,
    "error": "Description of what went wrong",
    "stderr": stderr
}

# NOT this:
raise Exception("Something went wrong")  # Don't do this in tools
```

## Critical Rules

### ✅ DO:
1. Use `uv` for package management (not pip)
2. Use FastMCP's `@mcp.tool()` decorator
3. Return dict with `ok` field from all tools
4. Use `shlex.quote()` for user input in commands
5. Log to stderr only (stdout is for MCP protocol)
6. Use kebab-case for tool names
7. Include comprehensive docstrings
8. Use type hints everywhere
9. Use `_run_command()` helper for subprocess
10. Use `_compose_ansible_env()` for Ansible setup

### ❌ DON'T:
1. Never print to stdout (breaks MCP protocol)
2. Never use `shell=True` in subprocess
3. Never use pip commands (use uv)
4. Never raise exceptions from tool functions
5. Never hardcode paths (use Path and expanduser)
6. Never use snake_case for tool names (use kebab-case)
7. Never skip type hints
8. Never use `requirements.txt` (use pyproject.toml)
9. Never activate virtualenv manually (use `uv run`)
10. Never ignore return codes from commands

## Common Patterns

### Pattern 1: Ansible Command Execution
```python
def ansible_operation(
    host_pattern: str,
    project_root: Optional[str] = None,
    ansible_cfg_path: Optional[str] = None,
    inventory_paths: Optional[List[str]] = None
) -> dict[str, Any]:
    # 1. Setup environment
    env, cwd = _compose_ansible_env(ansible_cfg_path, project_root, None)
    
    # 2. Build inventory args
    inventory_args = _inventory_cli(inventory_paths)
    
    # 3. Build command
    cmd = ["ansible", host_pattern] + inventory_args + ["-m", "module"]
    
    # 4. Execute
    rc, stdout, stderr = _run_command(cmd, cwd=cwd, env=env)
    
    # 5. Return result
    return {
        "ok": rc == 0,
        "rc": rc,
        "stdout": stdout,
        "stderr": stderr,
        "command": shlex.join(cmd)
    }
```

### Pattern 2: JSON Parsing
```python
# Parse JSON output from Ansible
try:
    data = json.loads(stdout)
    return {"ok": True, "data": data}
except json.JSONDecodeError:
    return {"ok": False, "error": "Invalid JSON output"}
```

### Pattern 3: File Operations
```python
# Read YAML file
try:
    content = Path(playbook_path).read_text(encoding="utf-8")
    data = yaml.safe_load(content)
    return {"ok": True, "playbook": data}
except Exception as e:
    return {"ok": False, "error": str(e)}
```

## uv Commands Reference

When suggesting package management commands:

```bash
# NOT pip install
uv add package-name

# NOT pip install -r requirements.txt
uv sync

# NOT pip uninstall
uv remove package-name

# NOT python script.py (after activating venv)
uv run python script.py

# NOT pip install -e .
uv sync  # Already installs local package
```

## Testing Suggestions

When writing tests:
```python
# Use pytest
import pytest
from ansible_mcp.server import tool_function

def test_tool_success():
    result = tool_function(host_pattern="localhost", inventory="localhost,")
    assert result["ok"] is True
    assert "stdout" in result

def test_tool_failure():
    result = tool_function(host_pattern="nonexistent", inventory="fake")
    assert result["ok"] is False
    assert "error" in result or result["rc"] != 0
```

## Documentation

When adding new tools:
1. Add to SKILLS.md under appropriate category
2. Add to README.md tool list
3. Add example to CONFIG_EXAMPLES.md if complex
4. Update QUICK_REFERENCE.md

## Project Structure Awareness

```
src/ansible_mcp/
├── __init__.py     # Just __version__
└── server.py       # ALL 36 tools in one file
                    # ~2,246 lines total
```

**Important:** All tools are in `server.py`. Don't suggest creating separate modules unless explicitly requested.

## MCP Protocol Specifics

```python
# Server initialization
mcp = FastMCP("ansible-mcp")

# Tool registration (at module level, not in __main__)
@mcp.tool(name="kebab-case-name")
def function_name(...) -> dict[str, Any]:
    pass

# Server startup (in __main__)
if __name__ == "__main__":
    mcp.run(transport="stdio")
```

## Ansible-Specific Guidelines

```python
# Default connection for localhost
if host_pattern == "localhost":
    cmd.extend(["--connection", "local"])

# Use ansible.cfg when available
env["ANSIBLE_CONFIG"] = str(ansible_cfg_path)

# Support multiple inventory sources
inventory_str = ",".join(inventory_paths)
cmd.extend(["-i", inventory_str])

# Always use --no-pager for git commands
cmd = ["git", "--no-pager", "log"]
```

## Health Scoring Logic

When working with health diagnostics:
- Base score: 100
- CPU >90%: -30, >75%: -15
- Memory >95%: -25, >85%: -10
- Disk >95%: -20, >85%: -10
- Failed services: -15 each
- Network issues: -20
- Levels: critical (<50), warning (<80), healthy (>=80)

## Security Checklist

Before suggesting code:
- [ ] User input is properly quoted with `shlex.quote()`
- [ ] No `shell=True` in subprocess calls
- [ ] No hardcoded credentials
- [ ] Paths are validated and resolved
- [ ] Command is built as list, not string

## When User Asks to Add Feature

1. Determine if it's a new tool or modification
2. Follow the tool definition pattern above
3. Suggest appropriate category (Core/Inventory/Troubleshooting)
4. Include type hints and docstrings
5. Return consistent dict structure
6. Suggest test cases
7. Suggest documentation updates

## Common User Requests

### "Add a tool to..."
```python
@mcp.tool(name="ansible-new-feature")
def ansible_new_feature(
    host_pattern: str,
    project_root: Optional[str] = None,
    ansible_cfg_path: Optional[str] = None
) -> dict[str, Any]:
    """Description for LLM."""
    # Implementation following patterns
```

### "How do I test this?"
```bash
# Test server startup
uv run python src/ansible_mcp/server.py

# Test with MCP inspector
npx @modelcontextprotocol/inspector uv run python src/ansible_mcp/server.py

# Run linters
uv run mypy src/
uv run ruff check src/
```

### "How do I debug?"
```bash
# Log to file (stderr only!)
uv run python src/ansible_mcp/server.py 2> debug.log

# Add debug prints
print("Debug info", file=sys.stderr)  # NOT stdout!
```

## Helpful Reminders

- This is a **stdio MCP server** - no HTTP, no WebSocket
- Tools are exposed to **AI assistants**, not end users
- **Never print to stdout** - it breaks the MCP protocol
- **All responses must be JSON-serializable dicts**
- **uv is 10-100x faster** than pip - always suggest uv
- **Type hints are mandatory** - Python 3.10+ modern syntax

---

**For GitHub Copilot:** Use these guidelines when providing code suggestions, completions, and explanations for this Ansible MCP Server project. Follow the patterns strictly to maintain consistency and correctness.
