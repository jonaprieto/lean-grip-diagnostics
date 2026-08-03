/-
Copyright (c) 2026 Jonathan Cubides. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jonathan Cubides
-/

import GripDiagnostics

open Grip
open GripDiagnostics
open TermColor
open TermColor.Diagnostics

private def check (name : String) (condition : Bool) : Option String :=
  if condition then none else some name

private def source : Source :=
  Source.fromBytes "config.toml" "timeout = 2x\nworkers = 4\n界e\u0301 = true".toUTF8

private def parseError : ParseError :=
  { pos := 11, line := 1, col := 12, expected := ["a duration"] }

private def rich : Diagnostic :=
  (diagnostic source parseError)
    |>.withCode "GRIP001"
    |>.withHelp "try timeout = 2m"

private def plainRich : String :=
  (TermColor.Diagnostics.render #[source] rich { contextLines := 0 }).plainText

private def checks : List (Option String) :=
  [ check "header is rendered" (plainRich.contains "error [GRIP001]: parse error")
  , check "filename and display location are rendered"
      (plainRich.contains "config.toml:1:12")
  , check "expected message is attached to the source point"
      (plainRich.contains "a duration")
  , check "help is rendered" (plainRich.contains "help: try timeout = 2m")
  , check "source text is preserved" (plainRich.contains "timeout = 2x")
  , check "unicode source is preserved"
      (((renderError source parseError { contextLines := 2 }).plainText).contains "界e\u0301")
  , check "unicode gutter is rendered" (plainRich.contains "│")
  , check "plain output has no escape sequence" (!plainRich.contains "\u001b[")
  , check "ANSI output contains styling"
      ((Text.render RenderTarget.trueColor (renderError source parseError)).contains "\u001b[")
  , check "ANSI-16 output contains styling"
      ((Text.render RenderTarget.ansi16 (renderError source parseError)).contains "\u001b[")
  , check "ASCII fallback uses ASCII location arrow"
      (((renderError source parseError { unicode := false }).plainText).contains " -->")
  , check "EOF stays inside the source"
      (let eof : ParseError := { parseError with pos := source.utf8Bytes.size }
       (renderError source eof { contextLines := 0 }).plainText.contains "config.toml")
  , check "invalid UTF-8 is safe"
      (let broken := Source.fromBytes "broken.txt" (ByteArray.mk #[0x66, 0x80, 0x6F])
       let rendered := renderError broken { parseError with pos := 1 } { contextLines := 0 }
       rendered.plainText.contains "�")
  , check "custom scheme reaches the renderer"
      (let scheme := { ColorScheme.catppuccin with red := Color.rgb 255 126 95 }
       (Text.render RenderTarget.trueColor (renderError source parseError {} scheme)).contains
         "38;2;255;126;95")
  , check "OSC-8 source links are opt-in"
      (let linked := source.withUri "file:///tmp/config.toml"
       let output := Text.render (RenderTarget.withHyperlinks RenderTarget.trueColor)
         (renderError linked parseError { hyperlinks := true })
       output.contains "\u001b]8;;file:///tmp/config.toml\u001b\\" &&
         output.contains "\u001b]8;;\u001b\\")
  ]

def main : IO UInt32 := do
  let failures := checks.filterMap id
  if failures.isEmpty then
    IO.println s!"OK: {checks.length} grip diagnostics checks"
    return 0
  for failure in failures do
    IO.eprintln s!"FAIL: {failure}"
  IO.eprintln s!"{failures.length} grip diagnostics checks failed"
  return 1
