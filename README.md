# grip-diagnostics

[![CI](https://github.com/jonaprieto/lean-grip-diagnostics/actions/workflows/ci.yml/badge.svg)](https://github.com/jonaprieto/lean-grip-diagnostics/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/jonaprieto/lean-grip-diagnostics?display_name=tag&sort=semver)](https://github.com/jonaprieto/lean-grip-diagnostics/releases)
[![Lean 4](https://img.shields.io/badge/Lean%204-v4.33.0-6f42c1)](lean-toolchain)
[![Docs](https://img.shields.io/badge/docs-GitHub%20Pages-4c8bf5)](https://jonaprieto.github.io/lean-grip-diagnostics/)
[![License](https://img.shields.io/badge/license-Apache--2.0-green)](LICENSE)

Adapter from Grip's byte-offset `ParseError` to the pure
[`termcolor-diagnostics`](https://github.com/jonaprieto/lean-termcolor-diagnostics) model.

## Install

```lean
require grip-diagnostics from git
  "https://github.com/jonaprieto/lean-grip-diagnostics.git" @ "v0.2.5"
```

## Quick start

```lean
import Grip
import GripDiagnostics
import TermColor.Diagnostics

open Grip GripDiagnostics TermColor TermColor.Diagnostics

def source : Source := Source.fromBytes "config.toml" "timeout = 2x".toUTF8
def error : ParseError := { pos := 11, line := 1, col := 12, expected := ["a duration"] }

def text : Text :=
  (diagnostic source error).withCode "GRIP001" |>.withHelp "try timeout = 2m"
    |> fun d => render #[source] d

#eval Text.render RenderTarget.plain text
```

The adapter preserves source bytes and maps a parser failure to a clamped primary point label.
Rendering supports plain text, ANSI targets, width-aware context, tabs, Unicode, and optional
OSC-8 locations. Terminal IO remains optional.

## Build

```sh
lake build GripDiagnostics GripDiagnostics.Properties tests demo readme
lake exe tests
lake exe demo
```

## Related projects

[`grip`](https://github.com/jonaprieto/lean-grip) supplies parsing;
[`termcolor-diagnostics`](https://github.com/jonaprieto/lean-termcolor-diagnostics) supplies the
renderer. [`lean-calc-chat`](https://github.com/jonaprieto/lean-calc-chat) uses the adapter in a
terminal application.

## License

Apache-2.0.
