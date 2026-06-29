# Multi-stage build for Ansible MCP Server
FROM python:3.10-slim as builder

WORKDIR /build

# Install system dependencies required for building
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv package manager
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Copy project files
COPY . .

# Install dependencies using uv
RUN /root/.cargo/bin/uv sync --no-dev


# Final stage
FROM python:3.10-slim

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ansible \
    openssh-client \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy virtual environment from builder
COPY --from=builder /build/.venv /app/.venv

# Copy application code
COPY --from=builder /build/src /app/src
COPY --from=builder /build/pyproject.toml /app/
COPY --from=builder /build/uv.lock /app/

# Set environment variables
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Create non-root user for security
RUN useradd -m -u 1000 ansible && \
    chown -R ansible:ansible /app

USER ansible

# Health check to verify server is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import socket; socket.create_connection(('127.0.0.1', 8000), timeout=5)" || exit 1

# Expose port for SSE transport (optional)
EXPOSE 8000

# Default entrypoint for stdio mode (default MCP transport)
ENTRYPOINT ["python", "src/ansible_mcp/server.py"]

# For SSE mode, override with:
# CMD ["python", "src/ansible_mcp/server.py", "--transport", "sse", "--host", "0.0.0.0", "--port", "8000"]
