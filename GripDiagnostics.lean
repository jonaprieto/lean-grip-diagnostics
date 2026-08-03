/-
Copyright (c) 2026 Jonathan Cubides. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jonathan Cubides
-/

import Grip
import TermColor.Diagnostics

/-!
# GripDiagnostics: source-annotated parser failures

This package is the optional presentation layer for Grip. The parser core remains independent of
terminal packages: a `ParseError` keeps its byte offset and expected labels, while this module
translates that data into `TermColor.Diagnostics`' source-aware model.

The adapter deliberately uses the original byte offset as a point span. `TermColor.Diagnostics`
then derives line numbers, tab stops, Unicode display columns, color, width, and optional OSC-8
links from the source bytes.
-/

namespace GripDiagnostics

open Grip
open TermColor
open TermColor.Diagnostics

private def safeOffset (source : Source) (error : ParseError) : Nat :=
  min error.pos (Source.utf8Bytes source).size

/-- Convert a Grip parse failure into one primary source label.

The returned value is intentionally a normal `Diagnostic`: callers can add a code, note, or help
message before passing it to `TermColor.Diagnostics.render`. -/
def diagnostic (source : Source) (error : ParseError) (title : String := "parse error") :
    Diagnostic :=
  (Diagnostic.error title).withLabel
    (Label.primary (Span.point 0 (safeOffset source error)) error.message)

/-- Render a Grip parse failure as pure styled text.

Use `Text.render` for an explicit target or `TermColor.Terminal.writeText` at a CLI's IO
boundary. -/
def renderError (source : Source) (error : ParseError) (config : RenderConfig := {})
    (scheme : ColorScheme := ColorScheme.catppuccin) : Text :=
  TermColor.Diagnostics.render #[source] (diagnostic source error) config scheme

end GripDiagnostics
