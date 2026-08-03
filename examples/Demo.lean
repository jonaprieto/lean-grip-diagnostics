/-
Copyright (c) 2026 Jonathan Cubides. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jonathan Prieto-Cubides
-/

import GripDiagnostics
import TermColor.Detect

open Grip
open GripDiagnostics
open TermColor
open TermColor.Diagnostics

private def input : String := "timeout = 2x\nworkers = 4\n界e\u0301 = true"

private def source : Source :=
  Source.fromBytes "config.toml" input.toUTF8 |>.withUri "file:///tmp/config.toml"

private def parse : Parser Nat :=
  GParser.weakenFallible
    ((GParser.string "timeout = " *> GParser.nat) <* GParser.eof)

private def failure : ParseError :=
  match parse.parse input.toUTF8 with
  | .error error => error
  | .ok _ => { pos := input.toUTF8.size, line := 1, col := 1, expected := ["end of input"] }

private def output (target : RenderTarget) : String :=
  let diagnostic := (diagnostic source failure)
    |>.withCode "GRIP001"
    |>.withHelp "check the duration suffix: s, m, or h"
  Text.render target (TermColor.Diagnostics.render #[source] diagnostic
    { width := 76, contextLines := 1, hyperlinks := true } ColorScheme.catppuccin)

def main : IO Unit := do
  let detected ← TermColor.target
  let target := if detected.styles then RenderTarget.withHyperlinks detected else detected
  IO.println (output target)
