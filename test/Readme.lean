/-
Copyright (c) 2026 Jonathan Cubides. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jonathan Cubides
-/

import GripDiagnostics

open Grip
open GripDiagnostics
open TermColor.Diagnostics

private def source : Source := Source.fromBytes "config.toml" "timeout = 2x".toUTF8

private def error : ParseError :=
  { pos := 11, line := 1, col := 12, expected := ["a duration"] }

def main : IO Unit := do
  IO.println (TermColor.Diagnostics.render #[source] (diagnostic source error)
    { contextLines := 0 }).plainText
