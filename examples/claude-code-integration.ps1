# Claude Code + Memory System Integration (PowerShell)
#
# Installation:
#   1. Add to your PowerShell profile:
#      Add-Content $PROFILE "`n. `"$env:USERPROFILE\.openclaw\openclaw-memory\examples\claude-code-integration.ps1`""
#
#   2. Restart PowerShell or run: . $PROFILE
#
# Usage:
#   claw "your question"           # Auto-injects project memories
#   claw-remember "fact to store"  # Store a fact about current project
#   claw-forget "pattern"          # Remove memories matching pattern
#   claw-show                      # Show all memories for current project

# Path to Memory System
$MEMORY_CLI = if ($env:OPENCLAW_MEMORY_CLI) {
    $env:OPENCLAW_MEMORY_CLI
} else {
    "$env:USERPROFILE\.openclaw\openclaw-memory\cli.js"
}

# Check if Memory System is installed
if (-not (Test-Path $MEMORY_CLI)) {
    Write-Warning "OpenClaw Memory System not found at $MEMORY_CLI"
    Write-Host "Install it first: git clone https://github.com/AtlasPA/openclaw-memory $env:USERPROFILE\.openclaw\openclaw-memory"
}

# Main Claude Code wrapper with memory integration
function claw {
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$UserPrompt
    )

    $PROJECT_DIR = Get-Location
    $PROJECT_NAME = Split-Path -Leaf $PROJECT_DIR
    $PROMPT_TEXT = $UserPrompt -join " "

    # Get memories for current project
    $MEMORIES = ""
    if (Test-Path $MEMORY_CLI) {
        try {
            $MEMORIES = node $MEMORY_CLI recall `
                --query $PROMPT_TEXT `
                --project $PROJECT_NAME `
                --cwd $PROJECT_DIR `
                --limit 10 `
                --format markdown 2>$null
        } catch {
            # Silently ignore if Memory System not set up yet
        }
    }

    # Check for .claude-memory.md file
    $MEMORY_FILE = ""
    if (Test-Path ".claude-memory.md") {
        $MEMORY_FILE = Get-Content ".claude-memory.md" -Raw
    }

    # Build full context
    $FULL_CONTEXT = ""

    if ($MEMORIES -or $MEMORY_FILE) {
        $FULL_CONTEXT = "# 🧠 Recalled Context`n`n"

        if ($MEMORY_FILE) {
            $FULL_CONTEXT += "## Project Memory (.claude-memory.md)`n`n"
            $FULL_CONTEXT += "$MEMORY_FILE`n`n"
        }

        if ($MEMORIES) {
            $FULL_CONTEXT += "## Semantic Memories (from previous sessions)`n`n"
            $FULL_CONTEXT += "$MEMORIES`n`n"
        }

        $FULL_CONTEXT += "---`n`n**User's actual request:** $PROMPT_TEXT"

        $memoryCount = ($MEMORIES -split "`n" | Where-Object { $_ -match '^-' }).Count
        Write-Host "🧠 Injected $memoryCount memories + project context" -ForegroundColor Green
    } else {
        $FULL_CONTEXT = $PROMPT_TEXT
        Write-Host "💡 Tip: Create .claude-memory.md or use claw-remember to store project context" -ForegroundColor Yellow
    }

    # Execute Claude Code with context
    claude-code $FULL_CONTEXT
}

# Store a fact about the current project
function claw-remember {
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Fact
    )

    $FACT_TEXT = $Fact -join " "
    $PROJECT_DIR = Get-Location
    $PROJECT_NAME = Split-Path -Leaf $PROJECT_DIR

    if (-not $FACT_TEXT) {
        Write-Host "Usage: claw-remember <fact to remember>`n"
        Write-Host "Examples:"
        Write-Host "  claw-remember 'Uses React 18 with TypeScript'"
        Write-Host "  claw-remember 'Prefers functional components over classes'"
        Write-Host "  claw-remember 'API endpoint: https://api.example.com'"
        return
    }

    if (-not (Test-Path $MEMORY_CLI)) {
        Write-Error "Memory System not installed"
        return
    }

    node $MEMORY_CLI store `
        --content $FACT_TEXT `
        --project $PROJECT_NAME `
        --cwd $PROJECT_DIR `
        --category "project-context"

    Write-Host "✓ Stored: $FACT_TEXT" -ForegroundColor Green
}

# Remove memories matching a pattern
function claw-forget {
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Pattern
    )

    $PATTERN_TEXT = $Pattern -join " "
    $PROJECT_DIR = Get-Location
    $PROJECT_NAME = Split-Path -Leaf $PROJECT_DIR

    if (-not $PATTERN_TEXT) {
        Write-Host "Usage: claw-forget <pattern to forget>`n"
        Write-Host "Examples:"
        Write-Host "  claw-forget 'React 17'    # Remove outdated version info"
        Write-Host "  claw-forget 'old API'     # Remove references to old API"
        return
    }

    if (-not (Test-Path $MEMORY_CLI)) {
        Write-Error "Memory System not installed"
        return
    }

    node $MEMORY_CLI delete `
        --query $PATTERN_TEXT `
        --project $PROJECT_NAME `
        --cwd $PROJECT_DIR

    Write-Host "✓ Forgot memories matching: $PATTERN_TEXT" -ForegroundColor Green
}

# Show all memories for current project
function claw-show {
    $PROJECT_DIR = Get-Location
    $PROJECT_NAME = Split-Path -Leaf $PROJECT_DIR

    if (-not (Test-Path $MEMORY_CLI)) {
        Write-Error "Memory System not installed"
        return
    }

    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "🧠 Memories for: $PROJECT_NAME" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""

    # Show .claude-memory.md if exists
    if (Test-Path ".claude-memory.md") {
        Write-Host "## Project Context File (.claude-memory.md)" -ForegroundColor Yellow
        Write-Host ""
        Get-Content ".claude-memory.md"
        Write-Host ""
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
        Write-Host ""
    }

    # Show semantic memories
    node $MEMORY_CLI list `
        --project $PROJECT_NAME `
        --cwd $PROJECT_DIR `
        --format table

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
}

# Initialize project memory
function claw-init {
    $PROJECT_DIR = Get-Location
    $PROJECT_NAME = Split-Path -Leaf $PROJECT_DIR
    $DATE = Get-Date -Format "yyyy-MM-dd"

    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "🧠 Initialize Memory for: $PROJECT_NAME" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "This will create a .claude-memory.md file with your project context."
    Write-Host ""

    # Template
    $template = @"
# Claude Memory - $PROJECT_NAME

Last updated: $DATE

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
"@

    Set-Content -Path ".claude-memory.md" -Value $template

    Write-Host "✓ Created .claude-memory.md" -ForegroundColor Green
    Write-Host ""
    Write-Host "Edit it now: notepad .claude-memory.md"
    Write-Host "Or add facts: claw-remember 'your fact here'"
}

Write-Host "✓ Claude Code + Memory System integration loaded" -ForegroundColor Green
Write-Host ""
Write-Host "Commands:"
Write-Host "  claw <question>           - Ask Claude with auto-injected context"
Write-Host "  claw-remember <fact>      - Store a fact about current project"
Write-Host "  claw-forget <pattern>     - Remove memories matching pattern"
Write-Host "  claw-show                 - Show all memories for this project"
Write-Host "  claw-init                 - Create .claude-memory.md template"
