resource ResIce = {
  param
    Agr = Ag Number Gender ;
    Number = Sg | Pl ;
    Gender = Masc | Fem | Neutr ;

  oper
    hello : Agr => Str ;
    hello = table {
      Ag Sg Masc => "sæll" ;
      Ag Sg _    => "sæl" ;
      Ag Pl Masc => "sælir" ;
      Ag Pl _    => "sælar" } ;

    Rec : Type = {s : Str ; a : Agr} ;

    mkRec : Str -> Number -> Gender -> Rec ;
    mkRec s n g = {s = s ; a = Ag n g} ;
}
