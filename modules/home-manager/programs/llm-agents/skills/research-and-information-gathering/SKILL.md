---
name: research-and-information-gathering
description: "MUST load when performing web search. Triggered when: (1) using library/framework APIs, configuration options, or method signatures, (2) investigating error messages or debugging, (3) checking best practices or recommended patterns, (4) using a technology or tool for the first time, (5) using an API not yet present in the project even from an already-used library, (6) choosing between multiple implementation approaches. Provides search query formulation, source validation, conflicting information handling, and insufficient results reporting templates."
compatibility: No external dependencies. Works in all environments.
---

# Research and Information Gathering

Practical guidance for executing web searches effectively. For the decision of **when** to search, refer to the Web Search Policy in AGENTS.md / CLAUDE.md.

## Search Query Formulation

### Good Search Queries

Include version numbers when relevant:
- "Next.js 14 app router data fetching"
- "React 18 useTransition hook"
- "TypeScript 5.0 decorators"

Include year for time-sensitive topics:
- "Node.js best practices 2026"
- "React state management comparison 2026"

Include specific error messages:
- "EADDRINUSE port already in use Node.js"
- "hydration mismatch Next.js"

Include technology stack context:
- "authentication Next.js 14 server actions"
- "form validation React Hook Form Zod"

### Poor Search Queries

Too vague:
- "React hooks"
- "how to deploy"
- "database query"

Missing context:
- "middleware" (middleware for what?)
- "API routes" (which framework?)
- "styling" (which approach/library?)

## Source Validation

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

3. **Source credibility ranking**
   - Official documentation (highest priority)
   - Official blog posts / release notes
   - Well-known community resources (Vercel, MDN, etc.)
   - Recent Stack Overflow answers (with high votes)
   - Personal blogs (verify with official docs)

## Conflicting Information Handling

When search returns conflicting information:

**Report to user with sources, let them decide.**

Template:
```
I found two different approaches:

Approach 1 (Official docs, [date]):
[Details...]
Source: [URL]

Approach 2 (Community guide, [date]):
[Details...]
Source: [URL]

Which approach fits your use case?
```

Prioritize by source credibility:
- Official docs > Official blog > Established community > Personal blogs

## When Research is Insufficient

Report when research does not yield adequate results.

Template:
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

## Search Execution Checklist

### During Search

1. Use multiple search queries if first attempt is insufficient
2. Cross-reference information across multiple sources
3. Verify publication dates and version compatibility

### After Search

1. Synthesize findings into clear recommendation
2. Cite sources (especially for official docs)
3. Note any version-specific caveats
4. Report conflicting information if found
