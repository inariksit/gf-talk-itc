resource Subtypes = {
  oper
    -- Record extension for types
    A : Type = {s : Str} ;
    B : Type = A ** {s2 : Str} ; -- {s,s2 : Str}

    -- …and for terms
    a : A = {s = "a"} ;
    b : B = a ** {s2 = "b"} ;    -- {s = "a" ; s2 = "b}

    f : A -> A -> A ;
    f a1 a2 = {s = a1.s ++ a2.s} ; -- only using the s field of the argument

    test : A = f a b ; -- works fine


  -- Let's define some Bools to get some more types
  param
    Bool = True | False ;

------------------
-- Depth subtyping
------------------

  oper
    -- Is D <: C?
    C : Type = A ** {c : {}} ;
    D : Type = A ** {c : {b : Bool}} ;
    E : Type = A ** {c : Bool} ;

    c : C = {s = "c" ; c = <>} ; -- <> = empty record
    d : D = {s = "d" ; c = {b = True}} ;
    e : E = {s = "e" ; c = True} ;

    g, g' : C -> C ;
    g x = x ** {c = <>} ;        -- Replace original c with empty record
    g' x = x ** {c = x.c ** <>} ; -- Extend original c with empty record

    g'' : D -> D ;
    g'' x = x ** {c = x.c ** <>} ; -- Extend original c with empty record

    {- Testing on the command line.
    $ gf
    > i -retain Subtypes.gf
    > cc g c
    {s = "c"; c = <>}

    > cc g d
    {s = "d"; c = <>}

    -- Extending with empty record should work like this
    > cc {b = True} ** <>
    {b = True}

    > cc g' d
    {s = "d"; c = <>} -- Bug or feature? On line 37, c = (x.c ** <>) ;  in this case x=d, and d.c = {b=True}

    > cc g'' d
    {s = "d"; c = {b = True}}

    > cc g e
    missing record fields: c type of e
    expected: {s : Str; c : {}}
    inferred: {s : Str; c : Subtypes.Bool}

    > cc g a
    missing record fields: c type of a
    expected: {s : Str; c : {}}
    inferred: {s : Str}
    -}

---------------------
-- Function subtyping
---------------------

  -- Imagine these functions are from the Resource Grammar Library.
  param
    Number = Sg | Pl ;
  oper
    -- IDet <: Det
    Det : Type = {s : Str ; n : Number} ; -- determiner: "this", "a"
    IDet : Type = Det ** {isWh : Bool} ; -- interrogative: "which", "how much"

    CN : Type = Number => Str ; -- common noun: "song"

    -- NP <: IP
    IP : Type = {s : Str ; n : Number} ; -- interrogative phrase: "which song"
    NP : Type = IP ** {isPron : Bool} ; -- noun phrase: "this song"

    -- Constructors for lexical categories
    mkDet : Str -> Number -> Det = \s,n -> {s=s ; n=n} ;
    mkIDet : Str -> Number -> Bool -> IDet = \s,n,b -> mkDet s n ** {isWh=b} ;
    mkCN : Str -> CN = \str -> table {Sg => str ; Pl => str + "s"} ;

    -- Lexicon
    these : Det = mkDet "these" Pl ;
    which : IDet = mkIDet "which" Sg True ;
    song : CN = mkCN "song" ;

    -- Syntactic functions
    detCN : Det -> CN -> NP = \det,cn -> {
      s = det.s ++ cn ! det.n ;
      n = det.n ;
      isPron = False ; -- We can make NP out of pronouns in other functions, and isPron field is for their sake.
      } ;              -- DetCN is always applied to common nouns, so isPron is always False.

    -- detCN can be used in place of idetCN, so detCN <: idetCN
    -- IDet has a field that Det doesn't have, but in this particular function, even the IP doesn't need it.
    -- There can be other functions that take an IDet as an argument, and use the isWh-field.
    idetCN : IDet -> CN -> IP = detCN ;

    -- Test
    these_songs : NP = detCN these song ;
    which_song : IP = idetCN which song ;


}
