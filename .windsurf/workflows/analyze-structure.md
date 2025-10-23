---
description: Flutter Package Code Structure and Best Practices Audit
---

**Goal:**
Analyze the entire Flutter package codebase (including `lib/src/`, `example/`, and `test/` folders)
and give me a detailed review on **architecture, structure, and maintainability**, focusing on
*clean code, SOLID principles, package scalability, and Flutter package conventions*.

**Context:**
This package is a context menu system for Flutter. It contains menu entries, selectable items,
submenus, overlays, and menu states. I’m aiming for a highly modular, dependency-free, and scalable
design that can support theming, animations, adaptive layouts, and advanced user interactions.

**Instructions:**

1. **Evaluate folder structure:**

    * Is the current directory layout logical and scalable for a public Flutter package?
    * Are internal and public APIs clearly separated (`lib/src` for internals, root exports for
      public)?
    * Suggest a clean hierarchy (e.g., `core/`, `state/`, `models/`, `widgets/`, `actions/`,
      `utils/`).
2. **Assess architectural design:**

    * Identify any coupling between UI (`BuildContext`, widgets) and logic that breaks clean
      separation.
    * Suggest how to isolate logic (controllers, actions, state machines) from presentation (
      widgets, overlays).
    * Comment on how well the current structure adheres to the **Single Responsibility**, *
      *Open/Closed**, and **Dependency Inversion** principles.
3. **Code readability and maintainability:**

    * Highlight any long methods, mixed responsibilities, or redundant abstractions.
    * Check naming consistency, null-safety handling, and documentation quality.
    * Suggest refactoring points for better cohesion and clarity.
4. **Best practices for Flutter package development:**

    * Check for proper use of `@immutable`, `const` constructors, and widget immutability.
    * Verify `export` strategy and public API cleanliness (avoid leaking internal classes).
    * Recommend how to structure barrel files for clean imports.
5. **Testing and maintainability:**

    * Suggest what kinds of tests are missing (unit, widget, integration).
    * Point out where logic should be tested without a widget tree.
    * Recommend folder organization for tests (`test/core/`, `test/widgets/`, etc.).
6. **Performance and extensibility:**

    * Identify any potential rebuild or overlay inefficiencies.
    * Suggest how to make actions or state updates more performant or modular.
    * Mention if any patterns (Observer, Command, State, or ValueNotifier) could improve
      scalability.
7. **Documentation and consistency:**

    * Recommend how to document internals (doc comments vs README vs API reference).
    * Suggest naming consistency (e.g., suffixes like `State`, `Controller`, `Entry`, `Renderer`).

**Output format:**
Give me a detailed structured report with sections:

* Folder & File Organization
* Architecture & Dependency Flow
* Code Smells & Anti-patterns
* Suggested Refactors
* Missing Abstractions
* Public API Recommendations
* Testing Coverage & Recommendations
* Documentation & Developer Experience

**Important:**
Be brutally honest — I want a *senior-level, detailed critique*, not generic advice.
Focus on concrete, actionable recommendations tailored to my codebase.
Assume I know Flutter and architecture deeply; skip beginner explanations.

**Extra Context:**
I’m intentionally avoiding 3rd-party state management dependencies (like provider, bloc, riverpod).
I want to keep the package lightweight, relying only on core Flutter/Dart patterns and solid
internal structure.