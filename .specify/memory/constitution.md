<!--
Sync Impact Report
==================
- Version change: (none) → 1.0.0
- Modified principles: N/A (initial ratification)
- Added sections:
  - I. Zero-Dependency
  - II. Public API Surface Control
  - III. Static Analysis Compliance
  - IV. Layered Architecture
  - V. Simplicity & YAGNI
  - Quality Gates (Section 2)
  - Development Workflow (Section 3)
  - Governance
- Removed sections: N/A
- Templates requiring updates:
  - .specify/templates/plan-template.md — ✅ no update needed
    (Constitution Check section is generic; principles are referenced at plan time)
  - .specify/templates/spec-template.md — ✅ no update needed
    (Spec template is requirement-focused, no principle-specific slots)
  - .specify/templates/tasks-template.md — ✅ no update needed
    (Task phases are story-driven; no principle-specific task types required)
  - .specify/templates/commands/*.md — ✅ N/A (no command files exist)
- Follow-up TODOs: none
-->

# flutter_context_menu Constitution

## Core Principles

### I. Zero-Dependency

The package MUST NOT introduce runtime dependencies beyond the Flutter SDK
itself. This is a foundational promise to consumers: `flutter_context_menu`
adds zero transitive weight to their dependency tree.

- Every feature MUST be implementable with Flutter SDK primitives alone.
- `dev_dependencies` (lints, test utilities) are exempt from this rule.
- If a capability cannot be achieved without a third-party package, the
  feature MUST be rejected or redesigned until it can.

**Rationale**: Minimizing dependency surface reduces version conflicts,
supply-chain risk, and upgrade friction for consumers.

### II. Public API Surface Control

All public symbols MUST be exported exclusively through the barrel file
`lib/flutter_context_menu.dart`. No consumer should ever import from
`lib/src/` directly.

- New public classes, typedefs, or extensions MUST be added to the barrel
  file before the PR is merged.
- Removing or renaming a public symbol is a MAJOR version bump per SemVer.
- Adding a new public symbol is a MINOR version bump.
- Internal refactors that do not change the barrel file are PATCH-level.

**Rationale**: A single entry point makes the API discoverable, prevents
accidental exposure of internals, and enforces intentional versioning.

### III. Static Analysis Compliance

All code MUST pass `flutter analyze --fatal-warnings` and
`dart format --set-exit-if-changed .` with zero issues before merge.

- The project uses `flutter_lints` plus project-specific rules:
  `prefer_relative_imports`, `prefer_const_declarations`,
  `prefer_const_constructors`, `prefer_final_fields`.
- New lint rule additions MUST be applied project-wide (no per-file
  ignores unless justified in the PR description).
- CI enforces both analysis and formatting as hard gates.

**Rationale**: Consistent style and zero-warning discipline prevent
regressions and keep the codebase approachable for contributors.

### IV. Layered Architecture

The package is organized into three layers with a strict dependency
direction: **Models → Components → Widgets**.

- **Models** (`lib/src/core/models/`): Pure data definitions
  (`ContextMenu`, `ContextMenuEntry`, `ContextMenuItem`). No widget
  imports allowed.
- **Components** (`lib/src/components/`): Concrete entry types
  (`MenuItem`, `MenuHeader`, `MenuDivider`) that may reference models
  but MUST NOT import widget-layer code.
- **Widgets** (`lib/src/widgets/`): Stateful display logic
  (`ContextMenuRegion`, `ContextMenuWidget`, etc.) that composes
  models and components.

New code MUST respect this dependency direction. A model file importing
from `widgets/` is a violation.

**Rationale**: Layered separation keeps the data model testable in
isolation and prevents circular dependencies.

### V. Simplicity & YAGNI

Features MUST solve a concrete, demonstrated need. Speculative
abstractions, premature configurability, and "just in case" code are
prohibited.

- Three similar lines of code are preferred over a premature helper.
- No feature flags or backward-compatibility shims when the code can
  simply be changed.
- Custom menu entries are supported via subclassing `ContextMenuEntry<T>`;
  new entry types SHOULD use this extension point rather than adding
  parameters to existing classes.

**Rationale**: A focused API is easier to learn, maintain, and document.
Complexity must be justified by real-world usage.

## Quality Gates

All pull requests MUST pass the following automated gates before merge:

1. `flutter analyze --fatal-warnings` — zero warnings or errors.
2. `dart format --output=none --set-exit-if-changed .` — zero formatting
   drift.
3. The `example/` app MUST build successfully (`cd example && flutter
   build`).
4. If unit tests exist, they MUST pass. The package currently has no unit
   tests; the only test is a smoke test in `example/test/`.

Manual review MUST verify:

- New public symbols are added to the barrel file (Principle II).
- No new runtime dependencies introduced (Principle I).
- Layer boundaries respected (Principle IV).

## Development Workflow

1. **Branching**: Feature branches off `main`. One logical change per PR.
2. **Versioning**: Follow SemVer strictly, guided by Principle II rules:
   - MAJOR: public API removal or incompatible change.
   - MINOR: new public API addition.
   - PATCH: bug fixes, internal refactors, documentation.
3. **Changelog**: Every version bump MUST have a corresponding entry in
   `CHANGELOG.md` describing user-facing changes.
4. **Publishing**: Publish to pub.dev only from `main` after all quality
   gates pass.

## Governance

This constitution is the authoritative source of project principles.
All PRs and code reviews MUST verify compliance with the principles
above.

- **Amendments** require a documented rationale, a PR updating this
  file, and version bump per the semantic versioning rules below.
- **Version policy**: MAJOR for principle removal/redefinition, MINOR
  for new principle or material expansion, PATCH for clarifications
  and wording fixes.
- **Compliance review**: At least one reviewer MUST confirm constitution
  adherence before merge. The `/speckit.plan` Constitution Check gate
  references these principles.

**Version**: 1.0.0 | **Ratified**: 2026-03-02 | **Last Amended**: 2026-03-02
