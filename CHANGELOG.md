A professional CHANGELOG.md for an open-source enterprise product should be easy to read for humans and structured enough for automation. It serves as the primary "Control" document to link your database-tracked versions to actual project progress.

Below is a template based on the Keep a Changelog standard, customized for your Oracle Enterprise AI Assistant project.

CHANGELOG.md Template
Markdown

# Changelog
All notable changes to the **Oracle Enterprise AI Assistant** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
*Items listed here are completed in the `main` branch but not yet part of a tagged release.*
- ### Added
  - Initial structure for "Community Showcase" internal page.
- ### Fixed
  - P1: Hallucination issue when queryingHCM_SALARY table without specific parameters.

---

## [1.2.0] - 2025-12-25
### Added
- **AI Analytics**: Added "Chunking Analytics" to the Documents menu to visualize token splits.
- **Governance**: Introduced "Redaction Rules" (🚦) to mask PII data before LLM processing.
- **Help System**: Integrated the dynamic `ai_help_registry` database-driven menu.

### Changed
- Refactored Side Navigation to group items into: Knowledge, Governance, and Administration.
- Updated System Prompt logic to improve "Strategy Manager" retrieval accuracy.

### Fixed
- **P0**: Resolved connection timeout between Oracle APEX and OCI Generative AI endpoints.
- **P2**: Fixed UI alignment issues in the "Chat History" cards on mobile devices.

### Security
- Updated API key encryption method in the `Administration > Models` page.

---

## [1.1.0] - 2025-11-15
### Added
- Support for multi-PDF uploads in the Document Library.
- New "Context & Intent" dashboard for tracking intent-matching performance.

### Fixed
- **P1**: Fixed SQL injection vulnerability in the "Smart Search" input field.

---

## [1.0.0] - 2025-10-01
- Initial public open-source release.
- Core Chat Assistant functionality with RAG (Retrieval-Augmented Generation).
- Basic Administration and Document Management modules.
