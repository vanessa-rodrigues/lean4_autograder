import AutograderTests.Util

open Classical

variable (p q r : Prop)

theorem imp_self : p → p :=
  sorry_in_exercise_else by intros; assumption

-- commutativity of ∧ and ∨
theorem th1 : p ∧ q ↔ q ∧ p :=   
  Iff.intro
    (fun h : p ∧ q => show q ∧ p from And.intro (And.right h) (And.left h))
    (fun h : q ∧ p => show p ∧ q from And.intro (And.right h) (And.left h))

theorem th3 (h : ¬q → ¬p) : (p → q) := fun hp => Or.elim (em q)
  (fun hq => hq)
  (fun hnq => False.elim ((h hnq) hp))

theorem th2 : p ∧ q ↔ q ∧ p := by
  apply Iff.intro
  . intro h
    apply And.intro 
    . exact h.right
    . exact h.left
  . intro h
    apply And.intro 
    . exact h.right
    . exact h.left

theorem th4 : p ∨ ¬p -> ¬p ∨ p := fun h => h.elim
  (fun hp => Or.inr hp)
  (fun hnp => Or.inl hnp)

theorem th5 : p ∧ q -> p := by
  . intro h
    . exact h.left

def joinStringsWith (s1: String) (s2: String) (s3: String) : String :=
  String.append s2 (String.append s1 s3)

namespace Hidden
inductive List (α : Type u) where
  | nil  : List α
  | cons : α → List α → List α
deriving Repr 

notation  (priority := high) "[" "]" => List.nil   -- `[]`
infixr:67 (priority := high) " :: "  => List.cons  -- `a :: as`

-- as a warm-up exercise, let's define concatenation of two lists
def append (as bs : List α) : List α := 
  match as with 
  | [] => bs 
  | x :: xs => x :: (append xs bs)

infixl:65 (priority := high) " ++ " => append

def reverse (xs : List α) : List α := 
  match xs with 
  | List.nil => List.nil
  | List.cons x xs => (reverse xs) ++ (List.cons x List.nil)

@[simp]theorem append_nil (xs: List α) : reverse (xs ++ []) = [] ++ reverse xs := by 
  induction xs 
  . case nil => rfl 
  . case cons x xs h => simp [h, append, reverse]

end Hidden

/- STRUCTURES -/

-- Define the structure `Semigroup α` for a semigroup on a type `α`.
-- Reminder: A semigroup is an algebraic structure with an associative binary operation `mul`.
structure Semigroup (α : Type) where 
  mul : α -> α -> α
  assoc : mul (mul a b) c = mul a (mul b c) 

-- Now extend the structure to one for a monoid on α.
-- Reminder : A monoid is a semigroup with an element which acts as the left and right identity on `mul`.
structure Monoid (α : Type) extends Semigroup α where 
  e : α -- element 
  e_mul : mul e a = e -- left id in mul
  mul_e : mul a e = e -- right id in mul

