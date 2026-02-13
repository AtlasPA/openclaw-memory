#!/bin/bash
# Claude Code + Memory System Integration
#
# Installation:
#   1. Source this file in your ~/.bashrc or ~/.zshrc:
#      source ~/.openclaw/openclaw-memory/examples/claude-code-integration.sh
#
#   2. Restart your shell or run: source ~/.bashrc
#
# Usage:
#   claw "your question"           # Auto-injects project memories
#   claw-remember "fact to store"  # Store a fact about current project
#   claw-forget "pattern"          # Remove memories matching pattern
#   claw-show                      # Show all memories for current project

# Path to Memory System
MEMORY_CLI="${OPENCLAW_MEMORY_CLI:-$HOME/.openclaw/openclaw-memory/cli.js}"

# Check if Memory System is installed
if [ ! -f "$MEMORY_CLI" ]; then
  echo "Warning: OpenClaw Memory System not found at $MEMORY_CLI"
  echo "Install it first: git clone https://github.com/AtlasPA/openclaw-memory ~/.openclaw/openclaw-memory"
fi

# Main Claude Code wrapper with memory integration
claw() {
  local PROJECT_DIR=$(pwd)
  local PROJECT_NAME=$(basename "$PROJECT_DIR")
  local USER_PROMPT="$*"

  # Get memories for current project
  local MEMORIES=""
  if [ -f "$MEMORY_CLI" ]; then
    MEMORIES=$(node "$MEMORY_CLI" recall \
      --query "$USER_PROMPT" \
      --project "$PROJECT_NAME" \
      --cwd "$PROJECT_DIR" \
      --limit 10 \
      --format markdown \
      2>/dev/null)
  fi

  # Check for .claude-memory.md file
  local MEMORY_FILE=""
  if [ -f ".claude-memory.md" ]; then
    MEMORY_FILE=$(cat .claude-memory.md)
  fi

  # Build full context
  local FULL_CONTEXT=""

  if [ -n "$MEMORIES" ] || [ -n "$MEMORY_FILE" ]; then
    FULL_CONTEXT="# 🧠 Recalled Context

"

    if [ -n "$MEMORY_FILE" ]; then
      FULL_CONTEXT+="## Project Memory (.claude-memory.md)

$MEMORY_FILE

"
    fi

    if [ -n "$MEMORIES" ]; then
      FULL_CONTEXT+="## Semantic Memories (from previous sessions)

$MEMORIES

"
    fi

    FULL_CONTEXT+="---

**User's actual request:** $USER_PROMPT"

    echo "🧠 Injected $(echo "$MEMORIES" | grep -c '^-' || echo 0) memories + project context"
  else
    FULL_CONTEXT="$USER_PROMPT"
    echo "💡 Tip: Create .claude-memory.md or use claw-remember to store project context"
  fi

  # Execute Claude Code with context
  claude-code "$FULL_CONTEXT"
}

# Store a fact about the current project
claw-remember() {
  local FACT="$*"
  local PROJECT_DIR=$(pwd)
  local PROJECT_NAME=$(basename "$PROJECT_DIR")

  if [ -z "$FACT" ]; then
    echo "Usage: claw-remember <fact to remember>"
    echo ""
    echo "Examples:"
    echo "  claw-remember 'Uses React 18 with TypeScript'"
    echo "  claw-remember 'Prefers functional components over classes'"
    echo "  claw-remember 'API endpoint: https://api.example.com'"
    return 1
  fi

  if [ ! -f "$MEMORY_CLI" ]; then
    echo "Error: Memory System not installed"
    return 1
  fi

  node "$MEMORY_CLI" store \
    --content "$FACT" \
    --project "$PROJECT_NAME" \
    --cwd "$PROJECT_DIR" \
    --category "project-context"

  echo "✓ Stored: $FACT"
}

# Remove memories matching a pattern
claw-forget() {
  local PATTERN="$*"
  local PROJECT_DIR=$(pwd)
  local PROJECT_NAME=$(basename "$PROJECT_DIR")

  if [ -z "$PATTERN" ]; then
    echo "Usage: claw-forget <pattern to forget>"
    echo ""
    echo "Examples:"
    echo "  claw-forget 'React 17'    # Remove outdated version info"
    echo "  claw-forget 'old API'     # Remove references to old API"
    return 1
  fi

  if [ ! -f "$MEMORY_CLI" ]; then
    echo "Error: Memory System not installed"
    return 1
  fi

  node "$MEMORY_CLI" delete \
    --query "$PATTERN" \
    --project "$PROJECT_NAME" \
    --cwd "$PROJECT_DIR"

  echo "✓ Forgot memories matching: $PATTERN"
}

# Show all memories for current project
claw-show() {
  local PROJECT_DIR=$(pwd)
  local PROJECT_NAME=$(basename "$PROJECT_DIR")

  if [ ! -f "$MEMORY_CLI" ]; then
    echo "Error: Memory System not installed"
    return 1
  fi

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🧠 Memories for: $PROJECT_NAME"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # Show .claude-memory.md if exists
  if [ -f ".claude-memory.md" ]; then
    echo "## Project Context File (.claude-memory.md)"
    echo ""
    cat .claude-memory.md
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
  fi

  # Show semantic memories
  node "$MEMORY_CLI" list \
    --project "$PROJECT_NAME" \
    --cwd "$PROJECT_DIR" \
    --format table

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Initialize project memory
claw-init() {
  local PROJECT_DIR=$(pwd)
  local PROJECT_NAME=$(basename "$PROJECT_DIR")

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🧠 Initialize Memory for: $PROJECT_NAME"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "This will create a .claude-memory.md file with your project context."
  echo ""

  # Template
  cat > .claude-memory.md <<EOF
# Claude Memory - $PROJECT_NAME

Last updated: $(date +%Y-%m-%d)

## Tech Stack
<!-- List your frameworks, languages, build tools -->
- **Language:**
- **Framework:**
- **Build:**
- **Deployment:**

## Code Style
<!-- Your coding preferences and conventions -->
-
-

## Architecture
<!-- Key architectural decisions -->
- **State management:**
- **API communication:**
- **Testing:**

## Preferences
<!-- Things you do/don't want Claude to do -->
- ✅
- ❌

## Recent Context
<!-- What you're currently working on -->
-

---
<!-- Auto-updated by claw-remember -->
EOF

  echo "✓ Created .claude-memory.md"
  echo ""
  echo "Edit it now: ${EDITOR:-nano} .claude-memory.md"
  echo "Or add facts: claw-remember 'your fact here'"
}

# Export functions
export -f claw
export -f claw-remember
export -f claw-forget
export -f claw-show
export -f claw-init

echo "✓ Claude Code + Memory System integration loaded"
echo ""
echo "Commands:"
echo "  claw <question>           - Ask Claude with auto-injected context"
echo "  claw-remember <fact>      - Store a fact about current project"
echo "  claw-forget <pattern>     - Remove memories matching pattern"
echo "  claw-show                 - Show all memories for this project"
echo "  claw-init                 - Create .claude-memory.md template"
