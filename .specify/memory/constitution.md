<!--
Sync Impact Report
- Version change: 0.0.0 → 1.0.0 (initial ratification)
- Added principles:
  - I. Zero Dependencies
  - II. Type Safety
  - III. Public API Stability
  - IV. Static Analysis Compliance
  - V. Widget Composability
- Added sections:
  - Quality Gates
  - Development Workflow
  - Governance
- Removed sections: (none — fresh constitution)
- Templates requiring updates:
  - .specify/templates/plan-template.md — ✅ no updates needed
    (Constitution Check section is generic; principles slot in at
    usage time)
  - .specify/templates/spec-template.md — ✅ no updates needed
    (template is feature-agnostic)
  - .specify/templates/tasks-template.md — ✅ no updates needed
    (task phases are generic; no principle-specific task types added)
- Follow-up TODOs: none
-->

# flutter_context_menu Constitution

## Core Principles

### I. Zero Dependencies

The package MUST NOT introduce runtime dependencies beyond the
Flutter SDK (`flutter`). Dev-dependencies (linting, testing) are
permitted. Every feature MUST be implementable with Flutter's
built-in primitives (widgets, overlays, focus system, gestures).

**Rationale**: A context-menu widget is foundational UI
infrastructure. Adding third-party dependencies increases supply-
chain risk and version-conflict potential for consumers.

### II. Type Safety

All public APIs that operate on menu values MUST preserve generic
type parameters (`<T>`) through the full call chain — from
`ContextMenu<T>` through `ContextMenuState<T>`, entry builders,
and selection callbacks. Type erasure at any boundary is a
regression.

**Rationale**: Consumers rely on compile-time type checking to
connect menu selections to domain logic. Silent type erasure
causes runtime failures that are difficult to diagnose.

### III. Public API Stability

Breaking changes to exported symbols MUST be:
1. Documented in `CHANGELOG.md` under a **Breaking Changes**
   heading.
2. Reflected in a MINOR version bump (pre-1.0) or MAJOR version
   bump (post-1.0) per pub.dev semver conventions.
3. Accompanied by migration guidance when the change affects
   commonly used API surface.

New public API MUST be exported exclusively through the barrel
file `lib/flutter_context_menu.dart`. Internal implementation
files MUST NOT be imported directly by consumers.

**Rationale**: The package is published on pub.dev; downstream
projects pin versions and rely on semver guarantees.

### IV. Static Analysis Compliance

All code MUST pass `flutter analyze --fatal-warnings` and
`dart format --set-exit-if-changed .` before merge. The
project-level `analysis_options.yaml` rules — including
`prefer_relative_imports`, `prefer_const_constructors`,
`prefer_const_declarations`, and `prefer_final_fields` — are
non-negotiable.

**Rationale**: CI enforces these gates. A clean analysis report
is a prerequisite for every PR; violations block merge.

### V. Widget Composability

Menu entries MUST follow Flutter's compositional model:
- Custom entries are created by subclassing `ContextMenuEntry<T>`
  and implementing the `builder` method — not by modifying
  built-in entry classes.
- Labels, icons, and trailing widgets accept `Widget` (not
  primitive types) so consumers can compose arbitrary content.
- Positioning, focus, and keyboard navigation MUST work
  identically for built-in and custom entries.

**Rationale**: A context-menu library succeeds when it is
extensible without forking. Composability keeps the core small
while enabling unlimited customization.

## Quality Gates

All pull requests MUST satisfy these gates before merge:

- `flutter analyze --fatal-warnings` passes with zero issues.
- `dart format --set-exit-if-changed .` reports no formatting
  drift.
- `CHANGELOG.md` is updated for user-facing changes.
- Breaking changes include a **Breaking Changes** section in the
  changelog entry and appropriate version bump.
- The example app (`example/`) builds and runs without errors.

## Development Workflow

- **Imports**: Use relative imports within the `lib/` directory.
  The barrel file `lib/flutter_context_menu.dart` is the sole
  public entry point.
- **Branching**: Feature branches merge into `main` via pull
  request.
- **Versioning**: Follow pub.dev semver — pre-1.0, MINOR bumps
  for breaking changes; PATCH bumps for fixes and non-breaking
  additions.
- **Commit style**: Use conventional-commit prefixes (`feat:`,
  `fix:`, `docs:`, `chore:`, `refactor:`).

## Governance

This constitution is the authoritative source of project
principles. It supersedes ad-hoc conventions wherever a conflict
arises.

**Amendment procedure**:
1. Propose changes via the `/speckit.constitution` command or a
   pull request modifying this file.
2. Document the rationale for each change.
3. Increment the version per semver:
   - MAJOR: principle removal or incompatible redefinition.
   - MINOR: new principle or materially expanded guidance.
   - PATCH: wording clarification or typo fix.
4. Update `Last Amended` date.

**Compliance**: All spec, plan, and task artifacts produced by
SpecKit commands MUST be validated against these principles.
The plan template's "Constitution Check" section MUST reference
the principles active at generation time.

**Version**: 1.0.0 | **Ratified**: 2026-03-01 | **Last Amended**: 2026-03-01
