# Claude Code + Memory System Integration Guide

**Give Claude persistent memory across all your projects - never re-explain context again.**

---

## The Problem

Claude Code forgets everything between sessions:

```
Project A (React app):
  Session 1: "I use React 18 with TypeScript, functional components only"
  Session 2: "Add a new component" → Claude asks about your stack again 😞

Project B (Python API):
  Session 1: "I use FastAPI with PostgreSQL, prefer async/await"
  Session 2: "Add a new endpoint" → Claude asks about your stack again 😞
```

**You spend 20-30% of every session re-explaining context.**

---

## The Solution

Memory System stores project context locally and auto-injects it into every Claude Code session.

```
Project A (React app):
  Session 1: "I use React 18 with TypeScript"
  [Memory] Stored ✓

  Session 2: "Add a new component"
  [Memory] Recalled: React 18, TypeScript, functional components
  Claude: Creates functional component with TypeScript ✓

Project B (Python API):
  Session 1: "I use FastAPI with PostgreSQL"
  [Memory] Stored ✓

  Session 2: "Add a new endpoint"
  [Memory] Recalled: FastAPI, PostgreSQL, async/await
  Claude: Creates async FastAPI endpoint ✓
```

**Claude remembers everything. Forever.**

---

## Setup (5 minutes)

### Step 1: Install Memory System

```powershell
# Clone the repository
cd $env:USERPROFILE\.openclaw
git clone https://github.com/AtlasPA/openclaw-memory

# Install dependencies
cd openclaw-memory
npm install

# Setup database
npm run setup
```

### Step 2: Load PowerShell Integration

```powershell
# Add to your PowerShell profile
Add-Content $PROFILE "`n. `"$env:USERPROFILE\.openclaw\openclaw-memory\examples\claude-code-integration.ps1`""

# Reload profile
. $PROFILE
```

You should see:
```
✓ Claude Code + Memory System integration loaded

Commands:
  claw <question>           - Ask Claude with auto-injected context
  claw-remember <fact>      - Store a fact about current project
  claw-forget <pattern>     - Remove memories matching pattern
  claw-show                 - Show all memories for this project
  claw-init                 - Create .claude-memory.md template
```

---

## Usage

### Method 1: Auto-Memory (Quick Start)

Just use `claw` instead of `claude-code`:

```powershell
cd C:\projects\my-react-app

# First session - teach Claude about your project
claw "I'm building a React 18 app with TypeScript, using Vite for build, and Zustand for state. I prefer functional components and no default exports."

# Claude responds, Memory System extracts facts automatically

# Next session (next day)
claw "Add a user profile component"

# [Memory] Recalled 8 facts about 'my-react-app'
# Claude creates: Functional component, TypeScript, Zustand state, named export ✓
```

### Method 2: Explicit Memory (More Control)

Store specific facts you want Claude to remember:

```powershell
cd C:\projects\my-api

# Store tech stack
claw-remember "FastAPI with Python 3.11"
claw-remember "PostgreSQL database with SQLAlchemy"
claw-remember "Use async/await for all handlers"
claw-remember "Pydantic for validation"
claw-remember "Testing with pytest"

# Store preferences
claw-remember "Prefer dependency injection over globals"
claw-remember "All endpoints must have docstrings"
claw-remember "Use type hints everywhere"

# Store current context
claw-remember "Working on authentication module"
claw-remember "Using JWT tokens with 24h expiry"

# Now ask Claude anything
claw "Add a new endpoint for user registration"

# Claude gets all 9 facts automatically and creates:
# - Async FastAPI endpoint
# - Pydantic model for validation
# - SQLAlchemy model
# - Type hints
# - Docstring
# - Dependency injection
# ✓ Exactly what you want!
```

### Method 3: Project Memory File (Best for Complex Projects)

Create a `.claude-memory.md` file per project:

```powershell
cd C:\projects\my-saas-app

# Initialize template
claw-init

# Edit the file
notepad .claude-memory.md
```

**`.claude-memory.md` template:**
```markdown
# Claude Memory - my-saas-app

Last updated: 2026-02-13

## Tech Stack
- **Frontend:** Next.js 14 (App Router), React 18, TypeScript 5
- **Backend:** tRPC, Prisma ORM, PostgreSQL
- **Auth:** NextAuth.js with Google/GitHub OAuth
- **Payments:** Stripe
- **Email:** Resend
- **Hosting:** Vercel (frontend), Railway (database)

## Code Style
- Functional components with TypeScript
- Server components by default, client components only when needed
- ESLint strict mode + Prettier
- Tailwind CSS with custom design system
- Shadcn/ui for components

## Architecture
- **State:** React Query for server state, Zustand for UI state
- **Forms:** React Hook Form + Zod validation
- **API:** tRPC for type-safe API calls
- **Database:** Prisma with PostgreSQL
- **Auth:** Session-based with NextAuth

## Preferences
- ✅ Composition over inheritance
- ✅ Colocate related files (component + test + styles)
- ✅ Use TypeScript strict mode
- ✅ Server components > client components
- ✅ tRPC procedures must have input validation
- ❌ No default exports (use named exports)
- ❌ No any types (use unknown or proper types)
- ❌ Don't use class components
- ❌ Avoid prop drilling (use context or Zustand)

## Database Schema
- Users: id, email, name, image, role (user/admin)
- Subscriptions: id, userId, stripeId, status, plan
- Products: id, name, price, features[]
- Usage: id, userId, resource, count, resetAt

## Current Work (2026-02-13)
- Building subscription management dashboard
- Integrating Stripe webhooks for subscription updates
- Adding usage tracking for API calls
- Need to implement usage-based pricing tiers

## API Endpoints
- /api/auth/* - NextAuth routes
- /api/stripe/webhook - Stripe webhooks
- /api/trpc/* - tRPC API routes
```

**Now every Claude Code session in this project automatically has this context!**

```powershell
cd C:\projects\my-saas-app

claw "Add a new tRPC procedure for fetching user subscription"

# [Memory] Loaded .claude-memory.md (52 lines)
# Claude creates:
# - tRPC procedure with Zod input validation
# - Prisma query joining Users + Subscriptions
# - Proper TypeScript types
# - Server-side authorization check
# - Matches your exact stack and preferences ✓
```

---

## Multi-Project Workflow

The killer feature: **Each project has its own memory, automatically loaded based on your current directory.**

```powershell
# Switch between projects seamlessly

cd C:\projects\react-app
claw "Add a login form"
# [Memory] Recalls: React 18, TypeScript, React Hook Form, Zod
# Creates React form component ✓

cd C:\projects\python-api
claw "Add a login endpoint"
# [Memory] Recalls: FastAPI, PostgreSQL, JWT, async/await
# Creates FastAPI endpoint ✓

cd C:\projects\mobile-app
claw "Add a login screen"
# [Memory] Recalls: React Native, Expo, TypeScript, React Navigation
# Creates React Native screen ✓
```

**You never have to explain your stack again. Ever.**

---

## View Your Memories

```powershell
# Show all memories for current project
claw-show

# Output:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧠 Memories for: my-react-app
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Project Context File (.claude-memory.md)
[Contents of .claude-memory.md]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Semantic Memories (12 total)

ID    | Content                                    | Category        | Created
------|--------------------------------------------|-----------------|------------
1     | React 18 with TypeScript                   | tech-stack      | 2026-02-10
2     | Vite for build                             | tech-stack      | 2026-02-10
3     | Zustand for global state                   | architecture    | 2026-02-10
4     | Prefer functional components               | code-style      | 2026-02-10
5     | No default exports                         | code-style      | 2026-02-10
6     | Tailwind CSS for styling                   | tech-stack      | 2026-02-11
7     | Vitest + React Testing Library             | testing         | 2026-02-11
8     | Working on authentication flow             | current-work    | 2026-02-13
9     | Using JWT tokens in localStorage           | architecture    | 2026-02-13
10    | Protected routes with auth guard           | architecture    | 2026-02-13
11    | Login/register components completed        | current-work    | 2026-02-13
12    | Next: Add user profile page                | current-work    | 2026-02-13

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Update Memories

```powershell
# Add new facts as you go
claw-remember "Upgraded to React 18.3"
claw-remember "Using React Query for server state"
claw-remember "Added dark mode with next-themes"

# Remove outdated facts
claw-forget "React 18.0"
claw-forget "old authentication"
```

---

## Advanced: Global Context (All Projects)

Want Claude to remember things across ALL projects?

```powershell
# Create a global memory file
cd $env:USERPROFILE
claw-init

# Edit global memory
notepad .claude-memory.md
```

**Global `.claude-memory.md`:**
```markdown
# Claude Memory - Global Preferences

## My Coding Style (All Projects)
- Prefer functional programming over OOP
- Write self-documenting code (clear names > comments)
- Test critical paths, don't aim for 100% coverage
- Git: Commit often, squash before merge
- Use TypeScript for anything beyond 100 lines

## My Preferences
- ✅ Explicit is better than implicit
- ✅ Simple > clever
- ✅ Composition > inheritance
- ❌ Don't use var (use const/let)
- ❌ No magic numbers (use named constants)
- ❌ Avoid abbreviations in names

## My Environment
- OS: Windows 11
- Editor: VS Code with Vim extension
- Shell: PowerShell 7
- Package managers: npm, pip, cargo
- Prefer: CLI tools > GUI when possible

## My Workflow
- Morning: Review TODOs, plan day
- Code in 90-minute blocks with breaks
- Write tests alongside code
- Deploy at end of day
- Document as I go, not after
```

Now **every project** gets these preferences automatically, plus project-specific context.

---

## Real-World Example

### Before Memory System:

```powershell
# Monday - Project A
claw "I'm building a Next.js app with TypeScript and Tailwind. Add a login page."
# [Explains stack...]

# Tuesday - Project B
claw "I'm building a FastAPI backend with PostgreSQL. Add a login endpoint."
# [Explains stack...]

# Wednesday - Project A again
claw "Add a signup page"
# [Re-explains Next.js stack AGAIN...]
```

**Time wasted: ~5 minutes per session × 20 sessions/week = 100 minutes/week**

### After Memory System:

```powershell
# Monday - Project A
cd C:\projects\nextjs-app
claw-remember "Next.js 14, TypeScript, Tailwind, tRPC, Prisma"
claw "Add a login page"
# Claude creates it perfectly ✓

# Tuesday - Project B
cd C:\projects\fastapi-backend
claw-remember "FastAPI, PostgreSQL, SQLAlchemy, async/await"
claw "Add a login endpoint"
# Claude creates it perfectly ✓

# Wednesday - Project A
cd C:\projects\nextjs-app
claw "Add a signup page"
# [Memory] Recalled: Next.js 14, TypeScript, Tailwind, tRPC, Prisma
# Claude creates it perfectly ✓
# Zero time explaining stack!
```

**Time saved: 100 minutes/week = 6.6 hours/month = 80 hours/year**

---

## How It Works

### Semantic Search

Memory System doesn't just dump all facts into every prompt. It uses **semantic search** to find relevant memories:

```powershell
claw "Add a login form"

# Memory System searches for memories related to:
# - "login"
# - "form"
# - "authentication"
# - "user input"

# Returns top 10 most relevant:
# ✓ "React Hook Form for forms"
# ✓ "Zod validation"
# ✓ "JWT tokens for auth"
# ✓ "Login endpoint: POST /api/auth/login"
# ✗ "Database: PostgreSQL" (not relevant to forms)
# ✗ "Tailwind config" (not relevant to login)
```

This means Claude gets **exactly the context it needs**, not everything.

### Privacy

All data stored **locally** in `~/.openclaw/openclaw-memory/`:

```
~/.openclaw/openclaw-memory/
├── data/
│   └── memories.db        # SQLite database (local only)
├── embeddings/            # Vector embeddings (local only)
└── config.json            # Settings
```

**Nothing sent to external servers. Your memories stay on your machine.**

---

## Cost Savings

Every time you re-explain context:

```
"I'm building a Next.js app with TypeScript, using tRPC for API calls,
Prisma for database, Tailwind for styling, and Zustand for state management.
I prefer server components, functional programming, and no default exports."

Tokens: ~100
Cost: $0.0003
```

If you do this 20 times/week:
- Weekly cost: $0.006
- Monthly cost: $0.024
- **Yearly cost: $0.288**

With Memory System:
- This explanation stored once
- Auto-injected when relevant
- **Yearly savings: $0.288 + 80 hours of your time**

---

## FAQ

### Q: Do I need to run the Memory System server?

**A:** No! The shell integration calls the CLI directly. No server needed.

### Q: Does this work with the official Claude Code?

**A:** Yes! The integration wraps the official `claude-code` command.

### Q: Can I use this with other AI tools?

**A:** Yes! The memories are stored in a standard format. You can inject them into any tool.

### Q: What if I have 50 projects?

**A:** Each project has its own memory. Switch directories, get different context. Seamless.

### Q: Does this slow down Claude Code?

**A:** No. Memory lookup takes <100ms. You won't notice.

### Q: Can I share memories with my team?

**A:** Yes! Commit `.claude-memory.md` to git. Everyone gets the same context.

### Q: What if Memory System fails?

**A:** The wrapper falls back to normal `claude-code`. You lose context injection but Claude still works.

---

## Next Steps

1. **Install Memory System** (5 min)
2. **Load PowerShell integration** (1 min)
3. **Initialize your first project** with `claw-init` (2 min)
4. **Use `claw` instead of `claude-code`** from now on

**Total setup: 8 minutes. Benefits: Forever.**

---

## Tips

**Tip 1: Start simple**
```powershell
# Don't overthink it. Start with basics:
claw-remember "Tech stack: React + TypeScript"
claw-remember "Prefer functional components"

# Add more as you go
```

**Tip 2: Update as you work**
```powershell
# After making architectural decisions:
claw-remember "Using React Query for API calls"
claw-remember "Stripe integration on /api/stripe/*"
```

**Tip 3: Keep .claude-memory.md in git**
```powershell
# Share context with your team
git add .claude-memory.md
git commit -m "Add Claude context for project"
```

**Tip 4: Review memories monthly**
```powershell
claw-show  # See all memories
claw-forget "outdated thing"  # Clean up
```

---

## Links

- **Memory System Repo:** https://github.com/AtlasPA/openclaw-memory
- **Integration Scripts:** `~/.openclaw/openclaw-memory/examples/`
- **SKILL.md:** Full Memory System documentation

---

**Ready? Install now and never re-explain your stack again.**

```powershell
cd $env:USERPROFILE\.openclaw
git clone https://github.com/AtlasPA/openclaw-memory
cd openclaw-memory
npm install && npm run setup
Add-Content $PROFILE "`n. `"$env:USERPROFILE\.openclaw\openclaw-memory\examples\claude-code-integration.ps1`""
. $PROFILE
```

**Then:**
```powershell
cd C:\your-project
claw-init
claw "Let's get started!"
```

🎉 **You now have persistent memory across all your projects.**
