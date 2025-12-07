# Contributing to Oracle APEX AI Assistant

First off, thank you for considering contributing to Oracle APEX AI Assistant! 🎉

This document provides guidelines for contributing to the project. Following these guidelines helps maintain code quality and makes the review process smoother for everyone.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing Requirements](#testing-requirements)

---

## 📜 Code of Conduct

This project adheres to a Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

**In short:**
- Be respectful and inclusive
- Accept constructive criticism gracefully
- Focus on what's best for the community
- Show empathy towards others

---

## 🤔 How Can I Contribute?

### Reporting Bugs 🐛

Before submitting a bug report:
1. **Check existing issues** - your bug may already be reported
2. **Use the latest version** - the bug may be fixed
3. **Test with minimal setup** - eliminate external factors

**Good bug reports include:**
- Clear, descriptive title
- Oracle DB version (e.g., 23.4.0)
- APEX version (e.g., 24.2.10)
- Exact steps to reproduce
- Expected vs. actual behavior
- Error messages (full stack trace if applicable)
- Sample code (if applicable)

**Use the bug report template:** [.github/ISSUE_TEMPLATE/bug_report.md]

### Suggesting Features 💡

We love feature requests! Before suggesting:
1. **Check the roadmap** - it may be planned
2. **Search existing issues** - it may be discussed
3. **Consider scope** - does it fit the project goals?

**Good feature requests include:**
- Clear use case and problem statement
- Proposed solution (if you have one)
- Alternative approaches considered
- Impact on existing functionality
- Willingness to implement (even better!)

**Use the feature request template:** [.github/ISSUE_TEMPLATE/feature_request.md]

### Improving Documentation 📚

Documentation improvements are always welcome:
- Fix typos or clarify unclear sections
- Add examples or use cases
- Improve code comments
- Translate documentation (if multilingual support added)

### Contributing Code 💻

1. **Fork the repository**
2. **Create a feature branch** from `main`
   ```bash
   git checkout -b feature/my-new-feature
   ```
3. **Make your changes** (see Coding Standards below)
4. **Test thoroughly** (see Testing Requirements)
5. **Commit your changes** (see Commit Guidelines)
6. **Push to your fork**
   ```bash
   git push origin feature/my-new-feature
   ```
7. **Submit a Pull Request**

---

## 🛠️ Development Setup

### Prerequisites

- Oracle Database 23ai (23.4.0+)
- Oracle APEX 24.2.10+
- SQL*Plus or SQL Developer
- Git

### Local Setup

```bash
# 1. Fork and clone the repository
git clone https://github.com/YOUR_USERNAME/oracle-apex-ai-assistant.git
cd oracle-apex-ai-assistant

# 2. Create your development schema
sqlplus / as sysdba
CREATE USER ai8p_dev IDENTIFIED BY your_password;
GRANT CREATE SESSION, CREATE TABLE, CREATE PROCEDURE TO ai8p_dev;
-- ... other grants

# 3. Connect as dev user and install
sqlplus ai8p_dev/your_password
@database/scripts/install_full.sql

# 4. Load sample data
@database/data/01_context_domains.sql
@database/data/02_context_behaviors.sql
```

### Recommended Tools

- **SQL Developer** - Oracle's IDE for PL/SQL development
- **VS Code** - with Oracle extensions for syntax highlighting
- **Git** - version control
- **SQL*Plus** - for running scripts

---

## 📏 Coding Standards

### Oracle SQL Standards

#### ✅ DO: Use Oracle Proprietary JOIN Syntax

```sql
-- CORRECT ✅
SELECT e.employee_name, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id(+);  -- Left outer join

-- INCORRECT ❌
SELECT e.employee_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;
```

**Why?** This project uses Oracle's traditional syntax for consistency with existing codebase.

#### Naming Conventions

| Object Type | Prefix/Suffix | Example |
|-------------|---------------|---------|
| Lookup Tables | `LKP_` | `LKP_SECURITY_LEVEL` |
| Utility Packages | `_UTIL` | `DEBUG_UTIL` |
| Regular Tables | None | `AI_CHAT_SESSIONS` |
| Sequences | `_SEQ` | `AI_CHAT_SESSIONS_SEQ` |
| Indexes | `IDX_` | `IDX_SESSIONS_USER_ID` |

#### PL/SQL Standards

```sql
-- ✅ GOOD: Clear, documented, error handling
CREATE OR REPLACE PACKAGE BODY my_util AS

    /**
     * Brief description of procedure
     * @param p_user_id - User identifier
     * @return Success message
     */
    FUNCTION process_request(
        p_user_id IN NUMBER
    ) RETURN VARCHAR2 IS
        v_result VARCHAR2(4000);
    BEGIN
        -- Clear logic with comments
        IF p_user_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'User ID required');
        END IF;
        
        -- Process logic here
        v_result := 'Success';
        
        RETURN v_result;
    EXCEPTION
        WHEN OTHERS THEN
            -- Log error
            debug_util.error('Error in process_request: ' || SQLERRM);
            RAISE;
    END process_request;

END my_util;
/
```

**Best Practices:**
- ✅ Always include comments for complex logic
- ✅ Use meaningful variable names (`v_user_id` not `x`)
- ✅ Include exception handling
- ✅ Log errors using `DEBUG_UTIL` package
- ✅ Validate input parameters
- ❌ Never use `WHEN OTHERS` without re-raising or logging

### APEX Standards

- Use named static IDs for regions and items
- Follow APEX naming conventions (e.g., `P115_USER_PROMPT`)
- Minimize JavaScript; prefer APEX dynamic actions
- Document complex dynamic actions
- Use APEX_STRING, APEX_JSON packages for modern APIs

### Documentation Standards

Every public function/procedure must have:
```sql
/**
 * Brief one-line description
 * 
 * Detailed description if needed (optional)
 * 
 * @param p_parameter1 - Description of parameter
 * @param p_parameter2 - Description of parameter
 * @return Description of return value
 * @throws -20001 - Description of error condition
 * 
 * @example
 * DECLARE
 *   v_result VARCHAR2(100);
 * BEGIN
 *   v_result := my_function(p_param => 'value');
 * END;
 */
```

---

## 📝 Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `chore`: Maintenance tasks

**Examples:**

```
feat(chat): add streaming response support

Implements Server-Sent Events (SSE) for real-time streaming
of LLM responses in the chat interface.

Closes #42
```

```
fix(debug): resolve null pointer in debug_util.log()

Fixed issue where calling debug_util.log() with null 
extra_data parameter caused ORA-06502 error.

Fixes #58
```

---

## 🔄 Pull Request Process

### Before Submitting

1. ✅ **Test your changes** - run all test suites
2. ✅ **Update documentation** - if you changed APIs
3. ✅ **Check code style** - follow coding standards
4. ✅ **Rebase on main** - ensure clean merge
5. ✅ **Write clear commit messages**

### PR Template

Your PR description should include:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring

## Testing
- [ ] All existing tests pass
- [ ] Added new tests for new features
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project style guide
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
- [ ] Reviewed own code

## Related Issues
Closes #42
```

### Review Process

1. **Automated Checks** - CI/CD validation (if enabled)
2. **Code Review** - At least one maintainer approval
3. **Testing** - Maintainer may test in their environment
4. **Merge** - Squash and merge (keeps history clean)

**Timeline:** We aim to review PRs within 3-5 business days.

---

## 🧪 Testing Requirements

### Running Tests

```sql
-- Run all tests
@database/tests/run_all_tests.sql

-- Run specific test suite
@database/tests/test_chat_engine_pkg.sql
```

### Test Requirements

- All new features must include tests
- Tests must be self-contained
- Tests must clean up after themselves
- Include both positive and negative test cases

### Test Example

```sql
CREATE OR REPLACE PROCEDURE test_my_feature AS
    v_result VARCHAR2(100);
BEGIN
    -- Test Case 1: Valid input
    v_result := my_package.my_function(p_valid => 'Y');
    IF v_result != 'SUCCESS' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Test failed: expected SUCCESS');
    END IF;
    
    -- Test Case 2: Invalid input
    BEGIN
        v_result := my_package.my_function(p_valid => NULL);
        RAISE_APPLICATION_ERROR(-20001, 'Test failed: should have raised error');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE != -20001 THEN
                RAISE;
            END IF;
    END;
    
    DBMS_OUTPUT.PUT_LINE('✅ All tests passed');
END;
/
```

---

## ❓ Questions?

- **Not sure where to start?** Look for issues labeled `good first issue`
- **Need help?** Open a discussion or ask in the PR
- **Found a security issue?** Email alaa.guru@outlook.com (do NOT open public issue)
- **Want professional support?** Contact Alaaeldin Abdelmonem for consulting

### Contact the Maintainer

**Alaaeldin Abdelmonem**
- Email: alaa.guru@outlook.com
- LinkedIn: https://linkedin.com/in/alaa-eldin
- Website: https://regpulses.godaddysites.com/

---

## 🎉 Recognition

Contributors will be:
- Listed in [CONTRIBUTORS.md](CONTRIBUTORS.md)
- Mentioned in release notes
- Thanked in community updates

---

**Thank you for contributing to Oracle APEX AI Assistant! 🚀**
