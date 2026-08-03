# lean-grip-diagnostics

[![CI](https://github.com/jonaprieto/lean-grip-diagnostics/actions/workflows/ci.yml/badge.svg)](https://github.com/jonaprieto/lean-grip-diagnostics/actions/workflows/ci.yml)
[![Lean](https://img.shields.io/badge/Lean-v4.28.0-blue)](lean-toolchain)
[![License](https://img.shields.io/badge/license-Apache--2.0-green)](LICENSE)

The optional source-annotated diagnostics frontend for [Grip](https://github.com/jonaprieto/lean-grip).
It translates Grip's byte-offset `ParseError` into the rich, pure `TermColor.Diagnostics` model.

Grip stays Batteries-only and terminal-independent. This package adds the presentation layer:
Unicode-aware source context, styled filenames, tabs, CJK display width, color schemes, plain
output, and optional clickable OSC-8 locations.

## Install

Add the package to `lakefile.lean`:

~~~lean
require «grip-diagnostics» from git
  "https://github.com/jonaprieto/lean-grip-diagnostics.git"
  @ "v0.2.1"
~~~

`grip-diagnostics` brings in compatible pinned releases of Grip and
`termcolor-diagnostics`. The core `grip` package does not depend on this frontend.

## Quick start

The adapter accepts the original source bytes, so parser offsets stay byte-accurate while the
renderer computes human-facing line numbers and display columns:

~~~lean
import Grip                  -- parser and ParseError types
import GripDiagnostics       -- Grip -> TermColor adapter
import TermColor.Diagnostics -- source-aware renderer

open Grip
open GripDiagnostics
open TermColor
open TermColor.Diagnostics

def source : Source :=
  Source.fromBytes "config.toml" "timeout = 2x".toUTF8

def error : ParseError :=
  { pos := 11, line := 1, col := 12, expected := ["a duration"] }

def text : Text :=
  (diagnostic source error)
    |>.withCode "GRIP001"
    |>.withHelp "try timeout = 2m"
    |> fun diagnostic => render #[source] diagnostic

#eval Text.render RenderTarget.plain text
~~~

The normal parser path is identical:

~~~lean
def parser : Parser Nat :=
  GParser.weakenFallible
    ((GParser.string "timeout = " *> GParser.nat) <* GParser.eof)

def report (input : String) : Except ParseError Nat :=
  parser.parse input.toUTF8
~~~

At a CLI boundary, pass the returned `Text` to `TermColor.Text.render` for an explicit target or
to `TermColor.Terminal.writeText` when using the optional terminal package and automatic policy.

## API

~~~lean
namespace GripDiagnostics

def diagnostic (source : TermColor.Diagnostics.Source) (error : Grip.ParseError)
    (title : String := "parse error") : TermColor.Diagnostics.Diagnostic

end GripDiagnostics
~~~

`diagnostic` returns an ordinary `Diagnostic`, so callers can add codes, notes, help messages,
secondary labels, or a source URI before rendering:

~~~lean
let source := Source.fromBytes "config.toml" bytes |>.withUri "file:///tmp/config.toml"
let d := (GripDiagnostics.diagnostic source error)
  |>.withCode "GRIP001"
  |>.withNote "durations use s, m, or h"
  |>.withHelp "try timeout = 2m"
let text := TermColor.Diagnostics.render #[source] d { hyperlinks := true }
~~~

The primary label is a point span at the clamped parser byte offset. `Source.fromBytes` keeps the
raw bytes, including invalid UTF-8; `termcolor-diagnostics` renders invalid sequences as `�`.

## Rendering behavior

The package stack is deliberately one-way:

~~~text
Grip.ParseError + source bytes
  -> GripDiagnostics.diagnostic
  -> TermColor.Diagnostics.render
  -> TermColor.Text
  -> Text.render / TermColor.Terminal.writeText
~~~

- `termcolor-layout` supplies tab stops, Unicode display widths, wrapping, and source context.
- `termcolor` supplies semantic styles and Catppuccin, Dracula, or Monokai schemes.
- `termcolor-diagnostics` supplies labels, notes, help, source locations, and OSC-8 links.
- `termcolor-terminal` remains an optional IO edge; no terminal escapes enter the adapter.
- `termcolor-widgets` is intentionally not involved in a static parse failure.

Plain rendering suppresses ANSI and hyperlinks. ANSI-16, ANSI-256, true-color, Unicode, and ASCII
fallbacks are controlled by the existing TermColor APIs.

## Demo and development

~~~sh
lake update
lake build GripDiagnostics GripDiagnostics.Properties tests demo readme
lake exe tests
lake exe demo
python3 scripts/check-axioms.py
python3 scripts/style-check.py
~~~

The demo exercises a real Grip parser failure and renders the resulting source annotation. The
test executable covers byte offsets, EOF, Unicode, tabs, invalid UTF-8, color schemes, ASCII
fallback, and OSC-8 hyperlinks. The properties package checks that the adapter preserves source
bytes and maps each failure to exactly one clamped primary point label.

## Scope

This release presents one furthest-failure `ParseError` as one primary point diagnostic. Recovery,
multiple independent parser errors, fix-it edits, syntax highlighting, and JSON/SARIF output are
deliberately left to a later layer; they should not complicate the minimal adapter.

## License

Apache-2.0.
