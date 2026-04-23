# e2e-test-generator

## Description

Generates Cypress/Playwright tests from API docs. Creates golden-path + edge-case test scenarios. Tracks flaky tests.

---

## Purpose

Automatically create comprehensive end-to-end tests from API documentation or contract tests. Ensure API changes maintain backward compatibility and user flows still work.

---

## Capabilities

- 📝 **Test generation**: From OpenAPI/Swagger, GraphQL schema
- 🛤️ **User flows**: Create journeys (login → search → checkout)
- 📊 **Coverage analysis**: Find untested API endpoints
- 🔧 **Fix generation**: Suggest test updates for API changes
- 🐛 **Flakiness detection**: Track flaky tests, suggest fixes
- 📦 **Data seeding**: Generate realistic test data

---

## Commands

### Generate from API

```bash
e2e-test-generator generate --openapi ./api/openapi.yaml --output ./tests/cypress/
```

### Generate from Schema

```bash
e2e-test-generator generate --graphql ./api/schema.graphql --output ./tests/playwright/
```

### Golden Path

```bash
e2e-test-generator golden --flow "login-search-purchase" --output ./tests/e2e/login-flow.spec.js
```

### Edge Cases

```bash
e2e-test-generator edge --flow "checkout" --generate-invalid-cards --generate-network-errors
```

### Fix Flaky Tests

```bash
e2e-test-generator fix-flaky --test ./tests/e2e/checkout.spec.js --issue github-issue-123
```

### Coverage Report

```bash
e2e-test-generator coverage --compare ./tests/old ./tests/new --output report.html
```

---

## Exit Codes

- `0` - Generation successful ✅
- `1` - Generation failed ✖️
- `2` - Flakiness detected ⚠️
- `3` - API documentation error ❌

---

## Output Format

```javascript
// Generated Cypress test (./tests/e2e/login-flow.spec.js)
describe('User Login Flow', () => {
  beforeEach(() => {
    cy.visit('/login');
    cy.clearCookies();
  });

  it('should complete golden path: login → dashboard', () => {
    // Golden path: happy user journey
    cy.get('[data-testid="email"]').type('user@example.com');
    cy.get('[data-testid="password"]').type('password123');
    cy.get('[data-testid="login-btn"]').click();
    cy.url().should('include', '/dashboard');
  });

  it('should handle edge case: invalid email', () => {
    cy.get('[data-testid="email"]').type('not-an-email@@@@');
    cy.get('[data-testid="error-msg"]').should('contain', 'Invalid email');
  });

  it('should handle edge case: invalid password', () => {
    cy.get('[data-testid="email"]').clear().type('user@example.com');
    cy.get('[data-testid="password"]').clear().type('short');
    cy.get('[data-testid="error-msg"]').should('contain', 'Password must be 8+ characters');
  });

  it('should handle edge case: API rate limit', () => {
    cy.get('[data-testid="login-btn"]').click();
    cy.get('[data-testid="error-msg"]').should('contain', 'Too many requests');
  });
});
```

---

## Example Usage

```bash
# Generate from OpenAPI spec
e2e-test-generator generate --openapi ./api/openapi.yaml --output ./tests/cypress/

# Fix flaky tests
e2e-test-generator fix-flaky --test ./tests/e2e/checkout.spec.js --output ./tests/e2e/checkout-fixed.spec.js

# Generate from GraphQL schema
e2e-test-generator generate --graphql ./api/graphql/schema.json --output ./tests/playwright/
```

---

## Configuration

```yaml
# .e2e-test-generator.yaml
test_framework: cypress|playwright|jest
api_specs:
  - openapi: ./api/openapi.yaml
    graphql: ./api/graphql/schema.graphql
    rest_api: ./api/openapi.json
golden_paths:
  - login-search-purchase
  - user-registration
  - checkout
edge_cases:
  - invalid_email
  - invalid_password
  - network_timeout
  - api_rate_limit
  - database_failure
data_seeding:
  - user_profiles: 10
  - products: 50
  - carts: 100
flakiness:
  threshold: 0.1
  consecutive_failures: 3
  auto_tag_flaky: true
```

---

## Notes

- Supports Cypress, Playwright, Jest, Mocha
- Integrates with Postman, Insomnia collections
- Generates data-driven tests
- Tracks test execution results
- Suggests test improvements based on coverage
