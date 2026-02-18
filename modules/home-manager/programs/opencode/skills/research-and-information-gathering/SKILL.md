---
name: research-and-information-gathering
description: Deep research methodology for unfamiliar technologies and accurate information retrieval. Use when (1) encountering unfamiliar libraries, frameworks, or technologies, (2) researching API documentation, (3) investigating error messages or debugging guidance, (4) finding best practices for specific implementations, (5) verifying information freshness and source credibility, (6) resolving conflicting information from multiple sources, or (7) needing version-specific or time-sensitive technical information.
---

# Research and Information Gathering

Deep research methodology for unfamiliar technologies and accurate information retrieval.

## When to Execute Web Search

YOU MUST: Actively use web search when encountering:

### 🚨 MANDATORY Search Triggers

1. **Unfamiliar libraries, frameworks, or technologies**
   - Example: "How do I use Zustand for state management?"
   - Example: "What's the syntax for Prisma schema?"

2. **API documentation needs**
   - Example: "What parameters does stripe.checkout.sessions.create accept?"
   - Example: "How do I configure Tailwind CSS v4?"

3. **Best practices for specific implementations**
   - Example: "What's the recommended way to handle authentication in Next.js 14?"
   - Example: "How should I structure a monorepo with pnpm workspaces?"

4. **Error messages or debugging guidance**
   - Example: "Error: Cannot find module '@/lib/utils'" (in a specific framework)
   - Example: "CORS policy blocking fetch request" (for specific setup)

5. **Latest syntax or feature updates**
   - Example: "React Server Components syntax"
   - Example: "TypeScript 5.3 new features"

### 🎯 Specific Search Scenarios

**Version-Specific Queries:**
```
❓ User asks: "How do I use async components in Next.js?"
✅ Search: "Next.js 14 async components server components 2024"
   Reason: Next.js has breaking changes between versions
```

**Framework Configuration:**
```
❓ User asks: "Configure ESLint for my project"
✅ Search: "ESLint 9 configuration flat config 2024"
   Reason: ESLint changed config format in v9
```

**Library Usage:**
```
❓ User asks: "How do I validate forms with Zod?"
✅ Search: "Zod schema validation examples TypeScript"
   Reason: Need accurate API and patterns
```

**Error Resolution:**
```
❓ User encounters: "Module not found: Can't resolve 'fs'"
✅ Search: "Next.js fs module not found webpack 5 solution"
   Reason: Need specific solution for the framework
```

## Search Query Formulation

### Good Search Queries

✅ Include version numbers when relevant:
- "Next.js 14 app router data fetching"
- "React 18 useTransition hook"
- "TypeScript 5.0 decorators"

✅ Include year for time-sensitive topics:
- "Node.js best practices 2024"
- "React state management comparison 2024"

✅ Include specific error messages:
- "EADDRINUSE port already in use Node.js"
- "hydration mismatch Next.js"

✅ Include technology stack:
- "authentication Next.js 14 server actions"
- "form validation React Hook Form Zod"

### Poor Search Queries

❌ Too vague:
- "React hooks"
- "how to deploy"
- "database query"

❌ Missing context:
- "middleware" (middleware for what?)
- "API routes" (which framework?)
- "styling" (which approach/library?)

## Information Freshness Validation

### Publication Date Check

After receiving search results:

1. **Check publication date**
   - Prefer: Within last 12 months
   - Acceptable: 12-24 months (for stable technologies)
   - Suspicious: >24 months (may be outdated)

2. **Version compatibility**
   - Verify version matches user's project
   - Check for breaking changes in changelogs
   - Look for migration guides if versions differ

3. **Source credibility**
   - Official documentation (highest priority)
   - Official blog posts / release notes
   - Well-known community resources (Vercel, MDN, etc.)
   - Recent Stack Overflow answers (with high votes)
   - Personal blogs (verify with official docs)

### Conflicting Information Handling

When search returns conflicting information:

1. **Report to user with sources**
```
"I found two different approaches:

Approach 1 (Official Next.js docs, Jan 2024):
[Details...]
Source: https://nextjs.org/docs/...

Approach 2 (Community blog, Mar 2023):
[Details...]
Source: https://blog.example.com/...

The official documentation is more recent and recommends Approach 1.
Should I proceed with that?"
```

2. **Prioritize by source credibility**
   - Official docs > Official blog > Established community > Personal blogs

3. **Consider temporal context**
   - Newer information generally preferred for fast-evolving tech
   - Older, stable patterns may still be valid for mature tech

## Research Limitations and Reporting

### When Research is Insufficient

YOU MUST: Report when research doesn't yield adequate results

**Template for reporting:**

```
I searched for [specific query] to find [information needed].

Search attempts:
1. "[search query 1]" - Found [brief result summary]
2. "[search query 2]" - Found [brief result summary]

Results:
- [What I found]
- [What's still unclear]
- [Conflicting information, if any]

I need additional information about:
- [Specific missing detail 1]
- [Specific missing detail 2]

Could you provide:
- [Specific question to user]
```

**Example:**

```
I searched for "Bun 1.0 WebSocket server setup" to find how to create a WebSocket server with Bun.

Search attempts:
1. "Bun WebSocket server tutorial" - Found basic examples but not for v1.0
2. "Bun 1.0 WebSocket API documentation" - Found API reference but missing complete examples

Results:
- Bun has a built-in Bun.serve() API with WebSocket support
- The 'websocket' option in Bun.serve() handles WebSocket connections
- Found conflicting examples for message handling (some use 'message', others 'onMessage')

I need additional information about:
- The correct event handler name for Bun 1.0
- Whether you need additional libraries or if built-in is sufficient

Could you provide:
- Which Bun version are you using?
- Do you have any existing WebSocket implementation I should follow?
```

### Verification Requirements

NEVER: Continue with incomplete or uncertain information
NEVER: Fill gaps with assumptions or best guesses

YOU MUST: Explicitly state uncertainty
YOU MUST: Ask for clarification when information is ambiguous
YOU MUST: Verify assumptions with user before implementation

## Search Execution Guidelines

### Before Searching

1. Check if information is within my knowledge cutoff (January 2025)
2. Assess if this is stable, well-established knowledge
3. Determine if version-specific behavior is likely

### During Search

1. Use multiple search queries if first attempt is insufficient
2. Cross-reference information across multiple sources
3. Verify publication dates and version compatibility

### After Search

1. Synthesize findings into clear recommendation
2. Cite sources (especially for official docs)
3. Note any version-specific caveats
4. Report conflicting information if found

## Examples

### Example 1: Unfamiliar Library

```
User: "How do I use Drizzle ORM with PostgreSQL?"

✅ CORRECT Response:
"Let me search for the current Drizzle ORM setup with PostgreSQL."

[Executes WebSearch: "Drizzle ORM PostgreSQL setup tutorial 2024"]

"Based on the official Drizzle documentation (updated Nov 2024), here's how to set up Drizzle with PostgreSQL:

[Provides accurate, sourced information]

Source: https://orm.drizzle.team/docs/get-started-postgresql"
```

### Example 2: Error Message

```
User: "I'm getting 'Error: Cannot find module @/components/ui/button'"

✅ CORRECT Response:
"This looks like a path alias issue. Let me search for the specific solution for your setup."

[Executes WebSearch: "Next.js cannot find module @/ path alias tsconfig"]

"This error typically occurs when the path alias isn't properly configured in tsconfig.json.
Based on current Next.js documentation, you need to ensure:
[Provides solution]

Is your tsconfig.json configured with path aliases?"
```

### Example 3: Best Practices

```
User: "What's the best way to handle forms in React now?"

✅ CORRECT Response:
"Form handling in React has evolved significantly. Let me search for current best practices."

[Executes WebSearch: "React form handling best practices 2024 controlled uncontrolled"]

"Based on recent React documentation and community practices (2024), there are several approaches:

1. React Hook Form (most popular, recommended for complex forms)
2. Formik (established, but heavier)
3. Native controlled components (simple forms)
4. Server Actions (Next.js 14+)

Which approach fits your use case best? Do you need:
- Complex validation?
- Multi-step forms?
- Are you using Next.js 14+ with Server Actions?"
```

## When to Use This Skill

- Encountering unfamiliar libraries or frameworks
- Researching API documentation
- Investigating error messages
- Finding best practices for implementation
- Verifying information freshness
- Resolving conflicting information
