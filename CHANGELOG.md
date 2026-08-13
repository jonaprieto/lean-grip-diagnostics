# Changelog

## 0.2.6 — 2026-08-13

- Publish the dependency-graph README cleanup.

## 0.2.5 — 2026-08-12

- Adopt Lean v4.33.0 and precommit-lean v0.1.6.

## 0.2.4 — 2026-08-12

- Adopt the shared `precommit-lean` hooks and refresh them to the pinned release.
- Rewrite the README concisely and drop the version number from it; the lakefile is the
  only place a pin belongs.

## 0.2.1 — 2026-08-02

- Fix CI to resolve private dependency revisions from `lake-manifest.json` instead of stale pins.

## 0.2.0 — 2026-08-02

- Made `GripDiagnostics.diagnostic` the only adapter API; callers render through
  `TermColor.Diagnostics.render` directly.
- Kept Grip's dependency-free `ParseError.pretty` as the plain fallback and left rich rendering in
  the optional TermColor frontend.

## 0.1.2 — 2026-08-02

- Enable clickable OSC-8 source locations in the interactive demo when styling is enabled.

## 0.1.1 — 2026-08-02

- Terminate the demo output with a newline so the shell prompt starts on its own line.

## 0.1.0 — 2026-08-02

- Added the optional `GripDiagnostics` source-annotated error adapter.
- Preserved raw Grip byte offsets while delegating layout and rendering to the termcolor stack.
- Added Unicode, tabs, invalid UTF-8, ASCII fallback, color, OSC-8, executable tests, and proofs.
- Added CI, proof-axiom auditing, README artwork validation, and the initial visual gallery.
