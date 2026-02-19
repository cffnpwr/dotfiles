---
name: security-standards
description: Provides security guidelines and OWASP Top 10 vulnerability prevention standards for code that handles user input, authentication, data storage, or external APIs. Triggers when writing code that processes user input, reviewing code for security vulnerabilities, implementing authentication/authorization, or when OWASP compliance is needed. Includes validation checklists and common vulnerability patterns to avoid.
compatibility: No external dependencies. Works in all environments.
---

# Skill: Security Standards

## Overview

This skill provides security guidelines and standards for writing secure code. It focuses on preventing common vulnerabilities from the OWASP Top 10 and establishing secure coding practices.

**Use this skill when:**
- Writing code that handles user input
- Implementing authentication or authorization
- Working with databases or external APIs
- Reviewing code for security vulnerabilities
- OWASP compliance is required
- Processing sensitive data (credentials, tokens, PII)

## Core Principle

**Trust internal code and framework guarantees. Only validate at system boundaries (user input, external APIs).**

Don't add unnecessary validation for internal operations. Focus security efforts where external data enters the system.

## Common Vulnerabilities to Avoid (OWASP Top 10)

### 1. Command Injection
**Risk:** Attackers can execute arbitrary system commands.

**Prevention:**
- Validate and sanitize all shell inputs
- Use library functions instead of shell commands when possible
- Never construct shell commands from user input via string concatenation
- Use parameterized/safe APIs (e.g., subprocess with array arguments)

**Example (Vulnerable):**
```python
# ❌ NEVER DO THIS
os.system(f"rm {user_filename}")
```

**Example (Safe):**
```python
# ✅ CORRECT
import subprocess
subprocess.run(["rm", user_filename], check=True)
```

### 2. XSS (Cross-Site Scripting)
**Risk:** Attackers can inject malicious scripts into web pages.

**Prevention:**
- Escape user-generated content in HTML contexts
- Use framework auto-escaping features
- Apply Content Security Policy (CSP) headers
- Sanitize HTML if rich content is needed

**Example (Vulnerable):**
```javascript
// ❌ NEVER DO THIS
element.innerHTML = userInput;
```

**Example (Safe):**
```javascript
// ✅ CORRECT
element.textContent = userInput;
// OR use framework escaping (React, Vue, etc.)
```

### 3. SQL Injection
**Risk:** Attackers can manipulate database queries.

**Prevention:**
- Use parameterized queries/prepared statements
- Never build SQL with string concatenation
- Use ORM query builders with parameter binding

**Example (Vulnerable):**
```python
# ❌ NEVER DO THIS
cursor.execute(f"SELECT * FROM users WHERE username = '{username}'")
```

**Example (Safe):**
```python
# ✅ CORRECT
cursor.execute("SELECT * FROM users WHERE username = ?", (username,))
```

### 4. Path Traversal
**Risk:** Attackers can access files outside intended directories.

**Prevention:**
- Validate file paths before operations
- Use allowlist of permitted paths/patterns
- Prevent directory traversal sequences (../, ..\)
- Use path canonicalization functions

**Example (Vulnerable):**
```python
# ❌ NEVER DO THIS
with open(f"/uploads/{user_filename}", "r") as f:
    return f.read()
```

**Example (Safe):**
```python
# ✅ CORRECT
import os
safe_path = os.path.abspath(os.path.join("/uploads", user_filename))
if not safe_path.startswith("/uploads/"):
    raise ValueError("Invalid path")
with open(safe_path, "r") as f:
    return f.read()
```

### 5. Insecure Deserialization
**Risk:** Attackers can execute code via malicious serialized objects.

**Prevention:**
- Validate serialized data before processing
- Use safe serialization formats (JSON over pickle)
- Implement integrity checks (signatures, HMACs)
- Limit deserialization to trusted sources

**Example (Vulnerable):**
```python
# ❌ NEVER DO THIS (pickle from untrusted source)
import pickle
data = pickle.loads(user_data)
```

**Example (Safe):**
```python
# ✅ CORRECT
import json
data = json.loads(user_data)
# Then validate the data structure
```

### 6. Insufficient Authentication/Authorization
**Risk:** Unauthorized access to protected resources.

**Prevention:**
- Verify user permissions on every protected operation
- Check authorization at the resource level, not just at route level
- Don't rely solely on client-side checks
- Implement proper session management

**Example (Vulnerable):**
```python
# ❌ NEVER DO THIS
@app.route("/admin/delete/<item_id>")
def delete_item(item_id):
    # No authorization check!
    Item.delete(item_id)
```

**Example (Safe):**
```python
# ✅ CORRECT
@app.route("/admin/delete/<item_id>")
@require_auth
def delete_item(item_id):
    if not current_user.is_admin:
        abort(403)
    Item.delete(item_id)
```

### 7. Sensitive Data Exposure
**Risk:** Credentials, tokens, or PII leaked in logs, code, or responses.

**Prevention:**
- Never log credentials, tokens, or PII
- Never commit secrets to version control
- Use environment variables or secret management systems
- Redact sensitive data in error messages and logs

**Example (Vulnerable):**
```python
# ❌ NEVER DO THIS
logger.info(f"User login: {username} with password {password}")
API_KEY = "hardcoded-secret-key-123"
```

**Example (Safe):**
```python
# ✅ CORRECT
logger.info(f"User login: {username}")
API_KEY = os.environ.get("API_KEY")
```

## Security Checklist

Before submitting code, verify:

- ✅ **Validate all user inputs at system boundaries** - Check type, format, range, length
- ✅ **Use secure defaults** - Parameterized queries, prepared statements, safe APIs
- ✅ **Never commit secrets** - API keys, passwords, tokens belong in environment variables
- ✅ **Immediate fix** - If you notice insecure code, fix it immediately before proceeding

## When to Apply Security Measures

**System Boundaries (ALWAYS validate):**
- User input from forms, APIs, URLs
- File uploads
- External API responses
- Database query parameters
- Command-line arguments

**Internal Operations (DON'T over-validate):**
- Data passed between internal functions
- Framework-guaranteed safe operations
- Data already validated at entry point

## Quick Decision Tree

```
Is this code processing data from outside the system?
├─ YES → Apply security validation
│   ├─ User input? → Validate, sanitize, escape
│   ├─ Database query? → Use parameterized queries
│   ├─ Shell command? → Use safe APIs, validate input
│   ├─ File operation? → Validate paths, prevent traversal
│   └─ Authentication needed? → Verify permissions
└─ NO → Trust internal code, no extra validation needed
```

## Common Patterns

### Input Validation Pattern
```python
def validate_user_input(data):
    # Type check
    if not isinstance(data, str):
        raise ValueError("Invalid type")

    # Length check
    if len(data) > 1000:
        raise ValueError("Input too long")

    # Format check (example: alphanumeric only)
    if not data.isalnum():
        raise ValueError("Invalid format")

    return data
```

### Safe Database Query Pattern
```python
# Parameterized query (prevents SQL injection)
def get_user(username):
    return db.execute(
        "SELECT * FROM users WHERE username = ?",
        (username,)
    ).fetchone()
```

### Safe File Path Pattern
```python
def safe_file_access(base_dir, user_path):
    # Resolve absolute path
    full_path = os.path.abspath(os.path.join(base_dir, user_path))

    # Ensure it's within base_dir
    if not full_path.startswith(os.path.abspath(base_dir)):
        raise ValueError("Path traversal attempt detected")

    return full_path
```

## When NOT to Add Security Measures

**Avoid over-engineering:**
- Don't validate data that frameworks already validate
- Don't add error handling at boundaries that already have it
- Don't add authentication checks for already-protected routes
- Don't sanitize data multiple times in a chain of internal functions

**Example of over-engineering:**
```python
# ❌ WRONG - Validating already-validated data
def internal_process(data):
    # This data was already validated at the API endpoint
    if not isinstance(data, str):  # Unnecessary
        raise ValueError("Invalid type")
    # ... rest of function
```

## Review Workflow

When reviewing code for security:

1. **Identify system boundaries** - Where does external data enter?
2. **Check OWASP Top 10** - Are common vulnerabilities present?
3. **Verify input validation** - Is user input validated appropriately?
4. **Check authentication/authorization** - Are permissions verified?
5. **Look for secrets** - Are credentials hardcoded or logged?
6. **Test edge cases** - What happens with malicious input?

## Additional Resources

For OWASP Top 10 details: https://owasp.org/Top10/

For secure coding practices: https://cheatsheetseries.owasp.org/
