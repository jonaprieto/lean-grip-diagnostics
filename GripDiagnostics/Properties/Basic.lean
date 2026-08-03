/-
Copyright (c) 2026 Jonathan Cubides. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jonathan Cubides
-/

import GripDiagnostics

namespace GripDiagnostics.Properties

open Grip
open TermColor.Diagnostics

theorem diagnostic_uses_clamped_byte_offset (source : Source) (error : ParseError) :
    (diagnostic source error).labels =
      [Label.primary (Span.point 0 (min error.pos (Source.utf8Bytes source).size))
        error.message] := by
  rfl

theorem diagnostic_has_one_primary_label (source : Source) (error : ParseError) :
    (diagnostic source error).labels.length = 1 := by
  rfl

end GripDiagnostics.Properties
