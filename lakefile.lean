import Lake
open Lake DSL

package autograder

lean_lib AutograderTests where
  globs := #[.submodules `AutograderTests]

@[default_target]
lean_exe autograder where
  root := `Main
  supportInterpreter := true

require mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ "master"