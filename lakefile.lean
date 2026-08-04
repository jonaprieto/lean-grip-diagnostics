import Lake
open Lake DSL

package «grip-diagnostics» where
  version := v!"0.2.1"
  leanOptions := #[⟨`autoImplicit, false⟩, ⟨`relaxedAutoImplicit, false⟩]

require grip from git
  "https://github.com/jonaprieto/lean-grip.git"
  @ "17bed154d8188650bf8dd458ec44385ce72d6ba4"

require «termcolor-diagnostics» from git
  "https://github.com/jonaprieto/lean-termcolor-diagnostics.git"
  @ "dd016af716eece82535fbfd082522dbe1c5478e4"

@[default_target]
lean_lib GripDiagnostics where
  roots := #[`GripDiagnostics]
  globs := #[.andSubmodules `GripDiagnostics]

lean_lib «GripDiagnostics.Properties» where
  roots := #[`GripDiagnostics.Properties]
  globs := #[.andSubmodules `GripDiagnostics.Properties]

lean_exe «tests» where
  root := `Tests
  srcDir := "test"

lean_exe «demo» where
  root := `Demo
  srcDir := "examples"

lean_exe «readme» where
  root := `Readme
  srcDir := "test"
