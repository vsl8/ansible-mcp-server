# Docker Setup for Ansible MCP Server

Complete guide to using Docker with the Ansible MCP Server, including quick start commands, configuration, and production considerations.

## Table of Contents
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Configuration](#configuration)
- [Docker Compose Services](#docker-compose-services)
- [Transport Modes](#transport-modes)
- [Usage Examples](#usage-examples)
- [Integration with MCP Clients](#integration-with-mcp-clients)
- [Troubleshooting](#troubleshooting)
- [Production Considerations](#production-considerations)
- [Cleanup](#cleanup)

---

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose installed
- Git (for cloning)
- Local SSH keys (optional, for Ansible authentication)

### 1. Clone and Setup
```bash
git clone https://github.com/vsl8/ansible-mcp-server.git
cd ansible-mcp-server

# Copy environment file
cp .env.example .env
```

### 2. Build the Image
```bash
docker build -t ansible-mcp:latest .
```

### 3. Run Immediately
Choose your transport mode:

**Option A: Stdio Mode (Default - Local/Integrated Use)**
```bash
docker run --rm -it \
  -v $(pwd):/workspace \
  -v ~/.ssh:/home/ansible/.ssh:ro \
  ansible-mcp:latest
```

**Option B: SSE Mode (Remote/Network Access)**
```bash
docker run --rm -d \
  -p 8000:8000 \
  -v $(pwd):/workspace \
  -v ~/.ssh:/home/ansible/.ssh:ro \
  --name ansible-mcp \
  ansible-mcp:latest \
  python src/ansible_mcp/server.py --transport sse --host 0.0.0.0 --port 8000
```

### 4. Using Docker Compose (Recommended)
```bash
# Start stdio mode (interactive)
docker-compose run --rm ansible-mcp-stdio

# OR start SSE mode (background)
docker-compose up -d ansible-mcp-sse

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

---

## Installation

### Build Options

#### Standard Build
```bash
docker build -t ansible-mcp:latest .
```

#### Build Without Cache (Fresh install)
```bash
docker build --no-cache -t ansible-mcp:latest .
```

#### Build with Docker Compose
```bash
# Build with docker-compose
docker-compose build ansible-mcp-stdio

# Rebuild all services
docker-compose build
```

---

## Configuration

### Environment Variables

Edit `.env` file to customize settings:

```bash
cp .env.example .env
```

**Key Environment Variables:**
- **ANSIBLE_CONFIG_DIR** - Local directory mounted to `/workspace` (default: `.`)
- **SSH_KEY_PATH** - SSH keys path for Ansible authentication (default: `.`)
- **MCP_PORT** - Port for SSE mode (default: `8000`)
- **MCP_HOST** - Host for SSE mode (default: `0.0.0.0`)

### Example .env Configuration
```bash
# Ansible configuration
ANSIBLE_CONFIG_DIR=/path/to/ansible/config
SSH_KEY_PATH=$HOME/.ssh

# MCP Server settings
MCP_PORT=8000
MCP_HOST=0.0.0.0

# Optional: Ansible project settings
# MCP_ANSIBLE_PROJECT_ROOT=/workspace
# MCP_ANSIBLE_ROLES_PATH=/workspace/roles
# MCP_ANSIBLE_COLLECTIONS_PATHS=/workspace/collections
```

### Volume Mounts

| Host Path | Container Path | Purpose | Mode |
|-----------|----------------|---------|------|
| `$ANSIBLE_CONFIG_DIR` | `/workspace` | Ansible playbooks, roles, inventory | RW |
| `$SSH_KEY_PATH` | `/home/ansible/.ssh` | SSH keys for Ansible | RO |

---

## Docker Compose Services

### Available Services

1. **ansible-mcp-stdio** (Default)
   - Transport: Stdio (standard input/output)
   - Port: Not exposed
   - Interactive: Yes (tty)
   - Use Case: Local IDE integration (VS Code, Cursor, Copilot CLI)

2. **ansible-mcp-sse** (Optional)
   - Transport: SSE (Server-Sent Events)
   - Port: 8000 (configurable)
   - Interactive: No
   - Use Case: Remote access, Claude, GPT integration
   - Profile: `sse`

3. **ansible-control** (Optional)
   - Purpose: Additional control node for testing
   - Profile: `control`

### Using Profiles

Enable optional services with compose profiles:

```bash
# Enable SSE mode only
docker-compose --profile sse up

# Enable both SSE and control node
COMPOSE_PROFILES=sse,control docker-compose up

# Or modify .env file
echo "COMPOSE_PROFILES=sse,control" >> .env
docker-compose up
```

---

## Transport Modes

### Stdio Mode (Default)
- **Best for**: VS Code, Cursor, GitHub Copilot CLI
- **Communication**: Direct stdin/stdout
- **Port**: Not exposed
- **Interactive**: Yes
- **Command**: `docker-compose run --rm ansible-mcp-stdio`
- **Docker run**: `docker run --rm -it ansible-mcp:latest`

### SSE Mode (Optional)
- **Best for**: Remote access, Claude, OpenAI GPT
- **Communication**: HTTP with Server-Sent Events
- **Port**: 8000 (configurable)
- **Interactive**: No
- **Command**: `docker-compose up ansible-mcp-sse`
- **Docker run**: `docker run --rm -d -p 8000:8000 ansible-mcp:latest python src/ansible_mcp/server.py --transport sse --host 0.0.0.0 --port 8000`

### Transport Comparison

| Aspect | Stdio | SSE |
|--------|-------|-----|
| Network | Local only | Network accessible |
| Setup | Simple | Requires port mapping |
| Security | No auth needed | Add reverse proxy auth |
| Latency | Very low | Network dependent |
| Use Case | Local dev | Remote/cloud |

---

## 📊 Image Details

- **Base Image**: `python:3.10-slim`
- **Final Size**: ~800 MB (optimized with multi-stage build)
- **Builder Size**: ~1.2 GB (discarded)
- **Python Version**: 3.10+
- **Runtime User**: `ansible` (non-root, UID 1000)
- **Health Check**: Built-in TCP health check on port 8000
- **Included Tools**: Ansible, SSH client, Git

### Security Features
✅ Non-root user (`ansible:1000`)  
✅ Read-only SSH key mounts  
✅ Minimal base image  
✅ No unnecessary packages  
✅ Health check enabled  

---

## Usage Examples

### Example 1: Run Playbooks from Docker

```bash
# Create .env if not exists
cp .env.example .env

# Run with docker-compose
docker-compose run --rm ansible-mcp-stdio \
  -i /workspace/inventory.ini \
  /workspace/playbooks/site.yml
```

### Example 2: SSH Key Configuration

```bash
# Mount SSH keys from your machine
docker-compose run --rm \
  -e SSH_KEY_PATH=$HOME/.ssh \
  ansible-mcp-stdio
```

### Example 3: Custom Ansible Configuration

```bash
# Use custom ansible.cfg
docker-compose run --rm \
  -e ANSIBLE_CONFIG=/workspace/ansible.cfg \
  ansible-mcp-stdio
```

### Example 4: SSE Mode with Health Check

```bash
# Start in background with health check
docker-compose --profile sse up -d

# Check status
docker-compose --profile sse ps

# Test the server
curl http://localhost:8000/health

# View logs with timestamps
docker-compose --profile sse logs -f --timestamps ansible-mcp-sse
```

### Example 5: Interactive Control Node

```bash
# Start control node for testing
COMPOSE_PROFILES=control docker-compose run --rm ansible-control bash

# Inside container, you can run ansible commands
ansible --version
ansible-galaxy collection list
```

### Example 6: Resource Limits

```bash
# Run with CPU and memory limits
docker run --rm -it \
  --cpus="2" \
  --memory="2g" \
  -v $(pwd):/workspace \
  ansible-mcp:latest
```

---

## Integration with MCP Clients

### VS Code / Cursor (with stdio mode)

Add to `.vscode/settings.json`:
```json
{
  "tools": [
    {
      "name": "ansible-mcp",
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "-v",
        "${workspaceFolder}:/workspace",
        "-v",
        "${HOME}/.ssh:/home/ansible/.ssh:ro",
        "ansible-mcp:latest"
      ]
    }
  ]
}
```

### GitHub Copilot CLI

```bash
# Use docker run directly in your copilot config
gh copilot config set mcp_server:ansible \
  "docker run --rm -i -v $(pwd):/workspace -v ~/.ssh:/home/ansible/.ssh:ro ansible-mcp:latest"
```

### Claude / GPT (with SSE mode)

```json
{
  "mcp_servers": {
    "ansible": {
      "url": "http://localhost:8000",
      "transport": "sse"
    }
  }
}
```

### Cursor IDE

Add to `.cursor/mcp_servers.json`:
```json
{
  "servers": {
    "ansible": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "-v",
        "${workspaceFolder}:/workspace",
        "-v",
        "${HOME}/.ssh:/home/ansible/.ssh:ro",
        "ansible-mcp:latest"
      ]
    }
  }
}
```

---

## Troubleshooting

### Issue: Permission Denied for SSH Keys

**Symptom**: `Permission denied` when accessing SSH keys

**Solution**: Ensure SSH keys are readable:
```bash
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

### Issue: Ansible Module Not Found

**Symptom**: `ModuleNotFoundError` or module not available

**Solution**: Install additional Ansible collections in the container:
```bash
docker-compose run --rm ansible-mcp-stdio \
  ansible-galaxy collection install community.general
```

Or build a custom image with pre-installed collections:
```bash
# Add to Dockerfile USER section
RUN ansible-galaxy collection install community.general
```

### Issue: Container Can't Access Local Hosts

**Symptom**: Connection timeout to local machines

**Solution 1**: Use host network mode (macOS/Linux only):
```bash
docker run --rm -it --network host \
  -v $(pwd):/workspace \
  ansible-mcp:latest
```

**Solution 2**: Use Docker host gateway:
```bash
docker run --rm -it \
  -v $(pwd):/workspace \
  --add-host=host.docker.internal:host-gateway \
  ansible-mcp:latest
```

### Issue: Port 8000 Already in Use

**Symptom**: `Error response from daemon: Ports are not available`

**Solution**: Change the port in `.env`:
```bash
MCP_PORT=9000
```

Then restart:
```bash
docker-compose --profile sse down
docker-compose --profile sse up
```

Or use docker run with different port:
```bash
docker run --rm -d -p 9000:8000 ansible-mcp:latest
```

### Issue: Container Exits Immediately

**Symptom**: Container starts and stops without error

**Solution**: Check logs for actual error:
```bash
# Stdio mode - should stay running
docker-compose run ansible-mcp-stdio

# SSE mode - check logs
docker-compose logs ansible-mcp-sse
```

### Issue: Slow Build Time

**Symptom**: Docker build takes too long

**Solution**: The first build is slow. Subsequent builds use cache:
```bash
# Check build progress
docker build --progress=plain -t ansible-mcp:latest .

# Use BuildKit for faster builds (if available)
DOCKER_BUILDKIT=1 docker build -t ansible-mcp:latest .
```

### Issue: Out of Disk Space

**Symptom**: Docker build fails with "no space left on device"

**Solution**: Clean up unused Docker resources:
```bash
# Remove unused images
docker image prune -a

# Remove unused containers
docker container prune

# Remove unused volumes
docker volume prune

# Complete cleanup
docker system prune -a --volumes
```

---

## Production Considerations

### 1. **Non-root User**
The container runs as `ansible:1000` user for security. This prevents privilege escalation attacks.

### 2. **Health Checks**
Built-in health check monitors server availability. The check runs every 30 seconds with a 10-second timeout and 3-retry limit.

Monitor health:
```bash
docker-compose logs ansible-mcp-sse | grep health
```

### 3. **Logging**
Container logs to stdout for Docker log collection. Use standard Docker logging drivers:

```bash
# View logs
docker-compose logs -f

# View with timestamps
docker-compose logs -f --timestamps

# View last N lines
docker-compose logs --tail 100
```

### 4. **Resource Limits**
Set resource limits to prevent runaway consumption:

```bash
# In docker-compose.yml or via command line
docker run --rm -it \
  --cpus="2" \
  --memory="2g" \
  ansible-mcp:latest
```

### 5. **Networking**
Use a reverse proxy (nginx, HAProxy) for SSE mode in production:

```nginx
server {
    listen 80;
    server_name mcp.example.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Connection "upgrade";
        proxy_set_header Upgrade $http_upgrade;
    }
}
```

### 6. **Persistent Storage**
For persistent playbooks/roles, use Docker volumes:

```bash
docker volume create ansible-workspace

docker run --rm -it \
  --mount source=ansible-workspace,target=/workspace \
  ansible-mcp:latest
```

### 7. **Security Hardening**
- Run with read-only filesystem (except /tmp): `--read-only`
- Drop capabilities: `--cap-drop=ALL`
- Use AppArmor or SELinux profiles
- Enable user namespaces for isolation

---

## Performance Optimization

### Multi-stage Build Benefits
- **Reduced Image Size**: Development tools removed in final image
- **Faster Deployment**: Only runtime dependencies included
- **Security**: Less attack surface with minimal base image

### Build Caching
Docker caches build layers. For faster rebuilds:
```bash
# Use cache (default)
docker build -t ansible-mcp:latest .

# Invalidate cache from a specific layer
docker build --build-arg CACHEBUST=$(date +%s) -t ansible-mcp:latest .
```

### Image Optimization
- **Final image size**: ~800 MB
- **Builder stage**: ~1.2 GB (discarded)
- **Layers**: Minimized with multi-stage build

---

## File Descriptions

| File | Purpose | Size |
|------|---------|------|
| **Dockerfile** | Multi-stage build definition. Creates optimized Python 3.10 image with Ansible and dependencies | 1.7 KB |
| **docker-compose.yml** | Orchestration for stdio, SSE, and control services with networking and volume management | 2.1 KB |
| **.env.example** | Template for environment variables with documentation | 2.6 KB |
| **docs/DOCKER.md** | This comprehensive guide | ~9 KB |

---

## Cleanup

### Remove Running Containers
```bash
# Stop and remove specific service
docker-compose down

# Remove specific container
docker rm container-name

# Remove all stopped containers
docker container prune
```

### Remove Image
```bash
# Remove specific image
docker rmi ansible-mcp:latest

# Remove all unused images
docker image prune -a
```

### Remove Everything (including volumes)
```bash
# Warning: This removes all containers, images, and volumes
docker-compose down -v
docker rmi ansible-mcp:latest
docker volume prune -a
```

### Advanced Cleanup
```bash
# Remove everything (containers, images, volumes, networks)
docker system prune -a --volumes

# Check disk usage
docker system df
```

---

## FAQ

**Q: Can I run multiple instances?**
A: Yes, use different container names and ports:
```bash
docker run -d -p 8000:8000 --name mcp-1 ansible-mcp:latest
docker run -d -p 8001:8000 --name mcp-2 ansible-mcp:latest
```

**Q: How do I update to a newer version?**
A: Pull changes and rebuild:
```bash
git pull
docker build --no-cache -t ansible-mcp:latest .
```

**Q: Can I use this with Kubernetes?**
A: Yes, build the image and push to your registry. See Kubernetes documentation for deployment.

**Q: Does it work on Windows?**
A: Yes, with Docker Desktop. Use WSL2 backend for best performance.

**Q: How do I pass additional Ansible arguments?**
A: Override the command in docker run or adjust docker-compose.yml.

---

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Ansible Documentation](https://docs.ansible.com/)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [Python 3.10 Documentation](https://docs.python.org/3.10/)

---

**Last Updated**: 2024  
**Maintainer**: Ansible MCP Server Contributors  
**Documentation Version**: 1.0
