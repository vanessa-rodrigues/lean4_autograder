import AutograderTests.Util
import Mathlib.Data.Rat.Basic
import Mathlib.Tactic.Ring

theorem problem1 {a b : ℚ} (h1 : a - b = 4) (h2 : a * b = 1) :
    (a + b) ^ 2 = 20 :=
  calc (a + b) ^ 2 = (a - b) ^ 2 + 4 * (a * b) := by ring
  _ = 4 ^ 2 + 4 * 1 := by rw [h1, h2]
  _ = 20 := by ring

theorem problem2 {r s : ℚ} (h1 : s = 3) (h2 : r + 2 * s = -1) :
    r = -7 :=
  sorry
