/-
Copyright (c) 2026 Jonathan Cubides. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jonathan Prieto-Cubides
-/

import GripDiagnostics.Properties.Basic

namespace GripDiagnostics.Properties

open Grip
open TermColor.Diagnostics

theorem source_from_bytes_preserves_input (name : String) (bytes : ByteArray) :
    Source.utf8Bytes (Source.fromBytes name bytes) = bytes := by
  rfl

end GripDiagnostics.Properties
