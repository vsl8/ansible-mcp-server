# Ansible MCP Remote Architecture

## Before (stdio only)

```
┌─────────────────┐
│   AI Client     │
│  (VS Code/      │
│   Claude)       │
└────────┬────────┘
         │ stdio
         │ (same machine)
         ▼
┌─────────────────┐
│  Ansible MCP    │
│    Server       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Local Ansible  │
│   Installation  │
└─────────────────┘
```

## After (stdio + SSE)

### Local Development (stdio)
```
┌─────────────────┐
│   AI Client     │────┐
│  (VS Code)      │    │ stdio
└─────────────────┘    │ (same machine)
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
                                          │  └────────┬───────┘  │
                                          └───────────┼──────────┘
                                                      │
                                                      ▼
                                          ┌─────────────────────┐
                                          │  Infrastructure     │
                                          │  (Servers, Cloud)   │
                                          └─────────────────────┘
```

## Communication Flow (SSE)

### 1. Client Request
```
AI Client ──> {"tool": "ansible-ping", "host_pattern": "all"}
    │
    │ HTTPS POST /sse
    ▼
Nginx Reverse Proxy
    │
    │ Verify SSL, Auth Token
    ▼
Ansible MCP Server (Port 8000)
    │
    │ Parse MCP request
    ▼
Execute Ansible Command
    │
    │ ansible all -m ping
    ▼
Ansible Control Node
    │
    │ SSH to managed nodes
    ▼
Target Hosts
```

### 2. Server Response (SSE Stream)
```
Target Hosts ──> Ansible output
    │
    ▼
Ansible MCP Server
    │
    │ Format MCP response
    │ {"ok": true, "stdout": "..."}
    ▼
Nginx Reverse Proxy
    │
    │ Stream SSE events
    ▼
AI Client ──> Display results
```

## Deployment Scenarios

### Scenario 1: Small Team (10 developers)
```
Internet
   │
   ▼
┌──────────────────────────────────────┐
│  Company VPN                         │
│                                      │
│  ┌────────────┐      ┌────────────┐ │
│  │ Developer  │      │ Developer  │ │
│  │ Laptop 1   │      │ Laptop 2   │ │
│  └──────┬─────┘      └──────┬─────┘ │
│         │                    │       │
│         └──────┬─────────────┘       │
│                │ SSE                 │
│                ▼                     │
│       ┌────────────────┐             │
│       │ Ansible MCP    │             │
│       │ Server         │             │
│       └────────┬───────┘             │
│                │                     │
│                ▼                     │
│       ┌────────────────┐             │
│       │ Ansible        │             │
│       │ Inventory      │             │
│       │ (100 hosts)    │             │
│       └────────────────┘             │
└──────────────────────────────────────┘
```

### Scenario 2: Enterprise (100+ developers)
```
                    Internet
                       │
                       ▼
              ┌────────────────┐
              │ Load Balancer  │
              │ (HAProxy)      │
              └───┬────────┬───┘
                  │        │
         ┌────────┘        └────────┐
         │                          │
         ▼                          ▼
┌─────────────────┐        ┌─────────────────┐
│ Ansible MCP #1  │        │ Ansible MCP #2  │
│ (SSE)           │        │ (SSE)           │
└────────┬────────┘        └────────┬────────┘
         │                          │
         └────────┬─────────────────┘
                  │
                  ▼
         ┌─────────────────┐
         │ Ansible Tower/  │
         │ AWX (optional)  │
         └────────┬────────┘
                  │
                  ▼
         ┌─────────────────┐
         │ Infrastructure  │
         │ (1000+ hosts)   │
         └─────────────────┘
```

### Scenario 3: Hybrid (Local + Remote)
```
Developer Laptop
├── Local Projects
│   └── Ansible MCP (stdio)
│       └── Local Ansible
│           └── Development hosts
│
└── Remote Projects
    └── Connect to Remote MCP (SSE)
        └── Production Ansible
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

## Security Layers

### Layer 1: Network
```
Internet
   │
   │ Firewall: Only VPN IPs allowed
   ▼
VPN Gateway
   │
   │ VPN tunnel
   ▼
Internal Network
   │
   │ Firewall: Only port 443 allowed
   ▼
Ansible MCP Server
```

### Layer 2: Application
```
Client Request
   │
   │ Check Authorization header
   ▼
Authentication Middleware
   │
   │ Validate Bearer token
   ▼
Rate Limiting
   │
   │ Max 100 req/min per token
   ▼
MCP Request Handler
   │
   │ Validate input, sanitize
   ▼
Ansible Execution
```

### Layer 3: Audit
```
Every Request
   │
   ├──> Log to file: /var/log/ansible-mcp/access.log
   │    (timestamp, user, tool, parameters)
   │
   ├──> Send to SIEM: Splunk/ELK
   │    (real-time monitoring)
   │
   └──> Store in database: audit_trail table
        (compliance, investigations)
```

## Performance Characteristics

### stdio (Local)
```
Request ──> Process Pipe (0ms latency)
         ┗━> Ansible execution (varies)
         ┗━> Response via pipe (0ms latency)
         
Total overhead: ~1ms
```

### SSE (Remote)
```
Request ──> Network (5-50ms)
         ┗━> Nginx processing (1-5ms)
         ┗━> MCP server (1ms)
         ┗━> Ansible execution (varies)
         ┗━> Response via SSE stream (5-50ms)
         
Total overhead: 12-106ms (depending on network)
```

## Scaling Strategy

### Horizontal Scaling
```
                Load Balancer
                      │
        ┌─────────────┼─────────────┐
        │             │             │
        ▼             ▼             ▼
  ┌─────────┐   ┌─────────┐   ┌─────────┐
  │  MCP #1 │   │  MCP #2 │   │  MCP #3 │
  └────┬────┘   └────┬────┘   └────┬────┘
       │             │             │
       └─────────────┼─────────────┘
                     │
                     ▼
           Shared Ansible Config
           (NFS/GlusterFS)
```

### Vertical Scaling
```
Single Server
├── 16+ CPU cores ───> Handle multiple concurrent requests
├── 32+ GB RAM ────> Cache inventory, playbooks
├── SSD storage ───> Fast playbook execution
└── 10Gbps NIC ────> High throughput for many clients
```

## Monitoring

### Metrics to Track
```
┌──────────────────────────────────────┐
│ Ansible MCP Metrics Dashboard        │
├──────────────────────────────────────┤
│                                      │
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

## Comparison Table

| Aspect | stdio | SSE |
|--------|-------|-----|
| **Setup Complexity** | ⭐ Simple | ⭐⭐⭐ Moderate |
| **Performance** | ⭐⭐⭐⭐⭐ Fastest | ⭐⭐⭐⭐ Fast |
| **Multi-Client** | ❌ No | ✅ Yes |
| **Remote Access** | ❌ No | ✅ Yes |
| **Security Setup** | ⭐ Simple | ⭐⭐⭐⭐ Complex |
| **Maintenance** | ⭐ Minimal | ⭐⭐⭐ Regular |
| **Scalability** | ❌ Limited | ✅ Excellent |
| **Production Ready** | ⚠️ Local only | ✅ Yes |
| **Monitoring** | ⭐ Basic | ⭐⭐⭐⭐ Advanced |
| **Cost** | ⭐ Free | ⭐⭐ Infrastructure |

## Decision Matrix

Choose **stdio** if:
- ✅ You work on a single machine
- ✅ You want simplest setup
- ✅ You need lowest latency
- ✅ You don't need remote access

Choose **SSE** if:
- ✅ You have remote Ansible server
- ✅ Multiple people need access
- ✅ You want centralized management
- ✅ You need production deployment
- ✅ You can manage network/security

## Migration Path

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

# Step 4: Update client config
# Change from stdio to SSE in config file

# Step 5: Test from client
curl http://ansible-server:8000/health

# Step 6: (Optional) Add Nginx + SSL
# See REMOTE_SETUP.md

# Step 7: (Optional) Setup systemd
./setup-remote.sh
```

### Rollback plan:
```bash
# If issues, immediately revert client config to stdio
# Server can run both simultaneously on different ports

# stdio (backup)
uv run python server.py  # default stdio

# SSE (testing)
uv run python server.py --transport sse --port 8000
```
