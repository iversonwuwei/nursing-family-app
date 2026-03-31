## Harness Engineering Rules

This repository uses Harness Engineering as the default delivery model for all future implementation work.

### Operating Model

- Design every change as the smallest reviewable delivery unit.
- Before substantial edits, state the entry points, affected users, rollout stage, validation gate, and rollback path.
- Prefer root-cause fixes over surface patches, but keep the blast radius narrow.
- Do not mix unrelated cleanup into feature, bug-fix, or UX work.
- Distinguish three outcomes in status reporting: implemented, verified, and residual risk.

### Release Safety And Progressive Delivery

- Treat this app as a release-sensitive mobile client for family users.
- For user-visible or workflow-sensitive changes, prefer scoped exposure, reversible UI logic, or configuration-based fallback when available.
- If there is no runtime flag or remote config path, document the rollback method before changing behavior.
- Prefer reversible changes to navigation, tab state, data mapping, and interaction flows.
- Avoid one-way data migrations or destructive local-state changes unless the rollback impact is documented.

### Verification As A Gate

- Verification is mandatory. Every change needs explicit success signals.
- Default repository gate: `flutter analyze` and `flutter test`.
- For layout, navigation, or state-retention changes, also validate the affected flow on a simulator or an equivalent reproducible runtime path when feasible.
- If runtime validation is unavailable, state the exact unverified behavior and the best proxy signal.

### Observability And Reliability

- Follow the Harness Continuous Verification mindset: UI and state changes should leave behind evidence that the user flow is healthy.
- Preserve or add observable signals for important flows such as route entry, data loading, empty state, error recovery, and destructive actions.
- Prefer deterministic UI states and stable widget structure over fragile implicit behavior.
- For important views, define what healthy looks like before implementation.

### Mobile Frontend Rules

- For each meaningful UI change, describe user impact, data source, loading state, empty state, error state, and mobile impact.
- Respect the existing GetX architecture, route layering, and small-widget decomposition.
- Keep page state stable across tab switches, navigation pops, and app lifecycle changes when the feature requires continuity.
- When changing mock-backed flows, document whether the behavior is mock-only or intended to match the future real API contract.

### API And Integration Rules

- If introducing or changing service, repository, or mock interfaces, describe caller impact, compatibility expectations, and migration path to real APIs.
- Preserve backward compatibility for in-app consumers unless a breaking change is explicitly authorized.
- For payload or model changes, include examples and rollback strategy.

### Dependency And Supply Chain Rules

- Avoid adding new packages unless Flutter SDK, Dart SDK, or current dependencies are insufficient.
- Any new package, build step, or external service must be justified with source, purpose, risk, and minimum necessity.
- Preserve reproducible local builds and analyzer behavior.

### Required Delivery Templates

- Mobile frontend: scope -> user impact -> data or mock source -> loading, empty, error, mobile states -> verification -> rollback.
- Service or integration logic: scope -> contract and dependencies -> failure handling -> observability -> verification -> rollback.
- API or model: scope -> compatibility -> caller impact -> field evolution strategy -> examples -> verification -> rollback.

### Repository Verification Gates

- Minimum gate for code changes: `flutter analyze` and `flutter test`.
- Required extra gate for UI state, navigation, simulator-only, or rendering-sensitive work: run the affected flow on a simulator when feasible.
- If a required gate cannot run because of environment constraints, document the blocker and residual risk.

### Source Of Truth

- Primary reference: <https://developer.harness.io/docs>
- GitHub source reference: <https://github.com/harness/developer-hub>
- Most relevant Harness areas for this repository: Continuous Delivery verification, Feature Flags, Infrastructure as Code Management, Software Supply Chain Security, and release-oriented observability for mobile workflows.