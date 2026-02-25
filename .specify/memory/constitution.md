<!--
  Sync Impact Report
  ===================
  Version change: (none — template) → 1.0.0
  Modified principles: N/A (first ratification)
  Added sections:
    - Core Principles (I–V) derived from plan.md Constitution Check
    - Technology Constraints
    - Development Workflow
    - Governance
  Removed sections: N/A
  Templates requiring updates:
    - .specify/templates/plan-template.md ✅ no update needed (generic gates reference)
    - .specify/templates/spec-template.md ✅ no update needed (no constitution refs)
    - .specify/templates/tasks-template.md ✅ no update needed (generic template)
    - .specify/templates/agent-file-template.md ✅ no update needed (generic template)
    - CLAUDE.md ✅ already references "constitution principle I"
  Follow-up TODOs: none
-->

# Flutter Context Menu Constitution

## Core Principles

### I. Zero Dependencies

The package MUST maintain zero runtime dependencies beyond the Flutter
SDK (`flutter` SDK dependency only). All functionality MUST be
implemented using only Flutter SDK APIs (`ThemeExtension`,
`InheritedWidget`, `Color.lerp`, `BoxDecoration`, etc.). Dev
dependencies (`flutter_test`, `flutter_lints`) are permitted.

**Rationale**: A context menu widget is a leaf-level UI package.
Additional runtime dependencies increase version conflict risk for
consumers and bloat the dependency tree for a focused utility.

### II. Public API Discipline

All public types MUST be exported through the barrel file
`lib/flutter_context_menu.dart`. Internal source MUST follow the
three-layer architecture:

- **Models**: `lib/src/core/models/` — immutable data classes
- **Components**: `lib/src/components/` — concrete menu entry types
- **Widgets**: `lib/src/widgets/` — rendering, state, and provider
  widgets, organized into subdirectories (`base/`, `provider/`,
  `theme/`)

New public types MUST be placed in the correct layer. Types that are
not exported through the barrel file MUST be treated as private
implementation details.

**Rationale**: A single entry point simplifies consumer imports and
enforces architectural boundaries. The layered structure prevents
circular dependencies and keeps rendering separate from data.

### III. Static Analysis Compliance

All code MUST pass:
- `flutter analyze --fatal-warnings`
- `dart format --output=none --set-exit-if-changed .`

The following lint rules are enforced and MUST NOT be suppressed
without explicit justification:
- `prefer_relative_imports` — relative imports within the package
- `prefer_const_declarations`
- `prefer_const_constructors`
- `prefer_final_fields`

**Rationale**: CI gates enforce these checks. Suppressing warnings
hides real issues and erodes code quality over time.

### IV. Cross-Platform Compatibility

All code MUST work on Android, iOS, Web, and Desktop (macOS, Windows,
Linux) without platform-specific code or conditional imports. The
package MUST NOT use `dart:io`, platform channels, or any API
unavailable on all six targets.

**Rationale**: The package is published on pub.dev for general
Flutter consumption. Platform-specific code fragments the user base
and increases maintenance burden.

### V. Simplicity & Extensibility

New abstractions MUST be minimal and justified by concrete current
requirements. Custom entry builders MUST retain access to shared
state (e.g., theme data) via `BuildContext`. YAGNI applies — do not
build for hypothetical future requirements.

Immutable, `const`-constructible data classes are preferred.
`copyWith`, `merge`, and `lerp` methods MUST be provided on theme
data classes to support Flutter's theming conventions.

**Rationale**: A focused widget package must stay lean. Over-
engineering discourages contributions and increases the learning
curve for consumers.

## Technology Constraints

- **Dart**: ^3.6.0
- **Flutter**: >=3.27.0
- **Runtime dependencies**: Flutter SDK only (principle I)
- **Dev dependencies**: `flutter_test`, `flutter_lints` ^6.0.0
- **Versioning**: Semantic versioning per pub.dev conventions
  (MAJOR.MINOR.PATCH). Additive public API = MINOR bump. Breaking
  changes = MAJOR bump.

## Development Workflow

- **Analysis**: `flutter analyze --fatal-warnings` MUST pass before
  merge (CI-enforced).
- **Formatting**: `dart format --output=none --set-exit-if-changed .`
  MUST pass before merge (CI-enforced).
- **Testing**: No unit test suite exists for the package itself. The
  smoke test in `example/test/` MUST continue to pass. New features
  SHOULD be validated via the example app.
- **Branching**: Feature branches follow the pattern
  `###-feature-name` (e.g., `001-theme-support`).
- **Specifications**: Feature specs live in `specs/###-feature-name/`
  with plan, spec, tasks, and supporting artifacts.

## Governance

This constitution supersedes ad-hoc practices. All feature plans MUST
include a Constitution Check table verifying compliance with each
principle before implementation begins.

**Amendment procedure**:
1. Propose the change with rationale.
2. Update this file with the new or modified principle.
3. Increment the version (MAJOR for removals/redefinitions, MINOR
   for additions, PATCH for clarifications).
4. Update `LAST_AMENDED_DATE`.
5. Propagate changes to `CLAUDE.md` and any affected spec artifacts.

**Compliance review**: Each feature's plan.md MUST contain a
Constitution Check section that lists every principle with a
PASS/FAIL status and notes.

**Version**: 1.0.0 | **Ratified**: 2026-02-05 | **Last Amended**: 2026-02-24
