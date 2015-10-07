Require Export UniMath.Foundations.Sequences.
Require Export UniMath.Foundations.Algebra.Monoids_and_Groups.
Unset Automatic Introduction.
Open Scope multmonoid.

Definition sequenceProduct {M:monoid} : Sequence M -> M.
Proof.
  intros ? [n x].
  induction n as [|n sequenceProduct].     
  { exact 1. }
  { exact (sequenceProduct (pr2 (drop (S n,,x))) * x (lastelement _)). }
Defined.

Definition sequenceProductStep {M:monoid} {n} (x:stn (S n) -> M) :
  sequenceProduct (S n,,x) = sequenceProduct (n,,x ∘ (dni_allButLast _)) * x (lastelement _).
Proof. intros. reflexivity. Defined.

Definition sequenceProductCheck {M:monoid} (x:Sequence M) (m:M) :
  sequenceProduct (append x m) = sequenceProduct x * m.
Proof. intros ? [n x] ?.
       unfold append.
       rewrite sequenceProductStep.
       unfold funcomp.
       unfold lastelement.
       induction (natlthorgeh n n) as [p|q].
       { induction (isirreflnatlth _ p). }
       { apply (maponpaths (fun a => a * m)).
         apply (maponpaths (fun x => sequenceProduct (n,,x))).
         apply funextfun; intros [i b].
         simpl.
         induction (natlthorgeh i n) as [r|s].
         { simpl. apply (maponpaths x). apply pair_path_in2. apply isasetbool. }
         { simpl. induction (s b). }}
Defined.

Definition doubleProduct {M:monoid} : Sequence (Sequence M) -> M.
Proof.
  intros ? [n x].
  induction n as [|n doubleProduct].     
  { exact 1. }
  { exact ((doubleProduct (x ∘ (dni_allButLast _)) * sequenceProduct (x (lastelement _)))). }
Defined.

Lemma doubleProductStep {M:monoid} {n} (x:stn (S n) -> Sequence M) :
  doubleProduct (S n,,x) = doubleProduct (n,,x ∘ (dni_allButLast _)) * sequenceProduct (x (lastelement _)).
Proof. intros. reflexivity. Defined.

Theorem associativityOfProducts {M:monoid} (x:Sequence (Sequence M)) :
  sequenceProduct (flatten x) = doubleProduct x.
Proof.
  (* this proof comes from the Associativity theorem, Bourbaki, Algebra, Theorem 1, page 4. *)
  intros ? [n x].
  induction n as [|n IHn].
  { reflexivity. }
  { rewrite flattenStep, doubleProductStep.
    generalize (x (lastelement n)) as z.
    generalize (x ∘ (dni_allButLast _)) as y.
    intros y [m z].
    induction m as [|m IHm].
    { change (sequenceProduct (0,, z)) with (unel M). rewrite runax.
      change (concatenate (flatten (n,, y)) (0,, z)) with (flatten (n,, y)).
      exact (IHn y). }
    { rewrite sequenceProductStep, concatenateStep.
      generalize (z (lastelement m)) as w; generalize (z ∘ (dni_allButLast _)) as v; intros.
      rewrite <- assocax.
      rewrite sequenceProductCheck.
      apply (maponpaths (fun u => u*w)).
      apply IHm. } }
Defined.
