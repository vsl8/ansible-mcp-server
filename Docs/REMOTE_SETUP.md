# Remote Ansible Server Setup with SSE Protocol

This guide explains how to configure the Ansible MCP Server on a remote server and connect it using SSE (Server-Sent Events) protocol.

## Architecture Overview

```
┌─────────────────┐         SSE/HTTP          ┌──────────────────────┐
│   AI Client     │ ◄──────────────────────► │  Remote Ansible MCP  │
│ (VS Code/Claude)│      (Port 8000)          │      Server          │
└─────────────────┘                           └──────────────────────┘
                                                        │
                                                        │ SSH
                                                        ▼
                                              ┌──────────────────────┐
                                              │  Ansible Control     │
                                              │    Node(s)           │
                                              └──────────────────────┘
```

## Installation on Remote Server

### 1. Install on Remote Ansible Server

SSH into your remote server where Ansible is configured:

```bash
ssh user@remote-ansible-server

# Install uv package manager
curl -LsSf https://astral.sh/uv/install.sh | sh

# Clone or copy the ansible-mcp project
git clone https://github.com/vsl8/ansible-mcp-server.git
cd ansible-mcp-server

# Install dependencies
uv sync

# Verify Ansible is available
ansible --version
```

### 2. Start MCP Server with SSE Transport

#### Option A: Start with default settings (0.0.0.0:8000)

```bash
uv run python src/ansible_mcp/server.py --transport sse
```

#### Option B: Custom host and port

```bash
uv run python src/ansible_mcp/server.py --transport sse --host 0.0.0.0 --port 8080
```

#### Option C: Run as systemd service (recommended for production)

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

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable ansible-mcp
sudo systemctl start ansible-mcp
sudo systemctl status ansible-mcp
```

### 3. Firewall Configuration

Allow access to the MCP port:

```bash
# UFW (Ubuntu/Debian)
sudo ufw allow 8000/tcp

# Firewalld (RHEL/CentOS)
sudo firewall-cmd --permanent --add-port=8000/tcp
sudo firewall-cmd --reload

# iptables
sudo iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
```

### 4. Nginx Reverse Proxy (Optional but Recommended)

For SSL/TLS encryption, use Nginx as reverse proxy:

```nginx
# /etc/nginx/sites-available/ansible-mcp
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

Enable and reload:

```bash
sudo ln -s /etc/nginx/sites-available/ansible-mcp /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## Client Configuration

### Claude Desktop App

Edit `~/.config/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "ansible-remote": {
      "url": "http://remote-ansible-server:8000/sse",
      "transport": "sse"
    }
  }
}
```

Or with SSL/Nginx:

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

### VS Code with Copilot

Edit `.vscode/settings.json` in your project or user settings:

```json
{
  "mcp.servers": {
    "ansible-remote": {
      "type": "sse",
      "url": "http://remote-ansible-server:8000/sse"
    }
  }
}
```

### Cline (VS Code Extension)

Edit Cline MCP settings:

```json
{
  "mcpServers": {
    "ansible-remote": {
      "url": "http://remote-ansible-server:8000/sse",
      "transport": "sse"
    }
  }
}
```

## Security Considerations

### 1. Authentication (Recommended for Production)

Add authentication token support by modifying `server.py`:

```python
# Add at the top of server.py
import secrets
from functools import wraps

# Generate token: python -c "import secrets; print(secrets.token_urlsafe(32))"
AUTH_TOKEN = os.getenv("ANSIBLE_MCP_TOKEN")

def require_auth(handler):
    @wraps(handler)
    async def wrapper(request):
        token = request.headers.get("Authorization", "").replace("Bearer ", "")
        if AUTH_TOKEN and token != AUTH_TOKEN:
            return web.Response(status=401, text="Unauthorized")
        return await handler(request)
    return wrapper
```

Set environment variable:

```bash
export ANSIBLE_MCP_TOKEN="your-secure-token-here"
```

Update client config:

```json
{
  "mcpServers": {
    "ansible-remote": {
      "url": "http://remote-ansible-server:8000/sse",
      "transport": "sse",
      "headers": {
        "Authorization": "Bearer your-secure-token-here"
      }
    }
  }
}
```

### 2. Network Security

- **Use VPN**: Connect client to remote server via VPN
- **SSH Tunnel**: Create SSH tunnel for secure connection
- **IP Whitelist**: Restrict access to known IP addresses
- **TLS/SSL**: Always use HTTPS in production (via Nginx)

### 3. SSH Tunnel Alternative

Instead of exposing port directly, use SSH tunnel:

```bash
# On client machine
ssh -L 8000:localhost:8000 user@remote-ansible-server

# Keep this connection open
```

Then configure client to use `http://localhost:8000/sse`

## Testing Connection

### 1. Health Check

```bash
curl http://remote-ansible-server:8000/health
```

### 2. Test Tool Execution

```bash
curl -X POST http://remote-ansible-server:8000/sse \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/call",
    "params": {
      "name": "ansible-ping",
      "arguments": {
        "host_pattern": "localhost"
      }
    },
    "id": 1
  }'
```

### 3. Client-Side Testing

In Claude or VS Code, try:

```
Test ansible connection to localhost
```

## Troubleshooting

### Server not accessible

```bash
# Check if server is running
sudo netstat -tlnp | grep 8000

# Check logs
sudo journalctl -u ansible-mcp -f

# Test locally on server
curl http://localhost:8000/health
```

### Firewall issues

```bash
# Test from client
telnet remote-ansible-server 8000

# If connection refused, check firewall
sudo iptables -L -n | grep 8000
```

### Permission issues

```bash
# Ensure ansible user has proper permissions
sudo usermod -aG ansible <service-user>

# Check Ansible config
ansible --version
ansible-config dump
```

## Performance Considerations

### Connection Pooling

SSE maintains persistent connections. For high-load scenarios:

- Increase system file descriptor limits
- Use connection pooling in clients
- Monitor server resources

```bash
# Increase file descriptors
ulimit -n 65535

# In systemd service
LimitNOFILE=65535
```

### Scaling

For multiple Ansible servers:

- Deploy multiple MCP instances
- Use load balancer (HAProxy/Nginx)
- Configure client with multiple endpoints

## Comparison: stdio vs SSE

| Feature | stdio (Local) | SSE (Remote) |
|---------|--------------|--------------|
| Use Case | Same machine | Remote server |
| Transport | stdin/stdout | HTTP |
| Security | Process isolation | Network + auth |
| Performance | Fastest | Network latency |
| Scalability | Single client | Multiple clients |
| Firewall | None needed | Port configuration |

## Example: Complete Remote Setup

```bash
# On remote server
cd /opt
sudo git clone https://github.com/vsl8/ansible-mcp-server.git
cd ansible-mcp-server
uv sync

# Start server
uv run python src/ansible_mcp/server.py --transport sse --host 0.0.0.0 --port 8000

# On client machine (Claude Desktop)
# Edit ~/.config/Claude/claude_desktop_config.json
{
  "mcpServers": {
    "ansible-prod": {
      "url": "http://ansible.internal:8000/sse",
      "transport": "sse"
    }
  }
}

# Test in Claude
"Show me all hosts in Ansible inventory"
```

## Advanced: Multi-Server Configuration

Connect to multiple Ansible environments:

```json
{
  "mcpServers": {
    "ansible-prod": {
      "url": "https://ansible-prod.company.com/sse",
      "transport": "sse"
    },
    "ansible-staging": {
      "url": "https://ansible-staging.company.com/sse",
      "transport": "sse"
    },
    "ansible-local": {
      "command": "uv",
      "args": ["run", "python", "/path/to/ansible-mcp/src/ansible_mcp/server.py"],
      "transport": "stdio"
    }
  }
}
```

## Support

For issues or questions:
- GitHub: https://github.com/vsl8/ansible-mcp-server/issues
- Documentation: See `/Docs` folder

## Next Steps

1. ✅ Install on remote server
2. ✅ Start with SSE transport
3. ✅ Configure firewall
4. ✅ Update client config
5. ✅ Test connection
6. ✅ Add authentication (production)
7. ✅ Setup monitoring
