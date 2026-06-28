# Example MCP Configuration Files

## Visual Studio Code (VS Code) Configuration

Create or edit `~/.vscode/mcp.json`:

```json
{
  "mcpServers": {
    "ansible-mcp": {
      "command": "uv",
      "args": [
        "--directory",
        "/home/vsl8/Documents/git/github/ai-assisted-devops/ansible-mcp",
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

**Note**: Install the MCP extension from VS Code Extensions marketplace by searching for "Model Context Protocol".

## Cursor Configuration

Create or edit `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "ansible-mcp": {
      "command": "uv",
      "args": [
        "--directory",
        "/home/vsl8/Documents/git/github/ai-assisted-devops/ansible-mcp",
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

## Claude Desktop Configuration

### macOS

Edit `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "ansible-mcp": {
      "command": "uv",
      "args": [
        "--directory",
        "/home/vsl8/Documents/git/github/ai-assisted-devops/ansible-mcp",
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

### Linux

Edit `~/.config/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "ansible-mcp": {
      "command": "uv",
      "args": [
        "--directory",
        "/home/vsl8/Documents/git/github/ai-assisted-devops/ansible-mcp",
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

### Windows

Edit `%APPDATA%\Claude\claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "ansible-mcp": {
      "command": "uv",
      "args": [
        "--directory",
        "C:\\path\\to\\ansible-mcp-server",
        "run",
        "python",
        "src/ansible_mcp/server.py"
      ],
      "env": {
        "MCP_ANSIBLE_PROJECT_ROOT": "C:\\path\\to\\your\\ansible\\project",
        "MCP_ANSIBLE_INVENTORY": "C:\\path\\to\\your\\ansible\\project\\inventory\\hosts.ini",
        "MCP_ANSIBLE_PROJECT_NAME": "my-project"
      }
    }
  }
}
```

## Environment Variables Reference

| Variable | Description | Example |
|----------|-------------|---------|
| `MCP_ANSIBLE_PROJECT_ROOT` | Absolute path to Ansible project | `/home/user/ansible-project` |
| `MCP_ANSIBLE_INVENTORY` | Path to inventory file/directory | `/home/user/ansible-project/inventory` |
| `MCP_ANSIBLE_PROJECT_NAME` | Project identifier | `production-infra` |
| `MCP_ANSIBLE_ROLES_PATH` | Colon-separated roles paths | `/usr/share/ansible/roles:/opt/roles` |
| `MCP_ANSIBLE_COLLECTIONS_PATHS` | Colon-separated collections paths | `~/.ansible/collections:/usr/share/ansible/collections` |
| `MCP_ANSIBLE_ENV_*` | Any env var (strip `MCP_ANSIBLE_ENV_` prefix) | `MCP_ANSIBLE_ENV_ANSIBLE_CONFIG=/path/to/ansible.cfg` |

## Multi-Project Configuration

You can register multiple projects and switch between them:

```json
{
  "mcpServers": {
    "ansible-mcp-staging": {
      "command": "uv",
      "args": [
        "--directory",
        "/home/vsl8/Documents/git/github/ai-assisted-devops/ansible-mcp",
        "run",
        "python",
        "src/ansible_mcp/server.py"
      ],
      "env": {
        "MCP_ANSIBLE_PROJECT_ROOT": "/path/to/staging",
        "MCP_ANSIBLE_INVENTORY": "/path/to/staging/inventory",
        "MCP_ANSIBLE_PROJECT_NAME": "staging"
      }
    },
    "ansible-mcp-production": {
      "command": "uv",
      "args": [
        "--directory",
        "/home/vsl8/Documents/git/github/ai-assisted-devops/ansible-mcp",
        "run",
        "python",
        "src/ansible_mcp/server.py"
      ],
      "env": {
        "MCP_ANSIBLE_PROJECT_ROOT": "/path/to/production",
        "MCP_ANSIBLE_INVENTORY": "/path/to/production/inventory",
        "MCP_ANSIBLE_PROJECT_NAME": "production"
      }
    }
  }
}
```

## GitHub Copilot CLI Configuration

Create or edit `~/.github-copilot/config.json`:

```json
{
  "mcp": {
    "servers": {
      "ansible-mcp": {
        "command": "uv",
        "args": [
          "--directory",
          "/home/vsl8/Documents/git/github/ai-assisted-devops/ansible-mcp",
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
}
```

### Using with GitHub Copilot CLI

```bash
# Initialize configuration directory
mkdir -p ~/.github-copilot

# Test the integration
gh copilot explain "How do I use ansible-inventory tool?"

# Get suggestions
gh copilot suggest "Run health check on all servers"

# Use specific tools
gh copilot chat "List all hosts in my ansible inventory"
```

## Claude CLI Configuration

Create or edit `~/.config/claude/config.json`:

```json
{
  "mcpServers": {
    "ansible-mcp": {
      "command": "uv",
      "args": [
        "--directory",
        "/home/vsl8/Documents/git/github/ai-assisted-devops/ansible-mcp",
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

### Using with Claude CLI

```bash
# Install Claude CLI if not installed
npm install -g @anthropic-ai/claude-cli

# Initialize configuration
claude config init

# Test MCP integration
claude chat "Show me all ansible tools available"

# Use specific tools
claude chat "List all hosts in my inventory"

# Run diagnostics
claude chat "Run health check on web servers"
```

## Testing Configuration

After updating configuration files, restart your IDE or Claude Desktop application, then test with:

```
# In Cursor/Claude chat
Can you list all available MCP tools?
```

You should see the 36 Ansible MCP tools available.
