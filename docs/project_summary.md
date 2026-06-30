# Ansible MCP Server - Complete Project Documentation

## 📋 Project Overview

This is a modern implementation of the **Ansible MCP Server** using `uv` package manager, enabling AI assistants (VS Code, Cursor, Claude, GitHub Copilot CLI) to interact with Ansible infrastructure through 36 specialized tools. Based on the excellent work from [bsahane/mcp-ansible](https://github.com/bsahane/mcp-ansible).

**Status**: ✅ Production Ready  
**Version**: 0.1.0  
**Last Updated**: June 28, 2026  
**Maintainer**: Vidyadhar Lambade

---

## 🎯 Key Features

### Core Functionality
- ✅ **36 MCP Tools** across 3 categories
- ✅ **Core Ansible Tools** (17): Playbooks, roles, inventory, galaxy, vault
- ✅ **Inventory Suite** (6): Parsing, graphing, diffing, validation
- ✅ **Troubleshooting Suite** (13): Diagnostics, monitoring, self-healing
- ✅ **Dual Transport**: stdio (local) and SSE (remote)

### Improvements Over Original
- ✅ **uv Package Manager**: 10-100x faster than pip
- ✅ **Modern pyproject.toml**: Using PEP 735 dependency-groups
- ✅ **Comprehensive Documentation**: Consolidated in this file
- ✅ **Professional .gitignore**: 40+ patterns
- ✅ **Type Checking Support**: py.typed marker
- ✅ **Dev Dependencies**: pytest, mypy, ruff configured
- ✅ **Lock File**: Reproducible installs via uv.lock
- ✅ **Remote Access**: SSE transport for centralized Ansible management

---

## 📁 Project Structure

```
ansible-mcp-server/
├── src/
│   └── ansible_mcp/
│       ├── __init__.py         # Package metadata
│       ├── server.py            # Main MCP server (2,246 lines, 36 tools)
│       └── py.typed             # Type hints marker
├── Docs/
│   └── project_summary.md       # This file (consolidated documentation)
├── pyproject.toml               # Project configuration (uv-compatible)
├── uv.lock                      # Lock file for reproducible installs
├── .python-version              # Python version specification (3.10+)
├── .gitignore                   # Comprehensive gitignore
├── setup-remote.sh              # Automated remote setup script
└── test_transports.py           # Transport testing script

Virtual environment (not committed):
└── .venv/                       # Created by uv sync
```

---

## 🚀 Quick Start

### Prerequisites

- **Python 3.10+** installed on your system
- **Ansible** (will be installed via uv)
- **macOS or Linux** (Windows with WSL should work)

### Installation Steps

```bash
# 1. Install uv package manager
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add to PATH (if needed)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 2. Clone and setup
git clone https://github.com/vsl8/ansible-mcp-server.git
cd ansible-mcp-server

# 3. Install dependencies (creates .venv automatically)
uv sync

# 4. Test server (local mode)
uv run python src/ansible_mcp/server.py
# Press Ctrl+C to stop
```

---

## ⚙️ Configuration

### Local Mode (stdio) - Same Machine

**Use When:**
- Working on a single machine
- Need lowest latency
- Want simplest setup
- Don't need remote access

#### VS Code Configuration

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

**Note**: Install the MCP extension from VS Code Extensions marketplace.

#### Cursor Configuration

Edit `~/.cursor/mcp.json`:

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

#### Claude Desktop Configuration

**macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`  
**Linux**: `~/.config/Claude/claude_desktop_config.json`  
**Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

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

#### GitHub Copilot CLI Configuration

Edit `~/.github-copilot/config.json`:

```json
{
  "mcp": {
    "servers": {
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
}
```

**Usage:**
```bash
gh copilot chat "List all hosts in my ansible inventory"
gh copilot suggest "Run health check on all servers"
```

#### Claude CLI Configuration

Edit `~/.config/claude/config.json`:

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

**Usage:**
```bash
npm install -g @anthropic-ai/claude-cli
claude config init
claude chat "Show me all ansible tools available"
```

### Remote Mode (SSE) - Remote Server

**Use When:**
- Have remote Ansible server
- Multiple developers need access
- Want centralized Ansible management
- Need production deployment

#### Server Setup

```bash
# On remote server
ssh user@remote-ansible-server

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Clone project
git clone https://github.com/vsl8/ansible-mcp-server.git
cd ansible-mcp-server
uv sync

# Start server with SSE transport
uv run python src/ansible_mcp/server.py --transport sse --host 0.0.0.0 --port 8000

# Or use automated setup
./setup-remote.sh
```

#### Systemd Service (Production)

Create `/etc/systemd/system/ansible-mcp.service`:

```ini
[Unit]
Description=Ansible MCP Server with SSE
After=network.target

[Service]
Type=simple
User=ansible
WorkingDirectory=/opt/ansible-mcp-server
Environment="PATH=/home/ansible/.local/bin:/usr/local/bin:/usr/bin"
ExecStart=/home/ansible/.local/bin/uv run python src/ansible_mcp/server.py --transport sse --host 0.0.0.0 --port 8000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Enable and start:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable ansible-mcp
sudo systemctl start ansible-mcp
sudo systemctl status ansible-mcp
```

#### Firewall Configuration

```bash
# UFW (Ubuntu/Debian)
sudo ufw allow 8000/tcp

# Firewalld (RHEL/CentOS)
sudo firewall-cmd --permanent --add-port=8000/tcp
sudo firewall-cmd --reload
```

#### Nginx Reverse Proxy (SSL/TLS)

Create `/etc/nginx/sites-available/ansible-mcp`:

```nginx
server {
    listen 443 ssl http2;
    server_name ansible-mcp.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/ansible-mcp.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ansible-mcp.yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # SSE-specific settings
        proxy_buffering off;
        proxy_cache off;
        proxy_read_timeout 86400s;
    }
}
```

**Enable:**
```bash
sudo ln -s /etc/nginx/sites-available/ansible-mcp /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

#### Client Configuration (Remote SSE)

**All Clients** (Claude Desktop, VS Code, Cursor, etc.):

```json
{
  "mcpServers": {
    "ansible-remote": {
      "url": "https://ansible-mcp.yourdomain.com/sse",
      "transport": "sse"
    }
  }
}
```

**With Authentication:**
```json
{
  "mcpServers": {
    "ansible-remote": {
      "url": "https://ansible-mcp.yourdomain.com/sse",
      "transport": "sse",
      "headers": {
        "Authorization": "Bearer your-secure-token-here"
      }
    }
  }
}
```

### Environment Variables Reference

| Variable | Description | Example |
|----------|-------------|---------|
| `MCP_ANSIBLE_PROJECT_ROOT` | Ansible project directory | `/home/user/ansible-project` |
| `MCP_ANSIBLE_INVENTORY` | Inventory file/directory path | `/home/user/ansible-project/inventory` |
| `MCP_ANSIBLE_PROJECT_NAME` | Project identifier | `production-infra` |
| `MCP_ANSIBLE_ROLES_PATH` | Colon-separated roles paths | `/usr/share/ansible/roles:/opt/roles` |
| `MCP_ANSIBLE_COLLECTIONS_PATHS` | Colon-separated collections paths | `~/.ansible/collections:/usr/share/ansible/collections` |
| `MCP_ANSIBLE_ENV_*` | Forward env vars (strip prefix) | `MCP_ANSIBLE_ENV_ANSIBLE_CONFIG=/path/to/ansible.cfg` |

---

## 🏗️ Architecture

### Local Development (stdio)
```
┌─────────────────┐
│   AI Client     │
│  (VS Code)      │
└────────┬────────┘
         │ stdio (same machine)
         ▼
┌──────────────────┐
│  Ansible MCP     │
│    Server        │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Local Ansible   │
└──────────────────┘
```

### Remote Production (SSE)
```
┌─────────────────┐                       ┌──────────────────────┐
│  Developer 1    │                       │   Remote Server      │
│  (VS Code)      │──┐                    │                      │
└─────────────────┘  │                    │  ┌────────────────┐  │
                     │                    │  │ Nginx (SSL)    │  │
┌─────────────────┐  │   SSE/HTTPS       │  │ Port 443       │  │
│  Developer 2    │  ├──────────────────►│  └────────┬───────┘  │
│  (Claude)       │  │   Port 443         │           │          │
└─────────────────┘  │                    │           ▼          │
                     │                    │  ┌────────────────┐  │
┌─────────────────┐  │                    │  │ Ansible MCP    │  │
│  Developer 3    │  │                    │  │ Server (SSE)   │  │
│  (Cursor)       │──┘                    │  │ Port 8000      │  │
└─────────────────┘                       │  └────────┬───────┘  │
                                          │           │          │
                                          │           ▼          │
                                          │  ┌────────────────┐  │
                                          │  │ Ansible Core   │  │
                                          │  │ + Playbooks    │  │
                                          │  │ + Inventory    │  │
                                          │  └────────────────┘  │
                                          └──────────────────────┘
```

### Architecture Comparison

| Aspect | stdio (Local) | SSE (Remote) |
|--------|--------------|--------------|
| **Setup Complexity** | ⭐ Simple | ⭐⭐⭐ Moderate |
| **Performance** | ⭐⭐⭐⭐⭐ Fastest (0ms overhead) | ⭐⭐⭐⭐ Fast (12-106ms overhead) |
| **Multi-Client** | ❌ No | ✅ Yes |
| **Remote Access** | ❌ No | ✅ Yes |
| **Security Setup** | ⭐ Simple | ⭐⭐⭐⭐ Complex |
| **Maintenance** | ⭐ Minimal | ⭐⭐⭐ Regular |
| **Scalability** | ❌ Limited | ✅ Excellent |
| **Production Ready** | ⚠️ Local only | ✅ Yes |
| **Monitoring** | ⭐ Basic | ⭐⭐⭐⭐ Advanced |
| **Cost** | ⭐ Free | ⭐⭐ Infrastructure |

### Deployment Scenarios

#### Small Team (10 developers)
```
Company VPN
  │
  ├── Developer Laptop 1 ──┐
  ├── Developer Laptop 2 ──┼─── SSE ───► Ansible MCP Server
  └── Developer Laptop 3 ──┘                    │
                                                ▼
                                       Ansible Inventory
                                         (100 hosts)
```

#### Enterprise (100+ developers)
```
                 Internet
                    │
                    ▼
            Load Balancer (HAProxy)
                    │
        ┌───────────┴───────────┐
        │                       │
        ▼                       ▼
Ansible MCP #1         Ansible MCP #2
    (SSE)                  (SSE)
        │                       │
        └───────────┬───────────┘
                    │
                    ▼
         Ansible Tower/AWX (optional)
                    │
                    ▼
            Infrastructure (1000+ hosts)
```

#### Hybrid (Local + Remote)
```
Developer Laptop
├── Local Projects
│   └── Ansible MCP (stdio)
│       └── Development hosts
│
└── Remote Projects
    └── Ansible MCP (SSE)
        └── Production hosts

Config:
{
  "mcpServers": {
    "local-dev": {
      "command": "uv run python server.py",
      "transport": "stdio"
    },
    "production": {
      "url": "https://ansible-prod.company.com/sse",
      "transport": "sse"
    }
  }
}
```

---

## 🛠️ Available Tools (36 Total)

### Core Ansible Tools (17)

1. **create-playbook** - Create new Ansible playbook with optional role
2. **validate-playbook** - Validate playbook syntax
3. **ansible-playbook** - Execute Ansible playbook
4. **ansible-task** - Run ad-hoc Ansible task on hosts
5. **ansible-role** - Execute specific Ansible role
6. **create-role-structure** - Create new Ansible role structure
7. **ansible-inventory** - List and manage Ansible inventory
8. **register-project** - Register new Ansible project
9. **list-projects** - List all registered projects
10. **project-playbooks** - List playbooks in project
11. **project-run-playbook** - Run playbook from registered project
12. **ansible-ping** - Test connectivity to hosts
13. **ansible-gather-facts** - Gather system facts from hosts
14. **validate-yaml** - Validate YAML file syntax
15. **galaxy-install** - Install Ansible Galaxy role/collection
16. **galaxy-lock** - Create Galaxy requirements lock file
17. **project-bootstrap** - Bootstrap new Ansible project

### Inventory Management (6)

1. **inventory-parse** - Parse and analyze inventory structure
2. **inventory-graph** - Generate inventory visualization
3. **inventory-find-host** - Find host in inventory
4. **inventory-add-host** - Add host to inventory with variables
5. **inventory-diff** - Compare two inventory sources
6. **ansible-test-idempotence** - Test playbook idempotence

### Troubleshooting & Diagnostics (13)

1. **ansible-remote-command** - Execute remote commands
2. **ansible-fetch-logs** - Fetch logs from remote hosts
3. **ansible-service-manager** - Manage services on hosts
4. **ansible-diagnose-host** - Comprehensive host diagnostics
5. **ansible-capture-baseline** - Capture system baseline
6. **ansible-compare-states** - Compare system states
7. **ansible-auto-heal** - Automated healing actions
8. **ansible-network-matrix** - Test network connectivity matrix
9. **ansible-security-audit** - Security configuration audit
10. **ansible-health-monitor** - Continuous health monitoring
11. **ansible-performance-baseline** - Capture performance metrics
12. **ansible-log-hunter** - Search and analyze logs
13. **ansible-change-tracker** - Track system changes over time

---

## 💬 How to Use — Prompt Guide for AI Assistants

Once the Ansible MCP Server is configured in your AI assistant (VS Code Copilot, Claude, Cursor, etc.), you can interact with your Ansible infrastructure using natural language prompts. This section shows you **exactly what to type** to get started.

### 🚀 Getting Started — Register Your First Project

The first thing a new user should do is **register their Ansible project** so the MCP server knows where your playbooks, inventory, and roles live.

#### Step 1: Register a Project

> **Prompt:**
> ```
> Register my Ansible project called "homelab" with root path "/home/user/ansible-homelab"
> and inventory at "/home/user/ansible-homelab/inventory/hosts.ini"
> ```

This tells the MCP server about your project. You can register multiple projects.

#### Step 2: Make It the Default Project

> **Prompt:**
> ```
> Register my project "production-infra" at "/opt/ansible/production" with inventory
> "/opt/ansible/production/inventory/hosts.yml" and make it the default project
> ```

By setting a default, all subsequent commands will automatically use this project's paths and inventory — no need to specify them every time!

#### Step 3: Verify Registration

> **Prompt:**
> ```
> List all my registered Ansible projects
> ```

---

### 📖 Sample Prompts for Every Tool

Below are ready-to-use prompts for each of the 36 tools. Just copy, paste, and adjust paths/hostnames to your environment.

---

#### 🔧 Core Ansible Tools (17)

| # | Tool | Sample Prompt |
|---|------|---------------|
| 1 | **register-project** | `Register my Ansible project named "webapp" with root at "/home/user/ansible-webapp", inventory at "/home/user/ansible-webapp/inventory/hosts.ini", and make it the default` |
| 2 | **list-projects** | `List all my registered Ansible projects and show which one is the default` |
| 3 | **project-playbooks** | `Show me all the playbooks available in my "webapp" project` |
| 4 | **project-run-playbook** | `Run the playbook "deploy.yml" from my registered project "webapp" with check mode enabled` |
| 5 | **project-bootstrap** | `Bootstrap my Ansible project at "/home/user/new-project" — install galaxy dependencies and show environment details` |
| 6 | **create-playbook** | `Create an Ansible playbook that installs nginx on all webservers and saves it to "/home/user/ansible/playbooks/install-nginx.yml"` |
| 7 | **validate-playbook** | `Validate the syntax of my playbook at "/home/user/ansible/playbooks/deploy.yml"` |
| 8 | **ansible-playbook** | `Run the playbook "/home/user/ansible/site.yml" with inventory "/home/user/ansible/inventory/hosts.ini" in diff mode` |
| 9 | **ansible-task** | `Run an ad-hoc task on all webservers to check disk usage using the shell module with command "df -h"` |
| 10 | **ansible-role** | `Execute the "nginx" role on all hosts in the "webservers" group` |
| 11 | **create-role-structure** | `Create a new Ansible role called "postgres" under "/home/user/ansible/roles"` |
| 12 | **ansible-inventory** | `List all hosts and groups in my Ansible inventory` |
| 13 | **ansible-ping** | `Ping all hosts in my inventory to check connectivity` |
| 14 | **ansible-gather-facts** | `Gather system facts from all hosts in the "databases" group — show me OS, memory, and CPU info` |
| 15 | **validate-yaml** | `Validate the YAML syntax of my files at "/home/user/ansible/playbooks/deploy.yml" and "/home/user/ansible/inventory/group_vars/all.yml"` |
| 16 | **galaxy-install** | `Install all Ansible Galaxy roles and collections from requirements files in my project at "/home/user/ansible"` |
| 17 | **galaxy-lock** | `Create a lock file for all installed Galaxy roles and collections in my project at "/home/user/ansible"` |

---

#### 📦 Inventory Management (6)

| # | Tool | Sample Prompt |
|---|------|---------------|
| 1 | **inventory-parse** | `Parse my Ansible inventory and show me all groups, hosts, and their variables in detail` |
| 2 | **inventory-graph** | `Show me a visual graph of my inventory structure — all groups and host relationships` |
| 3 | **inventory-find-host** | `Find the host "db-server-01" in my inventory and show which groups it belongs to and its variables` |
| 4 | **inventory-add-host** | `Add host dev-test-az1 ansible_host=10.112.51.196 to group test in current project inventory file` |
| 5 | **inventory-diff** | `Compare my staging inventory at "/home/user/ansible/inventory/staging" with production at "/home/user/ansible/inventory/production" and show differences` |
| 6 | **ansible-test-idempotence** | `Test if my playbook "/home/user/ansible/playbooks/configure-nginx.yml" is idempotent — run it twice and check for changes on second run` |

**Additional Vault Operations:**

| Tool | Sample Prompt |
|------|---------------|
| **vault-encrypt** | `Encrypt the file "/home/user/ansible/group_vars/secrets.yml" using Ansible Vault with password file "/home/user/.vault_pass"` |
| **vault-decrypt** | `Decrypt the vault-encrypted file "/home/user/ansible/group_vars/secrets.yml" using password file "/home/user/.vault_pass"` |
| **vault-view** | `View the contents of my encrypted vault file "/home/user/ansible/group_vars/secrets.yml" without decrypting it permanently` |
| **vault-rekey** | `Change the vault password for "/home/user/ansible/group_vars/secrets.yml" — old password file is "/home/user/.old_vault_pass" and new is "/home/user/.new_vault_pass"` |

---

#### 🔍 Troubleshooting & Diagnostics (13)

| # | Tool | Sample Prompt |
|---|------|---------------|
| 1 | **ansible-remote-command** | `Run the command "systemctl status nginx" on all webservers with sudo privileges` |
| 2 | **ansible-fetch-logs** | `Fetch the last 200 lines of "/var/log/nginx/error.log" from all webservers and filter for "502" errors` |
| 3 | **ansible-service-manager** | `Restart the "nginx" service on host "web-01" and check its logs after restart` |
| 4 | **ansible-diagnose-host** | `Run a comprehensive diagnostic on host "db-server-01" — check CPU, memory, disk, services, and network` |
| 5 | **ansible-capture-baseline** | `Capture a system baseline snapshot called "pre-deployment" from all production servers` |
| 6 | **ansible-compare-states** | `Compare the current state of "web-01" against the baseline snapshot I captured earlier` |
| 7 | **ansible-auto-heal** | `The host "web-01" has symptoms: high memory usage and nginx not responding. Auto-heal it in dry-run mode first` |
| 8 | **ansible-network-matrix** | `Test network connectivity between all webservers and database servers on ports 5432 and 443` |
| 9 | **ansible-security-audit** | `Run a security audit on all production servers — check SSH config, firewall rules, and user permissions` |
| 10 | **ansible-health-monitor** | `Monitor the health of all webservers for 5 minutes with 30-second intervals` |
| 11 | **ansible-performance-baseline** | `Capture a performance baseline for "db-server-01" with a 60-second benchmark duration` |
| 12 | **ansible-log-hunter** | `Search for patterns "ERROR" and "CRITICAL" in logs on all servers from the last 1 hour, check /var/log/syslog and /var/log/nginx/error.log` |
| 13 | **ansible-change-tracker** | `Track what system changes have occurred on "web-01" since last week` |


---

### 💡 Pro Tips

1. **Be Specific About Hosts**: Use group names or host patterns
   - ✅ `ping all servers in the web group`
   - ✅ `check health of prod-*`
   - ❌ `ping servers` (too vague)

2. **Request Check Mode for Safety**: Add "check mode" or "dry run" for production
   - `run deploy.yml in check mode on production`

3. **Chain Operations**: The agent understands context
   - `diagnose the issue, then fix it if safe`

4. **Ask for Explanations**: Get insights, not just raw output
   - `what does the health score mean for web-01?`

5. **Specify Time Ranges for Logs**:
   - `search for errors in the last 2 hours`

---

### ⚠️ Safety Behaviors

The agent has built-in safety guidelines:

| Scenario | Agent Behavior |
|----------|----------------|
| **Production deployments** | Asks for confirmation before running |
| **Service restarts** | Confirms the action before executing |
| **Auto-healing** | Shows what will be fixed before proceeding |
| **Destructive commands** | Warns and requires explicit approval |
| **Broad host patterns** | Asks to confirm scope ("all" or "*") |

---

### 🔧 Troubleshooting the Agent

| Issue | Solution |
|-------|----------|
| Agent doesn't respond | Ensure MCP server is configured in Copilot CLI |
| Tools not found | Verify `ansible-remote-*` tools are available |
| Wrong project used | Check `@ansible-operator show registered projects` |
| Connection failures | Verify SSH keys and inventory paths |

---

## 📞 Support

- **Issues**: https://github.com/vsl8/ansible-mcp-server/issues
- **Repository**: https://github.com/vsl8/ansible-mcp-server
- **Original Project**: https://github.com/bsahane/mcp-ansible

---

## 📊 Project Statistics

| Metric | Value |
|--------|-------|
| Total Lines of Code | 2,246 (server.py) |
| Total Tools | 36 |
| Dependencies | 4 runtime + 4 dev |
| Installation Time | ~5-10 seconds with uv |
| Python Version | 3.10+ |
| Supported Clients | 5 (VS Code, Cursor, Claude Desktop, GitHub Copilot CLI, Claude CLI) |
| Transport Modes | 2 (stdio, SSE) |

---

### 🎯 Common Workflow Examples

#### Workflow 1: New Project Setup
```
1. "Register my Ansible project 'my-infra' at '/home/user/infra' with inventory '/home/user/infra/hosts.ini' and make it the default"
2. "Bootstrap my project at '/home/user/infra' — install galaxy dependencies"
3. "Ping all hosts in my inventory to verify connectivity"
4. "Show me a visual graph of my inventory"
```

#### Workflow 2: Deploy & Verify
```
1. "Validate the syntax of my playbook '/home/user/infra/deploy-app.yml'"
2. "Run the playbook 'deploy-app.yml' from my default project in check mode first"
3. "Now run it for real — execute 'deploy-app.yml' with diff mode to see changes"
4. "Test the idempotence of 'deploy-app.yml' to ensure it's safe to re-run"
```

#### Workflow 3: Troubleshoot a Server Issue
```
1. "Run a full diagnostic on host 'web-01' — check everything"
2. "Fetch the last 500 lines of /var/log/syslog from web-01 and filter for errors"
3. "Check if nginx is running on web-01 and restart it if needed"
4. "Monitor web-01 health for 2 minutes to confirm it's stable after fix"
```

#### Workflow 4: Security & Compliance
```
1. "Run a security audit on all production servers"
2. "Capture a baseline of all servers called 'june-2026-audit'"
3. "Encrypt my secrets file with ansible-vault"
4. "Check network connectivity matrix between web tier and database tier"
```

#### Workflow 5: Adding Hosts to Inventory

The `inventory-add-host` tool allows you to dynamically add hosts to your Ansible inventory files without manual editing.

**Basic Usage:**

```
1. "Add host dev-test-az1 ansible_host=10.112.51.196 to group test in current project inventory file"
2. "Add host db-prod-01 ansible_host=192.168.1.50 ansible_user=admin ansible_port=2222 to group dbservers in my-project/inventory/production.yml"
3. "Add host app-server-01 ansible_host=10.0.0.100 to group appservers in inventory/hosts.ini and create the group if it doesn't exist"
```

**Detailed Examples with inventory-add-host:**

| Scenario | Prompt |
|----------|--------|
| **Add host to existing group** | `Add host dev-test-az1 ansible_host=10.112.51.196 to group test in current project inventory file` |
| **Add host with multiple variables** | `Add host db-prod-01 ansible_host=192.168.1.50 ansible_user=admin ansible_port=2222 to group dbservers in my-project/inventory/production.yml` |
| **Create group if missing** | `Add host app-server-01 ansible_host=10.0.0.100 to group appservers in inventory/hosts.ini and create the group if it doesn't exist` |
| **Add to YAML inventory** | `Add host web-01 ansible_host=10.5.0.10 ansible_port=22 to group webservers in /etc/ansible/inventory/hosts.yml` |
| **Multiple hosts workflow** | `Add hosts prod-app-01 ansible_host=10.1.1.5 and prod-app-02 ansible_host=10.1.1.6 to group production-apps in my-project/inventory/production.ini` |

**Complete Workflow: Adding Hosts During Infrastructure Scaling**

```
1. "Show me current inventory structure"
   → Use: inventory-graph

2. "Add host new-db-01 ansible_host=10.2.0.50 ansible_user=root to group databases in my inventory and create the group if needed"
   → Use: inventory-add-host (with create_group=true)

3. "Verify new host was added and find all its details"
   → Use: inventory-find-host

4. "Ping the new host to verify connectivity"
   → Use: ansible-ping

5. "Run initial configuration playbook on new host"
   → Use: ansible-playbook or ansible-task
```

---

### 💡 Tips for Effective Prompts

1. **Be specific with host patterns** — Use group names (`webservers`, `databases`) or specific hosts (`web-01`)
2. **Always register and set a default project** — This eliminates the need to specify paths in every command
3. **Use check/dry-run mode first** — Ask for `--check` mode before running playbooks for real
4. **Combine tools naturally** — "Diagnose web-01, then auto-heal if there are issues"
5. **The AI remembers context** — After registering a project, you can just say "run the deploy playbook" without repeating paths

---

## 🔒 Security Best Practices

### For Remote Deployments

1. **Network Security**
   - Always use VPN or SSH tunnel
   - Implement firewall rules (whitelist IPs only)
   - Use SSL/TLS with valid certificates

2. **Authentication**
   - Generate secure tokens: `python -c "import secrets; print(secrets.token_urlsafe(32))"`
   - Use environment variables for tokens
   - Rotate tokens regularly

3. **Audit & Monitoring**
   - Log all requests: `/var/log/ansible-mcp/access.log`
   - Send logs to SIEM (Splunk/ELK)
   - Monitor connection count and error rates
   - Set up alerts for suspicious activity

4. **Rate Limiting**
   - Implement rate limiting: 100 requests/min per token
   - Block excessive failed authentication attempts
   - Use load balancer for DDoS protection

5. **System Security**
   - Run service as dedicated user (not root)
   - Apply principle of least privilege
   - Keep system and packages updated
   - Regular security audits

---

## 📊 Performance & Scaling

### Performance Characteristics

| Metric | stdio (Local) | SSE (Remote) |
|--------|--------------|--------------|
| Overhead | ~1ms | 12-106ms |
| Throughput | Highest | High |
| Latency | Lowest | Network dependent |
| Concurrent Clients | 1 | Unlimited* |

*Limited by server resources

### Horizontal Scaling

```
         Load Balancer
               │
   ┌───────────┼───────────┐
   │           │           │
   ▼           ▼           ▼
MCP #1      MCP #2      MCP #3
   │           │           │
   └───────────┼───────────┘
               │
               ▼
    Shared Ansible Config
      (NFS/GlusterFS)
```

### Vertical Scaling

**Recommended Specs:**
- 16+ CPU cores → Handle concurrent requests
- 32+ GB RAM → Cache inventory & playbooks
- SSD storage → Fast playbook execution
- 10Gbps NIC → High throughput

### Metrics to Monitor

```
┌──────────────────────────────────────┐
│ Ansible MCP Metrics Dashboard        │
├──────────────────────────────────────┤
│ Active Connections:  47              │
│ Requests/min:        234             │
│ Avg Response Time:   1.2s            │
│ Error Rate:          0.3%            │
│                                      │
│ Top Tools Used:                      │
│ 1. ansible-ping        45%           │
│ 2. ansible-playbook    30%           │
│ 3. ansible-gather-facts 15%          │
│                                      │
│ Server Health:                       │
│ CPU:    ████████░░ 45%               │
│ Memory: ████████░░ 60%               │
│ Disk:   ███░░░░░░░ 25%               │
└──────────────────────────────────────┘
```

---

## 🧪 Testing & Verification

### Test Server Startup

```bash
# Test stdio transport
uv run python src/ansible_mcp/server.py
# Press Ctrl+C to exit

# Test SSE transport
uv run python src/ansible_mcp/server.py --transport sse --port 8000

# Run automated tests
python3 test_transports.py
```

### Health Check

```bash
# Local
curl http://localhost:8000/health

# Remote
curl http://remote-server:8000/health
```

### Test in Client

After configuration, test with:
```
List all available MCP tools
```

You should see 36 Ansible MCP tools.

### Run Development Tools

```bash
# Type checking
uv run mypy src/

# Linting
uv run ruff check src/

# Format code
uv run ruff format src/

# Run tests (when implemented)
uv run pytest
```

---

## 🐛 Troubleshooting

### Server Not Showing Up

1. Check config file path is correct
2. Ensure paths are **absolute**, not relative
3. Restart application completely
4. Check logs: `uv run python src/ansible_mcp/server.py 2> /tmp/mcp.log`

### Connection Issues (Remote)

```bash
# Check if server is running
sudo netstat -tlnp | grep 8000

# Check systemd logs
sudo journalctl -u ansible-mcp -f

# Test locally on server
curl http://localhost:8000/health

# Test from client
telnet remote-ansible-server 8000
```

### Permission Errors

```bash
chmod +x src/ansible_mcp/server.py
uv sync  # Reinstall dependencies

# Ensure proper Ansible permissions
sudo usermod -aG ansible <service-user>
```

### Python Version Issues

```bash
uv python install 3.10
uv python pin 3.10
uv sync --refresh
```

### Firewall Issues

```bash
# Check firewall rules
sudo iptables -L -n | grep 8000
sudo ufw status

# Verify port is open
telnet remote-server 8000
```

---

## 💡 Why This Implementation is Better

### Performance
- **10-100x faster** dependency installation with uv
- **Parallel downloads** and builds
- **Cached packages** across projects
- **Lock files** for reproducibility

### Modern Package Management
- **No virtualenv activation** needed (`uv run`)
- **Single tool** for all operations
- **Better conflict resolution**
- **Automatic environment management**

### Developer Experience
- **Faster iteration** cycles
- **Simpler commands**
- **Professional project structure**
- **Comprehensive documentation**

### Project Quality
- **Type checking** support (py.typed)
- **Linting tools** configured (ruff)
- **Testing framework** ready (pytest)
- **Professional .gitignore**

### Commands Comparison

| Task | Original (pip) | Our (uv) | Speed |
|------|----------------|----------|-------|
| Install deps | `pip install -r requirements.txt` | `uv sync` | 6-10x faster |
| Add package | `pip install pkg && pip freeze > requirements.txt` | `uv add pkg` | Instant |
| Run script | `python script.py` (must activate venv first) | `uv run python script.py` | Same |
| Update deps | `pip install --upgrade -r requirements.txt` | `uv sync --upgrade` | 10x faster |
| Run tests | `pytest` (must activate venv first) | `uv run pytest` | Same |

---

## 🚀 Migration Path

### From bsahane/mcp-ansible:

1. Install uv: `curl -LsSf https://astral.sh/uv/install.sh | sh`
2. Clone this repo
3. Run `uv sync`
4. Update your MCP config to use `uv run`
5. Done! ✅

### From stdio to SSE:

```bash
# Step 1: Deploy on remote server
ssh ansible-server
git clone <repo>
cd ansible-mcp-server
uv sync

# Step 2: Test locally on server
uv run python src/ansible_mcp/server.py --transport sse --port 8000

# Step 3: Configure firewall
sudo ufw allow 8000/tcp

# Step 4: Update client config (change transport to SSE)

# Step 5: Test from client
curl http://ansible-server:8000/health

# Step 6: (Optional) Add Nginx + SSL

# Step 7: (Optional) Setup systemd
./setup-remote.sh
```

---

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make changes with tests
4. Run linters: `uv run ruff check src/`
5. Submit pull request

---

## 📝 License

MIT License - Same as original bsahane/mcp-ansible

---

## 🙏 Acknowledgments

- Original implementation: [bsahane/mcp-ansible](https://github.com/bsahane/mcp-ansible)
- Built with: [FastMCP](https://github.com/jlowin/fastmcp)
- Package manager: [uv](https://github.com/astral-sh/uv)
- Powered by: [Ansible](https://www.ansible.com/)


**🎉 Ready to revolutionize your Ansible workflows with AI assistance!**