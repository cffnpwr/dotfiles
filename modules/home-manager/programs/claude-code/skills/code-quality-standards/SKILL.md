# Code Quality Standards

Professional code quality and design principles for implementation and review.

## Code Quality Standards

YOU MUST: Write clear, maintainable code with proper documentation
YOU MUST: Follow established coding conventions for the project's language
YOU MUST: Include appropriate error handling
YOU MUST: Write meaningful variable and function names

**Examples:**

✅ GOOD:
```javascript
function calculateUserSubscriptionPrice(userId, planType) {
  const basePrices = { basic: 9.99, premium: 19.99, enterprise: 49.99 };
  return basePrices[planType] || 0;
}
```

❌ BAD:
```javascript
function calc(u, p) {
  const x = { b: 9.99, p: 19.99, e: 49.99 };
  return x[p] || 0;
}
```

## Fundamental Design Principles

YOU MUST: Adhere to these core principles:

### DRY (Don't Repeat Yourself)
- Eliminate code duplication
- Extract common logic into reusable functions/components
- Use inheritance, composition, or utilities appropriately

**Example:**

❌ BAD (Duplication):
```javascript
function processUserOrder(order) {
  console.log(`[${new Date().toISOString()}] Processing order ${order.id}`);
  // process order
}

function processUserRefund(refund) {
  console.log(`[${new Date().toISOString()}] Processing refund ${refund.id}`);
  // process refund
}
```

✅ GOOD (DRY):
```javascript
function log(message) {
  console.log(`[${new Date().toISOString()}] ${message}`);
}

function processUserOrder(order) {
  log(`Processing order ${order.id}`);
  // process order
}

function processUserRefund(refund) {
  log(`Processing refund ${refund.id}`);
  // process refund
}
```

### YAGNI (You Aren't Gonna Need It)
- Implement only what's needed now
- Don't add features for hypothetical future requirements
- Wait until requirements are clear before adding complexity

**Example:**

❌ BAD (Over-engineering):
```javascript
// User only needs basic authentication
class AuthenticationManager {
  constructor() {
    this.providers = [];
    this.strategies = new Map();
    this.middleware = [];
    this.cache = new LRUCache();
    this.rateLimiter = new RateLimiter();
  }

  registerProvider(provider) { /* ... */ }
  addStrategy(name, strategy) { /* ... */ }
  applyMiddleware(fn) { /* ... */ }
  // ... 50 more methods
}
```

✅ GOOD (YAGNI):
```javascript
// Simple authentication for current needs
function authenticateUser(username, password) {
  const user = findUserByUsername(username);
  if (!user || !verifyPassword(password, user.passwordHash)) {
    return null;
  }
  return user;
}
```

### KISS (Keep It Simple, Stupid)
- Favor simplicity over complexity
- Use straightforward solutions when possible
- Avoid premature optimization

**Example:**

❌ BAD (Over-complicated):
```javascript
const result = array.reduce((acc, item) =>
  [...acc, ...(item.active ? [item.value] : [])], []
);
```

✅ GOOD (Simple):
```javascript
const result = array
  .filter(item => item.active)
  .map(item => item.value);
```

### SOLID Principles

#### Single Responsibility Principle
Each function/class should have one reason to change

**Example:**

❌ BAD:
```javascript
class UserManager {
  saveUser(user) { /* save to DB */ }
  sendWelcomeEmail(user) { /* send email */ }
  logUserActivity(user) { /* log to file */ }
  generateReport(users) { /* create PDF */ }
}
```

✅ GOOD:
```javascript
class UserRepository {
  saveUser(user) { /* save to DB */ }
}

class EmailService {
  sendWelcomeEmail(user) { /* send email */ }
}

class ActivityLogger {
  logUserActivity(user) { /* log to file */ }
}

class ReportGenerator {
  generateUserReport(users) { /* create PDF */ }
}
```

#### Open/Closed Principle
Open for extension, closed for modification

#### Liskov Substitution Principle
Derived classes must be substitutable for base classes

#### Interface Segregation Principle
Don't force clients to depend on unused interfaces

#### Dependency Inversion Principle
Depend on abstractions, not concretions

## Error Handling and Debugging

### Prohibited Actions

NEVER: Use quick fixes or workarounds for errors
NEVER: Comment out error-causing code without proper resolution
NEVER: Silence errors with empty catch blocks
NEVER: Modify test cases to make them pass instead of fixing the underlying issue
NEVER: Use temporary patches that don't address root causes

**Examples:**

❌ BAD:
```javascript
try {
  processPayment(order);
} catch (error) {
  // TODO: fix later
}
```

❌ BAD:
```javascript
// This was causing errors, commented out for now
// validateUserInput(data);
saveToDatabase(data);
```

❌ BAD:
```javascript
// Test was failing, changed expected value to match output
expect(calculateTotal([1, 2, 3])).toBe(7); // changed from 6
```

### Required Actions

YOU MUST: Investigate and understand the root cause of errors
YOU MUST: Implement proper, sustainable solutions
YOU MUST: If unsure about the best approach, ask the user for guidance
YOU MUST: Preserve the integrity of existing test cases unless explicitly instructed otherwise

**Examples:**

✅ GOOD:
```javascript
try {
  processPayment(order);
} catch (error) {
  logger.error('Payment processing failed', { orderId: order.id, error });
  throw new PaymentError(`Failed to process payment: ${error.message}`);
}
```

✅ GOOD:
```javascript
// Before implementing, ask user:
// "The validateUserInput function is throwing errors. Should I:
// 1. Fix the validation logic?
// 2. Update the input data format?
// 3. Add error handling around the validation?
// What's the expected behavior?"
```

## Security Considerations

YOU MUST: Check for common vulnerabilities:
- SQL Injection: Use parameterized queries
- XSS (Cross-Site Scripting): Sanitize user input, escape output
- Command Injection: Validate and sanitize shell commands
- Path Traversal: Validate file paths
- Authentication/Authorization: Verify user permissions

**Examples:**

❌ BAD (SQL Injection):
```javascript
const query = `SELECT * FROM users WHERE id = ${userId}`;
```

✅ GOOD:
```javascript
const query = 'SELECT * FROM users WHERE id = ?';
db.execute(query, [userId]);
```

❌ BAD (XSS):
```javascript
element.innerHTML = userInput;
```

✅ GOOD:
```javascript
element.textContent = userInput;
// or use a sanitization library
element.innerHTML = DOMPurify.sanitize(userInput);
```

## Testing Requirements

YOU MUST: Preserve test integrity
- Fix the code to make tests pass, not the other way around
- If a test is genuinely incorrect, ask user before modifying
- Maintain or improve test coverage

**Example:**

❌ BAD:
```javascript
// Test failing, so I changed the test
expect(calculateDiscount(100, 0.1)).toBe(90); // was 91, changed to match output
```

✅ GOOD:
```javascript
// Test failing, investigate the calculateDiscount function
// Found bug: discount calculation was subtracting 10 instead of 10%
function calculateDiscount(price, discountRate) {
  return price - (price * discountRate); // Fixed: was "price - discountRate"
}
```

## When to Use This Skill

- Starting code implementation
- Reviewing code for quality
- Refactoring existing code
- Debugging errors and issues
- Making architectural decisions
