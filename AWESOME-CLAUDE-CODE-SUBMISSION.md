# Awesome Claude Code Resource Submission

**Submission URL:** https://github.com/hesreallyhim/awesome-claude-code/issues/new?template=recommend-resource.yml

---

## Form Fields

### Display Name
```
OpenClaw Memory System
```

### Category
```
Tooling
```

### Sub-Category
```
Tooling: Usage Monitors
```

### Primary Link
```
https://github.com/AtlasPA/openclaw-memory
```

### Author Name
```
AtlasPA
```

### Author Link
```
https://github.com/AtlasPA
```

### License
```
MIT
```

### Description
```
Persistent memory with semantic search for OpenClaw agents. Never repeat context again - agents remember facts, preferences, patterns, and conversation history across sessions. Automatic memory extraction, smart retrieval with importance scoring, and vector embeddings for semantic search. Free tier: 100 memories (7 days retention). Pro tier (0.5 USDT/month): unlimited memories with persistent storage. Includes CLI and web dashboard on port 9091.
```

### Validate Claims
```
1. Install the tool: `cd ~/.openclaw && git clone https://github.com/AtlasPA/openclaw-memory.git && cd openclaw-memory && npm install && npm run setup`
2. Start the dashboard: `npm run dashboard` (runs on http://localhost:9091)
3. Store a memory: `node src/cli.js store --content "User prefers Python over JavaScript" --type preference --wallet 0xTestWallet`
4. Search memories: `node src/cli.js search --query "programming language" --wallet 0xTestWallet`
5. Have a conversation with an agent and observe automatic memory extraction
6. Start a new session and see relevant memories automatically injected into context
```

### Specific Task(s)
```
Install the OpenClaw Memory System and have a conversation where you mention preferences or facts. End the session, start a new one, and observe how the agent remembers your preferences without you repeating them.
```

### Specific Prompt(s)
```
"Install the OpenClaw Memory System from ~/.openclaw/openclaw-memory. I prefer writing in TypeScript and use React for frontend projects. Remember this for future sessions."
```

### Additional Comments
```
This is part of the OpenClaw ecosystem (5 tools total: Cost Governor, Memory System, Context Optimizer, Smart Router, and API Quota Tracker). All tools use the same x402 payment protocol for Pro tier subscriptions. Memory System provides the foundation for Context Optimizer to intelligently compress context using stored memories.
```

### Recommendation Checklist
- [x] I have checked that this resource hasn't already been submitted
- [x] My resource provides genuine value to Claude Code users, and any risks are clearly stated
- [x] All provided links are working and publicly accessible
- [x] I am submitting only ONE resource in this issue
- [x] I understand that low-quality or duplicate submissions may be rejected

---

## Instructions

1. Go to: https://github.com/hesreallyhim/awesome-claude-code/issues/new?template=recommend-resource.yml
2. Copy and paste each field from above into the corresponding form field
3. Check all the checkboxes at the bottom
4. Click "Submit new issue"
5. The automated validator will check your submission and post results as a comment
