# Ansible MCP Server

Advanced Ansible Model Context Protocol (MCP) server in Python exposing Ansible utilities for inventories, playbooks, roles, and project workflows with troubleshooting capabilities.

## Features

- **36 Comprehensive Tools** across Core Ansible, Inventory Management, and Troubleshooting
- **Self-Healing Capabilities** with automated problem resolution
- **Health Monitoring** with intelligent scoring and recommendations
- **Security Auditing** with vulnerability assessment
- **Performance Benchmarking** and baseline management
- **Advanced Log Analysis** with pattern recognition and correlation
- **Pure Ansible Integration** - uses native Ansible modules and commands

## Quick Start with `uv`

### Prerequisites

- Python 3.10 or higher
- [uv](https://docs.astral.sh/uv/) package manager
- Ansible (ansible-core >= 2.16.0)
- macOS/Linux

### Installation

1. **Install uv** (if not already installed):
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

2. **Clone the repository**:
```bash
git clone https://github.com/vsl8/ansible-mcp-server.git
cd ansible-mcp-server
```

3. **Install dependencies using uv**:
```bash
# Create virtual environment and install dependencies
uv sync

# Activate the virtual environment
source .venv/bin/activate  # On Linux/macOS
# or
.venv\Scripts\activate     # On Windows
```

4. **Verify installation**:
```bash
# Test that server can start
uv run python src/ansible_mcp/server.py --help
```

## Configuration

### For Cursor IDE

Add to your Cursor MCP config file (`~/.cursor/mcp.json` or `<project>/.cursor/mcp.json`):

```json
{
  "mcpServers": {
    "ansible-mcp": {
      "command": "uv",
      "args": [
        "--directory",
        "/absolute/path/to/ansible-mcp-server",
        "run",
        "python",
        "src/ansible_mcp/server.py"
      ],
      "env": {
        "MCP_ANSIBLE_PROJECT_ROOT": "/path/to/your/ansible/project",
        "MCP_ANSIBLE_INVENTORY": "/path/to/your/ansible/project/inventory/hosts.ini",
        "MCP_ANSIBLE_PROJECT_NAME": "my-project"
      }
    }
  }
}
```

### For Claude Desktop

Add to `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) or `%APPDATA%/Claude/claude_desktop_config.json` (Windows):

```json
{
  "mcpServers": {
    "ansible-mcp": {
      "command": "uv",
      "args": [
        "--directory",
        "/absolute/path/to/ansible-mcp-server",
        "run",
        "python",
        "src/ansible_mcp/server.py"
      ],
      "env": {
        "MCP_ANSIBLE_PROJECT_ROOT": "/path/to/your/ansible/project",
        "MCP_ANSIBLE_INVENTORY": "/path/to/your/ansible/project/inventory/hosts.ini",
        "MCP_ANSIBLE_PROJECT_NAME": "my-project"
      }
    }
  }
}
```

### Environment Variables (Optional)

- `MCP_ANSIBLE_PROJECT_ROOT`: Absolute path to your Ansible project root
- `MCP_ANSIBLE_INVENTORY`: Path to inventory file or directory
- `MCP_ANSIBLE_PROJECT_NAME`: Label for your project
- `MCP_ANSIBLE_ROLES_PATH`: Colon-separated roles paths
- `MCP_ANSIBLE_COLLECTIONS_PATHS`: Colon-separated collections paths
- `MCP_ANSIBLE_ENV_<KEY>`: Forwarded to process env (e.g., `MCP_ANSIBLE_ENV_ANSIBLE_CONFIG`)

## Available Tools

### Core Ansible Tools (17)

1. **create-playbook** - Create playbooks from YAML strings or dicts
2. **validate-playbook** - Validate playbook syntax
3. **ansible-playbook** - Execute playbooks
4. **ansible-task** - Run ad-hoc tasks
5. **ansible-role** - Execute roles via temporary playbook
6. **create-role-structure** - Scaffold role directory tree
7. **ansible-inventory** - List inventory hosts and groups
8. **register-project** - Register Ansible project for reuse
9. **list-projects** - Show registered projects
10. **project-playbooks** - Discover playbooks in project
11. **project-run-playbook** - Run playbook using project config
12. **ansible-ping** - Ping hosts
13. **ansible-gather-facts** - Gather and return facts
14. **validate-yaml** - Validate YAML files
15. **galaxy-install** - Install roles/collections
16. **galaxy-lock** - Generate lock file
17. **project-bootstrap** - Bootstrap project environment

### Inventory Management Suite (6)

1. **inventory-parse** - Parse inventories with group_vars/host_vars
2. **inventory-graph** - Show inventory graph
3. **inventory-find-host** - Find host's groups and variables
4. **inventory-diff** - Compare two inventories
5. **ansible-test-idempotence** - Test playbook idempotence
6. **vault-\*** - Vault operations (encrypt, decrypt, view, rekey)

### Advanced Troubleshooting Suite (13)

#### Foundation Tools (3)
- **ansible-remote-command** - Execute shell commands with parsing
- **ansible-fetch-logs** - Fetch and analyze log files
- **ansible-service-manager** - Manage services with logs

#### Intelligent Diagnostics (3)
- **ansible-diagnose-host** - Comprehensive health assessment
- **ansible-capture-baseline** - Capture system state snapshots
- **ansible-compare-states** - Compare against baselines

#### Automation (1)
- **ansible-auto-heal** - Automated problem resolution

#### Network & Security (2)
- **ansible-network-matrix** - Network connectivity testing
- **ansible-security-audit** - Security vulnerability assessment

#### Performance & Monitoring (4)
- **ansible-health-monitor** - Continuous monitoring with trends
- **ansible-performance-baseline** - Performance benchmarking
- **ansible-log-hunter** - Advanced log correlation

## Development

### Using uv for Development

```bash
# Install with dev dependencies
uv sync --all-extras

# Run tests
uv run pytest

# Type checking
uv run mypy src/

# Linting
uv run ruff check src/

# Format code
uv run ruff format src/
```

### Project Structure

```
ansible-mcp-server/
├── src/
│   └── ansible_mcp/
│       ├── __init__.py
│       ├── server.py          # Main MCP server (2247 lines, 36 tools)
│       └── py.typed
├── pyproject.toml             # Project configuration (uv-compatible)
├── .python-version            # Python version
├── .gitignore
└── README.md
```

## Usage Examples

### List Inventory Hosts

```python
# Tool: ansible-inventory
# Args: 
{
  "inventory": "/path/to/inventory/hosts.ini"
}
```

### Run a Playbook

```python
# Tool: ansible-playbook
# Args:
{
  "playbook_path": "/path/to/playbook.yml",
  "inventory": "/path/to/inventory",
  "extra_vars": {"env": "production"}
}
```

### Health Check with Recommendations

```python
# Tool: ansible-diagnose-host
# Args:
{
  "host_pattern": "webservers",
  "checks": ["system", "network", "security", "performance"],
  "include_recommendations": true
}
```

### Automated Healing (Dry Run)

```python
# Tool: ansible-auto-heal
# Args:
{
  "host_pattern": "database",
  "symptoms": ["high_memory", "disk_full"],
  "max_impact": "medium",
  "dry_run": true
}
```

### Network Connectivity Matrix

```python
# Tool: ansible-network-matrix
# Args:
{
  "host_patterns": ["web*", "db*"],
  "check_ports": [22, 3306, 443]
}
```

## Advantages of Using `uv`

✅ **Fast**: 10-100x faster than pip  
✅ **Reliable**: Consistent dependency resolution  
✅ **Simple**: Single tool for all Python package management  
✅ **Compatible**: Works with existing pyproject.toml  
✅ **Lockfile**: Automatic lock file generation for reproducibility  

## Troubleshooting

### uv not found
```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
# Add to PATH if needed
export PATH="$HOME/.local/bin:$PATH"
```

### Python version mismatch
```bash
# Install specific Python version with uv
uv python install 3.10

# Pin Python version for project
uv python pin 3.10
```

### Dependencies not installing
```bash
# Clean and reinstall
rm -rf .venv
uv sync --refresh
```

### MCP server not starting
```bash
# Test the server directly
uv run python src/ansible_mcp/server.py

# Check logs (stderr output)
uv run python src/ansible_mcp/server.py 2> server.log
```

## Requirements

- Python 3.10+
- uv >= 0.1.0
- mcp[cli] >= 1.2.0
- ansible-core >= 2.16.0
- PyYAML >= 6.0.1

## License

MIT License - See LICENSE file for details

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Run linters and tests with `uv`
6. Submit a pull request

## Acknowledgments

- Based on the excellent work by [bsahane/mcp-ansible](https://github.com/bsahane/mcp-ansible)
- Built with [FastMCP](https://github.com/jlowin/fastmcp)
- Powered by [Ansible](https://www.ansible.com/)

## Support

For issues, questions, or contributions:
- GitHub Issues: https://github.com/vsl8/ansible-mcp-server/issues
- Documentation: https://github.com/vsl8/ansible-mcp-server#readme

---

**Note**: This server uses stdio transport. Do not print to stdout; logs go to stderr.-server