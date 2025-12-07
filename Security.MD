# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Currently supported versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

**Please do NOT report security vulnerabilities through public GitHub issues.**

If you discover a security vulnerability in Oracle APEX AI Assistant, please report it privately:

### How to Report

**Email:** alaa.guru@outlook.com

**Subject:** `[SECURITY] Oracle APEX AI Assistant - <brief description>`

**Include in your report:**
1. Type of vulnerability
2. Full paths of source file(s) related to the vulnerability
3. Step-by-step instructions to reproduce the issue
4. Proof-of-concept or exploit code (if possible)
5. Impact of the issue, including how an attacker might exploit it

### What to Expect

- **Acknowledgment:** Within 48 hours
- **Initial Assessment:** Within 7 days
- **Status Updates:** Every 7-14 days
- **Disclosure Timeline:** Coordinated disclosure after patch is available

### Security Best Practices

When deploying Oracle APEX AI Assistant:

1. **Never commit credentials** - Use Oracle Wallet for API keys
2. **Enable Row Level Security** - Activate VPD/RLS policies
3. **Use HTTPS only** - Enforce TLS 1.3
4. **Implement rate limiting** - Prevent abuse
5. **Regular updates** - Keep Oracle DB and APEX current
6. **Audit logging** - Monitor DEBUG_LOG regularly
7. **Network ACLs** - Restrict external API access
8. **Input validation** - Use prepared statements
9. **Least privilege** - Grant minimum necessary permissions
10. **Backup regularly** - Maintain disaster recovery plan

### Known Security Considerations

1. **API Keys:** Store LLM API keys in Oracle Wallet, never in code
2. **User Input:** All user prompts are validated and sanitized
3. **Data Classification:** Respect 4-level classification (Public → Restricted)
4. **Audit Trail:** All requests logged in DEBUG_LOG with TRACE_ID
5. **Network Access:** ACLs restrict outbound connections to approved endpoints

### Scope

**In Scope:**
- Oracle Database PL/SQL packages
- APEX application code
- Database schema and permissions
- API integrations
- Authentication and authorization
- Data classification enforcement

**Out of Scope:**
- Third-party LLM provider vulnerabilities (OpenAI, Claude, Gemini)
- Oracle Database core vulnerabilities (report to Oracle)
- Oracle APEX platform vulnerabilities (report to Oracle)
- Infrastructure (network, OS, etc.)

### Responsible Disclosure

We follow coordinated vulnerability disclosure:

1. Security researcher reports vulnerability privately
2. We acknowledge and investigate
3. We develop and test a fix
4. We release a security patch
5. Public disclosure after patch is available
6. Credit given to researcher (if desired)

### Security Updates

Security patches will be released as:
- **Critical:** Within 24-48 hours
- **High:** Within 7 days
- **Medium:** Within 30 days
- **Low:** Next regular release

### Hall of Fame

Security researchers who responsibly disclose vulnerabilities will be acknowledged here (with their permission).

*No entries yet - be the first!*

---

## Contact

**Security Contact:** Alaaeldin Abdelmonem  
**Email:** alaa.guru@outlook.com  
**LinkedIn:** https://linkedin.com/in/alaa-eldin

For general questions (non-security), please use GitHub Issues.

---

**Thank you for helping keep Oracle APEX AI Assistant and its users safe!**

© 2025 Alaaeldin Abdelmonem
