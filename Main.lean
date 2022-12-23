import Lean
open Lean IO System Elab Command

structure ExerciseResult where
  score : Float
  name : Name
  status : String
  output : String
  deriving ToJson

structure GradingResults where
  tests : Array ExerciseResult
  deriving ToJson

def Lean.Environment.moduleDataOf? (module : Name) (env : Environment) : Option ModuleData := do
  let modIdx : Nat ← env.getModuleIdx? module
  env.header.moduleData[modIdx]?

def Lean.Environment.moduleOfDecl? (decl : Name) (env : Environment) : Option Name := do
  let modIdx : Nat ← env.getModuleIdxFor? decl
  env.header.moduleNames[modIdx]?

def usedAxiomsAreValid (sheetAxioms: Array Name) (submissionAxioms : List Name) : Bool := 
  match submissionAxioms with 
  | [] => true
  | x :: xs => if sheetAxioms.contains x then usedAxiomsAreValid sheetAxioms xs else false 

def grade (sheetName : Name) (sheet submission : Environment) : IO (Array ExerciseResult) := do
  
  let names <- IO.FS.readFile "AutograderTests/exercises.txt"
  let mut exercise_names : HashSet Name := HashSet.empty
  for name in (names.splitOn "\n") do 
    exercise_names := exercise_names.insert name.toName

  let some sheetMod := sheet.moduleDataOf? sheetName
    | throw <| IO.userError s!"module name {sheetName} not found"
  let mut results := #[]

  for name in sheetMod.constNames, constInfo in sheetMod.constants do
    if not name.isInternal && exercise_names.contains name then
      let (_, sheetState) := ((CollectAxioms.collect name).run sheet).run {}
      let result ←
        -- exercise to be filled in
        if let some subConstInfo := submission.find? name then
          if subConstInfo.value?.any (·.hasSorry) then
            pure { name, status := "failed", output := "Proof contains sorry", score := 0.0 }
          else
            if not (constInfo.type == subConstInfo.type) then
              pure { name, status := "failed", output := "Type is different than expected", score := 0.0 }
            else
              let (_, submissionState) := ((CollectAxioms.collect name).run submission).run {}
              if usedAxiomsAreValid sheetState.axioms submissionState.axioms.toList 
                then pure { name, status := "passed", score := 1.0, output := "Passed all tests" }
              else 
                pure { name, status := "failed", output := "Contains unexpected axioms", score := 0.0 }
        else
          pure { name, status := "failed", output := "Declaration not found in submission", score := 0.0 }
      results := results.push result
  return results

def main (args : List String) : IO Unit := do
  let usage := throw <| IO.userError s!"Usage: autograder Exercise.Sheet.Module submission-file.lean"
  let [sheetName, submission] := args | usage
  let submission : FilePath := submission
  let some sheetName := Syntax.decodeNameLit ("`" ++ sheetName) | usage
  searchPathRef.set (← addSearchPathFromEnv {})
  let sheet ← importModules [{module := sheetName}] {}
  let submissionBuildDir : FilePath := "build" / "submission"
  FS.createDirAll submissionBuildDir
  let submissionOlean := submissionBuildDir / "Submission.olean"
  if ← submissionOlean.pathExists then FS.removeFile submissionOlean
  let mut errors := #[]
  let submissionEnv ←
    try
      let out ← IO.Process.output {
        cmd := "lean"
        args := #[submission.toString, "-o", submissionOlean.toString]
      }
      if out.exitCode != 0 then
        let result : ExerciseResult := { name := toString submission, status := "failed", output := out.stdout , score := 0.0 }
        let results : GradingResults := { tests := #[result] }
        IO.FS.writeFile "../results/results.json" (toJson results).pretty
        throw <| IO.userError s!"Lean exited with code {out.exitCode}:\n{out.stderr}"
      searchPathRef.modify fun sp => submissionBuildDir :: sp
      importModules [{module := `Submission}] {}
    catch ex =>
      errors := errors.push ex.toString
      importModules sheet.header.imports.toList {}
  let tests ← grade sheetName sheet submissionEnv
  let results : GradingResults := { tests }
  if errors.size == 0 then
    IO.FS.writeFile "../results/results.json" (toJson results).pretty
  unless errors.isEmpty && tests.all (fun x => x.status == "passed") do
    Process.exit 1
