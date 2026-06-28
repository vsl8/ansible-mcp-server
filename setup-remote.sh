#!/bin/bash
# Quick setup script for Ansible MCP Server with SSE transport

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Ansible MCP Remote Setup (SSE)       ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo -e "${YELLOW}Warning: Ansible not found. Installing...${NC}"
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y ansible
    elif command -v yum &> /dev/null; then
        sudo yum install -y ansible
    else
        echo -e "${RED}Error: Could not install Ansible. Please install manually.${NC}"
        exit 1
    fi
fi

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo -e "${YELLOW}Installing uv package manager...${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install dependencies
echo -e "${GREEN}Installing Python dependencies...${NC}"
uv sync

# Get configuration from user
read -p "Enter host to bind (default: 0.0.0.0): " HOST
HOST=${HOST:-0.0.0.0}

read -p "Enter port (default: 8000): " PORT
PORT=${PORT:-8000}

read -p "Create systemd service? (y/n, default: n): " CREATE_SERVICE
CREATE_SERVICE=${CREATE_SERVICE:-n}

if [ "$CREATE_SERVICE" = "y" ]; then
    echo -e "${GREEN}Creating systemd service...${NC}"
    
    SERVICE_FILE="/etc/systemd/system/ansible-mcp.service"
    CURRENT_USER=$(whoami)
    CURRENT_DIR=$(pwd)
    
    sudo tee $SERVICE_FILE > /dev/null <<EOF
[Unit]
Description=Ansible MCP Server with SSE
After=network.target

[Service]
Type=simple
User=$CURRENT_USER
WorkingDirectory=$CURRENT_DIR
Environment="PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin"
ExecStart=$HOME/.local/bin/uv run python src/ansible_mcp/server.py --transport sse --host $HOST --port $PORT
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
    
    sudo systemctl daemon-reload
    sudo systemctl enable ansible-mcp
    sudo systemctl start ansible-mcp
    
    echo -e "${GREEN}✓ Systemd service created and started${NC}"
    echo -e "  Check status: sudo systemctl status ansible-mcp"
    echo -e "  View logs: sudo journalctl -u ansible-mcp -f"
else
    echo -e "${GREEN}Starting server manually...${NC}"
    echo -e "${YELLOW}Note: Server will stop when terminal closes. Use systemd for persistent service.${NC}"
    echo
    exec uv run python src/ansible_mcp/server.py --transport sse --host $HOST --port $PORT
fi

# Firewall configuration
read -p "Configure firewall to allow port $PORT? (y/n, default: n): " CONFIG_FIREWALL
if [ "$CONFIG_FIREWALL" = "y" ]; then
    if command -v ufw &> /dev/null; then
        echo -e "${GREEN}Configuring UFW...${NC}"
        sudo ufw allow $PORT/tcp
        echo -e "${GREEN}✓ UFW configured${NC}"
    elif command -v firewall-cmd &> /dev/null; then
        echo -e "${GREEN}Configuring firewalld...${NC}"
        sudo firewall-cmd --permanent --add-port=$PORT/tcp
        sudo firewall-cmd --reload
        echo -e "${GREEN}✓ Firewalld configured${NC}"
    else
        echo -e "${YELLOW}No supported firewall found. Please configure manually.${NC}"
    fi
fi

echo
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Setup Complete!                       ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo
echo -e "Server Address: ${GREEN}http://$(hostname -I | awk '{print $1}'):$PORT/sse${NC}"
echo
echo "Client Configuration Example:"
echo -e "${YELLOW}"
cat <<EOF
{
  "mcpServers": {
    "ansible-remote": {
      "url": "http://$(hostname -I | awk '{print $1}'):$PORT/sse",
      "transport": "sse"
    }
  }
}
EOF
echo -e "${NC}"
echo
echo "Test connection:"
echo -e "  curl http://localhost:$PORT/health"
echo
echo "Documentation: See Docs/REMOTE_SETUP.md for detailed setup"
