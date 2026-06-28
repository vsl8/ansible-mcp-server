# Quick Reference: MCP Client Configuration

## Supported Clients (5 total)

| Client | Config File Location | Built-in MCP | CLI Support |
|--------|---------------------|--------------|-------------|
| **VS Code** | `~/.vscode/mcp.json` | Via Extension | ❌ |
| **Cursor** | `~/.cursor/mcp.json` | ✅ Yes | ❌ |
| **Claude Desktop** | `~/Library/Application Support/Claude/claude_desktop_config.json` | ✅ Yes | ❌ |
| **GitHub Copilot CLI** | `~/.github-copilot/config.json` | ✅ Yes | ✅ Yes |
| **Claude CLI** | `~/.config/claude/config.json` | ✅ Yes | ✅ Yes |

---

## Universal Configuration Template

Use this for **all clients** (just change the config file path):

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

**Note**: GitHub Copilot CLI uses `"mcp": { "servers": { ... } }` instead of `"mcpServers"`.

---

## Quick Setup Commands

### VS Code
```bash
mkdir -p ~/.vscode
# Edit ~/.vscode/mcp.json with config above
# Install MCP extension from marketplace
code --install-extension model-context-protocol
```

### Cursor
```bash
mkdir -p ~/.cursor
# Edit ~/.cursor/mcp.json with config above
# Restart Cursor
```

### Claude Desktop
```bash
# macOS
mkdir -p ~/Library/Application\ Support/Claude
# Edit ~/Library/Application Support/Claude/claude_desktop_config.json

# Linux
mkdir -p ~/.config/Claude
# Edit ~/.config/Claude/claude_desktop_config.json
```

### GitHub Copilot CLI
```bash
mkdir -p ~/.github-copilot
# Edit ~/.github-copilot/config.json with modified config
# Test with:
gh copilot chat "List ansible hosts"
```

### Claude CLI
```bash
mkdir -p ~/.config/claude
# Edit ~/.config/claude/config.json with config above
# Test with:
claude chat "Show ansible tools"
```

---

## CLI Usage Examples

### GitHub Copilot CLI
```bash
# Get explanations
gh copilot explain "How do I use ansible-inventory tool?"

# Get suggestions
gh copilot suggest "Run health check on servers"

# Interactive chat
gh copilot chat "List all hosts in my ansible inventory"
```

### Claude CLI
```bash
# Install (if needed)
npm install -g @anthropic-ai/claude-cli

# Initialize
claude config init

# Interactive chat
claude chat "Show me all ansible tools available"
claude chat "Run diagnostics on web servers"
claude chat "List hosts in my inventory"
```

---

## Testing Your Setup

After configuration, test with any client:

1. **Restart** the application/terminal
2. **Open chat** or run CLI command
3. **Ask**: "List all available MCP tools"
4. **Verify**: You should see 36 Ansible MCP tools

---

## Troubleshooting

### Server not showing up?
1. Check config file path is correct
2. Ensure paths are **absolute**, not relative
3. Restart application completely
4. Check logs: `uv run python src/ansible_mcp/server.py 2> /tmp/mcp.log`

### Permission errors?
```bash
chmod +x src/ansible_mcp/server.py
uv sync  # Reinstall dependencies
```

### Python version issues?
```bash
uv python install 3.10
uv python pin 3.10
uv sync --refresh
```

---

## Environment Variables (Optional but Recommended)

| Variable | Purpose | Example |
|----------|---------|---------|
| `MCP_ANSIBLE_PROJECT_ROOT` | Your Ansible project directory | `/home/user/ansible` |
| `MCP_ANSIBLE_INVENTORY` | Inventory file location | `/home/user/ansible/inventory/hosts.ini` |
| `MCP_ANSIBLE_PROJECT_NAME` | Project identifier | `production` |
| `MCP_ANSIBLE_ROLES_PATH` | Custom roles paths | `/usr/share/ansible/roles:/opt/roles` |
| `MCP_ANSIBLE_COLLECTIONS_PATHS` | Custom collections paths | `~/.ansible/collections` |
| `MCP_ANSIBLE_ENV_*` | Forward env vars (strip prefix) | `MCP_ANSIBLE_ENV_ANSIBLE_CONFIG=/path/to/ansible.cfg` |

---

## Quick Links

- 📖 **Full Documentation**: [README.md](README.md)
- 🔧 **Detailed Config Examples**: [CONFIG_EXAMPLES.md](CONFIG_EXAMPLES.md)
- 🚀 **Setup Guide**: [SETUP_GUIDE.md](SETUP_GUIDE.md)
- 💡 **Improvements**: [IMPROVEMENTS.md](IMPROVEMENTS.md)

---

**Need help?** Check the full documentation or open an issue on GitHub.
