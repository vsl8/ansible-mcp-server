# Quick Setup Guide for Ansible MCP Server with `uv`

## Prerequisites

- **Python 3.10+** installed on your system
- **uv** package manager (we'll install this)
- **Ansible** (will be installed via uv)
- **macOS or Linux** (Windows with WSL should work)

## Step-by-Step Setup

### 1. Install `uv` Package Manager

```bash
# Install uv (fast Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add to PATH (if needed)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify installation
uv --version
```

### 2. Clone and Setup the Project

```bash
# Clone the repository
git clone https://github.com/vsl8/ansible-mcp-server.git
cd ansible-mcp-server

# Install all dependencies (creates .venv automatically)
uv sync

# Activate virtual environment
source .venv/bin/activate

# Verify server can start
uv run python src/ansible_mcp/server.py
# Press Ctrl+C to stop (it's waiting for MCP stdio input)
```

### 3. Configure for Cursor IDE

Edit or create `~/.cursor/mcp.json`:

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

**Important**: Replace paths with your actual absolute paths!

### 4. Configure for Claude Desktop

#### macOS:
Edit `~/Library/Application Support/Claude/claude_desktop_config.json`

#### Linux:
Edit `~/.config/Claude/claude_desktop_config.json`

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

### 5. Restart Your Application

- **Cursor**: Restart Cursor IDE
- **Claude Desktop**: Quit and restart Claude Desktop

### 6. Verify It Works

In Cursor or Claude, try:

```
List all available MCP tools for Ansible
```

You should see 36 tools available!

## Quick Test Commands

### Test with localhost (no inventory needed)

```
Use the ansible-task tool to ping localhost
```

### List inventory (if you configured an inventory)

```
Use ansible-inventory to list all hosts in my inventory
```

### Get host facts

```
Use ansible-gather-facts to get system information from localhost
```

## Common Issues

### Issue: "uv: command not found"
**Solution**: 
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
```

### Issue: "Python 3.10+ required"
**Solution**:
```bash
# Install Python with uv
uv python install 3.10
uv python pin 3.10
```

### Issue: Server doesn't show up in MCP tools
**Solution**:
1. Check paths are absolute (not relative)
2. Restart IDE completely
3. Check logs: `uv run python src/ansible_mcp/server.py 2> /tmp/mcp-ansible.log`

### Issue: Ansible not found
**Solution**: It's included in dependencies, just run:
```bash
cd /path/to/ansible-mcp-server
uv sync
```

## Environment Variables Explained

| Variable | Purpose | Example |
|----------|---------|---------|
| `MCP_ANSIBLE_PROJECT_ROOT` | Your Ansible project directory | `/home/user/ansible` |
| `MCP_ANSIBLE_INVENTORY` | Inventory file location | `/home/user/ansible/inventory/hosts.ini` |
| `MCP_ANSIBLE_PROJECT_NAME` | Project identifier | `production` |

## Next Steps

1. ✅ Try running a simple playbook
2. ✅ Test the health check tools on your hosts
3. ✅ Explore the 36 available tools
4. ✅ Read full documentation in README.md

## Why `uv` is Better

✅ **10-100x faster** than pip  
✅ **Reliable** dependency resolution  
✅ **Simple** - one tool for everything  
✅ **Lockfile** - reproducible installs  
✅ **No conflicts** - isolated environments  

## Getting Help

- Full documentation: [README.md](README.md)
- Configuration examples: [CONFIG_EXAMPLES.md](CONFIG_EXAMPLES.md)
- Issue tracker: https://github.com/vsl8/ansible-mcp-server/issues

---

**Pro Tip**: Use `uv run` to run commands without activating venv:
```bash
uv run python src/ansible_mcp/server.py
uv run pytest
uv run mypy src/
```
