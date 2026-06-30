# Plan: GitHub Copilot Agent for Ansible MCP Server

## Problem Statement

Create a GitHub Copilot CLI Agent that acts as an **Infrastructure Operator** for the Ansible MCP Server. The agent should:
- Automatically invoke the default registered project
- Select the appropriate MCP tool based on user prompts
- Manage hosts, run playbooks, and monitor infrastructure health

## Proposed Approach

Use GitHub Copilot's **Custom Agents** feature via `.github/agents/` folder to define an agent that:
1. Has expert knowledge of all 36 Ansible MCP tools
2. Understands the project structure and default configuration
3. Routes user requests to the correct tool with proper parameters
4. Provides intelligent responses with operational context

## Architecture Overview

```
.github/
└── agents/
    └── ansible-operator.md      # Main agent definition
```

The agent will leverage:
- The existing MCP server tools (already available via `ansible-remote-*`)
- Default project configuration from `~/.config/mcp-ansible/config.json`
- Tool descriptions from SKILLS.md for intelligent routing

---

## Todos

### 1. Create Agent Definition File
**ID:** `create-agent-file`
**Description:** Create `.github/agents/ansible-operator.md` with:
- Agent name, description, and trigger keywords
- System prompt defining Infrastructure Operator persona
- Tool routing instructions and decision trees
- Default project behavior configuration

### 2. Define Tool Routing Logic
**ID:** `tool-routing`  
**Depends on:** `create-agent-file`
**Description:** Document how the agent selects tools based on user intent:
- **Connectivity checks** → `ansible-ping`
- **Run playbook** → `ansible-playbook` or `project-run-playbook`
- **System info** → `ansible-gather-facts`
- **Health checks** → `ansible-diagnose-host`
- **Service management** → `ansible-service-manager`
- **Inventory queries** → `inventory-parse`, `inventory-graph`
- **Remote commands** → `ansible-remote-command`
- **Log analysis** → `ansible-fetch-logs`, `ansible-log-hunter`
- **Monitoring** → `ansible-health-monitor`

### 3. Add Default Project Handling
**ID:** `default-project`
**Depends on:** `tool-routing`
**Description:** Add instructions for the agent to:
- Call `list-projects` on first interaction to identify default
- Store default project context for session
- Automatically pass `project_root` parameter from default project

### 4. Create Example Prompts Section
**ID:** `example-prompts`
**Depends on:** `default-project`
**Description:** Add documented examples showing:
- "Check if all web servers are reachable"
- "Run the deploy playbook on production"
- "Show me the health of the test environment"
- "What services are failing on dev servers?"
- "Gather facts from database servers"

### 5. Add Safety Guidelines
**ID:** `safety-guidelines`
**Depends on:** `example-prompts`
**Description:** Include safety instructions:
- Always confirm before destructive operations
- Use `--check` mode for unfamiliar playbooks
- Warn about production environments
- Recommend baseline capture before changes

### 6. Test Agent Invocation
**ID:** `test-agent`
**Depends on:** `safety-guidelines`
**Description:** Test the agent by:
- Invoking `@ansible-operator` with sample prompts
- Verifying correct tool selection
- Confirming default project is used
- Checking response quality

---

## File Structure to Create

```
.github/
└── agents/
    └── ansible-operator.md   # ~200-300 lines
```

## Agent Configuration Details

### Name
`ansible-operator`

### Trigger
`@ansible-operator` or auto-triggered when working in ansible-mcp repo

### Model
Will use the model configured in Copilot CLI (no override needed)

### Tools Available
All 36 tools from the Ansible MCP Server via `ansible-remote-*` prefix

---

## Key Design Decisions

1. **Single file agent** - Keep all instructions in one `.md` file for simplicity
2. **Default project first** - Always try default project before asking
3. **Tool descriptions inline** - Include brief tool descriptions so the agent knows capabilities without calling `list-tools`
4. **Safety by default** - Suggest dry-run/check mode for unknown operations
5. **Conversational** - Respond naturally, not just raw tool output

---

## Success Criteria

- [ ] Agent responds to `@ansible-operator` trigger
- [ ] Agent uses default project without prompting
- [ ] Agent selects correct tool for given intent
- [ ] Agent provides helpful context with responses
- [ ] Agent warns before destructive operations

---

## Notes

- The agent definition uses markdown with YAML frontmatter
- No code required - just instructions and examples
- Agent inherits all MCP tools configured in the environment
- Future enhancement: Add more personas (troubleshooter, security auditor)
