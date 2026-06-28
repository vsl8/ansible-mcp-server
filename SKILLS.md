# Skills for Ansible MCP Server

This document provides context for AI assistants (GitHub Copilot, etc.) to better understand and assist with the Ansible MCP Server project.

---

## Project Overview

**Name**: Ansible MCP Server  
**Type**: Model Context Protocol (MCP) Server  
**Language**: Python 3.10+  
**Package Manager**: uv (modern, fast Python package manager)  
**Framework**: FastMCP (MCP server framework)  
**Purpose**: Expose Ansible capabilities (playbooks, inventory, troubleshooting) through MCP protocol

### Key Technologies
- **FastMCP**: MCP server framework (`from mcp.server.fastmcp import FastMCP`)
- **Ansible Core**: 2.16.0+ for automation
- **PyYAML**: YAML parsing and serialization
- **uv**: Package management and virtual environment
- **Python dataclasses**: Configuration and data structures

---

## Project Structure

```
ansible-mcp-server/
├── src/
│   └── ansible_mcp/
│       ├── __init__.py         # Package metadata (__version__)
│       ├── server.py           # Main MCP server (2,246 lines, 36 tools)
│       └── py.typed            # Type hints marker
├── pyproject.toml              # Project config (PEP 621, PEP 735)
├── uv.lock                     # Dependency lock file
├── .python-version             # Python version (3.10+)
├── .gitignore                  # Comprehensive Python/uv gitignore
└── docs/
    ├── README.md               # Main documentation
    ├── SETUP_GUIDE.md          # Installation guide
    ├── CONFIG_EXAMPLES.md      # Configuration templates
    ├── QUICK_REFERENCE.md      # Quick reference card
    ├── IMPROVEMENTS.md         # Comparison with original
    └── PROJECT_SUMMARY.md      # Project overview
```

---

## Core Concepts

### 1. MCP (Model Context Protocol)
- **Protocol**: Stdio-based communication (stdin/stdout)
- **Transport**: JSON-RPC over stdio
- **Tools**: Functions exposed to LLM clients (36 total)
- **Clients**: VS Code, Cursor, Claude Desktop, GitHub Copilot CLI, Claude CLI

### 2. FastMCP Framework
```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("ansible-mcp")

@mcp.tool()
def tool_name(arg1: str, arg2: Optional[int] = None) -> dict[str, Any]:
    """Tool description for LLM."""
    # Implementation
    return {"ok": True, "result": "..."}

if __name__ == "__main__":
    mcp.run(transport="stdio")
```

### 3. Tool Categories (36 tools)

#### Core Ansible Tools (17)
- Playbook management: create, validate, execute
- Role management: create structure, execute
- Inventory management: list, parse
- Project management: register, bootstrap
- Galaxy: install collections/roles

#### Inventory Suite (6)
- Parsing with ansible.cfg support
- Graph visualization
- Host/group queries
- Inventory diffing
- Vault operations

#### Troubleshooting Suite (13)
- Remote command execution
- Log fetching and analysis
- Service management
- Health diagnostics with scoring
- Baseline capture and comparison
- Auto-healing with safety checks
- Network connectivity matrices
- Security audits
- Performance benchmarking
- Continuous monitoring
- Log correlation

---

## Architecture Patterns

### 1. Configuration Management
```python
@dataclass
class ProjectDefinition:
    name: str
    root: str
    inventory: Optional[str] = None
    roles_paths: Optional[List[str]] = None
    collections_paths: Optional[List[str]] = None
    env: Optional[Dict[str, str]] = None

@dataclass
class ServerConfiguration:
    projects: dict[str, ProjectDefinition]
    defaults: dict[str, Any]
```

**Config Storage**: `~/.config/mcp-ansible/config.json`

### 2. Environment Variables
- `MCP_ANSIBLE_PROJECT_ROOT`: Project directory
- `MCP_ANSIBLE_INVENTORY`: Inventory path
- `MCP_ANSIBLE_PROJECT_NAME`: Project identifier
- `MCP_ANSIBLE_ROLES_PATH`: Custom roles paths
- `MCP_ANSIBLE_COLLECTIONS_PATHS`: Custom collections paths
- `MCP_ANSIBLE_ENV_*`: Forwarded environment variables

### 3. Command Execution Pattern
```python
def _run_command(
    command: List[str],
    cwd: Optional[Path] = None,
    env: Optional[Dict[str, str]] = None
) -> tuple[int, str, str]:
    """Execute subprocess with env/cwd support."""
    process = subprocess.Popen(
        command,
        cwd=str(cwd) if cwd else None,
        env={**os.environ.copy(), **(env or {})},
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    stdout, stderr = process.communicate()
    return process.returncode, stdout, stderr
```

### 4. Tool Return Pattern
All tools return `dict[str, Any]` with:
- `ok: bool` - Success indicator
- `rc: int` - Return code (for command execution)
- `stdout: str` - Standard output
- `stderr: str` - Standard error
- `command: str` - Command executed (for transparency)
- Additional tool-specific fields

### 5. Health Scoring Algorithm
```python
def _calculate_health_score(metrics: Dict[str, Any]) -> dict[str, Any]:
    score = 100  # Start at 100
    
    # CPU: -30 (>90%), -15 (>75%)
    # Memory: -25 (>95%), -10 (>85%)
    # Disk: -20 (>95%), -10 (>85%)
    # Services: -15 per failed service
    # Network: -20 if unreachable
    
    return {
        "score": max(0, score),
        "level": "critical" | "warning" | "healthy",
        "issues": List[str],
        "recommendations": List[str]
    }
```

### 6. Ansible Integration Pattern
```python
def _compose_ansible_env(
    ansible_cfg_path: Optional[str] = None,
    project_root: Optional[str] = None,
    extra_env: Optional[Dict[str, str]] = None
) -> tuple[dict[str, str], Optional[Path]]:
    """Build Ansible environment and working directory."""
    env: Dict[str, str] = {}
    if ansible_cfg_path:
        env["ANSIBLE_CONFIG"] = str(Path(ansible_cfg_path).resolve())
    cwd = Path(project_root).resolve() if project_root else None
    if extra_env:
        env.update(extra_env)
    return env, cwd
```

---

## Common Development Tasks

### 1. Adding a New MCP Tool
```python
@mcp.tool(name="tool-name")  # Use kebab-case
def tool_name(
    required_param: str,
    optional_param: Optional[int] = None,
    project_root: Optional[str] = None,
    ansible_cfg_path: Optional[str] = None,
    inventory_paths: Optional[List[str]] = None
) -> dict[str, Any]:
    """Clear description for LLM to understand when to use this tool.
    
    Args:
        required_param: Description
        optional_param: Description
        project_root: Project root directory
        ansible_cfg_path: Ansible config file path
        inventory_paths: Inventory file paths
    
    Returns:
        Dict with ok, result, and other fields
    """
    # 1. Compose Ansible environment
    env, cwd = _compose_ansible_env(ansible_cfg_path, project_root, None)
    
    # 2. Build command
    cmd = ["ansible", "module", "-m", "arg"]
    
    # 3. Execute
    rc, stdout, stderr = _run_command(cmd, cwd=cwd, env=env)
    
    # 4. Return result
    return {
        "ok": rc == 0,
        "rc": rc,
        "stdout": stdout,
        "stderr": stderr,
        "command": shlex.join(cmd)
    }
```

### 2. Running the Server Locally
```bash
# Direct execution
uv run python src/ansible_mcp/server.py

# With MCP inspector
npx @modelcontextprotocol/inspector uv run python src/ansible_mcp/server.py

# Debug mode (with verbose logging to stderr)
uv run python src/ansible_mcp/server.py 2> debug.log
```

### 3. Testing Changes
```bash
# Type checking
uv run mypy src/ansible_mcp/

# Linting
uv run ruff check src/ansible_mcp/

# Formatting
uv run ruff format src/ansible_mcp/

# Run tests (when implemented)
uv run pytest
```

### 4. Package Management with uv
```bash
# Install dependencies
uv sync

# Add new dependency
uv add package-name

# Add dev dependency
uv add --dev package-name

# Update dependencies
uv sync --upgrade

# Remove dependency
uv remove package-name

# Run script without activating venv
uv run python script.py
```

---

## Best Practices

### 1. Tool Design
- ✅ Use descriptive docstrings (LLM reads these)
- ✅ Return consistent dict structure with `ok` field
- ✅ Include `command` in response for transparency
- ✅ Use Optional for all optional parameters
- ✅ Accept `project_root`, `ansible_cfg_path`, `inventory_paths` when applicable
- ✅ Use kebab-case for tool names (`ansible-ping`, not `ansible_ping`)

### 2. Error Handling
- ✅ Always catch subprocess errors
- ✅ Return `ok: false` instead of raising exceptions
- ✅ Include error details in `stderr` field
- ✅ Provide helpful error messages

### 3. Ansible Commands
- ✅ Use `ansible.cfg` for configuration
- ✅ Support both file and directory inventories
- ✅ Use `--no-pager` for git commands
- ✅ Default to `connection=local` for localhost
- ✅ Parse JSON output when available

### 4. Type Hints
- ✅ Use type hints for all parameters and returns
- ✅ Use `Optional[T]` for nullable types
- ✅ Use `Dict[str, Any]` for flexible dicts
- ✅ Use `List[str]` for lists

### 5. Logging
- ✅ All logs go to stderr (stdout is for MCP protocol)
- ✅ Use `print(..., file=sys.stderr)` for debugging
- ✅ Never print to stdout

---

## Common Patterns and Idioms

### 1. Inventory Handling
```python
def _inventory_cli(inventory_paths: Optional[List[str]]) -> list[str]:
    """Build inventory CLI arguments."""
    if not inventory_paths:
        return []
    joined = ",".join(str(Path(p).expanduser().resolve()) for p in inventory_paths)
    return ["-i", joined]
```

### 2. Module Arguments
```python
def _dict_to_module_args(module_args: Dict[str, Any]) -> str:
    """Convert dict to Ansible module args string."""
    parts: List[str] = []
    for key, value in module_args.items():
        if isinstance(value, (dict, list)):
            parts.append(f"{key}={shlex.quote(json.dumps(value))}")
        elif isinstance(value, bool):
            parts.append(f"{key}={'yes' if value else 'no'}")
        elif value is None:
            parts.append(f"{key}=")
        else:
            parts.append(f"{key}={shlex.quote(str(value))}")
    return " ".join(parts)
```

### 3. JSON Parsing from Ansible Output
```python
def _parse_json_output(stdout: str) -> dict[str, Any]:
    """Parse JSON output from Ansible modules."""
    facts: Dict[str, Any] = {}
    for line in stdout.splitlines():
        if "SUCCESS" in line and "=>" in line:
            try:
                left, right = line.split("=>", 1)
                host = left.split("|")[0].strip()
                data = json.loads(right.strip())
                facts[host] = data
            except Exception:
                continue
    return facts
```

### 4. Path Resolution
```python
# Always use absolute, resolved paths
path = Path(user_input).expanduser().resolve()

# For config files
config_path = Path.home() / ".config" / "mcp-ansible" / "config.json"

# For project files
project_file = (Path(project_root) / "inventory" / "hosts.ini").resolve()
```

---

## Security Considerations

### 1. Command Injection Prevention
- ✅ Always use `shlex.quote()` for user input in shell commands
- ✅ Use `subprocess.Popen()` with list arguments, not shell strings
- ✅ Validate file paths exist and are within expected directories
- ❌ Never use `shell=True` in subprocess

### 2. Sensitive Data
- ✅ Vault passwords via environment or files, never hardcoded
- ✅ Use Ansible vault for secrets in inventory
- ✅ Don't log sensitive data to stdout/stderr
- ✅ Support `MCP_ANSIBLE_ENV_*` for secure env variable forwarding

### 3. Input Validation
- ✅ Validate inventory paths exist
- ✅ Validate playbook YAML syntax before execution
- ✅ Validate host patterns (no shell metacharacters)
- ✅ Validate module names against allowed list

---

## Troubleshooting Guide

### Common Issues

1. **Server not starting**
   - Check Python version: `python --version` (need 3.10+)
   - Check dependencies: `uv sync`
   - Check syntax: `uv run python -m py_compile src/ansible_mcp/server.py`

2. **Tools not showing up in client**
   - Verify config path is absolute
   - Restart client application
   - Check logs: `uv run python src/ansible_mcp/server.py 2> /tmp/mcp.log`

3. **Ansible commands failing**
   - Check Ansible installation: `ansible --version`
   - Check inventory path is absolute
   - Check ansible.cfg location
   - Verify SSH keys for remote hosts

4. **Import errors**
   - Run `uv sync` to install dependencies
   - Check virtual environment: `which python`
   - Verify pyproject.toml dependencies

---

## Testing Guidelines

### Unit Tests (to be implemented)
```python
import pytest
from ansible_mcp.server import _calculate_health_score

def test_health_score_critical():
    metrics = {"cpu_percent": 95, "memory_percent": 90, "disk_usage_percent": 90}
    result = _calculate_health_score(metrics)
    assert result["score"] < 50
    assert result["level"] == "critical"

def test_health_score_healthy():
    metrics = {"cpu_percent": 30, "memory_percent": 40, "disk_usage_percent": 50}
    result = _calculate_health_score(metrics)
    assert result["score"] >= 80
    assert result["level"] == "healthy"
```

### Integration Tests
```python
def test_ansible_ping_localhost():
    from ansible_mcp.server import ansible_task
    
    result = ansible_task(
        host_pattern="localhost",
        module="ping",
        inventory="localhost,",
        connection="local"
    )
    
    assert result["ok"] is True
    assert "pong" in result["stdout"].lower()
```

---

## Performance Optimization Tips

1. **Command Execution**
   - Cache ansible-inventory output when possible
   - Use `--limit` to reduce scope of playbook runs
   - Batch multiple operations when safe

2. **JSON Parsing**
   - Use `json.loads()` directly when Ansible outputs JSON
   - Parse large outputs in chunks

3. **File Operations**
   - Use `Path.exists()` before reading
   - Use `Path.read_text()` for small files
   - Use generators for large file processing

---

## Version Compatibility

- **Python**: 3.10+ (uses `dict[str, Any]` syntax)
- **Ansible Core**: 2.16.0+ (latest features)
- **FastMCP**: 1.2.0+ (modern MCP protocol)
- **uv**: Latest stable version

---

## Related Documentation

- **MCP Specification**: https://modelcontextprotocol.io/
- **FastMCP Docs**: https://github.com/jlowin/fastmcp
- **Ansible Docs**: https://docs.ansible.com/
- **uv Docs**: https://docs.astral.sh/uv/

---

## Quick Reference

### Essential Commands
```bash
# Development
uv sync                           # Install dependencies
uv run python src/ansible_mcp/server.py  # Run server
uv run mypy src/                  # Type check
uv run ruff check src/            # Lint
uv run ruff format src/           # Format

# Package Management
uv add package-name               # Add dependency
uv add --dev package-name         # Add dev dependency
uv remove package-name            # Remove dependency

# Testing
uv run pytest                     # Run tests
uv run pytest -v                  # Verbose tests
uv run pytest -k test_name        # Run specific test
```

### Tool Naming Convention
- Use kebab-case: `ansible-ping`, `create-playbook`
- Prefix with category: `ansible-`, `inventory-`, `vault-`
- Be descriptive: `ansible-diagnose-host` not `diagnose`

### Return Structure
```python
{
    "ok": bool,           # Always present
    "rc": int,            # For commands
    "stdout": str,        # Command output
    "stderr": str,        # Error output
    "command": str,       # For transparency
    # ... additional fields
}
```

---

## Contributing

When adding features:
1. Update this Skills.md with new patterns
2. Add tool to appropriate category in README.md
3. Add configuration example if needed
4. Update QUICK_REFERENCE.md
5. Run linters before committing
6. Test with MCP inspector

---

**Note for AI Assistants**: This project uses FastMCP for MCP protocol, uv for package management, and implements 36 Ansible automation tools. All MCP communication is via stdio (JSON-RPC). Tools should return consistent dict structures with `ok` field. Ansible commands should respect ansible.cfg and support multiple inventories.
