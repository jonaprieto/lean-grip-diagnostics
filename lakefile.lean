import Lake
open Lake DSL

package «grip-diagnostics» where
  version := v!"0.2.3"
  leanOptions := #[⟨`autoImplicit, false⟩, ⟨`relaxedAutoImplicit, false⟩]

require grip from git
  "https://github.com/jonaprieto/lean-grip.git"
  @ "v0.1.0"

require «termcolor-diagnostics» from git
  "https://github.com/jonaprieto/lean-termcolor-diagnostics.git"
  @ "v0.1.10"

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
